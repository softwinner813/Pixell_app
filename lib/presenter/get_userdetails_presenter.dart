import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/get_user_derails.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class GetUserDetailsContract {
  void onDetailsSuccess(GetUserDetailsPojo pojoData);

  void onDetailsError(String errorTxt);
}

class GetUserDetailsPresenter {
  GetUserDetailsContract _view;
  RestDatasource api = new RestDatasource();

  GetUserDetailsPresenter(this._view);

  doGetUserDetails(BuildContext getContext, userID) async {
    try {
      await api
          .getUserDetails(getContext, userID)
          .then((GetUserDetailsPojo pojoData) {
        _view.onDetailsSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onDetailsError(error.toString());
    }
  }
}
