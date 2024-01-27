import 'package:flutter/material.dart';

class verhorPadding extends StatelessWidget {
  const verhorPadding({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10));
  }
}

class verticalPaddingTen extends StatelessWidget {
  const verticalPaddingTen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 10));
  }
}
