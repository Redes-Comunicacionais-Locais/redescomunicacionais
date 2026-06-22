import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

enum UpdateStatus { upToDate, optionalUpdate, forceUpdate }

class UpdateVersionService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1), // Cache de 1 hora
      ));
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint("Erro ao inicializar Remote Config: $e");
    }
  }

  Future<void> checkForUpdates(BuildContext context) async {
    if (Platform.isAndroid) {
      await _handleAndroidUpdate(context);
    } else if (Platform.isIOS) {
      await _handleIOSUpdate(context);
    }
  }

  Future<void> _handleAndroidUpdate(BuildContext context) async {
    try {
      // Verifica se há atualização na Play Store
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        //Firebase para saber se deve ser obrigatório ou opcional
        final UpdateStatus status = await checkFirebaseVersionStatus();

        if (status == UpdateStatus.forceUpdate &&
            updateInfo.immediateUpdateAllowed) {
          // Abre a tela inteira nativa da Play Store travando o app
          await InAppUpdate.performImmediateUpdate();
        } else if (status == UpdateStatus.optionalUpdate &&
            updateInfo.flexibleUpdateAllowed) {
          // Baixa a atualização em background
          AppUpdateResult result = await InAppUpdate.startFlexibleUpdate();

          if (result == AppUpdateResult.success) {
            // Quando terminar o download, avisa o usuário para reiniciar
            if (context.mounted) _showAndroidCompleteSnackbar(context);
          }
        }
      }
    } catch (e) {
      debugPrint("Erro no In-App Update do Android: $e");
      // Fallback: Se falhar a API da Play Store, roda a lógica universal via link
      if (context.mounted) await _handleIOSUpdate(context);
    }
  }

  Future<void> _handleIOSUpdate(BuildContext context) async {
    final UpdateStatus status = await checkFirebaseVersionStatus();

    if (status == UpdateStatus.upToDate) return;

    final bool isForceUpdate = status == UpdateStatus.forceUpdate;

    if (context.mounted) {
      _showIOSUpdateDialog(context, isForceUpdate);
    }
  }

  Future<UpdateStatus> checkFirebaseVersionStatus() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      String minRequired = _remoteConfig.getString('min_version_required');
      String latestVersion = _remoteConfig.getString('latest_version');

      if (_isVersionLower(currentVersion, minRequired)) {
        return UpdateStatus.forceUpdate;
      } else if (_isVersionLower(currentVersion, latestVersion)) {
        return UpdateStatus.optionalUpdate;
      }
    } catch (e) {
      debugPrint("Erro ao comparar versões no Firebase: $e");
    }
    return UpdateStatus.upToDate;
  }

  bool _isVersionLower(String current, String target) {
    if (target.isEmpty) return false;
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> targetParts = target.split('.').map(int.parse).toList();

    for (int i = 0; i < targetParts.length; i++) {
      int currentPart = i < currentParts.length ? currentParts[i] : 0;
      if (currentPart < targetParts[i]) return true;
      if (currentPart > targetParts[i]) return false;
    }
    return false;
  }

  void _showAndroidCompleteSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Atualização baixada com sucesso!"),
        duration: const Duration(days: 1), // Mantém aberto até interagir
        action: SnackBarAction(
          label: "REINICIAR",
          onPressed: () async {
            await InAppUpdate.completeFlexibleUpdate();
          },
        ),
      ),
    );
  }

  void _showIOSUpdateDialog(BuildContext context, bool isForceUpdate) {
    showDialog(
      context: context,
      barrierDismissible: !isForceUpdate,
      builder: (context) {
        return PopScope(
          canPop:
              !isForceUpdate, // Bloqueia o botão físico de voltar no Android/iOS
          child: AlertDialog(
            title: const Text("Nova Versão Disponível"),
            content: Text(isForceUpdate
                ? "Uma atualização obrigatória é necessária para continuar utilizando o aplicativo."
                : "Uma nova versão está disponível! Gostaria de atualizar agora?"),
            actions: [
              if (!isForceUpdate)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Depois"),
                ),
              TextButton(
                onPressed: () async {
                  final Uri url = Platform.isIOS
                      ? Uri.parse(
                          "https://apps.apple.com/br/app/redes-comunicacionais-locais/id6759577931")
                      : Uri.parse(
                          "https://play.google.com/store/apps/details?id=br.uff.redescomunicacionais&hl=pt_BR");

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text("Atualizar"),
              ),
            ],
          ),
        );
      },
    );
  }
}
