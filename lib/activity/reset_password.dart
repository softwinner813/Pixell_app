import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/reset_password_pojo.dart';
import 'package:pixell_app/presenter/reset_password_presenter.dart';
import 'package:pixell_app/presenter/reset_password_presenter.dart';
import 'package:pixell_app/presenter/reset_password_presenter.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';

import 'login.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ResetPasswordStateful();
  }
}

class _ResetPasswordStateful extends State<ResetPassword>
    implements ResetPasswordContract {
  ResetPasswordPresenter _resetPasswordPresenter;
  final textEmailController = TextEditingController();

  bool allFieldValidate = false;
  final FocusNode _emailFocus = FocusNode();

  @override
  void initState() {
    _resetPasswordPresenter = new ResetPasswordPresenter(this);
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
                .translate("label_title_reset_password"),
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
                  textInputAction: TextInputAction.done,
                  focusNode: _emailFocus,
                  onFieldSubmitted: (term) {
                    _clickValidation();
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
        child: new Container(
          child: Center(
            child: Text(
              AppLocalizations.of(context)
                  .translate('label_send_reset_password'),
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
    if (allFieldValidate) {
      MyUtils().check().then((intenet) {
        if (intenet != null && intenet) {
          _resetPasswordPresenter.doResetPassword(
              context, textEmailController.text);
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
  }

  void checkAllFieldValidate() {
    setState(() {
      if (MyUtils().validateEmail(context, textEmailController.text) == null) {
        allFieldValidate = true;
      } else {
        allFieldValidate = false;
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    textEmailController.dispose();
    super.dispose();
  }

  @override
  void onResetError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onResetSuccess(ResetPojo pojoData) {
    if(pojoData!=null && pojoData.status!=null && pojoData.status=="OK"){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MyLogin(
              fromScreen: "reset",
            )),
            (Route<dynamic> route) => false,
      );
    }
  }
}
