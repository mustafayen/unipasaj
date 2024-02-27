import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unipasaj/extensions/context_extensions.dart';

class FutureImage extends StatefulWidget {
  const FutureImage(
      {super.key,
      required this.future,
      this.fit,
      this.isCircular = false,
      this.onFutureLoaded});
  final Future<String> future;
  final BoxFit? fit;
  final bool isCircular;
  final Function(String?)? onFutureLoaded;

  @override
  State<FutureImage> createState() => _FutureImageState();
}

class _FutureImageState extends State<FutureImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: widget.future, // Resim URL'sini getir
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Veri yüklenene kadar bekleyen durum
          return Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[300]!,
            child: Container(
              color: Colors.grey[300]!.withOpacity(0.1),
            ),
          );
        } else {
          if (snapshot.hasError) {
            // Hata durumu
            return Text('Resim yüklenirken bir hata oluştu: ${snapshot.error}');
          } else {
            widget.onFutureLoaded?.call(snapshot.data!);
            // Veri başarıyla yüklendiği durum
            return snapshot.data != null
                ? widget.isCircular
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(snapshot.data!),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        child: Image.network(
                          snapshot.data!,
                          fit: widget.fit,
                        ),
                      )
                : SizedBox(); // Resim mevcutsa göster, değilse boş bir SizedBox göster
          }
        }
      },
    );
  }
}
