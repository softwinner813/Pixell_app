import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/charge_card_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class ChargeCardContract {
  void onChargeCardSuccess(ChargeCardPojo pojodata);

  void onChargeCardError(String errorTxt);
}

class ChargeCardPresenter {
  ChargeCardContract _view;
  RestDatasource api = new RestDatasource();

  ChargeCardPresenter(this._view);

  doChargeCard(BuildContext getContext,currency, req_id,login_token,stripeToken,needSaveCard) async {
    try {
      await api
          .chargeCard(getContext, currency, req_id,login_token,stripeToken,needSaveCard)
          .then((ChargeCardPojo pojodata) {
        _view.onChargeCardSuccess(pojodata);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onChargeCardError(error.toString());
    }
  }
}
