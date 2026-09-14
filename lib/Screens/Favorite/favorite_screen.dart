import 'package:coffee_appv2/core/services/cart_service.dart';
import 'package:coffee_appv2/core/services/favorite_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/models/favorite_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteMist,
      appBar: AppBar(
        backgroundColor: AppColors.latteMist,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Favorites",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.deepEspresso,
          ),
        ),
      ),
      body: ValueListenableBuilder<List<FavoriteItem>>(
        valueListenable: FavoriteService.instance.favoritesNotifier,
        builder: (context, favorites, _) {
          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.burntCaramel.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 42,
                        color: AppColors.burntCaramel,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "No Favorites Yet",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepEspresso,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tap the heart icon on any coffee or treat to save your favorites here.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 1.4,
                        color: AppColors.mutedTaupe,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final item = favorites[index];

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderLight, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Image with rounded corners
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        item.imgurl,
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 75,
                          width: 75,
                          color: AppColors.latteMist,
                          child: const Icon(
                            Icons.coffee,
                            color: AppColors.mutedTaupe,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Title, Subtitle, Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepEspresso,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.mutedTaupe,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
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
                                item.price,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.deepEspresso,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: Color(0xFFFFB800),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                item.rating,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mutedTaupe,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Action buttons (Add to cart & Remove favorite)
                    Column(
                      children: [
                        // Remove from favorites button
                        GestureDetector(
                          onTap: () {
                            FavoriteService.instance.removeFavorite(item.title);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Removed ${item.title} from Favorites",
                                  style: GoogleFonts.plusJakartaSans(),
                                ),
                                backgroundColor: AppColors.deepEspresso,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: AppColors.latteMist.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              size: 18,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Add to cart button
                        GestureDetector(
                          onTap: () {
                            final parsedPrice =
                                double.tryParse(item.price) ?? 0.0;
                            final added = CartService.instance.addToCart(
                              title: item.title,
                              imgurl: item.imgurl,
                              price: parsedPrice,
                              subtitle: item.subtitle,
                            );

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  added
                                      ? "Added ${item.title} to Order"
                                      : "${item.title} is already in Order",
                                  style: GoogleFonts.plusJakartaSans(),
                                ),
                                backgroundColor: added
                                    ? AppColors.burntCaramel
                                    : AppColors.deepEspresso,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: AppColors.burntCaramel,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.burntCaramel
                                      .withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
