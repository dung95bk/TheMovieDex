import 'package:themoviedex/data/model/local/expand_model.dart';

class GuideModelDomain extends ExpandableModel{
  String id;
  String parentId;
  String name;
  String slug;
  String description;
  String thumbnailUrl;

  GuideModelDomain.fromData({this.id, this.parentId, this.name, this.slug,
      this.description, this.thumbnailUrl});
}
