import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/account_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class AddUpdateAccountContract {
  void onAccountSuccess(AccountPojo pojoData);

  void onAccountError(String errorTxt);
}

class AddUpdateAccountPresenter {
  AddUpdateAccountContract _view;
  RestDatasource api = new RestDatasource();

  AddUpdateAccountPresenter(this._view);

  doGetAccount(
      BuildContext getContext,login_token) async {
    try {
      await api
          .getAccounts(getContext, login_token)
          .then((AccountPojo pojoData) {
        _view.onAccountSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onAccountError(error.toString());
    }
  }

  doCreateAccount(
      BuildContext getContext, Map mapRawBodyData, login_token) async {
    try {
      await api
          .addAccount(getContext, mapRawBodyData, login_token)
          .then((AccountPojo pojoData) {
        _view.onAccountSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onAccountError(error.toString());
    }
  }

  doUpdateAccount(
      BuildContext getContext, Map mapRawBodyData,String accountId, login_token) async {
    try {
      await api
          .updatepdateAccount(getContext, mapRawBodyData,accountId, login_token)
          .then((AccountPojo pojoData) {
        _view.onAccountSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onAccountError(error.toString());
    }
  }

}
