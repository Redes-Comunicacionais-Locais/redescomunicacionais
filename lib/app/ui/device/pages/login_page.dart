import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/login_controller.dart';
import 'package:redescomunicacionais/app/controller/version_controller.dart';
import 'package:redescomunicacionais/app/services/device_detector_service.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = Get.find<LoginController>();
  final versionController = Get.find<VersionController>();
  final DeviceDetectorService deviceDetector = DeviceDetectorService.instance;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isPortrait = screenHeight > screenWidth;
    final bool isSmallScreen = screenWidth < 400 || screenHeight < 600;
    final bool isTablet = screenWidth > 600;
    final bool isWeb = deviceDetector.isWeb;
    final bool isLandscape = !isPortrait;

    // Determina se deve usar layout horizontal (web ou landscape)
    final bool useHorizontalLayout =
        isWeb || (isLandscape && screenWidth > 700);

    // Calcula tamanhos responsivos
    double titleFontSize =
        _calculateTitleSize(screenWidth, isTablet, useHorizontalLayout);
    double logoSize = _calculateLogoSize(
        screenWidth, screenHeight, isPortrait, isTablet, useHorizontalLayout);
    double buttonWidth =
        _calculateButtonWidth(screenWidth, isTablet, useHorizontalLayout);
    double versionFontSize = _calculateVersionSize(screenWidth, isTablet);

    // Calcula paddings responsivos
    EdgeInsets screenPadding = _calculateScreenPadding(
        screenWidth, screenHeight, isTablet, useHorizontalLayout);
    double verticalSpacing =
        _calculateVerticalSpacing(screenHeight, isPortrait, isSmallScreen);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: screenPadding,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (useHorizontalLayout) {
                  return _buildHorizontalLayout(
                    constraints,
                    titleFontSize,
                    logoSize,
                    buttonWidth,
                    versionFontSize,
                    verticalSpacing,
                    screenWidth,
                    isTablet,
                  );
                } else {
                  return _buildVerticalLayout(
                    constraints,
                    titleFontSize,
                    logoSize,
                    buttonWidth,
                    versionFontSize,
                    verticalSpacing,
                    screenWidth,
                    isSmallScreen,
                    isTablet,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // Layout horizontal para web e landscape
  Widget _buildHorizontalLayout(
    BoxConstraints constraints,
    double titleFontSize,
    double logoSize,
    double buttonWidth,
    double versionFontSize,
    double verticalSpacing,
    double screenWidth,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight,
        ),
        child: Row(
          children: [
            // Lado esquerdo - Logo e título
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: verticalSpacing,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Título
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: verticalSpacing * 0.8,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Redes Comunicacionais\nLocais",
                          style: TextStyle(
                            fontSize: titleFontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 1.0),

                    // Logo
                    SvgPicture.asset(
                      'assets/RCLLogo.svg',
                      width: logoSize,
                      height: logoSize,
                      // ignore: deprecated_member_use
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: verticalSpacing * 1.2),

                    // Versão
                    Text(
                      versionController.version,
                      style: TextStyle(
                        fontSize: versionFontSize,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Lado direito - Botões de login
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: verticalSpacing,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Botão Google
                    Container(
                      width: buttonWidth,
                      margin: EdgeInsets.symmetric(
                        vertical: verticalSpacing * 0.6,
                      ),
                      child: SignInButton(
                        Buttons.google,
                        text: 'Entrar com Google',
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 20.0 : 18.0,
                          horizontal: 20.0,
                        ),
                        onPressed: _loginController.loginGoogle,
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 0.4),

                    // Botão Microsoft
                    Container(
                      width: buttonWidth,
                      margin: EdgeInsets.symmetric(
                        vertical: verticalSpacing * 0.6,
                      ),
                      child: SignInButton(
                        Buttons.microsoft,
                        text: 'Entrar com Microsoft',
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 24.0 : 22.0,
                          horizontal: 20.0,
                        ),
                        onPressed: _loginController.loginMicrosoft,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Layout vertical para mobile portrait
  Widget _buildVerticalLayout(
    BoxConstraints constraints,
    double titleFontSize,
    double logoSize,
    double buttonWidth,
    double versionFontSize,
    double verticalSpacing,
    double screenWidth,
    bool isSmallScreen,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título responsivo
              Flexible(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: verticalSpacing * 0.8,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Redes Comunicacionais Locais",
                        style: TextStyle(
                          fontSize: titleFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        maxLines: isSmallScreen ? 2 : 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ),
              ),

              // Logo responsivo
              Flexible(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: verticalSpacing * 0.6),
                    child: SvgPicture.asset(
                      'assets/RCLLogo.svg',
                      width: logoSize,
                      height: logoSize,
                      // ignore: deprecated_member_use
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Botões de login responsivos
              Flexible(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botão Google
                      Container(
                        width: buttonWidth,
                        margin: EdgeInsets.symmetric(
                          vertical: verticalSpacing * 0.4,
                        ),
                        child: SignInButton(
                          Buttons.google,
                          text: 'Entrar com Google',
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 20.0 : 16.0,
                            horizontal: 16.0,
                          ),
                          onPressed: _loginController.loginGoogle,
                        ),
                      ),

                      SizedBox(height: verticalSpacing * 0.3),

                      // Botão Microsoft
                      Container(
                        width: buttonWidth,
                        margin: EdgeInsets.symmetric(
                          vertical: verticalSpacing * 0.4,
                        ),
                        child: SignInButton(
                          Buttons.microsoft,
                          text: 'Entrar com Microsoft',
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 24.0 : 22.0,
                            horizontal: 16.0,
                          ),
                          onPressed: _loginController.loginMicrosoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Versão responsiva
              Flexible(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: verticalSpacing * 0.6,
                      bottom: verticalSpacing * 0.4,
                    ),
                    child: Text(
                      versionController.version,
                      style: TextStyle(
                        fontSize: versionFontSize,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos auxiliares para cálculos responsivos
  double _calculateTitleSize(
      double screenWidth, bool isTablet, bool useHorizontalLayout) {
    if (useHorizontalLayout) {
      if (isTablet) return 36.0;
      return screenWidth < 800 ? 28.0 : 32.0;
    }

    if (isTablet) return 40.0;
    if (screenWidth < 350) return 22.0;
    if (screenWidth < 400) return 26.0;
    return 32.0;
  }

  double _calculateLogoSize(double screenWidth, double screenHeight,
      bool isPortrait, bool isTablet, bool useHorizontalLayout) {
    if (useHorizontalLayout) {
      if (isTablet) return screenHeight * 0.35;
      return screenHeight * 0.3;
    }

    if (isTablet) return screenWidth * 0.25;

    double baseSize = isPortrait ? screenWidth * 0.4 : screenHeight * 0.3;

    // Limitadores para diferentes tamanhos de tela
    if (screenWidth < 350) return baseSize.clamp(120.0, 160.0);
    if (screenWidth < 400) return baseSize.clamp(140.0, 180.0);

    return baseSize.clamp(160.0, 220.0);
  }

  double _calculateButtonWidth(
      double screenWidth, bool isTablet, bool useHorizontalLayout) {
    if (useHorizontalLayout) {
      if (isTablet) return screenWidth * 0.25;
      return screenWidth * 0.3;
    }

    if (isTablet) return screenWidth * 0.4;
    if (screenWidth < 350) return screenWidth * 0.85;
    if (screenWidth < 400) return screenWidth * 0.8;
    return screenWidth * 0.75;
  }

  double _calculateVersionSize(double screenWidth, bool isTablet) {
    if (isTablet) return 14.0;
    if (screenWidth < 350) return 9.0;
    return 10.0;
  }

  EdgeInsets _calculateScreenPadding(double screenWidth, double screenHeight,
      bool isTablet, bool useHorizontalLayout) {
    if (useHorizontalLayout) {
      double horizontal = isTablet ? screenWidth * 0.08 : screenWidth * 0.05;
      double vertical = isTablet ? screenHeight * 0.04 : screenHeight * 0.02;

      return EdgeInsets.symmetric(
        horizontal: horizontal.clamp(20.0, 80.0),
        vertical: vertical.clamp(16.0, 40.0),
      );
    }

    double horizontal = isTablet ? screenWidth * 0.1 : screenWidth * 0.05;
    double vertical = isTablet ? screenHeight * 0.05 : screenHeight * 0.02;

    return EdgeInsets.symmetric(
      horizontal: horizontal.clamp(16.0, 60.0),
      vertical: vertical.clamp(8.0, 30.0),
    );
  }

  double _calculateVerticalSpacing(
      double screenHeight, bool isPortrait, bool isSmallScreen) {
    if (isSmallScreen) return screenHeight * 0.035;
    if (!isPortrait) return screenHeight * 0.045;
    return screenHeight * 0.04;
  }
}
