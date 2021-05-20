import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/get_user_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class GetSellersContract {
  void onSuccess(GetSellersPojo pojoData,String filter_type);

  void onError(String errorTxt);
}

class GetSellersPresenter {
  GetSellersContract _view;
  RestDatasource api = new RestDatasource();

  GetSellersPresenter(this._view);

  doGetSellers(BuildContext getContext,String filter_type) async {
    try {
      await api.getSellers(getContext,filter_type).then((GetSellersPojo pojoData) {
        _view.onSuccess(pojoData,filter_type);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onError(error.toString());
    }
  }

  doGetSellersFiltered(BuildContext getContext,String filterUrl) async {
    try {
      await api.getSellersFiltered(getContext,filterUrl).then((GetSellersPojo pojoData) {
        _view.onSuccess(pojoData,filterUrl);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onError(error.toString());
    }
  }

  doGetSellersNextLoad(BuildContext getContext,String filter_type,String nextLoadUrl) async {
    try {
      await api.getSellersNextLoad(getContext,filter_type,nextLoadUrl).then((GetSellersPojo pojoData) {
        _view.onSuccess(pojoData,filter_type);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onError(error.toString());
    }
  }
}
