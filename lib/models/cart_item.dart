class CartItem {
  final String? id;
  final String title;
  final String imgurl;
  final double price;
  final String? subtitle;
  int quantity;

  CartItem({
    this.id,
    required this.title,
    required this.imgurl,
    required this.price,
    this.subtitle,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}
