import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/get_rates_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class GetRatesContract {
  void onGetRatesSuccess(GetRatesPojo pojodata);

  void onGetRatesError(String errorTxt);
}

class GetRatesPresenter {
  GetRatesContract _view;
  RestDatasource api = new RestDatasource();

  GetRatesPresenter(this._view);

  doGetRates(BuildContext getContext, currency_code,login_token) async {
    try {
      await api
          .getRates(getContext, currency_code,login_token)
          .then((GetRatesPojo pojodata) {
        _view.onGetRatesSuccess(pojodata);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onGetRatesError(error.toString());
    }
  }
}
