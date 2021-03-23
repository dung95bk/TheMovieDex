import 'package:flutter/material.dart';
import 'package:themoviedex/data/model/local/expand_model.dart';
import 'package:themoviedex/domain/model/guide_model_domain.dart';
import 'package:themoviedex/presentation/custom_widgets/list_expandable.dart';
import 'package:themoviedex/presentation/screen/groups/groups_provider.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  GuideModelDomain groupData;
  GroupsPage({Key key, this.groupData}) : super(key: key);

  @override
  _GroupsPageState createState() {
    return _GroupsPageState();
  }
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GroupsProvider>(context, listen: false)..firstCallData(widget.groupData)..listener();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, GroupsProvider provider, child) {
        return RefreshIndicator(
          onRefresh: () => context.read<GroupsProvider>().reset(),
          child: ListExpandable(provider.listGroup, provider.controller, (ExpandableModel mapModel) {
            Provider.of<GroupsProvider>(context, listen: false)
                .colapseItem(mapModel);
          }, (ExpandableModel mapModel) {
            Provider.of<GroupsProvider>(context, listen: false)
                .expandItem(mapModel);
          }),
        );
      },
    );
  }
}