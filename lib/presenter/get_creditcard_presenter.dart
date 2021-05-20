import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/get_creditcard_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class GetCreditCardContract {
  void onGetCreditCardSuccess(GetCreditCardPojo pojodata);

  void onGetCreditCardError(String errorTxt);
}

class GetCreditCardPresenter {
  GetCreditCardContract _view;
  RestDatasource api = new RestDatasource();

  GetCreditCardPresenter(this._view);

  doGetCreditCard(BuildContext getContext, login_token) async {
    try {
      await api
          .getCrediCrad(getContext, login_token)
          .then((GetCreditCardPojo pojodata) {
        _view.onGetCreditCardSuccess(pojodata);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onGetCreditCardError(error.toString());
    }
  }
}
