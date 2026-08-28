import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/modules/admin/controller/admin_controller.dart';
import 'package:redescomunicacionais/app/modules/news/utils/cities_codes.dart';
import 'package:redescomunicacionais/app/modules/user/utils/userRoles.dart';
import 'package:redescomunicacionais/app/modules/user/data/model/user_model.dart';
import 'package:redescomunicacionais/app/utils/components/popups.dart';
import 'package:redescomunicacionais/app/utils/theme/color_pallete.dart';
import 'package:redescomunicacionais/app/utils/widgets/blinking_loading_icon.dart';

class AdminPage extends GetView<AdminController> {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('manage_users'.tr),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarBottomGradient(),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadAllUsers(),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.darkBlueToBlackGradient(),
        ),
        child: Column(
          children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'registered_users'.tr,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('filter_all'.tr, 'todos'),
                    const SizedBox(width: 8),
                    _buildFilterChip('filter_users'.tr, 'user'),
                    const SizedBox(width: 8),
                    _buildFilterChip('filter_editors'.tr, 'editor'),
                    const SizedBox(width: 8),
                    _buildFilterChip('filter_admins'.tr, 'admin'),
                  ],
                ),
              ),
            ),

            // Lista de usuários
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: BlinkingLoadingIcon(
                      size: 36,
                      color: Colors.white,
                    ),
                  );
                }

                String filter = controller.selectedRoleFilter.value;
                List<UserModel> filteredUsers = controller.users
                    .where((u) => filter == 'todos' ? true : u.role == filter)
                    .toList()
                  ..sort((a, b) => a.email.compareTo(b.email));

                if (filteredUsers.isEmpty) {
                  return Center(
                    child: Text(
                      'no_user_found'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    UserModel user = filteredUsers[index];
                    return _buildUserCard(user);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    String email = user.email;
    String userId = user.id;
    String currentRole = user.role;

    // Gera iniciais do email
    String initials = email.isNotEmpty ? email[0].toUpperCase() : 'U';

    // Cor baseada na role
    Color roleColor = _getRoleColor(currentRole);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: roleColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar único com iniciais
            CircleAvatar(
              radius: 25,
              backgroundColor: roleColor.withOpacity(0.2),
              child: Text(
                initials,
                style: TextStyle(
                  color: roleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Informações do usuário
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getRoleDisplayName(currentRole),
                      style: TextStyle(
                        color: roleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dropdown para alterar role
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: DropdownButton<String>(
                value: currentRole,
                underline: const SizedBox(),
                dropdownColor: Colors.black87,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: const TextStyle(color: Colors.white),
                items: [
                  DropdownMenuItem(value: 'user', child: Text('role_user'.tr)),
                  DropdownMenuItem(
                      value: 'editor', child: Text('role_editor'.tr)),
                  DropdownMenuItem(
                      value: 'admin', child: Text('role_admin'.tr)),
                ],
                onChanged: (newRole) async {
                  if (newRole != null && newRole != currentRole) {
                    // Confirma a alteração e pega as cidades (se aplicável)
                    final result =
                        await _showRoleChangeDialog(email, currentRole, newRole);
                    
                    if (result != null && result['confirmed'] == true) {
                      Map<String, String> operationsCities = result['cities'] ?? <String, String>{};

                      if (userId.isNotEmpty) {
                        try {
                          await controller.userRepository.updateRole(
                              userId, newRole, controller.user.email, operationsCities);
                          PopUps.snackbar(
                            texto: 'Cargo atualizado com sucesso'.tr,
                            cor: Colors.green,
                          );
                        } catch (e) {
                          PopUps.snackbar(
                            texto: 'Ocorreu um erro ao atualizar o cargo'.tr,
                            cor: Colors.red,
                          );
                        }
                      }
                      // Recarrega a lista
                      await controller.loadAllUsers();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case UserRoles.admin:
        return Colors.red;
      case UserRoles.editor:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Widget _buildFilterChip(String label, String filterValue) {
    return Obx(() {
      final isSelected = controller.selectedRoleFilter.value == filterValue;
      return FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          controller.selectedRoleFilter.value = filterValue;
        },
        backgroundColor:
            isSelected ? Colors.blue : Colors.black.withOpacity(0.4),
        selectedColor: Colors.blue,
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.white24,
          width: 1,
        ),
      );
    });
  }

  String _getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case UserRoles.admin:
        return 'role_admin'.tr;
      case UserRoles.editor:
        return 'role_editor'.tr;
      default:
        return 'role_user'.tr;
    }
  }

  Future<Map<String, dynamic>?> _showRoleChangeDialog(
      String email, String currentRole, String newRole) {
    
    Map<String, String> selectedCities = {};
    final citiesMap = CitiesCodes().cities;

    return showDialog<Map<String, dynamic>>(
      context: Get.context!,
      builder: (context) {
        // StatefulBuilder para gerenciar o estado dos checkboxes dentro do modal
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black87,
              title: Text(
                'confirm_change'.tr,
                style: const TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'change_role_of'.tr} $email\n${'from_label'.tr}: ${_getRoleDisplayName(currentRole)}\n${'to_label'.tr}: ${_getRoleDisplayName(newRole)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    // Mostra as opções de cidades apenas se a nova role for "editor"
                    if (newRole == 'editor') ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Cidades de atuação:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...citiesMap.entries.map((entry) {
                        return Theme(
                          data: ThemeData(
                              unselectedWidgetColor: Colors.white70),
                          child: CheckboxListTile(
                            title: Text(
                              entry.value,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                            // Verifica se a chave existe no map para marcar o checkbox
                            value: selectedCities.containsKey(entry.key),
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                            dense: true,
                            controlAffinity:
                                ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool? checked) {
                              setState(() {
                                if (checked == true) {
                                  // Adiciona ao map se marcado
                                  selectedCities[entry.key] = entry.value;
                                } else {
                                  // Remove do map se desmarcado
                                  selectedCities.remove(entry.key);
                                }
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text('cancel'.tr,
                      style: const TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validação opcional: exigir pelo menos uma cidade se for editor
                    if (newRole == 'editor' && selectedCities.isEmpty) {
                      PopUps.snackbar(
                        texto: 'Selecione pelo menos uma cidade para o editor.',
                        cor: Colors.orange,
                      );
                      return;
                    }
                    Navigator.of(context).pop({
                      'confirmed': true,
                      'cities': selectedCities, // Retorna o Map
                    });
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text('confirm'.tr,
                      style: const TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}