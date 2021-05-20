import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/signup_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class SignupContract {
  void onSignupSuccess(SignupPojo user);

  void onSignupError(String errorTxt);
}

class SignupPresenter {
  SignupContract _view;
  RestDatasource api = new RestDatasource();

  SignupPresenter(this._view);

  doSignup(
      BuildContext getContext,
      String username,
      String email,
      String date_of_birth,
      String password,
      bool isSeller,
      String profileImage,
      String profileThumbnail) async {
    try {
      await api.signup(getContext,username, email,date_of_birth, password, isSeller, profileImage, profileThumbnail).then((SignupPojo user) {
        _view.onSignupSuccess(user);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onSignupError(error.toString());
    }
  }
}
