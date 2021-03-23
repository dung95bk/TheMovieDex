import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:themoviedex/data/model/local/ablities_model.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/screen/detail_abilities/detail_abilities_provider.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';
import 'package:provider/provider.dart';

class DetailAbilitesPage extends StatefulWidget {
  GuideModelDomain abilitiesModel;

  DetailAbilitesPage(this.abilitiesModel);

  @override
  _DetailAbilitesPageState createState() {
    return _DetailAbilitesPageState();
  }
}

class _DetailAbilitesPageState extends State<DetailAbilitesPage> {
  DetailAbilitiesProvider provider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = DetailAbilitiesProvider();
      provider.initData(widget.abilitiesModel);

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            if (widget.abilitiesModel.thumbnailUrl?.isEmpty)
              Image.asset(R.img_ic_task_clear_asteroids)
            else
              CachedNetworkImage(imageUrl: widget.abilitiesModel.thumbnailUrl,  fit: BoxFit.cover,),
            Container(
                margin: EdgeInsets.only(top: 10.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0)),
                child: getDescription(widget.abilitiesModel.description))
          ],
        ),
      ),
    );
  }

  Widget getDescription(String description) {
    if (description == null) {
      return Html(
        data: "",
      );
    } else {
      return Html(
        data: description,
      );
    }
  }

  buildAppBar() {
    return Container(
      height: kToolbarHeight,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              NavigatorUtil.popSinglePage(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    R.img_ic_close,
                    fit: BoxFit.cover,
                    width: 16,
                    height: 16,
                  )),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.abilitiesModel.name,
              style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.display1,
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        ],
      ),
    );
  }
}
