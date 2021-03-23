import 'package:flutter/material.dart';
import 'package:themoviedex/data/model/local/expand_model.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/presentation/custom_widgets/list_expandable.dart';
import 'package:themoviedex/presentation/screen/map/map_page_provider.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  GuideModelDomain mapData;
  MapPage({Key key, this.mapData}) : super(key: key);

  @override
  _MapPageState createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MapPageProvider>(context, listen: false)..firstCallData(widget.mapData)..listener();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MapPageProvider provider, child) {
        return RefreshIndicator(
          onRefresh: () => context.read<MapPageProvider>().reset(),
          child: ListExpandable(provider.listMap, provider.controller, (ExpandableModel mapModel) {
            Provider.of<MapPageProvider>(context, listen: false)
                .colapseItem(mapModel);
          }, (ExpandableModel mapModel) {
            Provider.of<MapPageProvider>(context, listen: false)
                .expandItem(mapModel);
          }),
        );
      },
    );
  }
}
