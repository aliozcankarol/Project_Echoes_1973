import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/echo_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexString) {
    var hexColor = hexString.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  void _submit(BuildContext context) {
    final text = _controller.text;
    if (text.isNotEmpty) {
      context.read<EchoService>().submitEcho(text);
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EchoService>(
      builder: (context, echoService, child) {
        final state = echoService.state;
        final response = echoService.response;

        // Default background
        List<Color> backgroundGradient = [
          const Color(0xFF1A1A1A),
          const Color(0xFF111111),
        ];

        if (state == EchoState.success && response != null && response.colorPalette.isNotEmpty) {
          try {
            backgroundGradient = response.colorPalette.map(_hexToColor).toList();
            if (backgroundGradient.length == 1) {
              backgroundGradient.add(backgroundGradient.first.withValues(alpha: 0.8));
            }
          } catch (e) {
            // Fallback if hex parsing fails
          }
        }

        return Scaffold(
          body: AnimatedContainer(
            duration: const Duration(seconds: 3),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: backgroundGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: _buildContent(context, echoService),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, EchoService echoService) {
    final state = echoService.state;

    if (state == EchoState.loading) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          "Tuning frequency...",
          style: GoogleFonts.cormorantGaramond(
            color: Colors.white70,
            fontSize: 24,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    if (state == EchoState.success && echoService.response != null) {
      final response = echoService.response!;
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              curve: Curves.easeIn,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    response.poeticEcho,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 28,
                      height: 1.5,
                      letterSpacing: 1.2,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 3),
              curve: Curves.easeIn,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24, width: 8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.matrix([
                        0.393, 0.769, 0.189, 0, 0,
                        0.349, 0.686, 0.168, 0, 0,
                        0.272, 0.534, 0.131, 0, 0,
                        0,     0,     0,     1, 0,
                      ]), // Sepia filter
                      child: Image.network(
                        response.imageUrl,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 300,
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(color: Colors.white38),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 300,
                            height: 300,
                            color: Colors.black12,
                            child: const Center(
                              child: Icon(Icons.broken_image, color: Colors.white24, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () => echoService.reset(),
              child: Text(
                "Leave another memory",
                style: GoogleFonts.cormorantGaramond(
                  color: Colors.white54,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state == EchoState.error)
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text(
              echoService.errorMessage ?? "An error occurred.",
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                color: Colors.red[300],
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        TextField(
          controller: _controller,
          style: GoogleFonts.cormorantGaramond(
            color: Colors.white,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
          cursorColor: Colors.white54,
          decoration: InputDecoration(
            hintText: "What are you leaving behind?",
            hintStyle: GoogleFonts.cormorantGaramond(
              color: Colors.white38,
              fontSize: 28,
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
          onSubmitted: (_) => _submit(context),
        ),
      ],
    );
  }
}
