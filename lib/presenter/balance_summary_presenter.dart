import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/balance_summary_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class BalanceSummaryContract {
  void onBalanceSummarySuccess(BalanceSummaryPojo pojoData);

  void onBalanceSummaryError(String errorTxt);
}

class BalanceSummaryPresenter {
  BalanceSummaryContract _view;
  RestDatasource api = new RestDatasource();

  BalanceSummaryPresenter(this._view);

  doBalanceSummary(BuildContext getContext, login_token) async {
    try {
      await api
          .getBalanceSummary(getContext, login_token)
          .then((BalanceSummaryPojo pojoData) {
        _view.onBalanceSummarySuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onBalanceSummaryError(error.toString());
    }
  }

}
