import 'package:coffee_appv2/core/services/cart_service.dart';
import 'package:coffee_appv2/core/services/favorite_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/models/favorite_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatefulWidget {
  final String imgurl;
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final String? description;
  final String? category;

  const ProductDetailScreen({
    super.key,
    required this.imgurl,
    required this.title,
    required this.subtitle,
    required this.price,
    this.rating = "4.8",
    this.description,
    this.category,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Beverage options (Coffee / Tea)
  int _selectedBeverageSize = 1; // 0: Small, 1: Medium, 2: Large
  int _selectedSugar = 1; // 0: No Sugar, 1: Regular, 2: Extra
  int _selectedIce = 1; // 0: Less Ice, 1: Regular, 2: Extra

  // Cookie options
  int _selectedCookieWeight = 1; // 0: 100g, 1: 250g, 2: 500g
  int _selectedCookiePack = 0; // 0: Freshly Baked, 1: Gift Box Pack

  // Cake options
  int _selectedCakePound = 1; // 0: 1 Pound, 1: 2 Pounds, 2: 3 Pounds
  int _selectedCakeEggless = 0; // 0: Standard, 1: Eggless

  int _quantity = 1;

  final List<Map<String, dynamic>> _beverageSizes = [
    {
      "label": "Small",
      "oz": "8 oz",
      "extraPrice": 0.0,
      "icon": Icons.local_cafe_rounded,
    },
    {
      "label": "Medium",
      "oz": "12 oz",
      "extraPrice": 0.50,
      "icon": Icons.local_cafe_rounded,
    },
    {
      "label": "Large",
      "oz": "16 oz",
      "extraPrice": 1.00,
      "icon": Icons.local_cafe_rounded,
    },
  ];

  final List<Map<String, dynamic>> _cookieWeights = [
    {
      "label": "100 Grams",
      "sub": "~2-3 cookies",
      "extraPrice": 0.0,
      "icon": Icons.cookie_rounded,
    },
    {
      "label": "250 Grams",
      "sub": "~6-8 cookies",
      "extraPrice": 3.00,
      "icon": Icons.cookie_rounded,
    },
    {
      "label": "500 Grams",
      "sub": "~14-16 cookies",
      "extraPrice": 6.50,
      "icon": Icons.cookie_rounded,
    },
  ];

  final List<Map<String, dynamic>> _cakePounds = [
    {
      "label": "1 Pound",
      "sub": "Serves 4-6",
      "extraPrice": 0.0,
      "icon": Icons.cake_rounded,
    },
    {
      "label": "2 Pounds",
      "sub": "Serves 8-12",
      "extraPrice": 7.00,
      "icon": Icons.cake_rounded,
    },
    {
      "label": "3 Pounds",
      "sub": "Serves 14-18",
      "extraPrice": 14.00,
      "icon": Icons.cake_rounded,
    },
  ];

  final List<String> _sugarOptions = ["No Sugar", "Regular", "Extra Sweet"];
  final List<String> _iceOptions = ["Light Ice", "Normal Ice", "Extra Ice"];
  final List<String> _cookiePackOptions = [
    "Standard Box",
    "Artisan Tin (+ \$1.50)",
  ];
  final List<String> _cakePrepOptions = [
    "Standard Recipe",
    "Eggless (+ \$1.00)",
  ];

  String get _effectiveCategory {
    if (widget.category != null && widget.category!.isNotEmpty) {
      return widget.category!;
    }
    final t = widget.title.toLowerCase();
    final s = widget.subtitle.toLowerCase();
    if (t.contains("cookie") || s.contains("cookie") || t.contains("oatmeal")) {
      return "Cookie";
    }
    if (t.contains("cake") ||
        s.contains("cake") ||
        t.contains("tiramisu") ||
        t.contains("slice") ||
        t.contains("cheesecake")) {
      return "Cake";
    }
    if (t.contains("tea") ||
        s.contains("tea") ||
        t.contains("chai") ||
        t.contains("matcha") ||
        t.contains("bloom")) {
      return "Tea";
    }
    return "Coffee";
  }

  bool get _isCookie => _effectiveCategory == "Cookie";
  bool get _isCake => _effectiveCategory == "Cake";

  double get _basePrice => double.tryParse(widget.price) ?? 0.0;

  double get _itemPrice {
    double extra = 0.0;
    if (_isCookie) {
      extra += _cookieWeights[_selectedCookieWeight]["extraPrice"] as double;
      if (_selectedCookiePack == 1) extra += 1.50;
    } else if (_isCake) {
      extra += _cakePounds[_selectedCakePound]["extraPrice"] as double;
      if (_selectedCakeEggless == 1) extra += 1.00;
    } else {
      extra += _beverageSizes[_selectedBeverageSize]["extraPrice"] as double;
    }
    return _basePrice + extra;
  }

  double get _totalPrice => _itemPrice * _quantity;

  String get _detailedDescription {
    if (widget.description != null && widget.description!.isNotEmpty) {
      return widget.description!;
    }
    if (_isCookie) {
      return "${widget.title} is artisan baked daily with organic stone-ground flour, European unsalted butter, and pure cane sugar for the ultimate melt-in-your-mouth crisp and chewy texture.";
    }
    if (_isCake) {
      return "${widget.title} is crafted with layers of delicate sponge, silky handcrafted frosting, and premium confectionery ingredients designed for memorable celebrations and tea pairings.";
    }
    return "${widget.title} is handcrafted by our master baristas using ethically sourced single-origin beans, precision roasted to unlock nuanced flavor notes with velvety microfoam and rich crema.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteMist,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image with Floating Action Buttons
                _buildHeroImage(context),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title, Rating & Reviews
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepEspresso,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.subtitle,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: AppColors.mutedTaupe,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Rating Chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.deepEspresso,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFFB800),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.rating,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Roastery Tags
                      Row(
                        children: [
                          _buildBadge(Icons.eco_rounded, "Organic"),
                          const SizedBox(width: 8),
                          _buildBadge(
                            Icons.local_fire_department_rounded,
                            "Medium Roast",
                          ),
                          const SizedBox(width: 8),
                          _buildBadge(Icons.bolt_rounded, "Fair Trade"),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // Description
                      Text(
                        "About this Brew",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepEspresso,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _detailedDescription,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.mutedTaupe,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Customization Section depending on category
                      if (_isCookie) ...[
                        // Cookie Grams / Weight Selector
                        Text(
                          "Select Weight (Grams)",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildCategorySizeSelector(
                          items: _cookieWeights,
                          selectedIndex: _selectedCookieWeight,
                          onSelected: (idx) =>
                              setState(() => _selectedCookieWeight = idx),
                        ),
                        const SizedBox(height: 24),

                        // Cookie Packaging Preference
                        Text(
                          "Packaging Option",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildPillSelector(
                          options: _cookiePackOptions,
                          selectedIndex: _selectedCookiePack,
                          onSelected: (idx) =>
                              setState(() => _selectedCookiePack = idx),
                        ),
                      ] else if (_isCake) ...[
                        // Cake Pound / Size Selector
                        Text(
                          "Select Cake Size (Pounds)",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildCategorySizeSelector(
                          items: _cakePounds,
                          selectedIndex: _selectedCakePound,
                          onSelected: (idx) =>
                              setState(() => _selectedCakePound = idx),
                        ),
                        const SizedBox(height: 24),

                        // Cake Preparation Preference
                        Text(
                          "Baking Preference",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildPillSelector(
                          options: _cakePrepOptions,
                          selectedIndex: _selectedCakeEggless,
                          onSelected: (idx) =>
                              setState(() => _selectedCakeEggless = idx),
                        ),
                      ] else ...[
                        // Beverage Cup Size Selector
                        Text(
                          "Select Size",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildCategorySizeSelector(
                          items: _beverageSizes,
                          selectedIndex: _selectedBeverageSize,
                          onSelected: (idx) =>
                              setState(() => _selectedBeverageSize = idx),
                        ),
                        const SizedBox(height: 24),

                        // Sugar Level Selector
                        Text(
                          "Sweetness Level",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildPillSelector(
                          options: _sugarOptions,
                          selectedIndex: _selectedSugar,
                          onSelected: (idx) =>
                              setState(() => _selectedSugar = idx),
                        ),
                        const SizedBox(height: 22),

                        // Ice Level Selector
                        Text(
                          "Ice Preference",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepEspresso,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildPillSelector(
                          options: _iceOptions,
                          selectedIndex: _selectedIce,
                          onSelected: (idx) =>
                              setState(() => _selectedIce = idx),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Fixed Action Bar
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 360,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.deepEspresso,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
            child: Image.network(
              widget.imgurl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.deepEspresso,
                child: const Center(
                  child: Icon(
                    Icons.coffee,
                    size: 64,
                    color: AppColors.softAmber,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Gradient overlay for back/favorite readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Top Navigation Bar (Back & Favorite Button)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.deepEspresso,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Favorite Toggle
                ValueListenableBuilder<List<FavoriteItem>>(
                  valueListenable: FavoriteService.instance.favoritesNotifier,
                  builder: (context, favorites, _) {
                    final isFav = favorites.any((f) => f.title == widget.title);
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 20,
                          color: isFav
                              ? const Color(0xFFD32F2F)
                              : AppColors.burntCaramel,
                        ),
                        onPressed: () {
                          final added = FavoriteService.instance.toggleFavorite(
                            title: widget.title,
                            imgurl: widget.imgurl,
                            subtitle: widget.subtitle,
                            price: widget.price,
                            rating: widget.rating,
                          );
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                added
                                    ? "Added ${widget.title} to Favorites"
                                    : "Removed ${widget.title} from Favorites",
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
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.coffeeLatex,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.burntCaramel),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.deepEspresso,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySizeSelector({
    required List<Map<String, dynamic>> items,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return Row(
      children: List.generate(items.length, (index) {
        final isSelected = selectedIndex == index;
        final item = items[index];
        final iconData = item["icon"] as IconData? ?? Icons.coffee;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < items.length - 1 ? 10.0 : 0.0,
            ),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.deepEspresso : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.deepEspresso
                        : AppColors.borderLight,
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      iconData,
                      size: 22.0,
                      color: isSelected
                          ? AppColors.softAmber
                          : AppColors.mutedTaupe,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item["label"] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : AppColors.deepEspresso,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      (item["oz"] ?? item["sub"]) as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: isSelected
                            ? AppColors.lightTextSecondary
                            : AppColors.mutedTaupe,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPillSelector({
    required List<String> options,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return Row(
      children: List.generate(options.length, (index) {
        final isSelected = selectedIndex == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < options.length - 1 ? 8.0 : 0.0,
            ),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.burntCaramel : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.burntCaramel
                        : AppColors.borderLight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    options[index],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.deepEspresso,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowDark.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Price & Quantity Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total Price",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.mutedTaupe,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "\$${_totalPrice.toStringAsFixed(2)}",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepEspresso,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),

              // Quantity Counter
              Container(
                decoration: BoxDecoration(
                  color: AppColors.latteMist,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
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
                        "$_quantity",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepEspresso,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _quantity++),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.burntCaramel,
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
              const SizedBox(width: 14),

              // Add to Order Button
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      String sizeLabel;
                      if (_isCookie) {
                        sizeLabel =
                            _cookieWeights[_selectedCookieWeight]["label"]
                                as String;
                      } else if (_isCake) {
                        sizeLabel =
                            _cakePounds[_selectedCakePound]["label"] as String;
                      } else {
                        sizeLabel =
                            _beverageSizes[_selectedBeverageSize]["label"]
                                as String;
                      }
                      final subtitleWithCustomization =
                          "${widget.subtitle} ($sizeLabel)";

                      for (int i = 0; i < _quantity; i++) {
                        CartService.instance.addToCart(
                          title: widget.title,
                          imgurl: widget.imgurl,
                          price: _itemPrice,
                          subtitle: subtitleWithCustomization,
                        );
                      }

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Added $_quantity x ${widget.title} to Order",
                            style: GoogleFonts.plusJakartaSans(),
                          ),
                          backgroundColor: AppColors.burntCaramel,
                          duration: const Duration(seconds: 2),
                        ),
                      );

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.burntCaramel,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Add to Order",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
