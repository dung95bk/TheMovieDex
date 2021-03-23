import 'package:flutter/material.dart';
import 'package:themoviedex/data/model/local/expand_model.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/presentation/custom_widgets/list_expandable.dart';
import 'package:themoviedex/presentation/screen/groups/groups_provider.dart';
import 'package:themoviedex/presentation/screen/location/location_page_provider.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  GuideModelDomain locationData;

  LocationPage({Key key, this.locationData}) : super(key: key);

  @override
  _LocationPageState createState() {
    return _LocationPageState();
  }
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LocationPageProvider>(context, listen: false)..firstCallData(widget.locationData)..listener();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, LocationPageProvider provider, child) {
        return RefreshIndicator(
          onRefresh: () => context.read<LocationPageProvider>().reset(),
          child: ListExpandable(provider.listLocation, provider.controller, (ExpandableModel mapModel) {
            Provider.of<LocationPageProvider>(context, listen: false)
                .colapseItem(mapModel);
          }, (ExpandableModel mapModel) {
            Provider.of<LocationPageProvider>(context, listen: false)
                .expandItem(mapModel);
          }),
        );
      },
    );
  }
}