import 'package:coffee_appv2/core/services/favorite_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/models/favorite_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Productcard extends StatelessWidget {
  final String imgurl;
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final String? category;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const Productcard({
    super.key,
    required this.imgurl,
    required this.title,
    required this.subtitle,
    required this.price,
    this.rating = "4.8",
    this.category,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 185,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight, width: 1),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with rounded corners and floating tags
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imgurl,
                    height: 135,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheWidth: 500,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 135,
                        width: double.infinity,
                        color: AppColors.latteMist.withValues(alpha: 0.6),
                        child: const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.burntCaramel,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 135,
                      width: double.infinity,
                      color: AppColors.latteMist,
                      child: const Icon(
                        Icons.coffee,
                        color: AppColors.mutedTaupe,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                // Rating Badge (Top Left)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.deepEspresso.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB800),
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          rating,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Favorite Heart Button (Top Right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: ValueListenableBuilder<List<FavoriteItem>>(
                    valueListenable: FavoriteService.instance.favoritesNotifier,
                    builder: (context, favorites, _) {
                      final isFav = favorites.any(
                        (item) => item.title == title,
                      );

                      return GestureDetector(
                        onTap: () {
                          final added = FavoriteService.instance.toggleFavorite(
                            title: title,
                            imgurl: imgurl,
                            subtitle: subtitle,
                            price: price,
                            rating: rating,
                          );

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                added
                                    ? "Added $title to Favorites"
                                    : "Removed $title from Favorites",
                                style: GoogleFonts.plusJakartaSans(),
                              ),
                              backgroundColor: added
                                  ? AppColors.burntCaramel
                                  : AppColors.deepEspresso,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: isFav
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                            boxShadow: isFav
                                ? [
                                    BoxShadow(
                                      color: AppColors.burntCaramel.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17,
                            color: isFav
                                ? const Color(0xFFD32F2F)
                                : AppColors.burntCaramel,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Product Title
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.deepEspresso,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),

            // Product Subtitle / Description
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                height: 1.3,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedTaupe,
              ),
            ),
            const SizedBox(height: 12),

            // Price & Add to Cart Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price Tag
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.burntCaramel,
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepEspresso,
                      ),
                    ),
                  ],
                ),

                // Add to Cart Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onAddToCart,
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.burntCaramel,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.burntCaramel.withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            "Add",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
