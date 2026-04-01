// class AuthRepository {
//   Future<bool> register({required String email, required String password}) async {
//     await Future.delayed(const Duration(seconds: 2));
//     return true; 
//   }
// }
import '../../rest_client/mobile_api_dio.dart';
import '../../rest_client/profile.dart';

class AuthRepository {
  final MobileApiDio mobileApiDio;

  AuthRepository(this.mobileApiDio);

  Future<Profile> fetchProfile() async {
    return await mobileApiDio.api.getProfile();
  }
}