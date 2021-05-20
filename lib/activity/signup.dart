import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pixell_app/fragments/users_tab_layout.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/image_pojo.dart';
import 'package:pixell_app/models/post_image_pojo.dart';
import 'package:pixell_app/models/signup_pojo.dart';
import 'package:pixell_app/presenter/post_image_presenter.dart';
import 'package:pixell_app/presenter/signup_presenter.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart' as mypreference;

import '../dialog/signup_terms_condition.dart';

class MySignUp extends StatefulWidget {
  MySignUp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MySignUpStateful();
  }
}

class _MySignUpStateful extends State<MySignUp> implements SignupContract, PostImageContract {
  SignupPresenter _signupPresenter;

  final textNameController = TextEditingController();
  final textEmailController = TextEditingController();
  final textBirthdayController = TextEditingController();
  final textPasswordController = TextEditingController();
  final textConfirmPasswordController = TextEditingController();

  String passDateOfBirth = "";
  bool allFieldValidate = false;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _birthdayFocus = FocusNode();
  DateTime selectedDateTime;

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool checkedTermsValue = false;
  bool isSwitchedSeller = false;

  List<ImagePojo> _profileImagePojo = [];
  PostImagePresenter _postImagePresenter;
  File _image = null;

  Future<void> _selectDate(BuildContext context) async {
    if (selectedDateTime == null) {
      selectedDateTime = DateTime(DateTime.now().year - 21, 1);
    }

    final DateTime d = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(1800, 1),
      lastDate: DateTime.now(),
    );
    if (d != null)
      setState(() {
        selectedDateTime = d;
        textBirthdayController.text = new DateFormat.yMMMMd("en_US").format(d);
        passDateOfBirth = new DateFormat('yyyy-MM-dd hh:mm:ss').format(d);
      });
  }

  @override
  void initState() {
    _signupPresenter = new SignupPresenter(this);
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
                GestureDetector(
                    onTap: () {
                      _optionsPhotoDialogBox(
                          context,
                          'graphics/upload.png',
                          AppLocalizations.of(context)
                              .translate("msg_top_add_photo_dialog"),
                          AppLocalizations.of(context).translate("label_close"));
                    },
                    child: (_profileImagePojo == null ||
                        _profileImagePojo.length == 0)
                        ? Stack(
                      children: <Widget>[
                        Center(
                          child: Opacity(
                              opacity: 0.2,
                              child: Image.asset(
                                "graphics/user_default.png",
                                height: MyConstants.profile_image_height_width,
                                width: MyConstants.profile_image_height_width,
                              )
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            'graphics/add_btn.png',
                            height:
                            MyConstants.profile_image_height_width,
                            width:
                            MyConstants.profile_image_height_width,
                            color: MyUtils().getColorFromHex(MyConstants.color_theme),
                          ),
                        )
                      ],
                    )
                        : CircleAvatar(
                        child: Container(
                            height: MyConstants.profile_image_height_width,
                            width: MyConstants.profile_image_height_width,
                            decoration: BoxDecoration(
                              color: MyUtils()
                                  .getColorFromHex(MyConstants.color_screeb_bg),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      _profileImagePojo[0].thumbUrl),
                                  fit: BoxFit.cover),
                              border: Border.all(color: Colors.black, width: 1.0),
                              borderRadius:
                              BorderRadius.all(const Radius.circular(50.0)),
                            )),
                        radius:
                        50.0)
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0,
                      MyConstants.vertical_control_space,
                      0.0,
                      MyConstants.vertical_control_space),
                ),
                TextFormField(
                  controller: textNameController,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameFocus,
                  autofocus: false,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _nameFocus, _emailFocus);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: MyUtils().validateFieldOnly(
                      context,
                      textNameController.text,
                      AppLocalizations.of(context)
                          .translate('msg_enter_user_name'),
                    ),
                    labelText:
                        AppLocalizations.of(context).translate('hint_name'),
                    labelStyle: TextStyle(
                        color: _nameFocus.hasFocus
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
                  autofocus: false,
                  controller: textBirthdayController,
                  focusNode: _birthdayFocus,
                  onTap: () {
                    _birthdayFocus.unfocus();
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    errorText: MyUtils().validateFieldOnly(
                        context,
                        textBirthdayController.text,
                        AppLocalizations.of(context)
                            .translate('msg_select_birthdate')),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: AppLocalizations.of(context)
                        .translate('label_birthday'),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                ),
                TextFormField(
                  scrollPadding: EdgeInsets.only(
                      bottom: MyConstants.textformfield_scrollpadding),
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
                  scrollPadding: EdgeInsets.only(
                      bottom: MyConstants.textformfield_scrollpadding),
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
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('label_seller_switch'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: MyConstants.title_below_text_size,
                            color: MyUtils()
                                .getColorFromHex(MyConstants.color_edti_title_text),
                          ),
                        ),
                      ),
                    ),
                    Switch(
                      value: isSwitchedSeller,
                      onChanged: (value) {
                        setState(() {
                          isSwitchedSeller = value;
                        });
                      },
                    ),
                  ],
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.space_30, 0.0, 0.0),
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: checkedTermsValue,
                      onChanged: (newValue) {
                        checkedTermsValue = newValue;
                        checkAllFieldValidate();
                      }, //  <-- leading Checkbox
                    ),
                    Flexible(
                      child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('label_read_terms'),
                                style:  TextStyle(
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_edti_title_text),
                                    fontSize: MyConstants.textsize_terms_conditions),
                              ),
                              TextSpan(
                                text: " ",
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('label_click_terms'),
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_edti_title_text),
                                    fontSize:
                                    MyConstants.textsize_terms_conditions),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    MyUtils().check().then((internet) {
                                      if (internet != null && internet) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => TermsCondition(
                                            title: AppLocalizations.of(context)
                                                .translate('label_click_terms'),
                                            loadUrl: MyConstants.URL_TERMS_CONDITIONS,
                                          ),
                                        );
                                      } else {
                                        MyUtils().toastdisplay(
                                            AppLocalizations.of(context)
                                                .translate('msg_no_internet'));
                                      }
                                    });
                                  },
                              ),
                              TextSpan(
                                text: " ",
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('label_and_the'),
                                style:  TextStyle(
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_edti_title_text),
                                    fontSize: MyConstants.textsize_terms_conditions),
                              ),
                              TextSpan(
                                text: " ",
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('label_data_usage_policy'),
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_edti_title_text),
                                    fontSize:
                                    MyConstants.textsize_terms_conditions),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    MyUtils().check().then((internet) {
                                      if (internet != null && internet) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => TermsCondition(
                                            title: AppLocalizations.of(context)
                                                .translate('label_data_usage_policy'),
                                            loadUrl: MyConstants.URL_DATA_POLICY,
                                          ),
                                        );
                                      } else {
                                        MyUtils().toastdisplay(
                                            AppLocalizations.of(context)
                                                .translate('msg_no_internet'));
                                      }
                                    });
                                  },
                              ),
                            ],
                          ),),
                    ),
                  ],
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.space_50, 0.0, 0.0),
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
    if (textBirthdayController.text.isEmpty) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('msg_select_birthdate'));
      return;
    }

    //Password & Confirm password same
    if (textPasswordController.text != textConfirmPasswordController.text) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('msg_same_password_confirm'));
      return;
    }

    String thumbnail = "";
    String profile_pic = "";
    if (_profileImagePojo.length > 0) {
      thumbnail = _profileImagePojo[0].thumbUrl;
      profile_pic = _profileImagePojo[0].largeUrl;
    }

    if (allFieldValidate) {
      MyUtils().check().then((internet) {
        if (internet != null && internet) {
          _signupPresenter.doSignup(
              context,
              textNameController.text,
              textEmailController.text,
              passDateOfBirth,
              textPasswordController.text,
              isSwitchedSeller,
              profile_pic,
              thumbnail
          );
        } else {
          MyUtils().toastdisplay(
              AppLocalizations.of(context).translate('msg_no_internet'));
        }
      });
    }
  }

  void allFocusListener() {
    textNameController.addListener(() {
      checkAllFieldValidate();
    });

    textEmailController.addListener(() {
      checkAllFieldValidate();
    });

    textBirthdayController.addListener(() {
      checkAllFieldValidate();
    });

    textPasswordController.addListener(() {
      checkAllFieldValidate();
    });

    textConfirmPasswordController.addListener(() {
      checkAllFieldValidate();
    });
  }

  void checkAllFieldValidate() {
    setState(() {
      if (MyUtils().validateFieldOnly(context, textNameController.text, "") ==
              null &&
          MyUtils().validateEmail(context, textEmailController.text) == null &&
          MyUtils().validateFieldOnly(
                  context, textBirthdayController.text, "") ==
              null &&
          MyUtils()
                  .validatePassword(context, textPasswordController.text, "") ==
              null &&
          MyUtils().validatePassword(
                  context, textConfirmPasswordController.text, "") ==
              null &&
          checkedTermsValue) {
        allFieldValidate = true;
      } else {
        allFieldValidate = false;
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    textNameController.dispose();
    textEmailController.dispose();
    textBirthdayController.dispose();
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
  void onSignupError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onSignupSuccess(SignupPojo user) {
    if (user.token == null) {
      MyUtils().toastdisplay(
        AppLocalizations.of(context).translate("msg_error_login"),
      );
    } else {
      mypreference.MySharePreference()
          .saveBoolInPref(MyConstants.PREF_AS_GUEST, true);

      if (user.id != null) {
        mypreference.MySharePreference()
            .saveIntegerInPref(MyConstants.PREF_KEY_USERID, user.id);
      }

      mypreference.MySharePreference().saveStringInPref(
          MyConstants.PREF_KEY_LOGIN_TOKEN, user.token.toString());

      MyConstants.currentSelectedBottomTab = 0;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => UsersTabLayout(
                  fromScreen: MyConstants.FROM_SIGNUP,
                )),
        (Route<dynamic> route) => false,
      );
    }
  }
  ///Open Camera and Gallery dialog
  Future<void> _optionsPhotoDialogBox(
      BuildContext mContext,
      String imagePath,
      String topMsg,
      String buttonNameRight,
      ) {
    _postImagePresenter = PostImagePresenter(this);
    return showDialog(
      barrierDismissible: false,
      context: mContext,
      builder: (BuildContext context) => Material(
          type: MaterialType.transparency,
          child: WillPopScope(
            onWillPop: () {},
            child: Container(
              margin: EdgeInsets.only(
                  top: MyConstants.topbar_height,
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  topRight: const Radius.circular(3.0))),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      SizedBox(
                                        height: MyConstants.btn_height,
                                        width: MediaQuery.of(context).size.width,
                                        child: RaisedButton(
                                          onPressed: () {
                                            openCamera();
                                          },
                                          color: MyUtils().getColorFromHex(
                                              MyConstants.color_theme),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("label_take_picture"),
                                            style: TextStyle(
                                              fontSize:
                                              MyConstants.btn_round_text_size,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MyConstants.btn_height,
                                        width: MediaQuery.of(context).size.width,
                                        child: RaisedButton(
                                          onPressed: () {
                                            openGallery();
                                          },
                                          color: MyUtils().getColorFromHex(
                                              MyConstants.color_theme),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("label_from_gallery"),
                                            style: TextStyle(
                                              fontSize:
                                              MyConstants.btn_round_text_size,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        child: Text(
                                          buttonNameRight.toUpperCase(),
                                          style: MyConstants.textStyle_dialog_btn,
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
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
                                    bottomRight: const Radius.circular(3.0))),
                          )),
                    ]),
              ),
            ),
          )),
    );
  }

  openCamera() async {
    var picture = await ImagePicker.pickImage(
        source: ImageSource.camera);

    if (picture != null && this.mounted) {
      setState(() {
        MyUtils().check().then((internet) {
          if (internet != null && internet) {
            _image = picture;
            _postImagePresenter.doPostImage(context, picture.readAsBytesSync(), compress: true);
          } else {
            MyUtils().toastdisplay(
                AppLocalizations.of(context).translate('msg_no_internet'));
          }
        });
      });
    }
  }

  openGallery() async {
    Navigator.of(context).pop();
    var gallery = await ImagePicker.pickImage(
        source: ImageSource.gallery);

    if (gallery != null && this.mounted) {
      setState(() {
        MyUtils().check().then((internet) {
          if (internet != null && internet) {
            _image = gallery;
            _postImagePresenter.doPostImage(context, gallery.readAsBytesSync(), compress: true);
          } else {
            MyUtils().toastdisplay(
                AppLocalizations.of(context).translate('msg_no_internet'));
          }
        });
      });
    }
  }

  @override
  void onPostImageError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onPostImageSuccess(PostImagePojo user) {
    if (user != null) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate("msg_upload_imge_success"));
      setState(() {
        String strPicUrl = user.url;

        const start = "media/";

        if (strPicUrl.isNotEmpty && strPicUrl.contains(start)) {
          final startIndex = strPicUrl.indexOf(start);
          final endIndex = strPicUrl.length;

          String forDeleteFileName =
          strPicUrl.substring(startIndex + start.length, endIndex);

          _profileImagePojo.clear();
          _profileImagePojo.add(
              ImagePojo(user.thumbnail, user.url, forDeleteFileName, _image));
        }
      });
    } else {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate("msg_error_server"));
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
