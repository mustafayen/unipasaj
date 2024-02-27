import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unipasaj/extensions/context_extensions.dart';
import 'package:unipasaj/extensions/string_extensions.dart';
import 'package:unipasaj/localization/locale_keys.g.dart';
import 'package:unipasaj/pages/discover/kesfet_page_view_model.dart';

class Kesfet extends StatefulWidget {
  const Kesfet({super.key});

  @override
  State<Kesfet> createState() => _KesfetState();
}

class _KesfetState extends State<Kesfet> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<KesfetPageViewModel>(context, listen: false).getCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KesfetPageViewModel>(
      builder: (context, provider, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SearchBar(
                  hintText: 'Ara...',
                  onChanged: (value) {
                    provider.getCategories(searchParams: value);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    LocaleKeys.discover.translate,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          itemCount: provider.categories.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return Card(
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          provider.categories[index].imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Text(
                                        provider.fakeCategories[index].name,
                                        style: context.textTheme.headlineLarge!
                                            .copyWith(
                                          color: Colors.white,
                                          shadows: [
                                            const Shadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 0),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
