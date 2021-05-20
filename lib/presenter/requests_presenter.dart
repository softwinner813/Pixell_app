import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/requests_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class RequestsContract {
  void onRequestsSuccess(RequestsPojo pojoData);

  void onRequestsError(String errorTxt);
}

class RequestsPresenter {
  RequestsContract _view;
  RestDatasource api = new RestDatasource();

  RequestsPresenter(this._view);

  doRequests(BuildContext getContext, login_token) async {
    try {
      await api
          .getRequests(getContext, login_token)
          .then((RequestsPojo pojoData) {
        _view.onRequestsSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onRequestsError(error.toString());
    }
  }

  doRequestsNextLoad(
      BuildContext getContext, login_token, String nextLoadUrl) async {
    try {
      await api
          .getRequestsNextLoad(getContext, login_token, nextLoadUrl)
          .then((RequestsPojo pojoData) {
        _view.onRequestsSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onRequestsError(error.toString());
    }
  }
}
