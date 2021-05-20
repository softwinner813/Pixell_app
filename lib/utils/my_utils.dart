import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pixell_app/activity/edit_profile.dart';
import 'package:pixell_app/activity/requests/request_list.dart';
import 'package:pixell_app/fragments/users_tab_layout.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/get_hints_pojo.dart';

import 'my_constants.dart';

class MyUtils {
  void toastdisplay(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  String validateFieldOnly(BuildContext getContext, String value, String msg) {
    if (value.isEmpty) {
      return msg;
    }
    return null;
  }

  String validatePassword(BuildContext getContext, String value, String msg) {
    if (value.isEmpty || value.length < 8) {
      return msg;
    }
    return null;
  }

  String validateEmail(BuildContext getContext, String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (value.isEmpty) {
      return AppLocalizations.of(getContext).translate('msg_enter_email');
    } else {
      if (!regex.hasMatch(value)) {
        return AppLocalizations.of(getContext).translate('msg_valid_email');
      } else {
        return null;
      }
    }
  }

  bool validateMobile(BuildContext getContext, String value) {
    // Indian Mobile number are of 10 digit only
    if (value.isEmpty) {
      toastdisplay(
          AppLocalizations.of(getContext).translate('msg_enter_phone'));
      return false;
    }
    if (value.length != 10) {
      toastdisplay(
          AppLocalizations.of(getContext).translate('msg_mobile_10_digit'));
      return false;
    }

    return true;
  }

  //Convert HExt to color
  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  getCurrencyNameFromCountryCode(String isoCountryCode) {
    //Get currentcy name from ios country code
    if (isoCountryCode == "JP" || isoCountryCode == "JPN") {
      //Japan
      return "JPY";
    } else if (isoCountryCode == "IN" || isoCountryCode == "IND") {
      //India
      return "INR";
    } else if (isoCountryCode == "US" || isoCountryCode == "USA") {
      //USA
      return "USD";
    } else if (isoCountryCode == "MX" || isoCountryCode == "MEX") {
      //Mexico
      return "MXN";
    } else if (isoCountryCode == "ES" || isoCountryCode == "ESP") {
      // Spain
      return "EUR";
    } else if (isoCountryCode == "DK" || isoCountryCode == "DNK") {
      //Denmark
      return "DKK";
    } else if (isoCountryCode == "DE" || isoCountryCode == "DEU") {
      // Germany
      return "EUR";
    } else if (isoCountryCode == "AU" || isoCountryCode == "AUS") {
      // Australia
      return "AUD";
    } else if (isoCountryCode == "CA" || isoCountryCode == "CAN") {
      // Canada
      return "CAD";
    } else if (isoCountryCode == "CN" || isoCountryCode == "CHN") {
      // China
      return "CNY";
    } else if (isoCountryCode == "NL" || isoCountryCode == "NLD") {
      // Netherlands
      return "EUR";
    } else {
      return "USD";
    }
  }

  Future<void> customAlertHintDialogBox(
      BuildContext mContext,
      String imagePath,
      GetHintsPojo pojo,
      String hintId,
  ) {
    Map<String, String> hint = pojo.hints.getHint(hintId);
    customAlertDialogBox(mContext, imagePath, hint["header"], hint["body"], "",  AppLocalizations.of(mContext)
        .translate("label_close"));
  }

  Future<void> customAlertDialogBox(
    BuildContext mContext,
    String imagePath,
    String topMsg,
    String bottomMsg,
    String buttonNameLeft,
    String buttonNameRight,
  ) {
    return alertDialogBox(mContext, imagePath, topMsg, bottomMsg, <Widget>[
      Visibility(
        child: FlatButton(
            child: Text(
              buttonNameLeft.toUpperCase(),
              style: MyConstants.textStyle_dialog_btn,
            ),
            onPressed: () {
              Navigator.of(mContext).pop();
              if (buttonNameLeft ==
                  AppLocalizations.of(mContext)
                      .translate("label_edit_profile")) {
                Navigator.push(
                  mContext,
                  MaterialPageRoute(
                      builder: (context) => EditProfile()),
                );
              }
            }),
        visible: buttonNameLeft.isNotEmpty,
      ),
      FlatButton(
          child: Text(
            buttonNameRight.toUpperCase(),
            style: MyConstants.textStyle_dialog_btn,
          ),
          onPressed: () {
            if (buttonNameRight ==
                AppLocalizations.of(mContext)
                    .translate("label_go_home")) {
              MyConstants.currentSelectedBottomTab = 0;
              Navigator.pushAndRemoveUntil(
                mContext,
                MaterialPageRoute(
                    builder: (context) => UsersTabLayout()),
                    (Route<dynamic> route) => false,
              );
            } else if (buttonNameRight ==
                AppLocalizations.of(mContext)
                    .translate("label_go_requestlist")) {
              MyConstants.currentSelectedBottomTab = 1;
              Navigator.pushAndRemoveUntil(
                mContext,
                MaterialPageRoute(
                    builder: (context) => RequestsList()),
                    (Route<dynamic> route) => false,
              );
            } else {
              Navigator.of(mContext).pop();
            }
          })
    ]);
  }

  Future<void> alertDialogBox(
      BuildContext mContext,
      String imagePath,
      String topMsg,
      String bottomMsg,
      List<Widget> buttons,
      ) {
    return showDialog(
        context: mContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {},
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0.0),
                content: new Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250.0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 150.0,
                          padding: EdgeInsets.all(15.0),
                          child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  new Image.asset(
                                    imagePath,
                                    alignment: Alignment.center,
                                    height: MyConstants.dialog_top_image_h_w,
                                    width: MyConstants.dialog_top_image_h_w,
                                  ),
                                  Text(
                                    topMsg,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )),
                          decoration: BoxDecoration(
                            color: MyUtils()
                                .getColorFromHex(MyConstants.color_alert_top),
                          ),
                        ),
                        Container(
                          height: 100.0,
                          padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                          child: Center(
                            child: AutoSizeText(
                              bottomMsg,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        )
                      ]),
                ),
                actions: buttons,
              ));
        });
  }

  Future<void> customAlertDialogBoxNew(
      BuildContext mContext,
      String imagePath,
      String topMsg,
      String bottomMsg,
      String buttonNameLeft,
      String buttonNameRight,
      ) {
    return showDialog(
      barrierDismissible: false,
      context: mContext,
      builder: (BuildContext context) => Material(
          type: MaterialType.transparency,
          child: WillPopScope(
            onWillPop: () {},
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width / 2,
                  bottom: MediaQuery.of(context).size.width / 2,
                  left: MyConstants.layout_margin,
                  right: MyConstants.layout_margin),
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  new Image.asset(
                                    imagePath,
                                    alignment: Alignment.center,
                                    height: MyConstants.dialog_top_image_h_w,
                                    width: MyConstants.dialog_top_image_h_w,
                                  ),
                                  Text(
                                    topMsg,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )),
                          decoration: BoxDecoration(
                              color: MyUtils()
                                  .getColorFromHex(MyConstants.color_alert_top),
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(3.0),
                                  topRight: const Radius.circular(3.0))
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: AutoSizeText(
                                    bottomMsg,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Visibility(
                                        child: InkWell(
                                          child: Text(
                                            buttonNameLeft.toUpperCase(),
                                            style: MyConstants.textStyle_dialog_btn,
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            if (buttonNameLeft ==
                                                AppLocalizations.of(context)
                                                    .translate(
                                                    "label_edit_profile")) {
                                              Navigator.push(
                                                mContext,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfile()),
                                              );
                                            }
                                          },
                                        ),
                                        visible: !buttonNameLeft.isEmpty,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                      ),
                                      InkWell(
                                        child: Text(
                                          buttonNameRight.toUpperCase(),
                                          style: MyConstants.textStyle_dialog_btn,
                                        ),
                                        onTap: () {
                                          if (buttonNameRight ==
                                              AppLocalizations.of(context)
                                                  .translate("label_go_home")) {
                                            MyConstants.currentSelectedBottomTab = 0;
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UsersTabLayout()),
                                                  (Route<dynamic> route) => false,
                                            );
                                          } else if (buttonNameRight ==
                                              AppLocalizations.of(context).translate(
                                                  "label_go_requestlist")) {
                                            MyConstants.currentSelectedBottomTab = 1;
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RequestsList()),
                                                  (Route<dynamic> route) => false,
                                            );
                                          } else {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    bottomLeft: const Radius.circular(3.0),
                                    bottomRight: const Radius.circular(3.0))
                            ),
                          )),
                    ]),
              ),
            ),
          )),
    );
  }

  ///Get device if for FCM
  Future<String> getDeviceId(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = await DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;; // unique ID on Android
    }
  }
}
