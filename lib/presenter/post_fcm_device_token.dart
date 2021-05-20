import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/post_fcm_device_token_pojo.dart';
import 'package:pixell_app/models/post_image_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class PostFCMTokenContract {
  void onPostFCMTokenSuccess(PostFcmToken pojoData);

  void onPostFCMTokenError(String errorTxt);
}

class PostFCMTokenPresenter {
  PostFCMTokenContract _view;
  RestDatasource api = new RestDatasource();

  PostFCMTokenPresenter(this._view);

  doPostFCMToken(BuildContext getContext,registration_id,type,user_id,device_id,name) async {
    try {
      await api
          .postFCMToken(getContext,registration_id,type,user_id,device_id,name)
          .then((PostFcmToken pojoData) {
        _view.onPostFCMTokenSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onPostFCMTokenError(error.toString());
    }
  }
}
