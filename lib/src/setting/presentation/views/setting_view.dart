import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/common/widgets/arrow_back_button.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/res/colors.dart';
import 'package:mustye/src/setting/presentation/provider/setting_provider.dart';
import 'package:provider/provider.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('........ Setting View .........');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        leading: const ArrowBackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.onSecondary.withAlpha(100),
              borderRadius: BorderRadius.circular(20),
            ),
    
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                CupertinoSwitch(
                  value: Provider.of<SettingProvider>(context).isDarkMode,
                  onChanged: (value) {
                    if (kDebugMode) {
                      print('onChanged Value : $value');
                      print(
                        'isDarkMode : ${context.read<SettingProvider>().isDarkMode}',
                      );
                    }
                    
                    context.read<SettingProvider>().toggleTheme();
                  },
                  activeTrackColor: Colours.primaryColor,
                  inactiveThumbColor: Colours.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
