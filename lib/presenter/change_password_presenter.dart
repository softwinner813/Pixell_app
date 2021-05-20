import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/change_password_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class ChangePasswordContract {
  void onSuccess(ChangePasswordPojo user);

  void onError(String errorTxt);
}

class ChangePasswordPresenter {
  ChangePasswordContract _view;
  RestDatasource api = new RestDatasource();

  ChangePasswordPresenter(this._view);

  doChangePassword(
      BuildContext getContext, userID, String password, login_token) async {
    try {
      await api
          .changePassword(getContext, userID, password, login_token)
          .then((ChangePasswordPojo pojoData) {
        _view.onSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onError(error.toString());
    }
  }
}
