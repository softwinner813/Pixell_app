import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/get_user_derails.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class EditUserContract {
  void onEditSuccess(GetUserDetailsPojo pojoData);

  void onEditError(String errorTxt);
}

class EditUserPresenter {
  EditUserContract _view;
  RestDatasource api = new RestDatasource();

  EditUserPresenter(this._view);

  doEditUser(
      BuildContext getContext, userID, Map mapRawBodyData, login_token) async {
    try {
      await api
          .editUser(getContext, userID, mapRawBodyData, login_token)
          .then((GetUserDetailsPojo pojoData) {
        _view.onEditSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onEditError(error.toString());
    }
  }
}
