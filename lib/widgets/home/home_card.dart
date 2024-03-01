import 'package:flutter/material.dart';
import 'package:unipasaj/class/markaClass.dart';
import 'package:unipasaj/extensions/context_extensions.dart';
import 'package:unipasaj/extensions/string_extensions.dart';
import 'package:unipasaj/helpers/bottom_modal_helper.dart';
import 'package:unipasaj/localization/locale_keys.g.dart';
import 'package:unipasaj/widgets/cards.dart';
import 'package:unipasaj/widgets/future_image.dart';
import 'package:unipasaj/widgets/marka_image.dart';
import 'package:unipasaj/widgets/paddings.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCard extends StatelessWidget {
  const HomeCard(
    this.markaModel,
    this.mapurl,
    this.imageurl,
    this.marka,
    this.indirim,
    this.bilgi,
    this.tarih,
    this.logoUrl,
    this.kategori,
    this.id,
    this.mycolor,
    this.addFavoriFunction, {
    super.key,
  });
  final Marka markaModel;
  final String mapurl;
  final String imageurl;
  final String marka;
  final String indirim;
  final String bilgi;
  final String tarih;
  final String logoUrl;
  final String kategori;
  final int id;
  final Color mycolor;

  final Function(String, int) addFavoriFunction; // Yeni parametre

  @override
  Widget build(BuildContext context) {
    final Uri uri = Uri.parse(mapurl);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Card(
        child: Center(
          child: Column(
            children: [
              const verticalPaddingTen(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.transparent,
                        child: Center(
                            child: MarkaImage(
                          future: getImageUrl(logoUrl),
                          marka: markaModel,
                        )),
                      ),
                    ),
                    const verhorPadding(),
                    Text(marka, style: context.textTheme.headlineSmall!),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.favorite, color: mycolor),
                      onPressed: () {
                        // IconButton'a tıklandığında favori ekleme fonksiyonunu çağır
                        addFavoriFunction(
                            userId!, id); // Yeni fonksiyon kullanımı
                      },
                    ),
                    Text(id.toString()),
                  ],
                ),
              ),
              const verhorPadding(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  bilgi,
                  textAlign: TextAlign.left,
                  style: context.textTheme.bodyMedium!,
                ),
              ),
              const verticalPaddingTen(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.percent,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          indirim,
                          style: context.textTheme.bodyMedium!,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.tag,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          kategori,
                          style: context.textTheme.bodyMedium!,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.date_range,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          tarih,
                          style: context.textTheme.bodyMedium!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Arka plan rengi

                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black, // Kenar rengi
                          ),
                          borderRadius:
                              BorderRadius.circular(10), // Kenar yarıçapı
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        print("Kupon Kodu Al");
                        UPBottomModalHelper.showCupponModal(
                            context, imageurl, markaModel);
                      },
                      child: Text(
                        LocaleKeys.takeCupponCode.translate,
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: Colors.black, // Yazı rengi
                        ), // Yazı rengi
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Harita butonunun işlevselliği buraya gelecek
                        _launchURL(uri);
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.location_on),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: MarkaImage(
                  marka: markaModel,
                  future: getImageUrl(logoUrl),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
