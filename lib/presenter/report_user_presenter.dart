import 'package:flutter/cupertino.dart';
import 'package:pixell_app/models/report_user_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';

abstract class ReportUserContract {
  void onReportUserSuccess(ReportUserPojo pojoData);
  void onReportUserError(String errorTxt);
}

class ReportUserPresenter {
  ReportUserContract _view;
  RestDatasource api = new RestDatasource();
  ReportUserPresenter(this._view);

  doReport(BuildContext getContext, userId, login_token) async {
    try {
      await api.reportUser(getContext,userId,login_token).then((ReportUserPojo pojoData) {
        _view.onReportUserSuccess(pojoData);
      });
    } catch(error){
      print('Error occured: $error');
      _view.onReportUserError(error.toString());
    }
  }
}