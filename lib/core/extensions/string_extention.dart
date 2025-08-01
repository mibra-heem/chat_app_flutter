import 'package:phone_numbers_parser/phone_numbers_parser.dart';

extension StringExtention on String {
  String get obscureEmail {
    // split the email into username and domain
    final index = indexOf('@');
    var username = substring(0, index);
    final domain = substring(index + 1);

    // obscure the email show first and last digit of the username
    username = '${username[0]}*****${username[username.length - 1]}';

    return '$username@$domain';
  }

  String get firstName {
    final index = indexOf(' ');
    final name = substring(0, index + 2);

    return '$name.';
  }

  String get lastName {
    final firstLetter = this[0];
    final index = indexOf(' ');
    final name = substring(index);

    return '$firstLetter.$name';
  }

  String get firstLetterCapital {
    final firstLetter = this[0].toUpperCase();
    final withoutFirstLetter = substring(1);

    return '$firstLetter$withoutFirstLetter';
  }

  String get normalizePhoneNumber {
    // Remove spaces, dashes, etc.
    var number = replaceAll(RegExp(r'\s+|\-'), '');

    // If starts with 0, convert to +92
    if (number.startsWith('0')) {
      number = '+92${number.substring(1)}';
    }

    // If already starts with +92 or any valid format, keep it
    return number;
  }

  /// Normalize phone number to E.164-like format
  /// Optional: provide defaultCountryCode (e.g., '92' for Pakistan, '1' for US)
  // String normalizePhone({String? defaultCountryCode}) {
  //   var number = replaceAll(RegExp(r'[^\d+]'), '');

  //   // Convert 00 prefix to + (international dialing)
  //   if (number.startsWith('00')) {
  //     number = '+${number.substring(2)}';
  //   }

  //   // Ensure number starts with '+'
  //   if (!number.startsWith('+')) {
  //     if (defaultCountryCode != null) {
  //       // Strip leading zero if present (local number)
  //       if (number.startsWith('0')) {
  //         number = number.substring(1);
  //       }
  //       number = '+$defaultCountryCode$number';
  //     } else {
  //       // If no default country code, just add +
  //       number = '+$number';
  //     }
  //   }

  //   // Remove any remaining non-digits (except +)
  //   return '+${number.replaceAll(RegExp(r'[^\d]'), '')}';
  // }

  /// Normalizes phone number into international format (e.g., +923001234567)
  ///
  /// [callerCountry] is the country ISO code like 'PK', 'US', 'IN', etc.
  /// Defaults to 'US' if not provided.
  String normalizePhone({IsoCode callerCountry = IsoCode.PK}) {
    try {
      final phoneNumber = PhoneNumber.parse(this, callerCountry: callerCountry);
      return phoneNumber.international; // includes '+'
    } on Exception catch (e) {
      return trim(); // fallback if parsing fails
    }
  }
}
