import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:pixell_app/activity/login.dart';
import 'package:pixell_app/activity/signup.dart';
import 'package:pixell_app/fragments/users_tab_layout.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/image_pojo.dart';
import 'package:pixell_app/models/post_fcm_device_token_pojo.dart';
import 'package:pixell_app/models/user_pojo.dart';
import 'package:pixell_app/presenter/login_presenter.dart';
import 'package:pixell_app/presenter/post_fcm_device_token.dart';
import 'package:pixell_app/presenter/post_image_presenter.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart' as mypreference;
import 'package:pixell_app/utils/share_preference.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key, this.fromScreen}) : super(key: key);

  final String fromScreen;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _FirstScreenStateful();
  }
}

class _FirstScreenStateful extends State<FirstScreen>
    implements LoginContract, PostFCMTokenContract {
  LoginPresenter _loginPresenter;
  var devideId = "";

  @override
  void initState() {
    _loginPresenter = new LoginPresenter(this);
    MyUtils().getDeviceId(context).then((id) {
      devideId = id;
      print("deviceiddddd-----" + devideId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg),
      body: Container(
        child: new Container(
            constraints: const BoxConstraints(minWidth: double.infinity),
            margin: const EdgeInsets.only(
                left: MyConstants.layout_margin,
                right: MyConstants.layout_margin),
            child: Column(children: <Widget>[
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        'graphics/top-logo.png',
                        width: 120.0,
                        height: 150.0,
                      ),
                    ]),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: Platform.isIOS,
                      child: SignInWithAppleButton(
                        onPressed: () async {
                          final credential = await SignInWithApple.getAppleIDCredential(
                            scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                          );
                          _loginPresenter.doAppleLogin(context, credential);
                        },
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(0.0, 24, 0.0, 0.0),
                    ),
                    SizedBox(
                      height: MyConstants.btn_height,
                      child: RaisedButton(
                        onPressed: () {
                          MyUtils().check().then((intenet) {
                            if (intenet != null && intenet) {
                              initiateFacebookLogin();
                            } else {
                              MyUtils().toastdisplay(
                                  AppLocalizations.of(context)
                                      .translate('msg_no_internet'));
                            }
                          });
                        },
                        color:
                        MyUtils().getColorFromHex(MyConstants.color_fb_btn),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'graphics/icon-facebook.png',
                              height: 28,
                              width: 28,
                            ),
                            new Container(
                              margin: new EdgeInsets.all(6),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("label_continue_fb"),
                              style: TextStyle(
                                fontSize: MyConstants.btn_round_text_size,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(0.0, 24, 0.0, 0.0),
                    ),
                    SizedBox(
                      height: MyConstants.btn_height,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyLogin(),
                              ));

                          /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(),
                                  ));*/
                        },
                        color: MyUtils()
                            .getColorFromHex(MyConstants.color_first_btn),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("label_logn_with_pixell"),
                          style: TextStyle(
                            fontSize: MyConstants.btn_round_text_size,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(0.0, 24, 0.0, 0.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('label_need_account'),
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MySignUp(
                                              title: AppLocalizations.of(
                                                  context)
                                                  .translate("label_signup"))),
                                );
                                // do what you need to do when "Click here" gets clicked
                              }),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                            child: GestureDetector(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('label_signup_text'),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MySignUp(
                                                title: AppLocalizations.of(
                                                    context)
                                                    .translate(
                                                    "label_signup"))),
                                  );
                                  // do what you need to do when "Click here" gets clicked
                                }),
                          ),
                        ),
                      ],
                    ),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 57.5),
                    ),
                  ],
                ),
              ),
              /*Container(
                height: MyConstants.bottombar_height,
                child: BottomViewAfterLogin(),
              ),*/
            ])),
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage(
              'graphics/full_bg.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onLoginError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onLoginSuccess(UserPojo user) {
    if (user.detail != null) {
      MyUtils().toastdisplay(user.detail);
    } else if (user.token != null) {
      MyConstants.currentSelectedBottomTab = 0;

      mypreference.MySharePreference()
          .saveBoolInPref(MyConstants.PREF_KEY_ISLOGIN, true);

      mypreference.MySharePreference()
          .saveIntegerInPref(MyConstants.PREF_KEY_USERID, user.id);

      mypreference.MySharePreference()
          .saveStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN, user.token);

      mypreference.MySharePreference()
          .saveBoolInPref(MyConstants.PREF_AS_GUEST, false);

      if (Platform.isIOS) {
        _callApiForPostFCMToken("ios", user.id);
      } else {
        _callApiForPostFCMToken("android", user.id);
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UsersTabLayout()),
            (Route<dynamic> route) => false,
      );
    }
  }

  void _callApiForPostFCMToken(type, user_id) {
    MySharePreference().getStringInPref(MyConstants.PREF_FCM_TOKEN).then((
        valueFCMToken) {
      if (!valueFCMToken.isEmpty) {
        PostFCMTokenPresenter _postFCMTokenPresenter = new PostFCMTokenPresenter(
            this);
        _postFCMTokenPresenter.doPostFCMToken(
            context, valueFCMToken, type, user_id, devideId, "test");
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

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginFacebookStatusChanged(null);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginFacebookStatusChanged(null);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        final token = facebookLoginResult.accessToken.token;

        print("FACEBOOK_PROFILE TOken-----" + token);

        onLoginFacebookStatusChanged(token);
        break;
    }
  }

  void onLoginFacebookStatusChanged(final token) {
    if (token != null) {
      MyUtils().check().then((internet) {
        if (internet != null && internet) {
          _loginPresenter.doFacebookLogin(context, token);
        } else {
          MyUtils().toastdisplay(
              AppLocalizations.of(context).translate('msg_no_internet'));
        }
      });
    } else {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('msg_error_server'));
    }
  }
}
