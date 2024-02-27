import 'package:flutter/material.dart';
import 'package:unipasaj/class/markaClass.dart';
import 'package:unipasaj/extensions/context_extensions.dart';
import 'package:unipasaj/extensions/string_extensions.dart';
import 'package:unipasaj/localization/locale_keys.g.dart';
import 'package:unipasaj/widgets/cards.dart';
import 'package:unipasaj/widgets/marka_image.dart';

class UPBottomModalHelper {
  //TODO: MARKA FOTOSUNUN ÜST KISMINA BASINCA TIKLAMAYI ALGILAMIYOR.
  static void showCupponModal(
      BuildContext context, String imageurl, Marka marka) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<String>(
          future: fetchNameFromFirestore(
              userId!), // Firestore'dan diğer verileri getir
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Veri yüklenene kadar bekleyen durum
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: const Center(
                  child:
                      CircularProgressIndicator(), // veya başka bir yükleme göstergesi
                ),
              );
            } else {
              if (snapshot.hasError) {
                // Hata durumu
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Text(
                        'Veri yüklenirken bir hata oluştu: ${snapshot.error}'),
                  ),
                );
              } else {
                // Veri başarıyla yüklendiği durum
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -60,
                        left: context.width * 0.05,
                        child: MarkaImage(
                          marka: marka,
                          future: getImageUrl(imageurl),
                          isCircular: true,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // Resmi göstermek için Image.network widget'ını kullanın
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(LocaleKeys.shareCode.translate),
                                  IconButton(
                                    icon: Icon(Icons.adaptive.share),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ]),

                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  const Text(
                                      "İndirimi almak için telefonu görevliye gösterin."),
                                  const SizedBox(height: 8),
                                  Text(user!.uid,
                                      style: context.textTheme.headlineSmall),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Divider(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          "Kampanya Detayları",
                                          style:
                                              context.textTheme.headlineMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
