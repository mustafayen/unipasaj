import 'package:flutter/material.dart';

class AuthCommonCard extends StatelessWidget {
  const AuthCommonCard({super.key, required this.child, required this.title});
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
