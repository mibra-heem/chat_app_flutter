import 'package:flutter/material.dart';
import 'package:mustye/core/app/widgets/circular_button.dart';
import 'package:mustye/core/app/resources/colors.dart';

class IncomingAudioCallBottomBar extends StatelessWidget {
  const IncomingAudioCallBottomBar({
    super.key,
    this.onAcceptCall,
    this.onRejectCall,
  });

  final VoidCallback? onAcceptCall;
  final VoidCallback? onRejectCall;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          spacing: 2,
          children: [
            CircularButton(
              icon: Icons.call_end_rounded,
              onPressed: onRejectCall,
            ),
            const Text('Reject'),
          ],
        ),
        Column(
          spacing: 2,
          children: [
            CircularButton(color: Colours.success, onPressed: onAcceptCall),
            const Text('Accept'),
          ],
        ),
      ],
    );
  }
}
