import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/update_request_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class UpdateRequestContract {
  void onUpdateRequestSuccess(UpdateRequestPojo pojodata);

  void onUpdateRequestError(String errorTxt);
}

class UpdateRequestPresenter {
  UpdateRequestContract _view;
  RestDatasource api = new RestDatasource();

  UpdateRequestPresenter(this._view);

  doUpdateRequest(BuildContext getContext, status, amount, asset_link,
      requestsId, login_token) async {
    try {
      await api
          .updateRequest(
              getContext, status, amount, asset_link, requestsId, login_token)
          .then((UpdateRequestPojo pojodata) {
        _view.onUpdateRequestSuccess(pojodata);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onUpdateRequestError(error.toString());
    }
  }
}
