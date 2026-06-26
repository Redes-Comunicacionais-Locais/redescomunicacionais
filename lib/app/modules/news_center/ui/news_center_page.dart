import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/modules/news_center/controller/news_center_controller.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/utils/theme/color_pallete.dart';

class NewsCenterPage extends GetView<NewsCenterController> {
  const NewsCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 8,
        foregroundColor: Colors.white,
        title: Text('central_da_materia'.tr),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarBottomGradient(),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.darkBlueToBlackGradient(),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHero(context),
                      const SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1,
                        children: [
                          _ActionCard(
                            title: 'Criar nova matéria'.tr,
                            subtitle: 'Comece a criar uma nova matéria'.tr,
                            icon: Icons.create_rounded,
                            accentColor: Colors.greenAccent,
                            onTap: () => Get.toNamed(Routes.CREATE_NEWS),
                          ),
                          _ActionCard(
                            title: 'Revisar Matérias'.tr,
                            subtitle:
                                'Fila de avaliação e aprovação editorial'.tr,
                            icon: Icons.fact_check_rounded,
                            accentColor: Colors.lightBlueAccent,
                            onTap: () => controller.openNewsMode('revision'),
                          ),
                          _ActionCard(
                            title: 'Ver seus rascunhos'.tr,
                            subtitle:
                                'Acesse suas matérias salvas como rascunhos'.tr,
                            icon: Icons.drafts_outlined,
                            accentColor: Colors.amberAccent,
                            onTap: () => controller.openNewsMode('drafts'),
                          ),
                          _ActionCard(
                            title: 'Ver suas matérias rejeitadas'.tr,
                            subtitle: 'Acompanhe o que voltou para ajustes'.tr,
                            icon: Icons.report_outlined,
                            accentColor: Colors.redAccent,
                            onTap: () => controller.openNewsMode('rejected'),
                          ),
                          _ActionCard(
                            title: 'Ver suas matérias excluídas'.tr,
                            subtitle: 'Confira o histórico de exclusões'.tr,
                            icon: Icons.delete_outline_rounded,
                            accentColor: Colors.deepOrangeAccent,
                            onTap: () => controller.openNewsMode('deleted'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: const Icon(
              Icons.newspaper_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Painel editorial'.tr,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.98),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Crie e organize as matérias em um único lugar.'.tr,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatefulWidget {
  const _ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  // Controle do estado do toque para a animação
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        // Multiplicadores responsivos
        final paddingValue = (cardWidth * 0.09).clamp(12.0, 20.0);
        final iconSize = (cardWidth * 0.16).clamp(24.0, 36.0);
        final titleFontSize = (cardWidth * 0.09).clamp(13.0, 18.0);
        final subtitleFontSize = (cardWidth * 0.07).clamp(11.0, 14.0);

        return GestureDetector(
          // Detecta quando o usuário toca e segura
          onTapDown: (_) => setState(() => _isPressed = true),
          // Detecta quando o usuário solta o toque
          onTapUp: (_) => setState(() => _isPressed = false),
          // Detecta se o usuário arrastou o dedo para fora do card (cancela o toque)
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _isPressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              // Opacidade reduz levemente no toque para dar feedback de clique
              opacity: _isPressed ? 0.85 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.all(paddingValue),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          widget.accentColor.withOpacity(0.20),
                          Colors.white.withOpacity(0.04),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: _isPressed
                            ? widget.accentColor
                                .withOpacity(0.5) // Borda brilha no toque
                            : Colors.white.withOpacity(0.18),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.accentColor
                              .withOpacity(_isPressed ? 0.15 : 0.08),
                          blurRadius: _isPressed ? 25 : 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Linha do topo com Ícone Principal e Indicador de Ação Visual
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(paddingValue * 0.6),
                              decoration: BoxDecoration(
                                color: widget.accentColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.icon,
                                size: iconSize,
                                color: widget.accentColor,
                              ),
                            ),
                            // Indicador de toque sutil (Seta/Chevron que brilha no toque)
                          ],
                        ),

                        const Spacer(),

                        // Textos inferiores
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: paddingValue * 0.3),
                            Text(
                              widget.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.65),
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
