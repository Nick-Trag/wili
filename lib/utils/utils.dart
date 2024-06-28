import 'package:intl/intl.dart' as intl;

// Helper class for useful static functions
class Utils {

  /// Formats a [price] to be fairly short. If it is less than 5 (integer) digits long, it is shown with 2 decimal digits.
  /// If it is larger, it is shown in a compact way, such as 10.2K, with a space added to the end to leave more space for the currency
  static String formatPrice(double price) {
    return price < 10000 ? intl.NumberFormat.decimalPatternDigits(decimalDigits: 2).format(price) : '${intl.NumberFormat.compact().format(price)} ';
  }
}