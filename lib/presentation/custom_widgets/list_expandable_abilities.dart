import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:themoviedex/data/model/local/ablities_model.dart';
import 'package:themoviedex/data/model/local/expand_model.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ListExpandableAbilities extends StatefulWidget {
  List<GuideModelDomain> listMap;
  ValueChanged<GuideModelDomain> onColapse;
  ValueChanged<GuideModelDomain> onExpand;
  ValueChanged<GuideModelDomain> onLinkClick;

  ListExpandableAbilities(
    this.listMap,
    this.onColapse,
    this.onExpand,
    this.onLinkClick, {
    Key key,
  }) : super(key: key);

  @override
  _ListExpandableAbilitiesState createState() {
    return _ListExpandableAbilitiesState();
  }
}

class _ListExpandableAbilitiesState extends State<ListExpandableAbilities> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildListView(context, widget.listMap);
  }

  Widget buildListView(BuildContext context, List<GuideModelDomain> listMap) {
    print("${listMap.length}");
    return ListView.builder(
      itemCount: listMap.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        GuideModelDomain mapModel = listMap[index];
        return StickyHeader(
          header: buildItemListView(context, mapModel),
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildItemContent(context, mapModel),
                buildItemLink(context, mapModel)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildItemListView(BuildContext context, GuideModelDomain mapModel) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildItemHeader(context, mapModel),
        ],
      ),
    );
  }

  Widget buildItemHeader(BuildContext context, GuideModelDomain mapModel) {
    return GestureDetector(
        onTap: () {
          if (mapModel.isExpanded) {
            if (widget.onColapse != null) {
              widget.onColapse(mapModel);
            }
          } else {
            if (widget.onExpand != null) {
              widget.onExpand(mapModel);
            }
          }
        },
        child: buildItemHeaderDecoration(context, mapModel));
  }

  Widget buildItemHeaderDecoration(
      BuildContext context, GuideModelDomain abilitiesModel) {
    print("is Left in list: ${abilitiesModel.isLeft}");
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: abilitiesModel.isLeft
                  ? [
                      Colors.lightBlue[800].withOpacity(0.7),
                      Colors.blue[800].withOpacity(0.7),
                      Colors.purple.withOpacity(0.7)
                    ]
                  : [
                      Colors.purple.withOpacity(0.7),
                      Colors.blue[800].withOpacity(0.7),
                      Colors.lightBlue[800].withOpacity(0.7)
                    ]),
        ),
        child: Container(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getContentHeaderItem(abilitiesModel.thumbnailUrl,
                  abilitiesModel.name, abilitiesModel.isLeft)),
        ));
  }

  List<Widget> getContentHeaderItem(
      String thumnailUrl, String text, bool isLeft) {
    var list = [
      if (thumnailUrl == null)
        Image.asset(
          R.img_ic_sabotage,
          fit: BoxFit.cover,
          width: 60,
          height: 60,
        )
      else
        CachedNetworkImage(
          imageUrl: thumnailUrl,
          fit: BoxFit.cover,
          width: 60,
          height: 60,
        ),
      Text(
        text,
        style: GoogleFonts.arapey(
          textStyle: Theme.of(context).textTheme.display1,
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
      ),
    ].toList();
    if (isLeft)
      return list;
    else
      return list.reversed.toList();
  }

  Widget buildItemContent(BuildContext context, GuideModelDomain mapModel) {
    if (mapModel.isExpanded) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          children: [
            mapModel.description != null
                ? Html(
                    data: mapModel.description,
                  )
                : Text(""),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget buildItemLink(BuildContext context, GuideModelDomain mapModel) {
    if (mapModel.isExpanded) {
      return GestureDetector(
        onTap: () => widget.onLinkClick(mapModel),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Text(
              "Click to read more about type of ${mapModel.name}",
              style: GoogleFonts.acme(
                textStyle: Theme.of(context).textTheme.display1,
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
