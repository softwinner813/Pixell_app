import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/age_confirm_pojo.dart';
import 'package:pixell_app/models/user_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class AgeConfirmContract {
  void onAgeConfirmSuccess(AgeConfirmPojo pojodata);

  void onAgeConfirmError(String errorTxt);
}

class AgeConfirmPresenter {
  AgeConfirmContract _view;
  RestDatasource api = new RestDatasource();

  AgeConfirmPresenter(this._view);

  doAgeConfirm(BuildContext getContext, String imageForVefiyAge,String login_token) async {
    try {
      await api.ageConfirm(getContext, imageForVefiyAge,login_token).then((AgeConfirmPojo pojodata) {
        _view.onAgeConfirmSuccess(pojodata);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onAgeConfirmError(error.toString());
    }
  }
}
