import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';

class MySignUpPassword extends StatefulWidget {
  MySignUpPassword({Key key, this.username, this.email, this.date_of_birth})
      : super(key: key);

  final String username;
  final String email;
  final String date_of_birth;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MySignUpPasswordStateful();
  }
}

class _MySignUpPasswordStateful extends State<MySignUpPassword> {
  final textPasswordController = TextEditingController();
  final textConfirmPasswordController = TextEditingController();

  bool allFieldValidate = false;
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
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
            AppLocalizations.of(context).translate("label_signup"),
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
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'graphics/step1.png',
                        height: MyConstants.round_step_height_width,
                        width: MyConstants.round_step_height_width,
                      ),
                      SizedBox(width: MyConstants.round_step_space),
                      Image.asset(
                        'graphics/step2_select.png',
                        height: MyConstants.round_step_height_width,
                        width: MyConstants.round_step_height_width,
                      ),
                      SizedBox(width: MyConstants.round_step_space),
                      Image.asset(
                        'graphics/step3.png',
                        height: MyConstants.round_step_height_width,
                        width: MyConstants.round_step_height_width,
                      )
                    ],
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0,
                      MyConstants.vertical_control_space,
                      0.0,
                      MyConstants.space_30),
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
                    _signupClickValidation();
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
          _signupClickValidation();
        },
        child: new Container(
          child: Center(
            child: Text(
              AppLocalizations.of(context).translate('label_next'),
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

  void _signupClickValidation() {
    //Password & Confirm password same
    if (textPasswordController.text != textConfirmPasswordController.text) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('msg_same_password_confirm'));
      return;
    }

    if (allFieldValidate) {
      /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TermsCondition( username: widget.username,email: widget.email,
                  date_of_birth: widget.date_of_birth,password: textPasswordController.text,)),
      );*/
    }
  }

  void allFocusListener() {
    textPasswordController.addListener(() {
      checkAllFieldValidate();
    });

    textConfirmPasswordController.addListener(() {
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
}
