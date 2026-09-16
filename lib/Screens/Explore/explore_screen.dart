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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onPopularSearchTap(String query) {
    setState(() {
      _searchQuery = query;
      _searchController.text = query;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: query.length),
      );
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _searchQuery.trim().isNotEmpty;
    final List<Map<String, String>> pool = isSearching
        ? AppData.productsByCategory.values.expand((list) => list).toList()
        : (AppData.productsByCategory[selectedCategory] ?? []);
    final currentProducts = isSearching
        ? pool.where((prod) {
            final title = prod["title"]!.toLowerCase();
            final subtitle = prod["subtitle"]!.toLowerCase();
            final query = _searchQuery.toLowerCase().trim();
            return title.contains(query) || subtitle.contains(query);
          }).toList()
        : pool;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.darkBackground,
                    ),
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
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppColors.mutedTaupe,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = "";
                                });
                                FocusScope.of(context).unfocus();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (!isSearching) ...[
                  Text(
                    "Popular Searches",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SearchWidget(
                        text: "Espresso",
                        onTap: () => _onPopularSearchTap("Espresso"),
                      ),
                      const SizedBox(width: 8),
                      SearchWidget(
                        text: "Caramel",
                        onTap: () => _onPopularSearchTap("Caramel"),
                      ),
                      const SizedBox(width: 8),
                      SearchWidget(
                        text: "Latte",
                        onTap: () => _onPopularSearchTap("Latte"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SearchWidget(
                        text: "Cheesecake",
                        onTap: () => _onPopularSearchTap("Cheesecake"),
                      ),
                      const SizedBox(width: 8),
                      SearchWidget(
                        text: "Cookie",
                        onTap: () => _onPopularSearchTap("Cookie"),
                      ),
                      const SizedBox(width: 8),
                      SearchWidget(
                        text: "Cold Brew",
                        onTap: () => _onPopularSearchTap("Cold Brew"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                if (!isSearching) ...[
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
                  const SingleChildScrollView(
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
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Search Results',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkBackground,
                        ),
                      ),
                      Text(
                        '${currentProducts.length} items found',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mutedTaupe,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                if (currentProducts.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppColors.mutedTaupe.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No items found for "$_searchQuery"',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedTaupe,
                          ),
                        ),
                      ],
                    ),
                  )
                else
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
                          double.tryParse(currentProducts[index]["price"]!) ??
                          0.0;
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

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
