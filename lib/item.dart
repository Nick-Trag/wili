class WishlistItem {
  String name;
  double price;
  String category; // Will become some kind of enum
  bool purchased;
  String note;
  int quantity;
  String link; // URL
  String image; // path to image

  WishlistItem({required this.name, required this.category, this.price = 0, this.purchased= false, this.note = "", this.quantity = 1, this.link = "", this.image = ""});
}