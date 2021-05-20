import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/age_confirm_pojo.dart';
import 'package:pixell_app/models/post_request_pojo.dart';
import 'package:pixell_app/models/user_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class PostRequestContract {
  void onPostRequestSuccess(PostRequestPojo pojodata);

  void onPostRequestError(String errorTxt);
}

class PostRequestPresenter {
  PostRequestContract _view;
  RestDatasource api = new RestDatasource();

  PostRequestPresenter(this._view);

  doPostRequest(BuildContext getContext, String user_to_id,String login_token,List<dynamic> requestsId) async {
    try {
      await api.postRequest(getContext, user_to_id,login_token,requestsId).then((PostRequestPojo pojodata) {
        _view.onPostRequestSuccess(pojodata);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onPostRequestError(error.toString());
    }
  }
}
