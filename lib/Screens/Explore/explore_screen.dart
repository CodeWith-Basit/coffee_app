import 'package:coffee_appv2/Screens/ProductDetail/product_detail_screen.dart';
import 'package:coffee_appv2/core/data/app_data.dart';
import 'package:coffee_appv2/core/services/cart_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/widget/build_category_card.dart';
import 'package:coffee_appv2/widget/product_card.dart';
import 'package:coffee_appv2/widget/search_widget.dart';
import 'package:coffee_appv2/widget/seasonal_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedCategory = "Coffee";

  @override
  Widget build(BuildContext context) {
    final currentProducts = AppData.productsByCategory[selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: AppColors.latteMist,
      appBar: AppBar(
        backgroundColor: AppColors.latteMist,
        elevation: 0,
        title: Text(
          'DISCOVER',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.burntCaramel,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Explore KOVERA",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBackground,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderLight, width: 1.5),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search coffee, cakes, cookies, teas...",
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.mutedTaupe,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.burntCaramel,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Popular Searches",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBackground,
                ),
              ),
              const SizedBox(height: 8),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SearchWidget(text: "Espresso"),
                  SearchWidget(text: "Caramel"),
                  SearchWidget(text: "Latte"),
                  SearchWidget(text: "Cheesecake"),
                  SearchWidget(text: "Cookie"),
                  SearchWidget(text: "Cold Brew"),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Seasonal Editions",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.burntCaramel,
                ),
              ),
                Text(
                  "Curated Collections",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBackground,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SeasonalCard(
                        imagePath:
                            "https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=1037&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        title: "Autumn Vibes",
                        description: "Warm & Cozy",
                      ),
                      SeasonalCard(
                        imagePath:
                            "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?q=80&w=869&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        title: "Autumn Vibes",
                        description: "Warm & Cozy",
                      ),
                      SeasonalCard(
                        imagePath:
                            "https://images.unsplash.com/photo-1561478908-d067fe75a553?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        title: "Autumn Vibes",
                        description: "Warm & Cozy",
                      ),
                      SeasonalCard(
                        imagePath:
                            "https://images.unsplash.com/photo-1509785307050-d4066910ec1e?q=80&w=728&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        title: "Autumn Vibes",
                        description: "Warm & Cozy",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AppData.categories.map((category) {
                      final isActive = category["label"] == selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Buildcategorycard(
                          icon: category["icon"] as IconData,
                          label: category["label"] as String,
                          isActive: isActive,
                          onTap: () {
                            setState(() {
                              selectedCategory = category["label"] as String;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.63,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return Productcard(
                      imgurl: currentProducts[index]["imgurl"]!,
                      title: currentProducts[index]["title"]!,
                      subtitle: currentProducts[index]["subtitle"]!,
                      price: currentProducts[index]["price"]!,
                      category: selectedCategory,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              imgurl: currentProducts[index]["imgurl"]!,
                              title: currentProducts[index]["title"]!,
                              subtitle: currentProducts[index]["subtitle"]!,
                              price: currentProducts[index]["price"]!,
                              category: selectedCategory,
                            ),
                          ),
                        );
                      },
                      onAddToCart: () {
                        final parsedPrice =
                            double.tryParse(currentProducts[index]["price"]!) ?? 0.0;
                        final added = CartService.instance.addToCart(
                          title: currentProducts[index]["title"]!,
                          imgurl: currentProducts[index]["imgurl"]!,
                          price: parsedPrice,
                          subtitle: currentProducts[index]["subtitle"],
                        );

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              added
                                  ? "Added ${currentProducts[index]['title']} to Order"
                                  : "${currentProducts[index]['title']} is already added in Order",
                              style: GoogleFonts.plusJakartaSans(),
                            ),
                            backgroundColor: added
                                ? AppColors.burntCaramel
                                : AppColors.deepEspresso,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: currentProducts.length,
                ),
              ],
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
