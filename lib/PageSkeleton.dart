import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PageSkeleton extends StatelessWidget {
  late String title;
  late Widget child;
  PageSkeleton({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)),
    body: child);
  }
}