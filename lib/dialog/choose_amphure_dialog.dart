import 'package:flutter/material.dart';
import 'package:main_cluesnew/dao/amphure_dao.dart';

class ChooseAmphureDialog extends StatefulWidget {
  final List<AmphureDao> listAmphure;
  final TextStyle styleTitle;
  final TextStyle styleSubTitle;
  final TextStyle styleTextNoData;
  final TextStyle styleTextSearch;
  final TextStyle styleTextSearchHint;
  final double borderRadius;
  final Color colorBackgroundSearch;
  final Color colorBackgroundHeader;
  final Color colorLine;
  final Color colorLineHeader;
  final Color colorBackgroundDialog;

  const ChooseAmphureDialog(
      {super.key,
      required this.listAmphure,
      required this.styleTitle,
      required this.styleSubTitle,
      required this.styleTextNoData,
      required this.styleTextSearch,
      required this.styleTextSearchHint,
      required this.colorBackgroundHeader,
      required this.colorBackgroundSearch,
      required this.colorBackgroundDialog,
      required this.colorLine,
      required this.colorLineHeader,
      this.borderRadius = 16});

  static show(BuildContext context,
      {required List<AmphureDao> listAmphure,
      required TextStyle styleTitle,
      required TextStyle styleSubTitle,
      required TextStyle styleTextNoData,
      required TextStyle styleTextSearch,
      required TextStyle styleTextSearchHint,
      required Color colorBackgroundSearch,
      required Color colorBackgroundHeader,
      required Color colorBackgroundDialog,
      required Color colorLine,
      required Color colorLineHeader,
      double borderRadius = 16}) {
    return showDialog(
        context: context,
        builder: (context) {
          return ChooseAmphureDialog(
            listAmphure: listAmphure,
            styleTitle: styleTitle,
            styleSubTitle: styleSubTitle,
            styleTextNoData: styleTextNoData,
            styleTextSearch: styleTextSearch,
            colorBackgroundSearch: colorBackgroundSearch,
            colorBackgroundHeader: colorBackgroundHeader,
            colorBackgroundDialog: colorBackgroundDialog,
            colorLine: colorLine,
            colorLineHeader: colorLineHeader,
            borderRadius: borderRadius,
            styleTextSearchHint: styleTextSearchHint,
          );
        });
  }

  @override
  _ChooseAmphureDialogState createState() => _ChooseAmphureDialogState();
}

class _ChooseAmphureDialogState extends State<ChooseAmphureDialog> {
  List<AmphureDao>? listAmphureFilter;
  late List<AmphureDao> listAmphure;
  final TextEditingController _searchAmphureController =
      TextEditingController();

  @override
  void initState() {
    listAmphureFilter = List.of(widget.listAmphure);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: const Color.fromARGB(115, 0, 0, 0).withOpacity(0.2),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
//          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
              width: 300,
              height: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildSearchContainer(),
                  Container(
                    color: const Color.fromARGB(255, 30, 136, 229),
                    height: 4,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(widget.borderRadius))),
                      padding: const EdgeInsets.all(8),
                      child: buildListView(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    return Stack(
      children: <Widget>[
        ListView.builder(
            itemCount: listAmphureFilter!.length,
            itemBuilder: (context, index) {
              return buildRowProvince(listAmphureFilter![index]);
            }),
        Center(
            child: Visibility(
                visible: listAmphureFilter!.isEmpty,
                child: Text(
                  "ไม่มีข้อมูล",
                  style: const TextStyle(fontSize: 22),
                )))
      ],
    );
  }

  Widget buildRowProvince(AmphureDao amphure) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context, amphure);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    amphure.nameTh,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    amphure.nameEn,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[200],
            )
          ],
        ));
  }

  Widget buildSearchContainer() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(widget.borderRadius))),
      child: Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: _searchAmphureController,
                style: widget.styleTextSearch,
                decoration: InputDecoration.collapsed(
                    hintText: "อำเภอ..", hintStyle: widget.styleTextSearchHint),
                onChanged: (text) async {
                  List list = widget.listAmphure.where((item) {
                    text = text.toLowerCase();
                    return item.nameTh.toLowerCase().contains(text) ||
                        item.nameEn.toLowerCase().contains(text);
                  }).toList();

                  setState(() {
                    listAmphureFilter = list.cast<AmphureDao>();
                  });
                },
              )),
        ],
      ),
    );
  }
}