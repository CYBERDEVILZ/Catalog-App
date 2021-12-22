import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class UserModel with ChangeNotifier {
  String? _uid;
  String? _username;
  String? _email;
  File? _imageurl;

  get uid => _uid;
  get username => _username;
  get email => _email;
  get imageurl => _imageurl;

  void setuid(uid) {
    _uid = uid;
    notifyListeners();
  }

  void setusername(username) {
    _username = username;
    notifyListeners();
  }

  void setemail(email) {
    _email = email;
    notifyListeners();
  }

  void setimageurl(imageurl) {
    _imageurl = imageurl;
    notifyListeners();
  }
}
