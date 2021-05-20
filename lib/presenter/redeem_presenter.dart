import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/redeem_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class RedeemContract {
  void onRedeemSuccess(RedeemPojo pojoData);

  void onRedeemError(String errorTxt);
}

class RedeemPresenter {
  RedeemContract _view;
  RestDatasource api = new RestDatasource();

  RedeemPresenter(this._view);

  doRedeem(BuildContext getContext,currency,type,login_token) async {
    try {
      await api.postRedeem(getContext,currency,type,login_token)
          .then((RedeemPojo pojoData) {
        _view.onRedeemSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onRedeemError(error.toString());
    }
  }
}
