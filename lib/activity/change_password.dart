import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixell_app/activity/login.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/change_password_pojo.dart';
import 'package:pixell_app/presenter/change_password_presenter.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ChangePasswordStateful();
  }
}

class _ChangePasswordStateful extends State<ChangePassword>
    implements ChangePasswordContract {
  ChangePasswordPresenter _changePasswordPresenter;

  final textPasswordController = TextEditingController();
  final textConfirmPasswordController = TextEditingController();

  bool allFieldValidate = false;
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    _changePasswordPresenter = new ChangePasswordPresenter(this);
    isPasswordVisible = false;
    isConfirmPasswordVisible = false;
    allFocusListener();

    super.initState();
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
            AppLocalizations.of(context)
                .translate("label_title_change_password"),
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
                  obscureText: !isPasswordVisible,
                  controller: textPasswordController,
                  textInputAction: TextInputAction.next,
                  focusNode: _passwordFocus,
                  autofocus: false,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(
                        context, _passwordFocus, _confirmPasswordFocus);
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
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                ),
                TextFormField(
                  obscureText: !isConfirmPasswordVisible,
                  autofocus: false,
                  controller: textConfirmPasswordController,
                  textInputAction: TextInputAction.done,
                  focusNode: _confirmPasswordFocus,
                  onFieldSubmitted: (term) {
                    _clickValidation();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: MyUtils().validatePassword(
                        context,
                        textConfirmPasswordController.text,
                        AppLocalizations.of(context)
                            .translate('msg_reenter_password')),
                    labelText: AppLocalizations.of(context)
                        .translate('hint_confirm_password'),
                    labelStyle: TextStyle(
                        color: _confirmPasswordFocus.hasFocus
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
                      icon: Icon(isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
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
              onTap: () {},
              child: new Text(
                AppLocalizations.of(context).translate('label_go_to_home'),
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
                  AppLocalizations.of(context)
                      .translate('label_change_password'),
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
    //Password & Confirm password same
    if (textPasswordController.text != textConfirmPasswordController.text) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('msg_same_password_confirm'));
      return;
    }

    if (allFieldValidate) {
      MyUtils().check().then((intenet) {
        if (intenet != null && intenet) {
          MySharePreference()
              .getIntegerInPref(MyConstants.PREF_KEY_USERID)
              .then((value) {
            if (value != -1) {

              MySharePreference()
                  .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
                  .then((valueToken) {
                if (!valueToken.isEmpty) {
                  _changePasswordPresenter.doChangePassword(
                      context, value, textPasswordController.text,valueToken);
                }
              });
            }
          });
        } else {
          MyUtils().toastdisplay(
              AppLocalizations.of(context).translate('msg_no_internet'));
        }
      });
    }
  }

  void allFocusListener() {
    textConfirmPasswordController.addListener(() {
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
          MyUtils().validatePassword(
                  context, textConfirmPasswordController.text, "") ==
              null) {
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
    textConfirmPasswordController.dispose();
    super.dispose();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void onError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onSuccess(ChangePasswordPojo user) {
    if (user.token != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MyLogin(
                  fromScreen: "change_password",
                )),
        (Route<dynamic> route) => false,
      );
    } else {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('msg_error_server'));
    }
  }
}
