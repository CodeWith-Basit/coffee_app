import 'package:flutter/material.dart';

class AppData {
  static const List<Map<String, dynamic>> categories = [
    {"label": "Coffee", "icon": Icons.coffee},
    {"label": "Tea", "icon": Icons.local_drink},
    {"label": "Cookie", "icon": Icons.cookie},
    {"label": "Cake", "icon": Icons.cake},
  ];

  static const Map<String, List<Map<String, String>>> productsByCategory = {
    "Coffee": [
      {
        "imgurl":
            "https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=600&auto=format&fit=crop",
        "title": "Caramel Cloud Latte",
        "subtitle": "Warm, frothy, and perfectly sweetened.",
        "price": "4.99",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=600&auto=format&fit=crop",
        "title": "Iced Hazelnut Macchiato",
        "subtitle": "Velvety espresso with roasted hazelnut.",
        "price": "5.49",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=600&auto=format&fit=crop",
        "title": "Classic Espresso Roast",
        "subtitle": "Rich, intense, and deeply aromatic.",
        "price": "3.89",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=600&auto=format&fit=crop",
        "title": "Vanilla Cold Brew",
        "subtitle": "Slow-steeped over 18 hours with vanilla.",
        "price": "4.79",
      },
    ],
    "Tea": [
      {
        "imgurl":
            "https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=600&auto=format&fit=crop",
        "title": "Matcha Green Latte",
        "subtitle": "Ceremonial Japanese matcha & oat milk.",
        "price": "4.89",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1597481499750-3e6b22637e12?q=80&w=600&auto=format&fit=crop",
        "title": "Earl Grey Infusion",
        "subtitle": "Bergamot infused black tea with honey.",
        "price": "3.99",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1556679343-c7306c1976bc?q=80&w=600&auto=format&fit=crop",
        "title": "Chai Spice Brew",
        "subtitle": "Cardamom, cinnamon & steamed milk.",
        "price": "4.49",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1544787219-7f47ccb76574?q=80&w=600&auto=format&fit=crop",
        "title": "Hibiscus Bloom Tea",
        "subtitle": "Refreshing tart floral infusion iced.",
        "price": "4.29",
      },
    ],
    "Cookie": [
      {
        "imgurl":
            "https://images.unsplash.com/photo-1499636136210-6f4ee915583e?q=80&w=600&auto=format&fit=crop",
        "title": "Choco Chunk Cookie",
        "subtitle": "Gooey Belgian chocolate chunks.",
        "price": "2.99",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?q=80&w=600&auto=format&fit=crop",
        "title": "Salted Caramel Cookie",
        "subtitle": "Sweet caramel core with sea salt.",
        "price": "3.49",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?q=80&w=600&auto=format&fit=crop",
        "title": "Hazelnut Butter Cookie",
        "subtitle": "Toasted hazelnuts & brown butter.",
        "price": "3.29",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=600&auto=format&fit=crop",
        "title": "Oatmeal Cranberry",
        "subtitle": "Cinnamon spiced rolled oats.",
        "price": "2.89",
      },
    ],
    "Cake": [
      {
        "imgurl":
            "https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=600&auto=format&fit=crop",
        "title": "Velvet Cocoa Cake",
        "subtitle": "Layered rich dark chocolate ganache.",
        "price": "5.99",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1533134242443-d4fd215305ad?q=80&w=600&auto=format&fit=crop",
        "title": "Berry Cheesecake",
        "subtitle": "Creamy New York cheesecake with coulis.",
        "price": "6.49",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1571115177098-24ec42ed204d?q=80&w=600&auto=format&fit=crop",
        "title": "Tiramisu Delight",
        "subtitle": "Mascarpone & espresso soaked ladyfingers.",
        "price": "5.79",
      },
      {
        "imgurl":
            "https://images.unsplash.com/photo-1565958011703-44f9829ba187?q=80&w=600&auto=format&fit=crop",
        "title": "Pistachio Cream Slice",
        "subtitle": "Infused pistachio sponge & white cream.",
        "price": "6.29",
      },
    ],
  };

  static List<Map<String, String>> searchProducts(
    String query, {
    String? category,
  }) {
    // If query is empty, return regular category products or all products
    if (query.trim().isEmpty) {
      if (category != null) {
        return productsByCategory[category] ?? [];
      }
      return productsByCategory.values.expand((element) => element).toList();
    }
    final lowerQuery = query.toLowerCase().trim();
    // Pool of products to search from
    final List<Map<String, String>> pool = category != null
        ? (productsByCategory[category] ?? [])
        : productsByCategory.values.expand((element) => element).toList();
    // Filter matching products
    return pool.where((item) {
      final title = item["title"]?.toLowerCase() ?? "";
      final subtitle = item["subtitle"]?.toLowerCase() ?? "";
      return title.contains(lowerQuery) || subtitle.contains(lowerQuery);
    }).toList();
  }
}
