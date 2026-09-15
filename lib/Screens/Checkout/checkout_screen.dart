import 'package:coffee_appv2/core/services/cart_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/models/cart_item.dart';
import 'package:coffee_appv2/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> items;
  final double subtotal;

  const CheckoutScreen({
    super.key,
    required this.items,
    required this.subtotal,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedDeliveryMethod = 0; // 0: Pickup, 1: Delivery
  int _selectedPaymentMethod = 0; // 0: Apple Pay, 1: Credit Card, 2: Cash
  String _selectedTip = "15%";
  bool _isPlacingOrder = false;

  final double _deliveryFee = 2.50;
  final double _taxRate = 0.08;

  double get _tipAmount {
    switch (_selectedTip) {
      case "10%":
        return widget.subtotal * 0.10;
      case "15%":
        return widget.subtotal * 0.15;
      case "20%":
        return widget.subtotal * 0.20;
      default:
        return 0.0;
    }
  }

  double get _total {
    final delivery = _selectedDeliveryMethod == 1 ? _deliveryFee : 0.0;
    final tax = widget.subtotal * _taxRate;
    return widget.subtotal + delivery + tax + _tipAmount;
  }

  void _processCheckout() async {
    setState(() => _isPlacingOrder = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    CartService.instance.clearCart();
    setState(() => _isPlacingOrder = false);

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.warmPorcelain,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 28,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.burntCaramel.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.burntCaramel,
                size: 48,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Order Confirmed!",
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.deepEspresso,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your barista is preparing your artisan brew. It will be ready in ~12 mins.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.mutedTaupe,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.burntCaramel,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close dialog
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const BottomNavBar(initialIndex: 0),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  "Back to Home",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteMist,
      appBar: AppBar(
        backgroundColor: AppColors.latteMist,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.deepEspresso,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Checkout",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.deepEspresso,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery / Pickup Switch
            _buildDeliveryMethodToggle(),
            const SizedBox(height: 22),

            // Order Summary List
            _buildSectionHeader("Order Summary (${widget.items.length})"),
            const SizedBox(height: 10),
            _buildOrderItemsCard(),
            const SizedBox(height: 22),

            // Delivery / Pickup Address Details
            _buildSectionHeader(
              _selectedDeliveryMethod == 0
                  ? "Pickup Location"
                  : "Delivery Address",
            ),
            const SizedBox(height: 10),
            _buildAddressCard(),
            const SizedBox(height: 22),

            // Payment Method
            _buildSectionHeader("Payment Method"),
            const SizedBox(height: 10),
            _buildPaymentMethodsCard(),
            const SizedBox(height: 22),

            // Tip Option
            _buildSectionHeader("Barista Tip"),
            const SizedBox(height: 10),
            _buildTipSelector(),
            const SizedBox(height: 22),

            // Price Breakdown Card
            _buildSectionHeader("Payment Details"),
            const SizedBox(height: 10),
            _buildPaymentBreakdownCard(),
            const SizedBox(height: 28),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isPlacingOrder ? null : _processCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.burntCaramel,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: _isPlacingOrder
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_outline_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "Pay \$${_total.toStringAsFixed(2)}",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.deepEspresso,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildDeliveryMethodToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.coffeeLatex,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedDeliveryMethod = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedDeliveryMethod == 0
                      ? AppColors.deepEspresso
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.storefront_rounded,
                        size: 18,
                        color: _selectedDeliveryMethod == 0
                            ? Colors.white
                            : AppColors.mutedTaupe,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Store Pickup",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _selectedDeliveryMethod == 0
                              ? Colors.white
                              : AppColors.mutedTaupe,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedDeliveryMethod = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedDeliveryMethod == 1
                      ? AppColors.deepEspresso
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.moped_rounded,
                        size: 18,
                        color: _selectedDeliveryMethod == 1
                            ? Colors.white
                            : AppColors.mutedTaupe,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Delivery (\$2.50)",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _selectedDeliveryMethod == 1
                              ? Colors.white
                              : AppColors.mutedTaupe,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmPorcelain,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: widget.items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 48,
                    height: 48,
                    color: AppColors.coffeeLatex,
                    child: Image.network(
                      item.imgurl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Icon(
                        Icons.local_cafe_rounded,
                        color: AppColors.burntCaramel,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.deepEspresso,
                        ),
                      ),
                      Text(
                        "Qty: ${item.quantity}",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.mutedTaupe,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\$${item.totalPrice.toStringAsFixed(2)}",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepEspresso,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmPorcelain,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.burntCaramel.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _selectedDeliveryMethod == 0
                  ? Icons.store_rounded
                  : Icons.location_on_rounded,
              color: AppColors.burntCaramel,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedDeliveryMethod == 0
                      ? "KŌVÉRA Roastery & Flagship"
                      : "442 Lexington Ave, Apt 5B",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepEspresso,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _selectedDeliveryMethod == 0
                      ? "Est. pickup ready in 10-15 mins"
                      : "New York, NY 10017 • Hand to me",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.mutedTaupe,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Edit",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.burntCaramel,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard() {
    final methods = [
      {"icon": Icons.apple, "title": "Apple Pay"},
      {"icon": Icons.credit_card_rounded, "title": "Visa •••• 4289"},
      {"icon": Icons.money_rounded, "title": "Cash at Counter"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmPorcelain,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(methods.length, (index) {
          final m = methods[index];
          final isSelected = _selectedPaymentMethod == index;
          return InkWell(
            onTap: () => setState(() => _selectedPaymentMethod = index),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    m["icon"] as IconData,
                    color: isSelected
                        ? AppColors.burntCaramel
                        : AppColors.mutedTaupe,
                    size: 22,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      m["title"] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: AppColors.deepEspresso,
                      ),
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: isSelected
                        ? AppColors.burntCaramel
                        : AppColors.mutedTaupe,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTipSelector() {
    final tips = ["None", "10%", "15%", "20%"];
    return Row(
      children: tips.map((tip) {
        final isSelected = _selectedTip == tip;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTip = tip),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.burntCaramel
                      : AppColors.warmPorcelain,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    tip,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.deepEspresso,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentBreakdownCard() {
    final delivery = _selectedDeliveryMethod == 1 ? _deliveryFee : 0.0;
    final tax = widget.subtotal * _taxRate;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.warmPorcelain,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBreakdownRow(
            "Subtotal",
            "\$${widget.subtotal.toStringAsFixed(2)}",
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            "Delivery",
            delivery == 0 ? "Free" : "\$${delivery.toStringAsFixed(2)}",
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            "Estimated Tax (8%)",
            "\$${tax.toStringAsFixed(2)}",
          ),
          if (_tipAmount > 0) ...[
            const SizedBox(height: 8),
            _buildBreakdownRow(
              "Barista Tip ($_selectedTip)",
              "\$${_tipAmount.toStringAsFixed(2)}",
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.borderLight,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepEspresso,
                ),
              ),
              Text(
                "\$${_total.toStringAsFixed(2)}",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.burntCaramel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.mutedTaupe,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.deepEspresso,
          ),
        ),
      ],
    );
  }
}
