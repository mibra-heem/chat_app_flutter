import 'package:mustye/core/enums/call.dart';

extension CallStatusExt on CallStatus {

  static CallStatus toEnum(String value) {
    return CallStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CallStatus.ended,
    );
  }
}

extension CallTypeExt on CallType {

  static CallType toEnum(String value) {
    return CallType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CallType.audio,
    );
  }
}
