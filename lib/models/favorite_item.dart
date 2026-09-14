class FavoriteItem {
  final String title;
  final String imgurl;
  final String subtitle;
  final String price;
  final String rating;

  FavoriteItem({
    required this.title,
    required this.imgurl,
    required this.subtitle,
    required this.price,
    this.rating = "4.8",
  });
}
