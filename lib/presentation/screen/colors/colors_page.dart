import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/presentation/screen/colors/colors_page_provider.dart';
import 'package:provider/provider.dart';

class ColorsPage extends StatefulWidget {
  GuideModelDomain colorData;

  ColorsPage({Key key, this.colorData}) : super(key: key);

  @override
  _ColorsPageState createState() {
    return _ColorsPageState();
  }
}

class _ColorsPageState extends State<ColorsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ColorsPageProvider>(context, listen: false)
        ..listener()
        ..initData(widget.colorData);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ColorsPageProvider provider, child) {
        return buildList(context, provider.listColors, provider.controller);
      },
    );
  }

  Widget buildList(
      BuildContext context, List<GuideModelDomain> list, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: list.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        GuideModelDomain guideModelDomain = list[index];
        return buildItem(context, guideModelDomain);
      },
    );
  }

  Widget buildItem(BuildContext context, GuideModelDomain guideModelDomain) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            guideModelDomain.thumbnailUrl != null
                ? CachedNetworkImage(
                    imageUrl:  guideModelDomain.thumbnailUrl,
                    fit: BoxFit.fill,
                    width: 80,
                  )
                : SizedBox(),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        guideModelDomain.name,
                        style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.display1,
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
