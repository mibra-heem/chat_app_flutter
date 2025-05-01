import 'package:mustye/core/utils/typedef.dart';

abstract class SettingRepo {
  const SettingRepo();

  RFuture<bool> checkIfDarkModeOn(); 
  RFuture<void> cacheDarkMode({required bool isDarkMode}); 

}
