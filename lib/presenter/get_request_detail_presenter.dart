import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/get_request_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class GetRequestContract {
  void onRequestSuccess(GetRequestPojo pojoData);

  void onRequestError(String errorTxt);
}

class GetRequestPresenter {
  GetRequestContract _view;
  RestDatasource api = new RestDatasource();

  GetRequestPresenter(this._view);

  doGetRequest(BuildContext getContext, login_token, request_id) async {
    try {
      await api
          .getRequest(getContext, login_token, request_id)
          .then((GetRequestPojo pojoData) {
        _view.onRequestSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onRequestError(error.toString());
    }
  }
}
