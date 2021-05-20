import 'package:flutter/material.dart';
import 'package:pixell_app/activity/edit_profile.dart';
import 'package:pixell_app/activity/first_screen.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/logout_pojo.dart';
import 'package:pixell_app/presenter/logout_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

class MyProfileFragment extends StatefulWidget {
  MyProfileFragment({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return new _MyProfileFragmentStateFul();
  }
}

class _MyProfileFragmentStateFul extends State<MyProfileFragment>
    implements LogoutContract {
  LogoutPresenter _logoutPresenter;

  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  @override
  void initState() {
    _logoutPresenter = new LogoutPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
          left: MyConstants.layout_margin, right: MyConstants.layout_margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('label_your_profile'),
            textAlign: TextAlign.center,
          ),
          new Container(
            margin:
                new EdgeInsets.fromLTRB(0.0, MyConstants.space_30, 0.0, 0.0),
          ),

          /*SizedBox(
              height: MyConstants.btn_height,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChangePassword()),
                  );
                },
                color: MyUtils().getColorFromHex(MyConstants.color_theme),
                child: Text(
                  AppLocalizations.of(context).translate("label_change_password"),
                  style: TextStyle(
                    fontSize: MyConstants.btn_round_text_size,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            new Container(
              margin: new EdgeInsets.fromLTRB(
                  0.0, MyConstants.space_30, 0.0, 0.0),
            ),*/

          SizedBox(
            height: MyConstants.btn_height,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              onPressed: () {
                _logoutPresenter = new LogoutPresenter(this);
                MyUtils().check().then((intenet) {
                  if (intenet != null && intenet) {
                    MySharePreference()
                        .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
                        .then((value) {
                      if (!value.isEmpty) {
                        _logoutPresenter.doLogout(context, value);
                      }
                    });
                  } else {
                    MyUtils().toastdisplay(AppLocalizations.of(context)
                        .translate('msg_no_internet'));
                  }
                });
              },
              color: MyUtils().getColorFromHex(MyConstants.color_theme),
              child: Text(
                AppLocalizations.of(context).translate("label_logout"),
                style: TextStyle(
                  fontSize: MyConstants.btn_round_text_size,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          new Container(
            margin:
                new EdgeInsets.fromLTRB(0.0, MyConstants.space_30, 0.0, 0.0),
          ),
          SizedBox(
            height: MyConstants.btn_height,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );
              },
              color: MyUtils().getColorFromHex(MyConstants.color_theme),
              child: Text(
                AppLocalizations.of(context).translate("label_edit_profile"),
                style: TextStyle(
                  fontSize: MyConstants.btn_round_text_size,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg),
      body: Stack(
        children: <Widget>[
          body,
          Align(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Container(
                  height: MyConstants.bottombar_height,
                  child: _bottomWidgetAfterLogin.calllBottomTabWidget(context),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onLogoutError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onLogoutSuccess(LogoutPojo pojodata) {
    if (pojodata != null) {
      if (pojodata.logged != null) {
        MySharePreference().clearAllPref();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FirstScreen()),
          (Route<dynamic> route) => false,
        );
      } else if (pojodata.detail != null) {
        MyUtils().toastdisplay(pojodata.detail);
      }
    }
  }
}
