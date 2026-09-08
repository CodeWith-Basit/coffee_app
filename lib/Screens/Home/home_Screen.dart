import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteMist,
      appBar: AppBar(
        backgroundColor: AppColors.latteMist,
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
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.mutedTaupe),
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Icon(
              Icons.shopping_cart_checkout,
              color: AppColors.softAmber,
            ),
          ),
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.mutedTaupe),
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Icon(Icons.notification_add, color: AppColors.softAmber),
          ),
          Container(
            height: 48,
            width: 48,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.mutedTaupe),
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://unsplash.com/s/photos/person',
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What will\nyou sip today?",
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: AppColors.deepEspresso,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Welcome to KŌVÉRA, your sanctuary for premium coffee moments.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedTaupe,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mutedTaupe, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              height: 48,
              width: double.infinity,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  prefixIcon: Icon(Icons.search, color: AppColors.softAmber),
                  hintText: "Search caramel latte, cold brew...",
                  suffixIcon: Icon(
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.deepEspresso,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.softAmber,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.softAmber.withValues(alpha: 0.15),
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
                          "Warm, frothy, and perfectly sweetened.",
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
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.burntCaramel,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
