import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:themoviedex/data/config/ServerConfig.dart';
import 'package:themoviedex/data/helper/api_name.dart';
import 'package:themoviedex/data/remote/models/base_api_model/user_list.dart';
import 'package:themoviedex/data/remote/models/enums/media_type.dart';
import 'package:themoviedex/data/remote/models/response_model.dart';
import 'package:themoviedex/data/remote/request.dart';
import 'package:themoviedex/data/remote/request/get_category_request.dart';
import 'package:themoviedex/data/remote/request/get_detail_category_request.dart';
import 'package:themoviedex/data/remote/request/get_detail_task_request.dart';
import 'package:themoviedex/data/remote/request/get_guide_request.dart';
import 'package:themoviedex/data/remote/request/get_list_image_request.dart';
import 'package:themoviedex/data/remote/request/get_token_request.dart';

import 'models/models.dart';

class Http {
  static final Http _instance = Http._internal();

  static Http get instance => _instance;
  final _dio = Dio();
  final Request _http = Request(ServerConfig.instance.baseApiHost);

  factory Http() {
    return _instance;
  }

  Http._internal() {

  }

  Future<ResponseModel<dynamic>> updateUser(String uid, String email,
      String photoUrl, String userName, String phone) async {
    final String _url = '/Users';
    final _data = {
      "phone": phone,
      "email": email,
      "photoUrl": photoUrl,
      "userName": userName,
      "uid": uid
    };
    return await _http.request(_url, method: "POST", data: _data);
  }

  Future<ResponseModel<UserListModel>> getUserList(String uid,
      {int page = 1, int pageSize = 20}) async {
    final String _url = '/UserLists/User/$uid?page=$page&pageSize=$pageSize';
    final r = await _http.request<UserListModel>(_url);
    return r;
  }

  Future<ResponseModel<dynamic>> createUserList(UserList d) async {
    final String _url = '/UserLists';
    final data = {
      "id": 0,
      "updateTime": DateTime.now().toString(),
      "createTime": DateTime.now().toString(),
      "runTime": 0,
      "totalRated": 0,
      "selected": 0,
      "revenue": 0,
      "itemCount": 0,
      "description": d.description,
      "backGroundUrl": d.backGroundUrl,
      "uid": d.uid,
      "listName": d.listName
    };
    return await _http.request(_url, method: 'POST', data: data);
  }

  Future<ResponseModel<dynamic>> deleteUserList(int listid) async {
    final String _url = '/UserLists/$listid';
    return await _http.request(_url, method: 'DELETE');
  }

  Future<ResponseModel<dynamic>> addUserListDetail(UserListDetail d) async {
    final String _url = '/UserListDetails';
    final data = {
      "id": 0,
      "photoUrl": d.photoUrl,
      "mediaName": d.mediaName,
      "mediaType": d.mediaType,
      "mediaid": d.mediaid,
      "listid": d.listid,
      "rated": d.rated,
      "runTime": d.runTime,
      "revenue": d.revenue
    };
    return await _http.request(_url, method: 'POST', data: data);
  }

  Future<ResponseModel<UserListDetail>> getUserListDetailItem(
      int listid, String mediaType, int mediaid) async {
    final String _url = '/UserListDetails/$listid/$mediaType/$mediaid';
    final r = await _http.request<UserListDetail>(_url);
    return r;
  }

  Future<ResponseModel<UserListDetailModel>> getUserListDetailItems(int listid,
      {int page = 1, int pageSize = 20}) async {
    final String _url =
        '/UserListDetails/List/$listid?page=$page&pageSize=$pageSize';
    final r = await _http.request<UserListDetailModel>(_url);
    return r;
  }

  Future<ResponseModel<dynamic>> updateUserList(UserList list) async {
    final String _url = '/UserLists/${list.id}';
    final data = {
      "id": list.id,
      "updateTime": DateTime.now().toString(),
      "createTime": list.createTime,
      "runTime": list.runTime,
      "totalRated": list.totalRated,
      "selected": 0,
      "revenue": list.revenue,
      "itemCount": list.itemCount,
      "description": list.description,
      "backGroundUrl": list.backGroundUrl,
      "uid": list.uid,
      "listName": list.listName
    };
    return await _http.request(_url, method: 'PUT', data: data);
  }

  Future<ResponseModel<CastListDetail>> getCastListDetail(int listId,
      {int page = 1, int pageSize = 20}) async {
    final String _url =
        '/CastList/$listId/detail?page=$page&pageSize=$pageSize';
    final r = await _http.request<CastListDetail>(_url);
    return r;
  }

  Future<ResponseModel<BaseCast>> addCast(BaseCast cast) async {
    final String _url = '/CastList/addCast';
    final _data = {
      "listId": cast.listId,
      "Name": cast.name,
      "castId": cast.castId,
      "profileUrl": cast.profileUrl
    };
    final r = await _http.request<BaseCast>(_url, method: 'POST', data: _data);
    return r;
  }

  Future<ResponseModel<BaseCast>> deleteCast(int id) async {
    final String _url = '/CastList/detail/$id';
    final r = await _http.request<BaseCast>(_url, method: 'DELETE');
    return r;
  }

  Future<ResponseModel<AccountState>> getAccountState(
      String uid, int mediaId, MediaType type) async {
    final String _url =
        '/UserAccountStates/$uid/${type.toString().split('.').last}/$mediaId';
    final r = await _http.request<AccountState>(_url);
    return r;
  }

  Future<ResponseModel<AccountState>> updateAccountState(AccountState d) async {
    final String _url = '/UserAccountStates';
    final data = {
      'id': d.id,
      'mediaType': d.mediaType,
      'watchlist': d.watchlist ? 1 : 0,
      'rated': d.rated,
      'favorite': d.favorite ? 1 : 0,
      'mediaId': d.mediaId,
      'uid': d.uid
    };
    final r =
    await _http.request<AccountState>(_url, method: 'POST', data: data);
    return r;
  }

  Future<ResponseModel<dynamic>> setFavorite(UserMedia d) async {
    final String _url = '/UserFavorite';
    final _data = {
      'id': 0,
      'uid': d.uid,
      'mediaId': d.mediaId,
      'name': d.name,
      'genre': d.genre,
      'overwatch': d.overwatch,
      'photoUrl': d.photoUrl,
      'rated': d.rated,
      'ratedCount': d.ratedCount,
      'popular': d.popular,
      'mediaType': d.mediaType,
      'releaseDate': d.releaseDate,
      'createDate': DateTime.now().toString(),
    };
    final r = await _http.request(_url, method: 'POST', data: _data);
    return r;
  }

  Future<ResponseModel<UserMediaModel>> getFavorite(
      String uid, String mediaType,
      {int page = 1, int pageSize = 20}) async {
    final String _url =
        '/UserFavorite/$uid?mediaType=$mediaType&page=$page&pageSize=$pageSize';
    final r = await _http.request<UserMediaModel>(_url,
        cached: true, cacheDuration: Duration(days: 0));
    return r;
  }

  Future<ResponseModel<dynamic>> deleteFavorite(
      String uid, MediaType type, int mediaId) async {
    final String _url =
        '/UserFavorite/$uid/${type.toString().split('.').last}/$mediaId';
    final r = await _http.request(_url, method: 'DELETE');
    return r;
  }

  Future<ResponseModel<dynamic>> setWatchlist(UserMedia d) async {
    final String _url = '/UserWatchlist';
    final _data = {
      'id': 0,
      'uid': d.uid,
      'mediaId': d.mediaId,
      'name': d.name,
      'genre': d.genre,
      'overwatch': d.overwatch,
      'photoUrl': d.photoUrl,
      'rated': d.rated,
      'ratedCount': d.ratedCount,
      'popular': d.popular,
      'mediaType': d.mediaType,
      'releaseDate': d.releaseDate,
      'createDate': DateTime.now().toString(),
    };
    final r = await _http.request(_url, method: 'POST', data: _data);
    return r;
  }

  Future<ResponseModel<UserMediaModel>> getWatchlist(
      String uid, String mediaType,
      {int page = 1, int pageSize = 20}) async {
    final String _url =
        '/UserWatchlist/$uid?mediaType=$mediaType&page=$page&pageSize=$pageSize';
    final r = await _http.request<UserMediaModel>(_url);
    return r;
  }

  Future<ResponseModel<dynamic>> deleteWatchlist(
      String uid, MediaType type, int mediaId) async {
    final String _url =
        '/UserWatchlist/$uid/${type.toString().split('.').last}/$mediaId';
    final r = await _http.request(_url, method: 'DELETE');
    return r;
  }

  Future<ResponseModel<BaseMovieModel>> getMovies(
      {int page = 1, int pageSize = 20}) async {
    final String _url = '/Movies?page=$page&pageSize=$pageSize';
    final r = await _http.request<BaseMovieModel>(_url,
        cached: true, cacheDuration: Duration(days: 0));
    return r;
  }

  Future<ResponseModel<BaseMovieModel>> searchMovies(String query,
      {int page = 1, int pageSize = 20}) async {
    final String _url =
        '/Movies/Search?name=$query&page=$page&pageSize=$pageSize';
    final r = await _http.request<BaseMovieModel>(_url);
    return r;
  }

  Future<ResponseModel<MovieStreamLinks>> getMovieStreamLinks(
      int movieid) async {
    final String _url = '/MovieStreamLinks/MovieId/$movieid';
    final r = await _http.request<MovieStreamLinks>(_url);
    return r;
  }

  Future<ResponseModel<bool>> hasMovieStreamLinks(int movieid) async {
    String _url = '/MovieStreamLinks/Exist/$movieid';
    final _r = _http.request<bool>(_url);
    return _r;
  }

  Future<ResponseModel<dynamic>> getMovieLikes(
      {int movieid, String uid = ''}) async {
    final String _url = '/Movies/Like/$movieid?uid=$uid';
    final r = await _http.request(_url);
    return r;
  }

  Future<ResponseModel<MovieLikeModel>> likeMovie(MovieLikeModel like) async {
    final String _url = '/Movies/Like';
    final _data = {'id': 0, 'movieId': like.movieId ?? 0, 'uid': like.uid};
    final r =
    await _http.request<MovieLikeModel>(_url, method: "POST", data: _data);
    return r;
  }

  Future<ResponseModel<MovieLikeModel>> unlikeMovie(MovieLikeModel like) async {
    final String _url = '/Movies/Like';
    final _data = {'id': 0, 'movieId': like.movieId ?? 0, 'uid': like.uid};
    final r = await _http.request<MovieLikeModel>(_url,
        method: "DELETE", data: _data);
    return r;
  }

  Future<ResponseModel<BaseTvShowModel>> getTvShows(
      {int page = 1, int pageSize = 20}) async {
    final String _url = '/TvShows?page=$page&pageSize=$pageSize';
    final r = await _http.request<BaseTvShowModel>(_url,
        cached: true, cacheDuration: Duration(days: 0));
    return r;
  }

  Future<ResponseModel<BaseTvShowModel>> searchTvShows(String query,
      {int page = 1, int pageSize = 20}) async {
    final String _url = '/TvShows/Search/$query&page=$page&pageSize=$pageSize';
    final r = await _http.request<BaseTvShowModel>(_url);
    return r;
  }

  Future<ResponseModel<TvShowStreamLinks>> getTvSeasonStreamLinks(
      int tvid, int season) async {
    final String _url = '/TvShowStreamLinks/$tvid/$season';
    final r = await _http.request<TvShowStreamLinks>(_url,
        cached: true, cacheDuration: Duration(minutes: 10));
    return r;
  }

  Future<ResponseModel<dynamic>> getTvShowLikes(
      {int tvid, int season = 0, int episode = 0, String uid = ''}) async {
    final String _url =
        '/TvShows/Like/$tvid?season=$season&episode=$episode&uid=$uid';
    final r = await _http.request(_url);
    return r;
  }

  Future<ResponseModel<TvShowLikeModel>> likeTvShow(
      TvShowLikeModel like) async {
    final String _url = '/TvShows/Like';
    final _data = {
      'id': 0,
      'tvId': like.tvId ?? 0,
      'season': like.season,
      'episode': like.episode,
      'uid': like.uid
    };
    final r =
    await _http.request<TvShowLikeModel>(_url, method: "POST", data: _data);
    return r;
  }

  Future<ResponseModel<TvShowLikeModel>> unlikeTvShow(
      TvShowLikeModel like) async {
    final String _url = '/TvShows/Like';
    final _data = {
      'id': 0,
      'tvId': like.tvId ?? 0,
      'season': like.season,
      'episode': like.episode,
      'uid': like.uid
    };
    final r = await _http.request<TvShowLikeModel>(_url,
        method: "DELETE", data: _data);
    return r;
  }

  Future<ResponseModel<bool>> hasTvShowStreamLinks(int tvid) async {
    String _url = '/TvShowStreamLinks/Exist/$tvid';
    final _r = await _http.request<bool>(_url);
    return _r;
  }

  Future<ResponseModel<bool>> hasTvSeasonStreamLinks(
      int tvid, int season) async {
    final String _url = '/TvShowStreamLinks/Exist/$tvid/$season';
    final _r = await _http.request<bool>(_url);
    return _r;
  }

  Future<ResponseModel<MovieComment>> createMovieComment(
      MovieComment comment) async {
    String _url = '/MovieComments';
    var _data = {
      'mediaId': comment.mediaId,
      'comment': comment.comment,
      'uid': comment.uid,
      'createTime': comment.createTime,
      'updateTime': comment.updateTime,
      'like': 0,
    };
    return await _http.request<MovieComment>(_url, method: 'POST', data: _data);
  }

  Future<ResponseModel<TvShowComment>> createTvShowComment(
      TvShowComment comment) async {
    final String _url = '/TvShowComments';
    final _data = {
      'mediaId': comment.mediaId,
      'comment': comment.comment,
      'uid': comment.uid,
      'createTime': comment.createTime,
      'updateTime': comment.updateTime,
      'like': comment.like,
      'season': comment.season,
      'episode': comment.episode
    };
    final r =
    await _http.request<TvShowComment>(_url, method: 'POST', data: _data);
    return r;
  }

  Future<ResponseModel<TvShowComments>> getTvShowComments(
      int tvid, int season, int episode,
      {int page = 1, int pageSize = 40}) async {
    final String _url =
        '/TvShowComments/$tvid/$season/$episode?page=$page&pageSize=$pageSize';
    final r = await _http.request<TvShowComments>(_url);
    return r;
  }

  Future<ResponseModel<MovieComments>> getMovieComments(int movieid,
      {int page = 1, int pageSize = 40}) async {
    final String _url = '/MovieComments/$movieid';
    final r = await _http.request<MovieComments>(_url);
    return r;
  }

  Future<ResponseModel<String>> sendStreamLinkReport(
      StreamLinkReport report) async {
    final String _url = '/Email/ReportEmail';
    final _data = {
      'mediaName': report.mediaName,
      'linkName': report.linkName,
      'content': report.content,
      'mediaId': report.mediaId,
      'streamLinkId': report.streamLinkId,
      'type': report.type,
      'streamLink': report.streamLink
    };
    final r = await _http.request<String>(_url, method: "POST", data: _data);
    return r;
  }

  Future<ResponseModel<String>> sendRequestStreamLink(
      StreamLinkReport report) async {
    final String _url = '/Email/RequestLinkEmail';
    final _data = {
      'mediaName': report.mediaName,
      'mediaId': report.mediaId,
      'type': report.type,
      'season': report.season
    };
    final r = await _http.request<String>(_url, method: "POST", data: _data);
    return r;
  }




























  /**
   * Old data
   *
   */
  Future<Response> getToken(GetTokenRequest getTokenRequest) async {
    return _dio.post("/${ApiName.GET_TOKEN}",
        data: jsonEncode(getTokenRequest.toJson()));
  }

  Future<Response> getListImage(GetListImageRequest getListImageRequest) async {
    return _dio.post("/${ApiName.GET_LIST_IMAGE_HOT}",
        data: jsonEncode(getListImageRequest.toJson()));
  }

  Future<Response> getListCategory(
      GetcategoryRequest getcategoryRequest) async {
    return _dio.post("/${ApiName.GET_CATEGORIES}",
        data: jsonEncode(getcategoryRequest.toJson()));
  }

  Future<Response> getCategoryDetail(
      GetCategoryDetailRequest getCategoryDetailRequest) async {
    return _dio.post("/${ApiName.GET_CATEGORIES_DETAIL}",
        data: jsonEncode(getCategoryDetailRequest.toJson()));
  }

  Future<Response> getGuide(
      GetGuideRequest getGuideRequest) async {
    return _dio.post("/${ApiName.GET_GUIDE}",
        data: jsonEncode(getGuideRequest.toJson()));
  }

  Future<Response> getDetailTask(
      GetDetailTaskRequest getDetailTaskRequest) async {
    return _dio.post("/${ApiName.GET_DETAIL_TASK}",
        data: jsonEncode(getDetailTaskRequest.toJson()));
  }

  Future<Response> executeRequest(String request) async {
    return _dio.post("/", data: request);
  }
}
