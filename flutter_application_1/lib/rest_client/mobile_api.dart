import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'profile.dart';

part 'mobile_api.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class MobileApi {
  factory MobileApi(Dio dio, {String baseUrl}) = _MobileApi;

  @GET('/posts/1')
  Future<Profile> getProfile();
}
