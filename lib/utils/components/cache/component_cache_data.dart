import 'package:flutter_component/data/spref.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class ComponentCacheData implements _CacheKey {
  static final ComponentCacheData instant = ComponentCacheData._internal();

  ComponentCacheData._internal();

  late SharedPreferences pref;

  Future<void> initCache() async {
    await SPref.instant.init();
    pref = SPref.instant.prefs;
  }

  // #region deviceId
  ///Lấy ra deviceId
  String get deviceId => pref.getString(_CacheKey.deviceId) ?? '';

  ///Lưu lại deviceId
  Future<void> setDeviceId(String deviceId) => pref.setString(_CacheKey.deviceId, deviceId);

  // #endregion

  // #region token
  ///Lấy ra token
  String get token => pref.getString(_CacheKey.token) ?? '';

  ///Lưu lại token
  Future<void> setToken(String token) => pref.setString(_CacheKey.token, token);

  // #endregion

  // #region token refresh
  ///Lấy ra token refresh
  String get refreshToken => pref.getString(_CacheKey.refreshToken) ?? '';

  ///Lưu lại token refresh
  Future<void> setRefreshToken(String refreshToken) => pref.setString(_CacheKey.refreshToken, refreshToken);

  // #endregion

  // #region token firebase
  ///Lấy ra token firebase
  String get tokenFirebase => pref.getString(_CacheKey.tokenFirebase) ?? "";

  ///Lưu lại token firebase
  Future<bool>? setTokenFirebase(String tokenFirebase) => pref.setString(_CacheKey.tokenFirebase, tokenFirebase);

  // #endregion

  // #region idUser
  ///Lấy ra idUser
  int? get idUser => pref.getInt(_CacheKey.idUser);

  ///Lưu lại idUser
  Future<void>? setIdUser(int idUser) => pref.setInt(_CacheKey.idUser, idUser);

  // #endregion

  Future removeAllCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(_CacheKey.token);
    await preferences.remove(_CacheKey.refreshToken);
    await preferences.remove(_CacheKey.tokenFirebase);
    await preferences.remove(_CacheKey.idUser);
  }
}

abstract class _CacheKey extends AppKey {
  _CacheKey._internal();

  static const String token = AppKey.xToken;
  static const String refreshToken = AppKey.xTokenRefresh;
  static const String tokenFirebase = "tokenFirebase";
  static const String idUser = "idUser";
  static const String deviceId = "deviceId";
}
