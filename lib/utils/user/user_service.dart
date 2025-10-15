import 'package:jmusic/constants/storage_constant.dart';
import 'package:jmusic/utils/storage_service.dart';

var USER_ID = 0;
var USER_NAME = 'GUEST_USER';

saveUser(body) async {
  var obj = {
    "id": body['id'],
    "username": body['username'],
    "name": body['name'],
    "type": body['type']
  };

  _initUserService(obj);

  await saveJson(STORAGE_KEY_USER, obj);
}

_initUserService(obj) async {
  USER_ID = obj['id'];
  USER_NAME = obj['username'];
}

loadUser() async {
  var obj = await loadJson(STORAGE_KEY_USER);

  print('loadUser : $obj');
  if (obj != null) {
    _initUserService(obj);
  }
  return obj;
}

deleteUser() async {
  await deleteJson(STORAGE_KEY_USER);
}

Future<int> getUserId() async {
  var obj = await loadJson(STORAGE_KEY_USER);
  return obj['id'];
}
