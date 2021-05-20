import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/get_values_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class GetValuesContract {
  void onGetValuesSuccess(GetValuesPojo pojoData);
  void onGetValuesError(String errorTxt);
}

class GetValuesPresenter {
  GetValuesContract _view;
  RestDatasource api = new RestDatasource();
  GetValuesPresenter(this._view);

  doGetValues(BuildContext getContext) async{
    try {
      await api.getValues(getContext).then((GetValuesPojo pojoData) {
        _view.onGetValuesSuccess(pojoData);
      });
    } catch(error){
      print('Error occured: $error');
      _view.onGetValuesError(error.toString());
    }
  }
}