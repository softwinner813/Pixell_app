import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/dele_image_pojo.dart';
import 'package:pixell_app/models/delete_user_pojo.dart';
import 'package:pixell_app/models/post_image_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class DeleteUserContract {
  void onDeleteUserSuccess(DeleteUserPojo pojoData);

  void onDeleteUserError(String errorTxt);
}

class DeleteUserPresenter {
  DeleteUserContract _view;
  RestDatasource api = new RestDatasource();

  DeleteUserPresenter(this._view);

  doDeleteUser(BuildContext getContext, String userID,String login_token) async {
    try {
      await api
          .deletePixellAccount(getContext, userID,login_token)
          .then((DeleteUserPojo pojoData) {
        _view.onDeleteUserSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onDeleteUserError(error.toString());
    }
  }
}
