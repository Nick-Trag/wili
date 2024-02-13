class WishlistItem {
  String name;
  int category;
  double price;
  bool purchased;
  String note;
  int quantity;
  String link; // URL
  String image; // local path to image

  WishlistItem({
    required this.name,
    required this.category,
    this.price = 0,
    this.purchased = false,
    this.note = "",
    this.quantity = 1,
    this.link = "",
    this.image = ""}
  );

  // TODO: + id (?) Actually probably not, since it is auto-increment
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'purchased': purchased,
      'note': note,
      'quantity': quantity,
      'link': link,
      'image': image,
    };
  }
}
