import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/reset_password_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class ResetPasswordContract {
  void onResetSuccess(ResetPojo pojoData);

  void onResetError(String errorTxt);
}

class ResetPasswordPresenter {
  ResetPasswordContract _view;
  RestDatasource api = new RestDatasource();

  ResetPasswordPresenter(this._view);

  doResetPassword(BuildContext getContext, String email) async {
    try {
      await api.resetPassword(getContext, email).then((ResetPojo pojoData) {
        _view.onResetSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onResetError(error.toString());
    }
  }
}
