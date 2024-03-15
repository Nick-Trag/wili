class WishlistItem {
  int id;
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
    this.id = -1, // id will have a value of -1 if the item does not already exist in the database. So that the DBMS will auto-increment it when it adds it
    this.price = 0,
    this.purchased = false,
    this.note = "",
    this.quantity = 1,
    this.link = "",
    this.image = ""}
  );

  WishlistItem.from(WishlistItem item) :
    name = item.name,
    category = item.category,
    id = item.id,
    price = item.price,
    purchased = item.purchased,
    note = item.note,
    quantity = item.quantity,
    link = item.link,
    image = item.image;

  // Do not return the ID, as we do not want it to change, other than by the DBMS itself.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category_id': category,
      'price': price,
      'purchased': purchased ? 1 : 0,
      'note': note,
      'quantity': quantity,
      'link': link,
      'image': image,
    };
  }
}
