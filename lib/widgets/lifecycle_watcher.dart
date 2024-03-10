import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/providers/item_provider.dart';

class LifecycleWatcher extends StatefulWidget {
  const LifecycleWatcher({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // When the app goes into the background, we clear all the no longer in use images
    if (state == AppLifecycleState.paused) {
      Provider.of<ItemProvider>(context, listen: false).clearUnusedImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}