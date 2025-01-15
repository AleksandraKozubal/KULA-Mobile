import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TikTokSocialMediaButton extends StatelessWidget {
  final String url;
  final double size;
  final Color color;

  const TikTokSocialMediaButton({
    required this.url,
    this.size = 24.0,
    this.color = Colors.black,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.music_note,
        size: size,
        color: color,
      ),
      onPressed: () => _launchURL(url),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
