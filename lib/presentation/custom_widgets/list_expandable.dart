import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:themoviedex/data/model/local/expand_model.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/generated/r.dart';

class ListExpandable extends StatefulWidget {
  List<GuideModelDomain> listMap;
  ValueChanged<ExpandableModel> onColapse;
  ValueChanged<ExpandableModel> onExpand;
  ScrollController scrollController;
  ListExpandable(
    this.listMap,
    this.scrollController,
    this.onColapse,
    this.onExpand, {
    Key key,
  }) : super(key: key);

  @override
  _ListExpandableState createState() {
    return _ListExpandableState();
  }
}

class _ListExpandableState extends State<ListExpandable> {
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
      controller: widget.scrollController,
      itemCount: listMap.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        GuideModelDomain mapModel = listMap[index];
        return buildItemListView(context, mapModel);
      },
    );
  }

  Widget buildItemListView(BuildContext context, GuideModelDomain mapModel) {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildItemHeader(context, mapModel),
          SizedBox(
            height: 10,
          ),
          buildItemContent(context, mapModel)
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
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(width: 3.0, color: Colors.white),
            borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          "${mapModel.name}",
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(

            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget buildItemContent(BuildContext context, GuideModelDomain mapModel) {
    if (mapModel.isExpanded) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),
                child: mapModel.thumbnailUrl != null
                    ? CachedNetworkImage(imageUrl: mapModel.thumbnailUrl)
                    : SizedBox()),
            SizedBox(
              height: 15.0,
            ),

            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
