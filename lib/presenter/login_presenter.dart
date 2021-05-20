import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/user_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class LoginContract {
  void onLoginSuccess(UserPojo user);

  void onLoginError(String errorTxt);
}

class LoginPresenter {
  LoginContract _view;
  RestDatasource api = new RestDatasource();

  LoginPresenter(this._view);

  doLogin(BuildContext getContext, String username, String password) async {
    try {
      await api.login(getContext, username, password).then((UserPojo user) {
        _view.onLoginSuccess(user);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onLoginError(error.toString());
    }
  }

  doFacebookLogin(BuildContext getContext, String token) async {
    try {
      await api.facebook_login(getContext, token).then((UserPojo user) {
        _view.onLoginSuccess(user);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onLoginError(error.toString());
    }
  }

  doAppleLogin(BuildContext getContext, AuthorizationCredentialAppleID credentials) async {
    try {
      await api.apple_login(getContext, credentials.authorizationCode).then((UserPojo user) {
        _view.onLoginSuccess(user);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onLoginError(error.toString());
    }
  }
}
