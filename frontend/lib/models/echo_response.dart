class EchoResponse {
  final String imageUrl;
  final List<String> colorPalette;
  final String poeticEcho;

  EchoResponse({
    required this.imageUrl,
    required this.colorPalette,
    required this.poeticEcho,
  });

  factory EchoResponse.fromMap(Map<String, dynamic> map) {
    return EchoResponse(
      imageUrl: map['imageUrl'] as String? ?? '',
      colorPalette: List<String>.from(map['color_palette'] ?? []),
      poeticEcho: map['poetic_echo'] as String? ?? '',
    );
  }
}
