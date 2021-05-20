import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/get_hints_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class GetHintsContract {
  void onGetHintsSuccess(GetHintsPojo pojoData);
  void onGetHintsError(String errorTxt);
}

class GetHintsPresenter {
  GetHintsContract _view;
  RestDatasource api = new RestDatasource();
  GetHintsPresenter(this._view);

  doGetHints(BuildContext getContext) async{
    try {
      await api.getHints(getContext).then((GetHintsPojo pojoData) {
        _view.onGetHintsSuccess(pojoData);
      });
    } catch(error){
      print('Error occured: $error');
      _view.onGetHintsError(error.toString());
    }
  }
}