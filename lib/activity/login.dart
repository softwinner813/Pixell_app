import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixell_app/activity/reset_password.dart';
import 'package:pixell_app/activity/walkthrough/login_walkthrough.dart';
import 'package:pixell_app/activity/walkthrough/seller_walkthrough.dart';
import 'package:pixell_app/fragments/users_tab_layout.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/get_user_derails.dart';
import 'package:pixell_app/models/post_fcm_device_token_pojo.dart';
import 'package:pixell_app/models/user_pojo.dart';
import 'package:pixell_app/presenter/get_userdetails_presenter.dart';
import 'package:pixell_app/presenter/login_presenter.dart';
import 'package:pixell_app/presenter/post_fcm_device_token.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart' as mypreference;
import 'package:pixell_app/utils/share_preference.dart';

class MyLogin extends StatefulWidget {
  MyLogin({Key key, this.fromScreen}) : super(key: key);

  final String fromScreen;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyLoginStateful();
  }
}

class _MyLoginStateful extends State<MyLogin>
    implements LoginContract, GetUserDetailsContract, PostFCMTokenContract {
  LoginPresenter _loginPresenter;
  GetUserDetailsPresenter _userDetailsPresenter;

  final textPasswordController = TextEditingController();
  final textEmailController = TextEditingController();

  bool allFieldValidate = false;
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  bool isPasswordVisible = false;
  var devideId = "";

  @override
  void initState() {

    _loginPresenter = new LoginPresenter(this);
    _userDetailsPresenter = new GetUserDetailsPresenter(this);
    isPasswordVisible = false;
    allFocusListener();
    super.initState();
    _openDialog();
  }

  @override
  Widget build(BuildContext context) {
    Widget topbar = new Container(
      child: Center(
          child: Row(
        children: <Widget>[
          new IconButton(
              icon: new Image.asset(
                'graphics/arrow-left.png',
                height: MyConstants.toolbar_icon_height_width,
                width: MyConstants.toolbar_icon_height_width,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              }),
          Text(
            AppLocalizations.of(context).translate("label_log_in"),
            style: TextStyle(
                fontSize: MyConstants.toolbar_text_size, color: Colors.white),
          ),
        ],
      )),
      height: MyConstants.topbar_height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('graphics/surface_top_signup.png'),
          fit: BoxFit.fill,
        ),
      ),
    );

    Widget middleSection = new Expanded(
      child: new Container(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
                left: MyConstants.layout_margin,
                right: MyConstants.layout_margin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0,
                      MyConstants.vertical_control_space,
                      0.0,
                      MyConstants.vertical_control_space),
                ),
                TextFormField(
                  autofocus: false,
                  controller: textEmailController,
                  textInputAction: TextInputAction.next,
                  focusNode: _emailFocus,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _emailFocus, _passwordFocus);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: MyUtils()
                        .validateEmail(context, textEmailController.text),
                    labelText:
                        AppLocalizations.of(context).translate('hint_email'),
                    labelStyle: TextStyle(
                        color: _emailFocus.hasFocus
                            ? MyUtils().getColorFromHex(MyConstants.color_theme)
                            : Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyUtils()
                              .getColorFromHex(MyConstants.color_theme),
                          width: 2.0),
                      borderRadius:
                          BorderRadius.circular(MyConstants.input_box_radius),
                    ),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                ),
                TextFormField(
                  obscureText: !isPasswordVisible,
                  controller: textPasswordController,
                  textInputAction: TextInputAction.done,
                  focusNode: _passwordFocus,
                  autofocus: false,
                  onFieldSubmitted: (term) {
                    _clickValidation();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: MyUtils().validatePassword(
                        context,
                        textPasswordController.text,
                        AppLocalizations.of(context)
                            .translate('msg_enter_password')),
                    labelText:
                        AppLocalizations.of(context).translate('hint_password'),
                    labelStyle: TextStyle(
                        color: _passwordFocus.hasFocus
                            ? MyUtils().getColorFromHex(MyConstants.color_theme)
                            : Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyUtils()
                              .getColorFromHex(MyConstants.color_theme),
                          width: 2.0),
                      borderRadius:
                          BorderRadius.circular(MyConstants.input_box_radius),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Widget bottomBanner = new GestureDetector(
        onTap: () {
          _clickValidation();
        },
        child: Column(
          children: <Widget>[
            new Container(
              margin:
                  new EdgeInsets.fromLTRB(0.0, MyConstants.space_50, 0.0, 0.0),
            ),
            new GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPassword(),
                    ));
              },
              child: new Text(
                AppLocalizations.of(context).translate('label_forgot_password'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                ),
              ),
            ),
            new Container(
              margin:
                  new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, MyConstants.space_50),
            ),
            new Container(
              child: Center(
                child: Text(
                  AppLocalizations.of(context).translate('label_log_in'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MyConstants.btn_text_size,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              height: MyConstants.bottombar_height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: allFieldValidate
                      ? new AssetImage('graphics/surface_bottom_selected.png')
                      : new AssetImage('graphics/surface_bottom_signup.png'),
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ));

    Widget body = new Column(
      // This makes each child fill the full width of the screen
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        topbar,
        middleSection,
        bottomBanner,
      ],
    );

    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg),
      body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: body,
      ),
    );
  }

  void _clickValidation() {
    if (allFieldValidate) {
      MyUtils().check().then((intenet) {
        if (intenet != null && intenet) {

          MyUtils().getDeviceId(context).then((id) {
            devideId = id;
            print("deviceiddddd-----" + devideId);
          });

          _loginPresenter.doLogin(
              context, textEmailController.text, textPasswordController.text);
        } else {
          MyUtils().toastdisplay(
              AppLocalizations.of(context).translate('msg_no_internet'));
        }
      });
    }
  }

  void allFocusListener() {
    textEmailController.addListener(() {
      checkAllFieldValidate();
    });

    textPasswordController.addListener(() {
      checkAllFieldValidate();
    });
  }

  void checkAllFieldValidate() {
    setState(() {
      if (MyUtils()
                  .validatePassword(context, textPasswordController.text, "") ==
              null &&
          MyUtils().validateEmail(context, textEmailController.text) == null) {
        allFieldValidate = true;
      } else {
        allFieldValidate = false;
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    textPasswordController.dispose();
    textEmailController.dispose();
    super.dispose();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void onLoginError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onLoginSuccess(UserPojo user) {
    if (user.logged != null) {
      MyUtils().toastdisplay(
        AppLocalizations.of(context).translate("msg_error_login"),
      );
    } else if (user.error != null) {
      MyUtils().toastdisplay(user.error);
    } else {
      mypreference.MySharePreference()
          .saveBoolInPref(MyConstants.PREF_KEY_ISLOGIN, true);

      mypreference.MySharePreference()
          .saveIntegerInPref(MyConstants.PREF_KEY_USERID, user.id);

      mypreference.MySharePreference()
          .saveStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN, user.token);

      mypreference.MySharePreference()
          .saveBoolInPref(MyConstants.PREF_AS_GUEST, false);

      MyConstants.currentSelectedBottomTab = 0;

      if (Platform.isIOS) {
        _callApiForPostFCMToken("ios",user.id);
      } else {
        _callApiForPostFCMToken("android",user.id);
      }

      _userDetailsPresenter.doGetUserDetails(context, user.id);
    }
  }


  @override
  void onDetailsSuccess(GetUserDetailsPojo pojoData) {
    if (pojoData.loginTimes <= 1) {
      Widget destination = LoginWalkthrough();
      if (pojoData.profile.isSeller) {
        destination = SellerWalkthrough();
      }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => destination));
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UsersTabLayout()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void onDetailsError(String errorTxt) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UsersTabLayout()),
          (Route<dynamic> route) => false,
    );
  }

  void _callApiForPostFCMToken(type,user_id) {
    MySharePreference().getStringInPref(MyConstants.PREF_FCM_TOKEN).then((valueFCMToken) {
      if (!valueFCMToken.isEmpty) {
        PostFCMTokenPresenter _postFCMTokenPresenter = new PostFCMTokenPresenter(this);
        _postFCMTokenPresenter.doPostFCMToken(context, valueFCMToken, type, user_id, devideId, "test");
      }

    });
  }

  @override
  void onPostFCMTokenError(String errorTxt) {
    // TODO: implement onPostFCMTokenError
  }

  @override
  void onPostFCMTokenSuccess(PostFcmToken pojoData) {
    // TODO: implement onPostFCMTokenSuccess
  }

  void _openDialog() {
    if (widget.fromScreen == "reset") {
      Timer.run(() {
        MyUtils().customAlertDialogBox(
            context,
            'graphics/img-mailbox.png',
            AppLocalizations.of(context).translate("label_reset_top_dialog"),
            AppLocalizations.of(context).translate("msg_reset_bottom_dialog"),
            "",
            AppLocalizations.of(context).translate("label_continue"));
      });
    } else if (widget.fromScreen == "change_password") {
      Timer.run(() {
        MyUtils().customAlertDialogBox(
            context,
            'graphics/img-changed.png',
            AppLocalizations.of(context).translate("label_change_top_dialog"),
            AppLocalizations.of(context).translate("msg_change_bottom_dialog"),
            "",
            AppLocalizations.of(context).translate("label_log_in"));
      });
    }
  }
}
