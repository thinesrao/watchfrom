import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watchfrom/data/api/tmdb_image_url.dart';

class ProviderLogo extends StatelessWidget {
  const ProviderLogo({
    super.key,
    required this.logoPath,
    this.size = 40,
  });

  final String logoPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: TmdbImageUrl.logo(logoPath),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => SizedBox(
          width: size,
          height: size,
          child: const ColoredBox(
            color: Colors.grey,
            child: Icon(Icons.tv, size: 20),
          ),
        ),
      ),
    );
  }
}
