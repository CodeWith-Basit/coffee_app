import 'package:coffee_appv2/core/services/cart_service.dart';
import 'package:coffee_appv2/core/services/firestore_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/models/cart_item.dart';
import 'package:coffee_appv2/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int _selectedPaymentMethod =
      1; // 0: Apple Pay, 1: Credit / Debit Card, 2: Cash on Delivery
  String _selectedTip = "15%";
  bool _isPlacingOrder = false;

  // Input Controllers for Address and Card details
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pickupNoteController = TextEditingController();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _obscureCvv = true;

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _pickupNoteController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.burntCaramel,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _processCheckout() async {
    // Basic validation for delivery address
    if (_selectedDeliveryMethod == 1 &&
        _addressController.text.trim().isEmpty) {
      _showError("Please enter your delivery address.");
      return;
    }

    // Strict validation and security limits for card payment
    if (_selectedPaymentMethod == 1) {
      final cardDigits =
          _cardNumberController.text.replaceAll(RegExp(r'\s+'), '');
      if (cardDigits.length < 16) {
        _showError("Please enter a valid 16-digit card number.");
        return;
      }

      final expiry = _expiryController.text.trim();
      if (expiry.length != 5 || !expiry.contains('/')) {
        _showError("Please enter a valid expiry date (MM/YY).");
        return;
      }

      // Check month validity (01-12)
      final parts = expiry.split('/');
      final month = int.tryParse(parts[0]) ?? 0;
      if (month < 1 || month > 12) {
        _showError("Please enter a valid month (01-12).");
        return;
      }

      final cvv = _cvvController.text.trim();
      if (cvv.length != 3) {
        _showError("CVV must be exactly 3 digits.");
        return;
      }

      if (_cardHolderController.text.trim().isEmpty) {
        _showError("Please enter the cardholder's name.");
        return;
      }
    }

    setState(() => _isPlacingOrder = true);
    try {
      final paymentMethodStr = _selectedPaymentMethod == 0
          ? "Apple Pay"
          : _selectedPaymentMethod == 1
              ? "Credit/Debit Card"
              : "Cash on Delivery";

      final addressStr = _selectedDeliveryMethod == 1
          ? "${_addressController.text.trim()}, ${_cityController.text.trim()}"
          : "Store Pickup: ${_pickupNoteController.text.trim().isNotEmpty ? _pickupNoteController.text.trim() : 'Flagship Store'}";

      // Save order into Firestore under /users/{uid}/orders/{orderId}
      await FirestoreService.instance.saveOrder(
        items: widget.items,
        subtotal: widget.subtotal,
        totalAmount: _total,
        deliveryMethod: _selectedDeliveryMethod == 1 ? 'Delivery' : 'Store Pickup',
        address: addressStr,
        paymentMethod: paymentMethodStr,
      );

      if (!mounted) return;

      CartService.instance.clearCart();
      setState(() => _isPlacingOrder = false);

      _showSuccessDialog();
    } catch (e) {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
        _showError("Could not place order. Please check your connection.");
      }
    }
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
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
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
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.burntCaramel.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _selectedDeliveryMethod == 0
                      ? Icons.storefront_rounded
                      : Icons.location_on_rounded,
                  color: AppColors.burntCaramel,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedDeliveryMethod == 0
                          ? "Pickup Instructions / Store"
                          : "Delivery Address Details",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepEspresso,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedDeliveryMethod == 0
                          ? "Type preferred store or pickup notes"
                          : "Enter your custom delivery address",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.mutedTaupe,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedDeliveryMethod == 1) ...[
            // Delivery Address Input
            _buildInputField(
              controller: _addressController,
              label: "Street Address, Apt / Suite",
              hintText: "e.g. 742 Evergreen Terrace, Apt 4B",
              icon: Icons.home_rounded,
            ),
            const SizedBox(height: 12),
            _buildInputField(
              controller: _cityController,
              label: "City / Area & Postal Code",
              hintText: "e.g. Brooklyn, NY 11201",
              icon: Icons.map_rounded,
            ),
          ] else ...[
            // Store Pickup Custom Note / Location Input
            _buildInputField(
              controller: _pickupNoteController,
              label: "Pickup Location / Note",
              hintText: "e.g. Downtown Flagship, hold until 5 PM",
              icon: Icons.store_rounded,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.deepEspresso,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.deepEspresso,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              hintText: hintText,
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.mutedTaupe.withValues(alpha: 0.8),
              ),
              prefixIcon: Icon(icon, size: 18, color: AppColors.burntCaramel),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsCard() {
    final methods = [
      {"icon": Icons.apple, "title": "Apple Pay"},
      {"icon": Icons.credit_card_rounded, "title": "Credit / Debit Card"},
      {
        "icon": Icons.money_rounded,
        "title": _selectedDeliveryMethod == 1
            ? "Cash on Delivery (COD)"
            : "Cash at Counter",
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmPorcelain,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ...List.generate(methods.length, (index) {
            final m = methods[index];
            final isSelected = _selectedPaymentMethod == index;
            return InkWell(
              onTap: () => setState(() => _selectedPaymentMethod = index),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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

          // Card input fields when Credit / Debit Card is selected
          if (_selectedPaymentMethod == 1) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderLight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    controller: _cardHolderController,
                    label: "Cardholder Name",
                    hintText: "e.g. John Doe",
                    icon: Icons.person_outline_rounded,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      LengthLimitingTextInputFormatter(30),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _cardNumberController,
                    label: "Card Number (16 digits)",
                    hintText: "0000 0000 0000 0000",
                    icon: Icons.credit_card_rounded,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d\s]')),
                      _CardNumberFormatter(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: _expiryController,
                          label: "Expiry Date",
                          hintText: "MM/YY",
                          icon: Icons.calendar_today_rounded,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d/]')),
                            _CardExpiryFormatter(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          controller: _cvvController,
                          label: "CVV / CVC (3 digits)",
                          hintText: "•••",
                          icon: Icons.lock_outline_rounded,
                          keyboardType: TextInputType.number,
                          obscureText: _obscureCvv,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureCvv
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 18,
                              color: AppColors.mutedTaupe,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureCvv = !_obscureCvv;
                              });
                            },
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
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
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 8,
                      offset: Offset(0, 2),
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
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
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

/// Custom formatter to format card numbers as: XXXX XXXX XXXX XXXX (16 digits maximum)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 16) {
      digitsOnly = digitsOnly.substring(0, 16);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digitsOnly[i]);
    }

    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

/// Custom formatter to format expiry date as: MM/YY (4 digits maximum)
class _CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(digitsOnly[i]);
    }

    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
