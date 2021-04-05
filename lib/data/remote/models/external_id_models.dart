import 'dart:convert' show json;

class ExternalIdModels {

  int id;
  String imdbId;
  String facebookId;
  String freebaseMid;
  String freebaseId;
  int tvrageId;
  String twitterId;
  String instagramId;
  ExternalIdModels.empty();

  ExternalIdModels.fromParams({this.id, this.imdbId, this.facebookId, this.freebaseMid,
      this.freebaseId, this.tvrageId, this.twitterId, this.instagramId});

  factory ExternalIdModels(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ExternalIdModels.fromJson(json.decode(jsonStr)) : new ExternalIdModels.fromJson(jsonStr);

  ExternalIdModels.fromJson(jsonRes) {
    id = jsonRes['id'];
    imdbId = jsonRes['imdb_id'];
    facebookId = jsonRes['facebook_id'];
    freebaseMid = jsonRes['freebase_mid'];
    freebaseId = jsonRes['freebase_id'];
    tvrageId = jsonRes['tvrage_id'];
    twitterId = jsonRes['twitter_id'];
    instagramId = jsonRes['instagram_id'];
  }

  @override
  String toString() {
    return 'ExternalIdModels{id: $id, imdbId: $imdbId, facebookId: $facebookId, freebaseMid: $freebaseMid, freebaseId: $freebaseId, tvrageId: $tvrageId, twitterId: $twitterId, instagramId: $instagramId}';
  }
}

