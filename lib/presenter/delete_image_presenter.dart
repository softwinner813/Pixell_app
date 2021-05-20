import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/dele_image_pojo.dart';
import 'package:pixell_app/models/post_image_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class DeleteImageContract {
  void onDeleteImageSuccess(DeleteImagePojo pojoData);

  void onDeleteImageError(String errorTxt);
}

class DeleteImagePresenter {
  DeleteImageContract _view;
  RestDatasource api = new RestDatasource();

  DeleteImagePresenter(this._view);

  doDeleteImage(BuildContext getContext, String fileName,String login_token) async {
    try {
      await api
          .deleteImage(getContext, fileName,login_token)
          .then((DeleteImagePojo pojoData) {
        _view.onDeleteImageSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onDeleteImageError(error.toString());
    }
  }
}
