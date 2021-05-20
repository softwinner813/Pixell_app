import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/age_confirm_pojo.dart';
import 'package:pixell_app/models/logout_pojo.dart';
import 'package:pixell_app/models/user_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class LogoutContract {
  void onLogoutSuccess(LogoutPojo pojodata);

  void onLogoutError(String errorTxt);
}

class LogoutPresenter {
  LogoutContract _view;
  RestDatasource api = new RestDatasource();

  LogoutPresenter(this._view);

  doLogout(BuildContext getContext,String login_token) async {
    try {
      await api.logout(getContext,login_token).then((LogoutPojo pojodata) {
        _view.onLogoutSuccess(pojodata);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onLogoutError(error.toString());
    }
  }
}
