import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/resources/colors.dart';
import 'package:mustye/core/app/widgets/arrow_back_button.dart';
import 'package:mustye/core/enums/call.dart';

class AudioCallAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AudioCallAppBar({required this.name, required this.status, super.key});

  final String name;
  final CallStatus status;

  @override
  State<AudioCallAppBar> createState() => _AudioCallAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AudioCallAppBarState extends State<AudioCallAppBar> {
  Timer? _timer;
  int _seconds = 0;

  @override
  void didUpdateWidget(covariant AudioCallAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.status == CallStatus.accepted && _timer == null) {
      _startTimer();
    } else if (widget.status != CallStatus.accepted && _timer != null) {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _seconds = 0;
  }

  String get _formattedTime {
    final minutes = _seconds ~/ 60;
    final seconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusText;

    switch (widget.status) {
      case CallStatus.calling:
        statusText = 'Calling...';
      case CallStatus.ringing:
        statusText = 'Ringing...';
      case CallStatus.accepted:
        statusText = _formattedTime;
      case CallStatus.rejected:
        statusText = 'Rejected';
      case CallStatus.ended:
        statusText = 'Ended';
      case CallStatus.cancelled:
        statusText = 'Cancelled';
      case CallStatus.missed:
        statusText = 'Missed';
      case CallStatus.reconnecting:
        statusText = 'Reconnecting...';
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      title: Column(
        children: [
          Text(widget.name, style: const TextStyle(fontSize: 14)),
          Text(
            statusText,
            style: const TextStyle(fontSize: 14, color: Colours.grey600),
          ),
        ],
      ),
      centerTitle: true,
      leading: const ArrowBackButton(),
      titleSpacing: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(IconlyBold.add_user, size: 26),
        ),
      ],
    );
  }
}
