import 'package:coffee_appv2/Screens/Checkout/checkout_screen.dart';
import 'package:coffee_appv2/Screens/ProductDetail/product_detail_screen.dart';
import 'package:coffee_appv2/core/services/cart_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/models/cart_item.dart';
import 'package:coffee_appv2/widget/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteMist,
      appBar: AppBar(
        backgroundColor: AppColors.latteMist,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your Order",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.deepEspresso,
          ),
        ),
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: CartService.instance.cartNotifier,
        builder: (context, cartItems, _) {
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: AppColors.mutedTaupe,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Your cart is empty",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepEspresso,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Add drinks & treats from Home or Explore",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.mutedTaupe,
                    ),
                  ),
                ],
              ),
            );
          }

          final subtotal = CartService.instance.subtotal;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return CartItemCard(
                      item: item,
                      onIncrement: () {
                        CartService.instance.incrementQuantity(index);
                      },
                      onDecrement: () {
                        CartService.instance.decrementQuantity(index);
                      },
                      onRemove: () {
                        CartService.instance.removeItem(index);
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              imgurl: item.imgurl,
                              title: item.title,
                              subtitle: item.subtitle ?? "Artisan Brew",
                              price: item.price.toStringAsFixed(2),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // Checkout summary container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowDark.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.mutedTaupe,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "\$${subtotal.toStringAsFixed(2)}",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepEspresso,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  items: cartItems,
                                  subtotal: subtotal,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.burntCaramel,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Checkout (\$${subtotal.toStringAsFixed(2)})",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
