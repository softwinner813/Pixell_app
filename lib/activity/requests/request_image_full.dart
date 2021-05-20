import 'package:flutter/material.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/requests_pojo.dart';
import 'package:pixell_app/models/update_request_pojo.dart';
import 'package:pixell_app/presenter/update_reques_presenter.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

import 'request_details.dart';

class RequestedImageFull extends StatefulWidget {
  RequestedImageFull({
    Key key,
    this.requestDetailsPojo,
  }) : super(key: key);

  Result requestDetailsPojo;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RequestedImageFullStateful();
  }
}

class _RequestedImageFullStateful extends State<RequestedImageFull>
    implements UpdateRequestContract {
  bool isLogin = false;
  List<dynamic> requestsId = [];

  UpdateRequestPresenter _updateRequestPresenter;

  @override
  void initState() {
    checkIsLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget topbar = Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            icon: Image.asset(
              'graphics/close.png',
              height: MyConstants.toolbar_icon_height_width,
              width: MyConstants.toolbar_icon_height_width,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context, true);
            }),
      ),
      height: MyConstants.topbar_height,
      width: MediaQuery.of(context).size.width,
    );

    Widget body = Container(
      child: Stack(
        children: <Widget>[
          FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            placeholder: "graphics/user_default_rectangle.png",
            image: widget.requestDetailsPojo.asset_link != null
                ? widget.requestDetailsPojo.asset_link
                : "",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          topbar,
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Visibility(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left:MyConstants.vertical_control_space,
                        right:MyConstants.vertical_control_space,
                        bottom:MyConstants.vertical_control_space),
                    color: Colors.black.withOpacity(.5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: MyConstants.btn_height,
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              onPressed: () {
                                _updateRequest("", MyConstants.STATUS_CLOSED, "");
                              },
                              color: MyUtils().getColorFromHex(MyConstants.color_green_019807),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("label_accept"),
                                style: TextStyle(
                                  fontSize: MyConstants.btn_round_text_size,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: MyConstants.btn_height,
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              onPressed: () {
                                _updateRequest("", MyConstants.STATUS_REVIEW_PENDING, "");
                              },
                              color: MyUtils()
                                  .getColorFromHex(MyConstants.color_first_btn),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("label_review_request"),
                                style: TextStyle(
                                  fontSize: MyConstants.btn_round_text_size,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  visible: widget.requestDetailsPojo.status !=
                      MyConstants.STATUS_CLOSED,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      MyConstants.vertical_control_space,
                      MyConstants.vertical_control_space,
                      MyConstants.vertical_control_space,
                      MyConstants.vertical_control_space),
                  color: Colors.black.withOpacity(.5),
                  child: Text(
                    widget.requestDetailsPojo.userFrom.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg),
        body: body);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkIsLogin() {
    if (this.mounted) {
      MySharePreference()
          .getBoolInPref(MyConstants.PREF_KEY_ISLOGIN)
          .then((valueIsLogedIn) {
        setState(() {
          isLogin = valueIsLogedIn;
        });
      });
    }
  }

  @override
  void onUpdateRequestError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onUpdateRequestSuccess(UpdateRequestPojo pojodata) {
    if (pojodata != null) {
      if (pojodata.detail != null) {
        MyUtils().toastdisplay(pojodata.detail.toString());
      } else {
        if (pojodata.status==MyConstants.STATUS_CLOSED) {
          widget.requestDetailsPojo.status = MyConstants.STATUS_CLOSED;
          Navigator.pop(context, true);
        } else {
          MyUtils().customAlertDialogBox(
              context,
              'graphics/img-mailbox.png',
              AppLocalizations.of(context)
                  .translate("label_review_request"),
              AppLocalizations.of(context)
                  .translate("label_request_sent_msg"),
              "",
              AppLocalizations.of(context).translate("label_go_requestlist"));
        }
      }
    }
  }

  void _updateRequest(
      String updateAmount, String updateStatus, String asset_link) {
    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        MySharePreference()
            .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
            .then((valueToken) {
          if (!valueToken.isEmpty) {
            _updateRequestPresenter = new UpdateRequestPresenter(this);
            _updateRequestPresenter.doUpdateRequest(
                context,
                updateStatus,
                updateAmount,
                asset_link,
                widget.requestDetailsPojo.id,
                valueToken);
          }
        });
      } else {
        MyUtils().toastdisplay(
            AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });
  }
}
