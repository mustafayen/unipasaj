import 'package:flutter/material.dart';
import 'package:unipasaj/class/markaClass.dart';

class MarkaDetay extends StatefulWidget {
  const MarkaDetay(
      {super.key, required this.marka, required this.markaImageUrl});
  final Marka marka;
  final String? markaImageUrl;

  @override
  State<MarkaDetay> createState() => _MarkaDetayState();
}

class _MarkaDetayState extends State<MarkaDetay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
      body: CustomScrollView(
        clipBehavior: Clip.none,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.marka.name),
                background: widget.markaImageUrl == null
                    ? CircularProgressIndicator()
                    : Image.network(
                        widget.markaImageUrl!,
                        fit: BoxFit.cover,
                      )),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
                height: 20,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(widget.marka.name),
                    ),
                  ],
                )),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child:
                        Text('$index', textScaler: const TextScaler.linear(5)),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    ));
  }
}
