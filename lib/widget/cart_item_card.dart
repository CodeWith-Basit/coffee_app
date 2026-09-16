import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const CartItemCard({
    super.key,
    required this.item,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                item.imgurl,
                height: 74,
                width: 74,
                fit: BoxFit.cover,
                cacheWidth: 250,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 74,
                  width: 74,
                  color: AppColors.latteMist,
                  child: const Icon(
                    Icons.coffee,
                    color: AppColors.burntCaramel,
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
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepEspresso,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mutedTaupe,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    "\$${item.price.toStringAsFixed(2)}",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.burntCaramel,
                    ),
                  ),
                ],
              ),
            ),

            // Actions (Remove button & Quantity controls)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onRemove != null)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onRemove,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                // Quantity controls
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.latteMist,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: onDecrement,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowLight,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.remove,
                            size: 14,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${item.quantity}",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onIncrement,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.burntCaramel,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
