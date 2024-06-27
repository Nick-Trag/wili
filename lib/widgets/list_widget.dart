import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/providers/settings_provider.dart';
import 'package:wili/widgets/item_card.dart';
import 'package:intl/intl.dart' as intl;


class ListWidget extends StatelessWidget {
  const ListWidget({
    super.key,
    required this.items,
    required this.categories,
  });

  final List<WishlistItem> items;
  final Map<int, String> categories;

  // TODO: Move this outside of this class and use it in other places as well
  String formatPrice(double price) {
    return price < 10000 ? intl.NumberFormat.decimalPatternDigits(decimalDigits: 2).format(price) : '${intl.NumberFormat.compact().format(price)} ';
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.not_interested),
          SizedBox(
            width: 200,
            child: Text(
              "No items wished for yet. Use the plus button to add an item.",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
    else { // TODO: Add total prices (Perhaps total not purchased + total purchased) (take quantity into account)
      double totalPrice = 0;
      double notPurchasedPrice = 0;
      for (WishlistItem item in items) {
        double itemPrice = item.quantity * item.price;
        if (!item.purchased) {
          notPurchasedPrice += itemPrice;
        }
        totalPrice += itemPrice;
      }

      return Column(
        children: [
          Consumer<SettingsProvider>(
            builder: (context, provider, row) => Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Not purchased: ${formatPrice(notPurchasedPrice)}${provider.currency}", textAlign: TextAlign.left,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Total price: ${formatPrice(totalPrice)}${provider.currency}", textAlign: TextAlign.right,),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                if (Provider.of<SettingsProvider>(context).moveToBot && index != items.length - 1 && !items[index].purchased && items[index + 1].purchased) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: ItemCardWidget(item: items[index], categoryName: categories[items[index].category]!),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                        child: Divider(height: 0),
                      ),
                    ],
                  );
                }
                return Padding(
                  // The last item gets considerably more padding on the bottom, in order for the floating action button to not hide any item's price
                  padding: index == items.length - 1 ? const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 55.0): const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ItemCardWidget(item: items[index], categoryName: categories[items[index].category]!),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}