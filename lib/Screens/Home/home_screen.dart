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
  String selectedCategory = "Coffee";

  final List<Map<String, dynamic>> categories = const [
    {"label": "Coffee", "icon": Icons.coffee},
    {"label": "Tea", "icon": Icons.local_drink},
    {"label": "Cookie", "icon": Icons.cookie},
    {"label": "Cake", "icon": Icons.cake},
  ];

  final Map<String, List<Map<String, String>>> productsByCategory = const {
    "Coffee": [
      {
        "imgurl":
            "https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=1637&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Caramel Cloud Latte",
        "subtitle": "Warm, frothy, and perfectly sweetened.",
        "price": "4.99",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Iced Hazelnut Macchiato",
        "subtitle": "Velvety espresso with roasted hazelnut.",
        "price": "5.49",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Classic Espresso Roast",
        "subtitle": "Rich, intense, and deeply aromatic.",
        "price": "3.89",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Vanilla Cold Brew",
        "subtitle": "Slow-steeped over 18 hours with vanilla.",
        "price": "4.79",
      },
    ],
    "Tea": [
      {
        "imgurl":
            "https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Matcha Green Latte",
        "subtitle": "Ceremonial Japanese matcha & oat milk.",
        "price": "4.89",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1597481499750-3e6b22637e12?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Earl Grey Infusion",
        "subtitle": "Bergamot infused black tea with honey.",
        "price": "3.99",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1556679343-c7306c1976bc?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Chai Spice Brew",
        "subtitle": "Cardamom, cinnamon & steamed milk.",
        "price": "4.49",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Hibiscus Bloom Tea",
        "subtitle": "Refreshing tart floral infusion iced.",
        "price": "4.29",
      },
    ],
    "Cookie": [
      {
        "imgurl":
            "https://images.unsplash.com/photo-1499636136210-6f4ee915583e?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Choco Chunk Cookie",
        "subtitle": "Gooey Belgian chocolate chunks.",
        "price": "2.99",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?q=80&w=1965&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Salted Caramel Cookie",
        "subtitle": "Sweet caramel core with sea salt.",
        "price": "3.49",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?q=80&w=1912&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Hazelnut Butter Cookie",
        "subtitle": "Toasted hazelnuts & brown butter.",
        "price": "3.29",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?q=80&w=1965&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Oatmeal Cranberry",
        "subtitle": "Cinnamon spiced rolled oats.",
        "price": "2.89",
      },
    ],
    "Cake": [
      {
        "imgurl":
            "https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=1989&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Velvet Cocoa Cake",
        "subtitle": "Layered rich dark chocolate ganache.",
        "price": "5.99",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1533134242443-d4fd215305ad?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Berry Cheesecake",
        "subtitle": "Creamy New York cheesecake with coulis.",
        "price": "6.49",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1571115177098-24ec42ed204d?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Tiramisu Delight",
        "subtitle": "Mascarpone & espresso soaked ladyfingers.",
        "price": "5.79",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=1989&auto=format&fit=crop&ixlib=rb-4.1.0",
        "title": "Pistachio Cream Slice",
        "subtitle": "Infused pistachio sponge & white cream.",
        "price": "6.29",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentProducts = productsByCategory[selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: AppColors.latteMist,
      appBar: AppBar(
        backgroundColor: AppColors.latteMist,
        elevation: 0,
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
              Icons.shopping_cart_checkout,
              color: AppColors.softAmber,
              size: 20,
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
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
                  border: Border.all(color: AppColors.borderLight, width: 1.5),
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                height: 50,
                width: double.infinity,
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.softAmber,
                    ),
                    hintText: "Search caramel latte, cold brew...",
                    suffixIcon: const Icon(
                      Icons.filter_alt_outlined,
                      color: AppColors.softAmber,
                    ),
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.mutedTaupe,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  children: categories.map((cat) {
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
                  children: currentProducts.map((prod) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Productcard(
                        imgurl: prod["imgurl"]!,
                        title: prod["title"]!,
                        subtitle: prod["subtitle"]!,
                        price: prod["price"]!,
                      ),
                    );
                  }).toList(),
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
                    colors: [AppColors.deepEspresso, AppColors.burntCaramel],
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
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
