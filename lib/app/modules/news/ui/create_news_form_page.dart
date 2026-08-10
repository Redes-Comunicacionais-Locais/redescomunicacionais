import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/modules/news/controller/create_news_form_controller.dart';
import 'package:redescomunicacionais/app/utils/components/markdown_editor.dart';
import 'package:redescomunicacionais/app/utils/theme/color_pallete.dart';
import 'package:redescomunicacionais/app/utils/theme/theme_controller.dart';

class CreateNewsPage extends GetView<CreateNewsFormController> {
  const CreateNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();
    final bool isLight = themeController.isLight;

    return Scaffold(
      backgroundColor: isLight
          ? theme.scaffoldBackgroundColor
          : null,

      appBar: AppBar(
        centerTitle: true,
        elevation: 2,

        backgroundColor: isLight
            ? theme.scaffoldBackgroundColor
            : null,

        foregroundColor: theme.colorScheme.onSurface,

        flexibleSpace: isLight
            ? null
            : Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarBottomGradient(),
          ),
        ),

        title: Text(
          'Adicionar Matéria'.tr,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),

        iconTheme: IconThemeData(
          color: theme.colorScheme.onSurface,
        ),
      ),

      body: Container(
        decoration: Get.find<ThemeController>().isLight
            ? const BoxDecoration(
          color: Colors.white,
        )
            : BoxDecoration(
          gradient: AppColors.darkBlueToBlackGradient(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleField(context, controller),
                  const SizedBox(height: 16),

                  _buildSubtitleField(context, controller),
                  const SizedBox(height: 16),

                  _buildCategorySelection(context, controller),
                  const SizedBox(height: 16),

                  _buildCitySelection(context, controller),
                  const SizedBox(height: 16),

                  _buildTypeSelection(context, controller),
                  const SizedBox(height: 16),

                  _buildYouTubeUrlField(context, controller),
                  const SizedBox(height: 16),

                  _buildMarkdownEditor(context, controller),
                  const SizedBox(height: 16),

                  _buildImagePicker(context, controller),
                  const SizedBox(height: 16),

                  _buildImageInfo(context),
                  _buildImagePreview(context, controller),
                  const SizedBox(height: 16),

                  _buildImageMessage(context, controller),
                  const SizedBox(height: 16),

                  _buildPublishButton(context, controller),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TÍTULO
  // ============================================================

  Widget _buildTitleField(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TextFormField(
      controller: controller.titleController,

      style: TextStyle(
        color: colors.onSurface,
      ),

      decoration: InputDecoration(
        labelText: 'title'.tr,

        labelStyle: TextStyle(
          color: colors.onSurfaceVariant,
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'title_required'.tr;
        }

        return null;
      },
    );
  }

  // ============================================================
  // SUBTÍTULO
  // ============================================================

  Widget _buildSubtitleField(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TextFormField(
      controller: controller.subtitleController,

      style: TextStyle(
        color: colors.onSurface,
      ),

      decoration: InputDecoration(
        labelText: 'subtitle_optional'.tr,

        labelStyle: TextStyle(
          color: colors.onSurfaceVariant,
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORIAS
  // ============================================================

  Widget _buildCategorySelection(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isLight = Get.find<ThemeController>().isLight;

    // No tema escuro o fundo da página é um GRADIENTE (não uma cor
    // sólida), então usamos transparente para o gradiente aparecer
    // por trás da caixa. No tema claro usamos branco, igual ao resto
    // da página.
    final Color boxBackgroundColor =
    isLight ? Colors.white : Colors.transparent;

    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: boxBackgroundColor,
              border: Border.all(
                color: colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Theme(
              data: theme.copyWith(
                canvasColor: boxBackgroundColor,
                cardColor: boxBackgroundColor,
                dividerColor: colorScheme.outline.withOpacity(0.3),

                // Desativa o "surface tint" automático do Material 3,
                // que sobrepõe a cor primary por cima do backgroundColor
                // e deixa a caixa com aparência acinzentada/escurecida.
                colorScheme: colorScheme.copyWith(
                  surfaceTint: Colors.transparent,
                ),
              ),
              child: ExpansionTile(
                backgroundColor: boxBackgroundColor,
                collapsedBackgroundColor: boxBackgroundColor,
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  'select_categories'.tr,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                iconColor: colorScheme.onSurface,
                collapsedIconColor: colorScheme.onSurface,
                children: controller.categories.map((category) {
                  return CheckboxListTile(
                    tileColor: boxBackgroundColor,
                    title: Text(
                      category,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    value: controller.selectedCategories.contains(category),
                    onChanged: (_) {
                      controller.toggleCategory(category);
                    },
                    activeColor: colorScheme.primary,
                    checkColor: colorScheme.onPrimary,
                    side: BorderSide(
                      color: colorScheme.outline,
                      width: 2,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
            ),
          ),

          if (controller.showCategoryError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'select_at_least_one_category'.tr,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // CIDADE
  // ============================================================

  Widget _buildCitySelection(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isLight = Get.find<ThemeController>().isLight;

    final Color boxBackgroundColor =
    isLight ? Colors.white : Colors.transparent;

    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: boxBackgroundColor,
              border: Border.all(
                color: colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Theme(
              data: theme.copyWith(
                canvasColor: boxBackgroundColor,
                cardColor: boxBackgroundColor,
                dividerColor: colorScheme.outline.withOpacity(0.3),

                // Desativa o "surface tint" automático do Material 3,
                // que sobrepõe a cor primary por cima do backgroundColor
                // e deixa a caixa com aparência acinzentada/escurecida.
                colorScheme: colorScheme.copyWith(
                  surfaceTint: Colors.transparent,
                ),
              ),
              child: ExpansionTile(
                backgroundColor: boxBackgroundColor,
                collapsedBackgroundColor: boxBackgroundColor,
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  'select_city'.tr,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                iconColor: colorScheme.onSurface,
                collapsedIconColor: colorScheme.onSurface,
                children: controller.cities.map((city) {
                  return CheckboxListTile(
                    tileColor: boxBackgroundColor,
                    title: Text(
                      city,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    value: controller.selectedCities.contains(city),
                    onChanged: (_) {
                      controller.toggleCity(city);
                    },
                    activeColor: colorScheme.primary,
                    checkColor: colorScheme.onPrimary,
                    side: BorderSide(
                      color: colorScheme.outline,
                      width: 2,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
            ),
          ),

          if (controller.showCityError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'select_at_least_one_city'.tr,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // TIPO
  // ============================================================

  Widget _buildTypeSelection(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isLight = Get.find<ThemeController>().isLight;

    final Color boxBackgroundColor =
    isLight ? Colors.white : Colors.transparent;

    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: boxBackgroundColor,
              border: Border.all(
                color: colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Theme(
              data: theme.copyWith(
                canvasColor: boxBackgroundColor,
                cardColor: boxBackgroundColor,
                dividerColor: colorScheme.outline.withOpacity(0.3),

                // Desativa o "surface tint" automático do Material 3,
                // que sobrepõe a cor primary por cima do backgroundColor
                // e deixa a caixa com aparência acinzentada/escurecida.
                colorScheme: colorScheme.copyWith(
                  surfaceTint: Colors.transparent,
                ),
              ),
              child: ExpansionTile(
                backgroundColor: boxBackgroundColor,
                collapsedBackgroundColor: boxBackgroundColor,
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  'select_type'.tr,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                iconColor: colorScheme.onSurface,
                collapsedIconColor: colorScheme.onSurface,
                children: controller.types.map((selectedType) {
                  return CheckboxListTile(
                    tileColor: boxBackgroundColor,
                    title: Text(
                      selectedType,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    value: controller.type == selectedType,
                    onChanged: (_) {
                      controller.toggleType(selectedType);
                    },
                    activeColor: colorScheme.primary,
                    checkColor: colorScheme.onPrimary,
                    side: BorderSide(
                      color: colorScheme.outline,
                      width: 2,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
            ),
          ),

          if (controller.showTypeError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'select_at_least_one_type'.tr,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // YOUTUBE
  // ============================================================

  Widget _buildYouTubeUrlField(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller.videoUrlController,

          style: TextStyle(
            color: colors.onSurface,
          ),

          decoration: InputDecoration(
            labelText: 'youtube_url_optional'.tr,

            labelStyle: TextStyle(
              color: colors.onSurfaceVariant,
            ),

            hintText: 'youtube_url_placeholder'.tr,

            hintStyle: TextStyle(
              color: colors.onSurfaceVariant.withOpacity(0.6),
            ),

            prefixIcon: Icon(
              Icons.video_library,
              color: colors.onSurfaceVariant,
            ),

            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colors.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colors.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'paste_youtube_link_here'.tr,
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EDITOR
  // ============================================================

  Widget _buildMarkdownEditor(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    return SizedBox(
      height: 300,
      child: MarkdownEditor(
        controller: controller.bodyController,
      ),
    );
  }

  // ============================================================
  // IMAGEM
  // ============================================================

  Widget _buildImagePicker(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          controller.imageController.pickImage();
        },

        icon: const Icon(
          Icons.image,
        ),

        label: Text(
          'add_image'.tr,
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildImageInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Text(
      'image_requirements'.tr,

      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: colors.onSurface,
      ),
    );
  }

  Widget _buildImagePreview(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    return Center(
      child: Obx(
            () {
          if (controller.imageController.base64String != null) {
            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    base64Decode(
                      controller.imageController.base64String!,
                    ),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildImageMessage(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Obx(
          () => Text(
        controller.imageController.message,

        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colors.secondary,
        ),
      ),
    );
  }

  // ============================================================
  // BOTÕES
  // ============================================================

  Widget _buildPublishButton(
      BuildContext context,
      CreateNewsFormController controller,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              controller.validateAndPublish(true);
            },

            icon: Icon(
              Icons.save_outlined,
              color: colors.primary,
            ),

            label: Text(
              'save_draft_news'.tr,
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            style: OutlinedButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                52,
              ),

              side: BorderSide(
                color: colors.primary,
                width: 1.4,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              controller.validateAndPublish(false);
            },

            icon: Icon(
              Icons.rocket_launch,
              color: colors.onPrimary,
            ),

            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                52,
              ),

              backgroundColor: colors.primary,

              foregroundColor: colors.onPrimary,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            label: Text(
              'publish_news'.tr,
              style: TextStyle(
                color: colors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}