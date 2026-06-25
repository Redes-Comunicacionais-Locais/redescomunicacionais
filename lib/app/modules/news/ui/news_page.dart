import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:redescomunicacionais/app/services/youtube_service.dart';
import 'package:redescomunicacionais/app/utils/responsive_utils.dart';
import 'package:redescomunicacionais/app/modules/news/controller/news_controller.dart';

class NewsPage extends GetView<NewsController> {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Configurações responsivas
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isTablet = ResponsiveUtils.isTablet(screenWidth);
    final bool isWideScreen = screenWidth > 900; // Para modo horizontal/web

    bool hasMoreThanTwoCategories =
        controller.selectedNews.categories.length > 2;
    List<String> visibleCategories = hasMoreThanTwoCategories
        ? controller.selectedNews.categories.take(2).toList()
        : controller.selectedNews.categories;

    return GetBuilder<NewsController>(
      init: controller,
      initState: (_) {
        try {
          controller.quillController?.dispose();
        } catch (_) {}

        controller.startQuillController();
      },
      dispose: (_) {
        try {
          controller.quillController?.dispose();
        } catch (_) {}
      },
      builder: (_) {
        if (controller.quillController == null) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              '${'full_type'.tr} ${controller.selectedNews.type}',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveUtils.calculateAppBarTitleSize(
                    screenWidth, isTablet, false),
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
              size: ResponsiveUtils.calculateIconSize(screenWidth, isTablet),
            ),
            centerTitle: true,
            toolbarHeight: isTablet ? 70.0 : 56.0,
          ),
          body: isWideScreen
              ? _buildWideScreenLayout(
                  screenWidth,
                  screenHeight,
                  isTablet,
                  visibleCategories,
                  hasMoreThanTwoCategories,
                  context,
                )
              : _buildMobileLayout(
                  screenWidth,
                  screenHeight,
                  isTablet,
                  visibleCategories,
                  hasMoreThanTwoCategories,
                  context,
                ),
        );
      },
    );
  }

  // Layout para telas grandes (modo horizontal/web)
  Widget _buildWideScreenLayout(
    double screenWidth,
    double screenHeight,
    bool isTablet,
    List<String> visibleCategories,
    bool hasMoreThanTwoCategories,
    BuildContext context,
  ) {
    String urlImages = controller.selectedNews.urlImages[0];
    List<String> cities = controller.selectedNews.cities;
    return Row(
      children: [
        // Lado esquerdo - Informações da notícia
        SizedBox(
          width: screenWidth * 0.4,
          height: screenHeight,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container da imagem (usa asset se imgurl vazio)
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      ResponsiveUtils.calculateResponsiveBorderRadius(
                              isTablet) *
                          0.8),
                  child: urlImages.isNotEmpty
                      ? Image.memory(
                          base64Decode(urlImages),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: isTablet ? 300 : 250,
                        )
                      : Image.asset(
                          controller.getCityImageAsset(
                              cities.isNotEmpty ? cities[0] : 'default'),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: isTablet ? 300 : 250,
                        ),
                ),
                SizedBox(height: isTablet ? 25 : 20),

                // Container do título
                Text(
                  controller.selectedNews.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 32 : 28,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 12 : 10),

                // Container do subtítulo
                Text(
                  controller.selectedNews.subtitle ?? '',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: isTablet ? 20 : 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 25 : 20),

                // Container com informações da notícia
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24, width: 1),
                    borderRadius: BorderRadius.circular(
                        ResponsiveUtils.calculateResponsiveBorderRadius(
                                isTablet) *
                            0.8),
                    color: Colors.white.withOpacity(0.05),
                  ),
                  padding: EdgeInsets.all(isTablet ? 16 : 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título da seção
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white70,
                            size: isTablet ? 20 : 18,
                          ),
                          SizedBox(width: isTablet ? 8 : 6),
                          Text(
                            '${'info_of'.tr} ${controller.selectedNews.type}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 12 : 10),

                      // Linha divisória
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white24,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 10),

                      // Informações organizadas
                      _buildInfoRowWideScreen(
                        isTablet,
                        visibleCategories,
                        hasMoreThanTwoCategories,
                        context,
                      ),
                    ],
                  ),
                ),
                // Espaçamento extra no final
                SizedBox(height: isTablet ? 40 : 32),
              ],
            ),
          ),
        ),

        // Divisor vertical
        Container(
          width: 1,
          height: screenHeight,
          color: Colors.white24,
        ),

        // Lado direito
        Expanded(
          child: Container(
            height: screenHeight,
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título da seção do conteúdo
                  Container(
                    child: Text(
                      '${'content_of'.tr} ${controller.selectedNews.type}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),

                  if (controller.selectedNews.videoUrl != '')
                    // Mini player do YouTube
                    Container(
                      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
                      child: YouTubeMiniPlayer(
                        videoUrl: controller.selectedNews.videoUrl!,
                        width: double.infinity,
                        height: isTablet ? 200 : 160,
                        autoPlay: false,
                        mute: false,
                        enableCaption: true,
                        captionLanguage: 'pt',
                      ),
                    ),
                  // Container com o conteúdo da notícia
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 400, // Altura mínima para o conteúdo
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(
                          ResponsiveUtils.calculateResponsiveBorderRadius(
                                  isTablet) *
                              0.5),
                    ),
                    child: AbsorbPointer(
                      child: QuillEditor.basic(
                        controller: controller.quillController,
                        focusNode: FocusNode(),
                        scrollController: ScrollController(),
                        config: QuillEditorConfig(
                          padding: EdgeInsets.all(isTablet ? 20 : 16),
                          autoFocus: false,
                          expands: false,
                          enableInteractiveSelection: false,
                          customStyles: DefaultStyles(
                            paragraph: DefaultTextBlockStyle(
                              TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 18 : 16,
                              ),
                              HorizontalSpacing.zero,
                              const VerticalSpacing(6, 0),
                              const VerticalSpacing(0, 0),
                              null,
                            ),
                            bold: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 18 : 16,
                            ),
                            italic: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: isTablet ? 18 : 16,
                            ),
                            underline: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                              fontSize: isTablet ? 18 : 16,
                            ),
                            quote: DefaultTextBlockStyle(
                              TextStyle(
                                color: Colors.white70,
                                fontSize: isTablet ? 18 : 16,
                              ),
                              HorizontalSpacing.zero,
                              const VerticalSpacing(6, 6),
                              const VerticalSpacing(0, 0),
                              BoxDecoration(
                                border: Border(
                                  left:
                                      BorderSide(color: Colors.white, width: 4),
                                ),
                              ),
                            ),
                            lists: DefaultListBlockStyle(
                              TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 18 : 16,
                              ),
                              HorizontalSpacing.zero,
                              const VerticalSpacing(6, 0),
                              const VerticalSpacing(0, 0),
                              const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Layout para dispositivos móveis (layout vertical original)
  Widget _buildMobileLayout(
    double screenWidth,
    double screenHeight,
    bool isTablet,
    List<String> visibleCategories,
    bool hasMoreThanTwoCategories,
    BuildContext context,
  ) {
    String urlImages = controller.selectedNews.urlImages[0];
    List<String> cities = controller.selectedNews.cities;
    return ListView(
      padding: ResponsiveUtils.calculateResponsivePadding(
          screenWidth, screenHeight, isTablet),
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  ResponsiveUtils.calculateResponsiveBorderRadius(isTablet) *
                      0.8),
              child: urlImages.isNotEmpty
                  ? Image.memory(
                      base64Decode(urlImages),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: isTablet ? 250 : 200,
                    )
                  : Image.asset(
                      controller.getCityImageAsset(
                          cities[0].isNotEmpty ? cities[0] : 'default'),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: isTablet ? 250 : 200,
                    ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 25 : 20),
        //Título
        Text(
          controller.selectedNews.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 32 : 28,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isTablet ? 12 : 10),
        //Subtítulo
        Text(
          controller.selectedNews.subtitle ?? '',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
            fontSize: isTablet ? 20 : 18,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isTablet ? 25 : 20),

        // Container com informações da notícia
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24, width: 1),
            borderRadius: BorderRadius.circular(
                ResponsiveUtils.calculateResponsiveBorderRadius(isTablet) *
                    0.8),
            color: Colors.white.withOpacity(0.05),
          ),
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da seção
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white70,
                    size: isTablet ? 20 : 18,
                  ),
                  SizedBox(width: isTablet ? 8 : 6),
                  Text(
                    '${'info_of'.tr} ${controller.selectedNews.type}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 12 : 10),

              // Linha divisória
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white24,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 12 : 10),

              // Informações organizadas
              _buildInfoRow(
                isTablet,
                visibleCategories,
                hasMoreThanTwoCategories,
                context,
              ),
            ],
          ),
        ),
        SizedBox(height: isTablet ? 25 : 20),

        if (controller.selectedNews.videoUrl != '')
          // Mini player do YouTube
          Container(
            padding: EdgeInsets.all(isTablet ? 16 : 12),
            child: YouTubeMiniPlayer(
              videoUrl: controller.selectedNews.videoUrl!,
              width: screenWidth * 0.9, // 90% da largura da tela
              height: isTablet ? 220 : 180,
              autoPlay: false,
              mute: false,
              enableCaption: true,
              captionLanguage: 'pt',
            ),
          ),
        SizedBox(height: isTablet ? 25 : 20),

        // Container com o conteúdo da notícia
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(
                ResponsiveUtils.calculateResponsiveBorderRadius(isTablet) *
                    0.5),
          ),
          child: AbsorbPointer(
            // ← BLOQUEIA TODA INTERAÇÃO
            child: QuillEditor.basic(
              controller: controller.quillController,
              focusNode: FocusNode(),
              scrollController: ScrollController(),
              config: QuillEditorConfig(
                padding: EdgeInsets.all(isTablet ? 20 : 16),
                autoFocus: false,
                expands: false,
                customStyles: DefaultStyles(
                  paragraph: DefaultTextBlockStyle(
                    TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 18 : 16,
                    ),
                    HorizontalSpacing.zero,
                    const VerticalSpacing(6, 0),
                    const VerticalSpacing(0, 0),
                    null,
                  ),
                  bold: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 18 : 16,
                  ),
                  italic: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: isTablet ? 18 : 16,
                  ),
                  underline: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    fontSize: isTablet ? 18 : 16,
                  ),
                  quote: DefaultTextBlockStyle(
                    TextStyle(
                      color: Colors.white70,
                      fontSize: isTablet ? 18 : 16,
                    ),
                    HorizontalSpacing.zero,
                    const VerticalSpacing(6, 6),
                    const VerticalSpacing(0, 0),
                    BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.white, width: 4),
                      ),
                    ),
                  ),
                  lists: DefaultListBlockStyle(
                    TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 18 : 16,
                    ),
                    HorizontalSpacing.zero,
                    const VerticalSpacing(6, 0),
                    const VerticalSpacing(0, 0),
                    const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget para construir a linha de informações com categorias responsivas (layout wide screen)
  Widget _buildInfoRowWideScreen(
    bool isTablet,
    List<String> visibleCategories,
    bool hasMoreThanTwoCategories,
    BuildContext context,
  ) {
    return Column(
      children: [
        // Primeira linha: Autor
        _buildInfoItem(
          icon: Icons.person_outline,
          label: 'author'.tr,
          value: controller.selectedNews.author,
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 12 : 10),

        // Segunda linha: Data
        _buildInfoItem(
          icon: Icons.schedule,
          label: 'date'.tr,
          value: DateFormat('dd/MM/yyyy')
              .format(controller.selectedNews.createdAt),
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 12 : 10),

        // Terceira linha: Cidade
        _buildInfoItem(
          icon: Icons.location_city,
          label: 'city'.tr,
          value: controller.selectedNews.cities[0],
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 12 : 10),

        // Quarta linha: Tipo
        _buildInfoItem(
          icon: Icons.category,
          label: 'type'.tr,
          value: controller.selectedNews.type,
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 12 : 10),
        _buildInfoItem(
          icon: Icons.category,
          label: 'type'.tr,
          value: controller.selectedNews.type,
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 12 : 10),
        // Quinta linha: Categorias
        _buildCategoriesItem(isTablet, controller.selectedNews.categories,
            visibleCategories, hasMoreThanTwoCategories, context),
      ],
    );
  }

  // Widget para construir a linha de informações com categorias responsivas
  Widget _buildInfoRow(
    bool isTablet,
    List<String> visibleCategories,
    bool hasMoreThanTwoCategories,
    BuildContext context,
  ) {
    return Column(
      children: [
        // Primeira linha: Autor e Data
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                icon: Icons.person_outline,
                label: 'author'.tr,
                value: controller.selectedNews.author,
                isTablet: isTablet,
              ),
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Expanded(
              child: _buildInfoItem(
                icon: Icons.schedule,
                label: 'date'.tr,
                value: DateFormat('dd/MM/yyyy')
                    .format(controller.selectedNews.createdAt),
                isTablet: isTablet,
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 12 : 10),

        // Segunda linha: Cidade e Tipo
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                icon: Icons.location_city,
                label: 'city'.tr,
                value: controller.selectedNews.cities[0],
                isTablet: isTablet,
              ),
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Expanded(
              child: _buildInfoItem(
                icon: Icons.category,
                label: 'type'.tr,
                value: controller.selectedNews.type,
                isTablet: isTablet,
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 12 : 10),

        // Terceira linha: Categorias
        _buildCategoriesItem(isTablet, controller.selectedNews.categories,
            visibleCategories, hasMoreThanTwoCategories, context),
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                  icon: Icons.supervisor_account,
                  label: 'reviewer'.tr,
                  value: controller.selectedNews.validatedByName ?? '',
                  isTablet: isTablet),
            )
          ],
        )
      ],
    );
  }

  // Widget para criar um item de informação individual
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 10 : 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(
            ResponsiveUtils.calculateResponsiveBorderRadius(isTablet) * 0.5),
        border: Border.all(color: Colors.white12, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white60,
                size: isTablet ? 16 : 14,
              ),
              SizedBox(width: isTablet ? 6 : 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: isTablet ? 12 : 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 4 : 2),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget específico para categorias
  Widget _buildCategoriesItem(
      bool isTablet,
      List<String> categorias,
      List<String> visibleCategories,
      bool hasMoreThanTwoCategories,
      BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 10 : 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(
            ResponsiveUtils.calculateResponsiveBorderRadius(isTablet) * 0.5),
        border: Border.all(color: Colors.white12, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.label_outline,
                color: Colors.white60,
                size: isTablet ? 16 : 14,
              ),
              SizedBox(width: isTablet ? 6 : 4),
              Text(
                categorias.length > 1 ? 'categories'.tr : 'category'.tr,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: isTablet ? 12 : 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 4 : 2),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              ...visibleCategories.map((cat) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 8 : 6,
                      vertical: isTablet ? 4 : 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                          ResponsiveUtils.calculateResponsiveBorderRadius(
                                  isTablet) *
                              0.3),
                      border: Border.all(
                          color: Colors.blue.withOpacity(0.5), width: 0.5),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 13 : 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
              if (hasMoreThanTwoCategories)
                GestureDetector(
                  onTap: () =>
                      _showAllCategoriesDialog(context, categorias, isTablet),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 8 : 6,
                      vertical: isTablet ? 4 : 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                          ResponsiveUtils.calculateResponsiveBorderRadius(
                                  isTablet) *
                              0.3),
                      border: Border.all(color: Colors.orange, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "+${categorias.length - 2}",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: isTablet ? 13 : 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.orange,
                          size: isTablet ? 14 : 12,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Método para mostrar popup com todas as categorias
  void _showAllCategoriesDialog(
      BuildContext context, List<String> categorias, bool isTablet) {
    showDialog(
      context: context,
      builder: (context) {
        return ResponsiveUtils.createResponsiveDialog(
          context: context,
          title: 'all_categories'.tr,
          content: categorias.join(", "),
          onConfirm: () => Navigator.of(context).pop(),
          confirmText: 'close'.tr,
        );
      },
    );
  }
}
