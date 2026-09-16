import 'dart:ui';

import 'package:coffee_appv2/Screens/ProductDetail/product_detail_screen.dart';
import 'package:coffee_appv2/Screens/Shop/shop_screen.dart';
import 'package:coffee_appv2/core/data/app_data.dart';
import 'package:coffee_appv2/core/services/cart_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/widget/build_category_card.dart';
import 'package:coffee_appv2/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String selectedCategory = "Coffee";

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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

    final topPadding = MediaQuery.of(context).padding.top;
    const double kToolbarContentHeight = kToolbarHeight;
    final double totalAppBarHeight = topPadding + kToolbarContentHeight;

    return Scaffold(
      backgroundColor: AppColors.latteMist,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            final double offset = _scrollController.hasClients
                ? _scrollController.offset
                : 0.0;
            // Clamped progress from 0.0 at offset 0 to 1.0 at offset 100+
            final double progress = (offset / 100.0).clamp(0.0, 1.0);

            // Opacity: from 0.0 (mostly transparent/natural blend) to 0.78 (subtle semi-transparent, not completely opaque)
            final double bgOpacity = progress * 0.78;
            // Blur sigma: from 0.0 to 14.0 (smooth BackdropFilter blur within 10-15 range)
            final double blurSigma = progress * 14.0;
            // Subtle bottom divider border opacity when scrolled
            final double borderOpacity = progress * 0.12;

            return ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.latteMist.withValues(alpha: bgOpacity),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.mutedTaupe.withValues(
                          alpha: borderOpacity,
                        ),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: child,
                ),
              ),
            );
          },
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: 16,
            title: Text(
              'GOOD MORNING',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.burntCaramel,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShopScreen()),
                  );
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.mutedTaupe.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.shopping_cart_checkout,
                    color: AppColors.softAmber,
                    size: 20,
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.mutedTaupe.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.notification_add,
                  color: AppColors.softAmber,
                  size: 20,
                ),
              ),
              Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.only(left: 4, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.mutedTaupe.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: totalAppBarHeight + 12),
                Text(
                  "What will\nyou sip today?",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: AppColors.deepEspresso,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Welcome to KŌVÉRA, your sanctuary for premium coffee moments.",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mutedTaupe,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: _searchController,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.softAmber,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                size: 18,
                                color: AppColors.mutedTaupe,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            )
                          : const Icon(
                              Icons.filter_alt_outlined,
                              color: AppColors.softAmber,
                            ),
                      hintText: "Search caramel latte, cold brew, cake...",
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mutedTaupe,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ================= SEARCH VIEW =================
                if (isSearching) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Search Results",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepEspresso,
                        ),
                      ),
                      Text(
                        "${currentProducts.length} items found",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mutedTaupe,
                        ),
                      ),
                    ],
                  ),

                  if (currentProducts.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 52,
                            color: AppColors.mutedTaupe.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No coffee or treat found for "$_searchQuery"',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mutedTaupe,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.63,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: currentProducts.length,
                    itemBuilder: (context, index) {
                      final product = currentProducts[index];
                      return Productcard(
                        imgurl: product["imgurl"]!,
                        title: product["title"]!,
                        subtitle: product["subtitle"]!,
                        price: product["price"]!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                imgurl: product["imgurl"]!,
                                title: product["title"]!,
                                subtitle: product["subtitle"]!,
                                price: product["price"]!,
                                category: selectedCategory,
                              ),
                            ),
                          );
                        },
                        onAddToCart: () {
                          final parsedPrice =
                              double.tryParse(product["price"]!) ?? 0.0;
                          final added = CartService.instance.addToCart(
                            title: product["title"]!,
                            imgurl: product["imgurl"]!,
                            price: parsedPrice,
                            subtitle: product["subtitle"],
                          );

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                added
                                    ? "Added ${product['title']} to Order"
                                    : "${product['title']} is already added in Order",
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
                  ),
                ] else ...[
                  // ================= NORMAL FULL UI =================
                  Container(
                    padding: const EdgeInsets.all(18),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.deepEspresso,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.softAmber,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColors.softAmber.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                                child: Text(
                                  "THE MORNING EDIT",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.burntCaramel,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Caramel\nCloud Latte",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Warm, frothy, and\nperfectly sweetened.",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.softAmber,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "10% OFF",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.burntCaramel,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.burntCaramel,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Order Now",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSd3AKE2lB_47MhSljDZUr-3qFxaHkZ2fXC_9p9VUordZgUk2u-bQSx1MDg&s=10',
                            height: 180,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Our Specialties",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: AppColors.deepEspresso,
                        ),
                      ),
                      Text(
                        "See all >",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.softAmber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      children: AppData.categories.map((cat) {
                        final isSelected = selectedCategory == cat["label"];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Buildcategorycard(
                            icon: cat["icon"] as IconData,
                            label: cat["label"] as String,
                            isActive: isSelected,
                            onTap: () {
                              setState(() {
                                selectedCategory = cat["label"] as String;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      children: (AppData.productsByCategory[selectedCategory] ?? [])
                          .map((prod) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Productcard(
                                imgurl: prod["imgurl"]!,
                                title: prod["title"]!,
                                subtitle: prod["subtitle"]!,
                                price: prod["price"]!,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                        imgurl: prod["imgurl"]!,
                                        title: prod["title"]!,
                                        subtitle: prod["subtitle"]!,
                                        price: prod["price"]!,
                                        category: selectedCategory,
                                      ),
                                    ),
                                  );
                                },
                                onAddToCart: () {
                                  final parsedPrice =
                                      double.tryParse(prod["price"]!) ?? 0.0;
                                  final added = CartService.instance.addToCart(
                                    title: prod["title"]!,
                                    imgurl: prod["imgurl"]!,
                                    price: parsedPrice,
                                    subtitle: prod["subtitle"],
                                  );

                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        added
                                            ? "Added ${prod['title']} to Order"
                                            : "${prod['title']} is already added in Order",
                                        style: GoogleFonts.plusJakartaSans(),
                                      ),
                                      backgroundColor: added
                                          ? AppColors.burntCaramel
                                          : AppColors.deepEspresso,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.deepEspresso,
                          AppColors.burntCaramel,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepEspresso.withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.burntCaramel,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "20% Off",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warmPorcelain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "Slow Mornings\ndeserves best coffee",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warmPorcelain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your First Order at Kovera ",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.warmPorcelain,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.burntCaramel,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Order Now",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warmPorcelain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
