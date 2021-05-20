import 'package:flutter/cupertino.dart';
import 'package:pixell_app/activity/requests/request_builder.dart';
import 'package:pixell_app/models/get_request_tree_pojo.dart';
import 'package:pixell_app/models/get_values_pojo.dart';
import 'package:pixell_app/models/user_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class RequestTreeContract {
  void onRequestTreeSuccess(RequestTreePojo pojoData);
  void onRequestTreeError(String errorTxt);
}

class RequestTreePresenter {
  RequestTreeContract _view;
  RestDatasource api = new RestDatasource();
  RequestTreePresenter(this._view);

  doRequestTree(BuildContext getContext,userId) async{
    try {
      await api.getRequestTree(getContext,userId).then((RequestTreePojo pojoData) {
        _view.onRequestTreeSuccess(pojoData);
      });
    } catch(error){
      print('Error occured: $error');
      _view.onRequestTreeError(error.toString());
    }
  }
}