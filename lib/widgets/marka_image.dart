import 'package:flutter/material.dart';
import 'package:unipasaj/class/markaClass.dart';
import 'package:unipasaj/pages/marka_detay/marka_detay.dart';
import 'package:unipasaj/widgets/future_image.dart';

class MarkaImage extends FutureImage {
  const MarkaImage(
      {super.key,
      required this.marka,
      required super.future,
      super.fit,
      super.isCircular,
      super.onFutureLoaded});

  final Marka marka;

  @override
  State<MarkaImage> createState() => _MarkaImageState();
}

class _MarkaImageState extends State<MarkaImage> {
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MarkaDetay(
            marka: widget.marka,
            markaImageUrl: imageUrl,
          );
        }));
      },
      child: FutureImage(
        future: widget.future,
        isCircular: widget.isCircular,
        onFutureLoaded: (image) {
          imageUrl = image;
        },
        fit: widget.fit,
      ),
    );
  }
}
