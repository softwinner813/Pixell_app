import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pixell_app/activity/search_user.dart';
import 'package:pixell_app/activity/walkthrough/seller_walkthrough.dart';
import 'package:pixell_app/fragments/users_tab_layout.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/age_confirm_pojo.dart';
import 'package:pixell_app/models/dele_image_pojo.dart';
import 'package:pixell_app/models/delete_user_pojo.dart';
import 'package:pixell_app/models/get_user_derails.dart';
import 'package:pixell_app/models/get_values_pojo.dart';
import 'package:pixell_app/models/image_pojo.dart';
import 'package:pixell_app/models/logout_pojo.dart';
import 'package:pixell_app/models/post_image_pojo.dart';
import 'package:pixell_app/models/raw_data_create.dart';
import 'package:pixell_app/presenter/age_confirm_presenter.dart';
import 'package:pixell_app/presenter/delete_image_presenter.dart';
import 'package:pixell_app/presenter/delete_user_presenter.dart';
import 'package:pixell_app/presenter/edit_user_presenter.dart';
import 'package:pixell_app/presenter/get_userdetails_presenter.dart';
import 'package:pixell_app/presenter/get_values_presenter.dart';
import 'package:pixell_app/presenter/logout_presenter.dart';
import 'package:pixell_app/presenter/post_image_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

import 'first_screen.dart';
import 'requests/add_bank_account.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditProfileStateful();
  }
}

class _EditProfileStateful extends State<EditProfile>
    implements
        GetValuesContract,
        GetUserDetailsContract,
        EditUserContract,
        PostImageContract,
        DeleteImageContract,
        AgeConfirmContract,
        LogoutContract,
        DeleteUserContract {
  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  GetUserDetailsPresenter _getUserDetailsPresenter;
  GetValuesPresenter _getValuesPresenter;
  EditUserPresenter _editUserPresenter;
  PostImagePresenter _postImagePresenter;
  DeleteImagePresenter _deleteImagePresenter;
  AgeConfirmPresenter _ageConfirmPresenter;

  File _image = null;
  File _imageUpload = null;
  String adultImageUrl = "";
  List<ImagePojo> _listImagePojo = [];
  List<ImagePojo> _profileImagePojo = [];
  List<String> listCountryDisplay = [];
  List<String> listCountryPassToApi = [];

  List<String> listGenderDisplay = [];
  List<String> listGenderPassToApi = [];

  List<String> listEthnicityDisplay = [];
  List<String> listEthnicityPassToApi = [];

  List<String> listbodyDisplay = [];
  List<String> listBodyPassToApi = [];

  final textNameController = TextEditingController();
  final textFirstNameController = TextEditingController();
  final textLastNameController = TextEditingController();
  final textEmailController = TextEditingController();
  final textBirthdayController = TextEditingController();
  final textHeightController = TextEditingController();
  final textWeightController = TextEditingController();
  final textPasswordController = TextEditingController();
  final textConfirmPasswordController = TextEditingController();
  final textDescriptionController = TextEditingController();

  bool allFieldValidate = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLogin = false;
  String _is_age_verified_status = "NOT_VERIFIED";

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _firstnameFocus = FocusNode();
  final FocusNode _lastnameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _birthdayFocus = FocusNode();
  final FocusNode _heightFocus = FocusNode();
  final FocusNode _weightFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  String dropdownCountryValue = '';
  String dropdownGenderValue = '';
  String dropdownEthnicityValue = '';
  String dropdownBodyValue = '';

  String dropdownPassCountryValue = '';
  String passDateOfBirth = "";
  bool tapFromUserProfile = true;
  bool tapFromUserAdultVerify = false;
  DateTime selectedDateTime;
  int userID;
  bool isSwitchedSeller = false;
  bool initialSwitchedSeller = false;
  bool isSwitchedAdult = false;
  String passwordLabelText = "********";
  String confirmpasswordLabelText = "********";
  int clickPos = 1;

  Future<void> _selectDate(BuildContext context) async {
    if (selectedDateTime == null) {
      selectedDateTime = DateTime.now();
    }
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(1500, 8),
      lastDate: DateTime.now(),
    );
    if (d != null)
      setState(() {
        selectedDateTime = d;
        textBirthdayController.text = DateFormat.yMMMMd("en_US").format(d);
        passDateOfBirth = DateFormat('yyyy-MM-dd hh:mm:ss').format(d);
      });
  }

  @override
  void initState() {
    checkIsLogin();

    _getValuesPresenter = GetValuesPresenter(this);
    _getUserDetailsPresenter = GetUserDetailsPresenter(this);
    _editUserPresenter = EditUserPresenter(this);
    _postImagePresenter = PostImagePresenter(this);
    _deleteImagePresenter = DeleteImagePresenter(this);
    _ageConfirmPresenter = AgeConfirmPresenter(this);

    _listImagePojo.add(ImagePojo("", "", "", null));

    isPasswordVisible = false;
    isConfirmPasswordVisible = false;
    allFocusListener();
    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        _getValuesPresenter.doGetValues(context);

        MySharePreference()
            .getIntegerInPref(MyConstants.PREF_KEY_USERID)
            .then((value) {
          if (value != -1) {
            userID = value;
            _getUserDetailsPresenter.doGetUserDetails(context, userID);
          }
        });
      } else {
        MyUtils().toastdisplay(
            AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget topbar = Container(
      child: Center(
          child: Row(
        children: <Widget>[
          Visibility(
            visible: false,
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
          Container(
            margin: new EdgeInsets.only(left: 15),
          ),
          Text(
            AppLocalizations.of(context).translate("label_edit_profile"),
            style: TextStyle(
                fontSize: MyConstants.toolbar_text_size, color: Colors.white),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon: Image.asset(
                    'graphics/check.png',
                    height: MyConstants.toolbar_icon_height_width,
                    width: MyConstants.toolbar_icon_height_width,
                  ),
                  onPressed: () {
                    _submitClickValidation();
                  }),
            ),
          ),
        ],
      )),
      height: MyConstants.topbar_height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('graphics/surface_top_signup.png'),
          fit: BoxFit.fill,
        ),
      ),
    );

    Widget middleSubSection = Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0,
                MyConstants.vertical_control_space + MyConstants.topbar_height,
                0.0,
                MyConstants.vertical_control_space),
          ),
          GestureDetector(
              onTap: () {
                tapFromUserAdultVerify = false;
                tapFromUserProfile = true;
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
                          50.0) /*Container(
                    height: MyConstants.profile_image_height_width,
                    width: MyConstants.profile_image_height_width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage(_image.path),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius:
                          BorderRadius.all(const Radius.circular(80.0)),
                    ),
                  ),*/
              ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)
                  .translate((_profileImagePojo == null ||
                  _profileImagePojo.length == 0) ?  'label_add_profile_photo' : 'label_change_profile_photo'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MyConstants.title_text_size,
                color: MyUtils().getColorFromHex(MyConstants.color_theme),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, MyConstants.vertical_control_space,
                0.0, MyConstants.space_30),
          ),
          TextFormField(
            controller: textNameController,
            textInputAction: TextInputAction.next,
            focusNode: _nameFocus,
            autofocus: false,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _nameFocus, _firstnameFocus);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              errorText: MyUtils().validateFieldOnly(
                context,
                textNameController.text,
                AppLocalizations.of(context).translate('msg_enter_user_name'),
              ),
              labelText: AppLocalizations.of(context).translate('hint_name'),
              labelStyle: TextStyle(
                  color: _nameFocus.hasFocus
                      ? MyUtils().getColorFromHex(MyConstants.color_theme)
                      : Colors.black),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyUtils().getColorFromHex(MyConstants.color_theme),
                    width: 2.0),
                borderRadius:
                    BorderRadius.circular(MyConstants.input_box_radius),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                _dialogFirstLastName();
              },
              child: Image.asset(
                'graphics/icon-info-white.png',
                height: MyConstants.bottomtab_icn_height_width,
                width: MyConstants.bottomtab_icn_height_width,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MyConstants.vertical_control_space_half),
          ),
          TextFormField(
            controller: textFirstNameController,
            textInputAction: TextInputAction.next,
            focusNode: _firstnameFocus,
            autofocus: false,
            enabled: !_isAudltRequestSent(),
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _firstnameFocus, _lastnameFocus);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText:
                  AppLocalizations.of(context).translate('hint_first_name'),
              labelStyle: TextStyle(
                  color: _firstnameFocus.hasFocus
                      ? MyUtils().getColorFromHex(MyConstants.color_theme)
                      : Colors.black),
              filled: true,
              fillColor: _isAudltRequestSent()?MyUtils().getColorFromHex(MyConstants.color_light_grey):Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyUtils().getColorFromHex(MyConstants.color_theme),
                    width: 2.0),
                borderRadius:
                    BorderRadius.circular(MyConstants.input_box_radius),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                _dialogFirstLastName();
              },
              child: Image.asset(
                'graphics/icon-info-white.png',
                height: MyConstants.bottomtab_icn_height_width,
                width: MyConstants.bottomtab_icn_height_width,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MyConstants.vertical_control_space_half),
          ),
          TextFormField(
            controller: textLastNameController,
            textInputAction: TextInputAction.next,
            focusNode: _lastnameFocus,
            autofocus: false,
            enabled: !_isAudltRequestSent(),
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _lastnameFocus, _heightFocus);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText:
                  AppLocalizations.of(context).translate('hint_last_name'),
              labelStyle: TextStyle(
                  color: _lastnameFocus.hasFocus
                      ? MyUtils().getColorFromHex(MyConstants.color_theme)
                      : Colors.black),
              filled: true,
              fillColor: _isAudltRequestSent()?MyUtils().getColorFromHex(MyConstants.color_light_grey):Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyUtils().getColorFromHex(MyConstants.color_theme),
                    width: 2.0),
                borderRadius:
                    BorderRadius.circular(MyConstants.input_box_radius),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).translate('label_country'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MyConstants.title_text_size,
                color: MyUtils()
                    .getColorFromHex(MyConstants.color_edti_title_text),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: DropdownButton<String>(
              hint: Text(
                dropdownCountryValue,
                style: TextStyle(
                  fontSize: MyConstants.title_text_size,
                  fontWeight: FontWeight.bold,
                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                ),
              ),
              value: null,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 0,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownCountryValue = newValue;
                });
              },
              items: listCountryDisplay
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: MyConstants.title_text_size,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).translate('label_gender'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MyConstants.title_text_size,
                color: MyUtils()
                    .getColorFromHex(MyConstants.color_edti_title_text),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: DropdownButton<String>(
              hint: Text(
                dropdownGenderValue,
                style: TextStyle(
                  fontSize: MyConstants.title_text_size,
                  fontWeight: FontWeight.bold,
                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                ),
              ),
              value: null,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 0,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownGenderValue = newValue;
                });
              },
              items: listGenderDisplay
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: MyConstants.title_text_size,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).translate('label_ethnicity'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MyConstants.title_text_size,
                color: MyUtils()
                    .getColorFromHex(MyConstants.color_edti_title_text),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: DropdownButton<String>(
              hint: Text(
                dropdownEthnicityValue,
                style: TextStyle(
                  fontSize: MyConstants.title_text_size,
                  fontWeight: FontWeight.bold,
                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                ),
              ),
              value: null,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 0,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownEthnicityValue = newValue;
                });
              },
              items: listEthnicityDisplay
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: MyConstants.title_text_size,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).translate('label_body'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MyConstants.title_text_size,
                color: MyUtils()
                    .getColorFromHex(MyConstants.color_edti_title_text),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: DropdownButton<String>(
              hint: Text(
                dropdownBodyValue,
                style: TextStyle(
                  fontSize: MyConstants.title_text_size,
                  fontWeight: FontWeight.bold,
                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                ),
              ),
              value: null,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 0,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownBodyValue = newValue;
                });
              },
              items:
                  listbodyDisplay.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: MyConstants.title_text_size,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          TextFormField(
            scrollPadding: EdgeInsets.only(
                bottom: MyConstants.textformfield_scrollpadding),
            autofocus: false,
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            controller: textHeightController,
            textInputAction: TextInputAction.next,
            focusNode: _heightFocus,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _heightFocus, _weightFocus);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              errorText: MyUtils().validateFieldOnly(
                context,
                textHeightController.text,
                AppLocalizations.of(context).translate('hint_height'),
              ),
              labelText: AppLocalizations.of(context).translate('label_height'),
              labelStyle: TextStyle(
                  color: _heightFocus.hasFocus
                      ? MyUtils().getColorFromHex(MyConstants.color_theme)
                      : Colors.black),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyUtils().getColorFromHex(MyConstants.color_theme),
                    width: 2.0),
                borderRadius:
                    BorderRadius.circular(MyConstants.input_box_radius),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          TextFormField(
            scrollPadding: EdgeInsets.only(
                bottom: MyConstants.textformfield_scrollpadding),
            autofocus: false,
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            controller: textWeightController,
            textInputAction: TextInputAction.next,
            focusNode: _weightFocus,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _weightFocus, _passwordFocus);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              errorText: MyUtils().validateFieldOnly(
                context,
                textWeightController.text,
                AppLocalizations.of(context).translate('hint_weight'),
              ),
              labelText: AppLocalizations.of(context).translate('label_weight'),
              labelStyle: TextStyle(
                  color: _weightFocus.hasFocus
                      ? MyUtils().getColorFromHex(MyConstants.color_theme)
                      : Colors.black),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyUtils().getColorFromHex(MyConstants.color_theme),
                    width: 2.0),
                borderRadius:
                    BorderRadius.circular(MyConstants.input_box_radius),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
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
              _fieldFocusChange(context, _passwordFocus, _confirmPasswordFocus);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              errorText: MyUtils().validatePassword(
                  context,
                  textPasswordController.text,
                  AppLocalizations.of(context).translate('msg_enter_password')),
              labelText: passwordLabelText,
              labelStyle: TextStyle(
                  color: _passwordFocus.hasFocus
                      ? MyUtils().getColorFromHex(MyConstants.color_theme)
                      : Colors.black),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyUtils().getColorFromHex(MyConstants.color_theme),
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
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          TextFormField(
            scrollPadding: EdgeInsets.only(
                bottom: MyConstants.textformfield_scrollpadding),
            obscureText: !isConfirmPasswordVisible,
            autofocus: false,
            controller: textConfirmPasswordController,
            textInputAction: TextInputAction.next,
            focusNode: _confirmPasswordFocus,
            onFieldSubmitted: (term) {
              _fieldFocusChange(
                  context, _confirmPasswordFocus, _descriptionFocus);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              errorText: MyUtils().validatePassword(
                  context,
                  textConfirmPasswordController.text,
                  AppLocalizations.of(context)
                      .translate('msg_reenter_password')),
              labelText: confirmpasswordLabelText,
              labelStyle: TextStyle(
                  color: _confirmPasswordFocus.hasFocus
                      ? MyUtils().getColorFromHex(MyConstants.color_theme)
                      : Colors.black),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyUtils().getColorFromHex(MyConstants.color_theme),
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
          Container(
            margin: EdgeInsets.fromLTRB(0.0, MyConstants.space_30, 0.0, 0.0),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).translate('label_description'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MyConstants.title_text_size,
                color: MyUtils()
                    .getColorFromHex(MyConstants.color_edti_title_text),
              ),
            ),
          ),
          /*loadProfileGridData(),*/
          TextFormField(
            scrollPadding: EdgeInsets.only(
                bottom: MyConstants.textformfield_scrollpadding),
            controller: textDescriptionController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            focusNode: _descriptionFocus,
            onFieldSubmitted: (term) {},
            autofocus: false,
            maxLines: null,
            decoration: InputDecoration(
              hintText:
                  AppLocalizations.of(context).translate('hint_max_word_limit'),
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: MyConstants.title_below_text_size,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, MyConstants.space_30),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).translate('label_your_pictures'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MyConstants.title_text_size,
                color: MyUtils()
                    .getColorFromHex(MyConstants.color_edti_title_text),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, 0.0, 0.0, MyConstants.vertical_control_space),
          ),
        ],
      ),
    );

    Widget middleSection = CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[middleSubSection],
          ),
        ),
        loadProfileSilverGridData(),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              middleviewBelowGrid(),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: MyConstants.bottombar_height),
        )
      ],
    );

    Widget bottomBanner = GestureDetector(
        onTap: () {},
        child: Container(
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                              left: MyConstants.bottom_tab_icon_align,
                              right: 0),
                          child: Image(
                            image: AssetImage('graphics/icon-search-1.png'),
                            height: MyConstants.bottomtab_icn_height_width,
                            width: MyConstants.bottomtab_icn_height_width,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: MyConstants.bottom_tab_icon_align,
                                right: 0),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("label_search"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: MyConstants.bottomtab_text_size,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchUser(),
                          ))
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                              left: 0,
                              right: MyConstants.bottom_tab_icon_align),
                          child: Image(
                            image: AssetImage('graphics/icon-login-1.png'),
                            height: MyConstants.bottomtab_icn_height_width,
                            width: MyConstants.bottomtab_icn_height_width,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 0,
                                right: MyConstants.bottom_tab_icon_align),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("label_log_in"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: MyConstants.bottomtab_text_size,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstScreen(),
                          ))
                    },
                  ),
                ),
              ],
            ),
          ),
          height: MyConstants.bottombar_height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('graphics/surface_bottom_tab.png'),
              fit: BoxFit.fill,
            ),
          ),
        ));

    Widget body = Container(
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
                left: MyConstants.layout_margin,
                right: MyConstants.layout_margin),
            child: middleSection,
          ),
          topbar,
          Align(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Container(
                    child: isLogin
                        ? Container(
                            height: MyConstants.bottombar_height,
                            child: _bottomWidgetAfterLogin
                                .calllBottomTabWidget(context),
                          )
                        : bottomBanner)
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg),
        body: body);
  }

  _isAudltRequestSent() {
    return (_is_age_verified_status == MyConstants.AGE_VERIFIED ||
        _is_age_verified_status == MyConstants.AGE_WAITING_VERIFICATION);
  }

  _dialogFirstLastName() {
    MyUtils().customAlertDialogBox(
        context,
        'graphics/icon-info-white.png',
        "Pixell",
        AppLocalizations.of(context).translate("msg_first_last_name"),
        "",
        AppLocalizations.of(context).translate("label_close"));
  }

  Container middleviewBelowGrid() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0.0, MyConstants.space_30, 0.0, 0.0),
          ),
          Text(
            AppLocalizations.of(context).translate('label_bank_account'),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: MyConstants.title_text_size,
              color:
                  MyUtils().getColorFromHex(MyConstants.color_edti_title_text),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space_half, 0.0, 0.0),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBankAccount()),
              );
            },
            child: Text(
              AppLocalizations.of(context).translate('label_edit_account_info'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MyConstants.title_text_size,
                color: MyUtils().getColorFromHex(MyConstants.color_theme),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, MyConstants.space_30, 0.0, 0.0),
          ),
          Text(
            AppLocalizations.of(context).translate('label_seller'),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: MyConstants.title_text_size,
              color:
                  MyUtils().getColorFromHex(MyConstants.color_edti_title_text),
            ),
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
          Visibility(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.fromLTRB(0.0, MyConstants.space_30, 0.0, 0.0),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('label_adult_seller'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: MyConstants.title_text_size,
                      color: MyUtils()
                          .getColorFromHex(MyConstants.color_edti_title_text),
                    ),
                  ),
                ),
                _is_age_verified_status == MyConstants.AGE_VERIFIED
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('label_adult_switch'),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: MyConstants.title_below_text_size,
                                  color: MyUtils().getColorFromHex(
                                      MyConstants.color_edti_title_text),
                                ),
                              ),
                            ),
                          ),
                          Switch(
                            value: isSwitchedAdult,
                            onChanged: (value) {
                              setState(() {
                                isSwitchedAdult = value;
                              });
                            },
                          ),
                        ],
                      )
                    : Container(
                        margin: const EdgeInsets.only(
                          top: MyConstants.vertical_control_space,
                        ),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: MyUtils().getColorFromHex(
                              MyConstants.color_age_verifed_box),
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'graphics/adult_pending.png',
                              height: 25,
                              width: 25,
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                            ),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('label_age_adult_pending'),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MyConstants.title_below_text_size,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
            visible: (_is_age_verified_status == MyConstants.AGE_VERIFIED ||
                _is_age_verified_status ==
                    MyConstants.AGE_WAITING_VERIFICATION),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, MyConstants.space_50, 0.0, 0.0),
          ),
          SizedBox(
            height: MyConstants.btn_height,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              onPressed: () {
                _submitClickValidation();
              },
              color: MyUtils().getColorFromHex(MyConstants.color_theme),
              child: Text(
                AppLocalizations.of(context).translate("label_save"),
                style: TextStyle(
                  fontSize: MyConstants.btn_round_text_size,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Visibility(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.fromLTRB(0.0, MyConstants.space_50, 0.0, 0.0),
                ),
                Text(
                  AppLocalizations.of(context).translate('label_adult_seller'),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: MyConstants.title_text_size,
                    color: MyUtils()
                        .getColorFromHex(MyConstants.color_edti_title_text),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      0.0, MyConstants.vertical_control_space_half, 0.0, 0.0),
                ),
                Text(
                  AppLocalizations.of(context).translate('label_adult_msg'),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: MyConstants.title_below_text_size,
                    color: MyUtils()
                        .getColorFromHex(MyConstants.color_edti_title_text),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.fromLTRB(0.0, MyConstants.space_30, 0.0, 0.0),
                ),
                SizedBox(
                  height: MyConstants.btn_height,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () {
                      _openAdultDialog();
                    },
                    color: MyUtils().getColorFromHex(MyConstants.color_theme),
                    child: Text(
                      AppLocalizations.of(context).translate("label_adult_btn"),
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
            visible: _is_age_verified_status == MyConstants.AGE_NOT_VERIFIED,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MyConstants.space_50, bottom: MyConstants.space_50),
            child: SizedBox(
              height: MyConstants.btn_height,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: () {
                  LogoutPresenter _logoutPresenter = new LogoutPresenter(this);
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
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                MyUtils().check().then((intenet) {
                  if (intenet != null && intenet) {
                    MySharePreference()
                        .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
                        .then((valueTokenLogin) {
                      if (!valueTokenLogin.isEmpty) {
                         MyUtils().alertDialogBox(
                          context,
                          'graphics/info_large.png',
                          AppLocalizations.of(context).translate("label_delete_pixell_acc_alert_title"),
                          AppLocalizations.of(context).translate("label_delete_pixell_acc_alert_subtitle"),
                          <Widget>[
                            FlatButton(
                                child: Text(
                                  AppLocalizations.of(context).translate("label_delete_pixell_acc_alert_delete").toUpperCase(),
                                  style: MyConstants.textStyle_red_dialog_btn,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  DeleteUserPresenter _deleteUserPresenter =
                                  new DeleteUserPresenter(this);
                                  _deleteUserPresenter.doDeleteUser(
                                      context, userID.toString(), valueTokenLogin);
                                }),
                            FlatButton(
                                child: Text(
                                  AppLocalizations.of(context).translate("label_cancel").toUpperCase(),
                                  style: MyConstants.textStyle_dialog_btn,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ],
                        );

                      }
                    });
                  } else {
                    MyUtils().toastdisplay(AppLocalizations.of(context)
                        .translate('msg_no_internet'));
                  }
                });
              },
              child: AutoSizeText(
                AppLocalizations.of(context)
                    .translate('label_delete_pixell_acc'),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MyConstants.title_text_size,
                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, MyConstants.space_20),
          ),
        ],
      ),
    );
  }

  void _submitClickValidation() {
    /* if (textBirthdayController.text.isEmpty) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('msg_select_birthdate'));
      return;
    }*/

    if (textDescriptionController.text.length > 400) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('hint_max_word_limit'));
      return;
    }

    if (textPasswordController.text != textConfirmPasswordController.text) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate('msg_same_password_confirm'));
      return;
    }

    if (this.mounted) {
      setState(() {
        if (allFieldValidate) {
          MyUtils().check().then((intenet) {
            if (intenet != null && intenet) {
              MySharePreference()
                  .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
                  .then((valueToken) {
                if (!valueToken.isEmpty) {
                  _editUserPresenter = EditUserPresenter(this);
                  _editUserPresenter.doEditUser(
                      context, userID, editProfilePayload(), valueToken);
                }
              });
            } else {
              MyUtils().toastdisplay(
                  AppLocalizations.of(context).translate('msg_no_internet'));
            }
          });
        }
      });
    }
  }

  Map editProfilePayload() {
    String thumbnail = "";
    String profile_pic = "";
    String gender = "";
    String country = "";
    String race = "";
    String body = "";

    if (_profileImagePojo.length > 0) {
      thumbnail = _profileImagePojo[0].thumbUrl;
      profile_pic = _profileImagePojo[0].largeUrl;
    }

    if (listGenderDisplay.length > 0 &&
        listGenderDisplay.contains(dropdownGenderValue)) {
      gender =
          listGenderPassToApi[listGenderDisplay.indexOf(dropdownGenderValue)];
    }

    if (listCountryDisplay.length > 0 &&
        listCountryDisplay.contains(dropdownCountryValue)) {
      country = listCountryPassToApi[
          listCountryDisplay.indexOf(dropdownCountryValue)];
    }

    if (listEthnicityDisplay.length > 0 &&
        listEthnicityDisplay.contains(dropdownEthnicityValue)) {
      race = listEthnicityPassToApi[
          listEthnicityDisplay.indexOf(dropdownEthnicityValue)];
    }

    if (listbodyDisplay.length > 0 &&
        listbodyDisplay.contains(dropdownBodyValue)) {
      body = listBodyPassToApi[listbodyDisplay.indexOf(dropdownBodyValue)];
    }

    List<Pic> uploadImages = [];
    for (var i = 1; i < _listImagePojo.length; i++) {
      Pic tempUploadPic = new Pic();
      tempUploadPic.thumbnail = _listImagePojo[i].thumbUrl;
      tempUploadPic.regular = _listImagePojo[i].largeUrl;

      uploadImages.add(tempUploadPic);
    }

    Map mapProfile = RawDataCreate().editProfileMainPostRawMap(
        textNameController.text,
        textFirstNameController.text,
        textLastNameController.text,
        /*textEmailController.text*/
        "",
        /*passDateOfBirth*/
        "",
        textPasswordController.text,
        textDescriptionController.text,
        thumbnail,
        profile_pic,
        isSwitchedSeller,
        isSwitchedAdult,
        _is_age_verified_status,
        gender,
        country,
        textHeightController.text,
        textWeightController.text,
        race,
        body,
        uploadImages);

    if (mapProfile.containsKey("")) {
      mapProfile.remove("");
    }

    return mapProfile;
  }

  SliverGrid loadProfileSilverGridData() {
    int addBtnIndex = 0;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          addBtnIndex = index + 1;
          return Container(
              alignment: Alignment.center,
              child: Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    clickPos = index + 1;
                    _deleteImagePresenter = DeleteImagePresenter(this);
                    fullImageAlertDialogBox(context, _listImagePojo[index + 1],
                        _deleteImagePresenter);
                  },
                  child: Stack(
                    children: <Widget>[
                      addBtnIndex == _listImagePojo.length
                          ? Container(
                              color: MyUtils()
                                  .getColorFromHex(MyConstants.color_theme),
                              height: MyConstants.edit_profile_image_h_w,
                              width: MyConstants.edit_profile_image_h_w,
                              child: IconButton(
                                  icon: Image.asset(
                                    'graphics/add_btn.png',
                                    height:
                                        MyConstants.toolbar_icon_height_width,
                                    width:
                                        MyConstants.toolbar_icon_height_width,
                                  ),
                                  onPressed: () {
                                    tapFromUserAdultVerify = false;
                                    tapFromUserProfile = false;
                                    _optionsPhotoDialogBox(
                                        context,
                                        'graphics/upload.png',
                                        AppLocalizations.of(context).translate(
                                            "msg_top_add_photo_dialog"),
                                        AppLocalizations.of(context)
                                            .translate("label_close"));
                                  }),
                            )
                          : Container(
                              width: double.infinity,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset(
                                    "graphics/user_default_rectangle.png",
                                    height: MyConstants.edit_profile_image_h_w,
                                    width: MyConstants.edit_profile_image_h_w),
                                imageUrl: _listImagePojo[index + 1].thumbUrl,
                                height: MyConstants.edit_profile_image_h_w,
                                width: MyConstants.edit_profile_image_h_w,
                              ),
                            ),
                    ],
                  ),
                ),
              ));
        },
        addAutomaticKeepAlives: true,
        childCount: _listImagePojo.length,
      ),
    );
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

    textHeightController.addListener(() {
      checkAllFieldValidate();
    });

    textWeightController.addListener(() {
      checkAllFieldValidate();
    });

    textPasswordController.addListener(() {
      checkAllFieldValidate();
    });

    textConfirmPasswordController.addListener(() {
      checkAllFieldValidate();
    });

    _passwordFocus.addListener(() {
      passwordLabelText =
          AppLocalizations.of(context).translate('hint_password');
    });

    _confirmPasswordFocus.addListener(() {
      confirmpasswordLabelText =
          AppLocalizations.of(context).translate('hint_confirm_password');
    });
  }

  void checkAllFieldValidate() {
    if (this.mounted) {
      setState(() {
        if (MyUtils().validateFieldOnly(context, textNameController.text, "") ==
                null &&
            /*MyUtils().validateEmail(context, textEmailController.text) == null &&*/
            MyUtils().validateFieldOnly(
                    context, textBirthdayController.text, "") ==
                null) {
          if (!(textPasswordController.text.isEmpty)) {
            if (MyUtils().validatePassword(
                    context, textPasswordController.text, "") ==
                null) {
              allFieldValidate = true;
            } else {
              allFieldValidate = false;
            }
          } else if (!(textConfirmPasswordController.text.isEmpty)) {
            if (MyUtils().validatePassword(
                    context, textConfirmPasswordController.text, "") ==
                null) {
              allFieldValidate = true;
            } else {
              allFieldValidate = false;
            }
          } else {
            allFieldValidate = true;
          }
        } else {
          allFieldValidate = false;
        }
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    textNameController.dispose();
    textFirstNameController.dispose();
    textLastNameController.dispose();
    textEmailController.dispose();
    textBirthdayController.dispose();
    textHeightController.dispose();
    textWeightController.dispose();
    textPasswordController.dispose();
    textConfirmPasswordController.dispose();
    textDescriptionController.dispose();
    super.dispose();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
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
    if (!tapFromUserAdultVerify) {
      Navigator.of(context).pop();
    }
    var picture = await ImagePicker.pickImage(
        source: ImageSource.camera);

    if (picture != null && this.mounted) {
      setState(() {
        MyUtils().check().then((internet) {
          if (internet != null && internet) {
            if (tapFromUserProfile) {
              _image = picture;
            }
            if (tapFromUserAdultVerify) {
            } else {
              _imageUpload = picture;
            }

            _postImagePresenter.doPostImage(context, picture.readAsBytesSync(), compress: true);
          } else {
            MyUtils().toastdisplay(
                AppLocalizations.of(context).translate('msg_no_internet'));
          }
        });
      });
    }
  }

  _openAdultDialog() {
    if (textFirstNameController.text.isEmpty) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate("msg_enter_firstname"));
    } else if (textLastNameController.text.isEmpty) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate("msg_enter_lastname"));
    } else {
      alertDialogAdult(
          context,
          'graphics/confirm.png',
          AppLocalizations.of(context)
              .translate("label_confirmation_adultness"),
          AppLocalizations.of(context)
              .translate("label_dialog_adult_msg"),
          AppLocalizations.of(context)
              .translate("label_close"));
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
            if (tapFromUserProfile) {
              _image = gallery;
            } else {
              _imageUpload = gallery;
            }

            _postImagePresenter.doPostImage(context, gallery.readAsBytesSync(), compress: true);
          } else {
            MyUtils().toastdisplay(
                AppLocalizations.of(context).translate('msg_no_internet'));
          }
        });
      });
    }
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
  void onGetValuesError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onGetValuesSuccess(GetValuesPojo pojoData) {
    dropdownCountryValue =
        AppLocalizations.of(context).translate("dropdown_country_default");
    dropdownGenderValue =
        AppLocalizations.of(context).translate("dropdown_gender_default");
    dropdownEthnicityValue =
        AppLocalizations.of(context).translate("dropdown_ethnicity_default");
    dropdownBodyValue =
        AppLocalizations.of(context).translate("dropdown_body_type_default");

    /*listCountryPassToApi.add("");
    listCountryDisplay.add(dropdownCountryValue);

    listGenderPassToApi.add("");
    listGenderDisplay.add(dropdownGenderValue);

    listEthnicityPassToApi.add("");
    listEthnicityDisplay.add(dropdownEthnicityValue);

    listBodyPassToApi.add("");
    listbodyDisplay.add(dropdownBodyValue);*/

    if (pojoData != null) {
      if (pojoData.country != null) {
        Map<String, String> _mapData = pojoData.country.toJsonStringType();
        listCountryPassToApi.addAll(_mapData.keys.toList());
        listCountryDisplay.addAll(_mapData.values.toList());
      }

      if (pojoData.gender != null) {
        Map<String, String> _mapData = pojoData.gender.toJsonStringType();
        listGenderPassToApi.addAll(_mapData.keys.toList());
        listGenderDisplay.addAll(_mapData.values.toList());
      }

      if (pojoData.race != null) {
        Map<String, String> _mapData = pojoData.race.toJsonStringType();
        listEthnicityPassToApi.addAll(_mapData.keys.toList());
        listEthnicityDisplay.addAll(_mapData.values.toList());
      }

      if (pojoData.body != null) {
        Map<String, String> _mapData = pojoData.body.toJsonStringType();
        listBodyPassToApi.addAll(_mapData.keys.toList());
        listbodyDisplay.addAll(_mapData.values.toList());
      }
    }
  }

  @override
  void onDetailsError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onDetailsSuccess(GetUserDetailsPojo pojoData) {
    if (pojoData != null) {
      setState(() {
        textNameController.text = pojoData.username;
        if (pojoData.firstName != null) {
          textFirstNameController.text = pojoData.firstName;
        }
        if (pojoData.lastName != null) {
          textLastNameController.text = pojoData.lastName;
        }
        textEmailController.text = pojoData.email;
        selectedDateTime = pojoData.dateOfBirth;
        textBirthdayController.text =
            DateFormat.yMMMMd("en_US").format(selectedDateTime);
        passDateOfBirth =
            DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDateTime);

        if (pojoData.profile != null && pojoData.profile.pics != null) {
          //For to add Profile pic here
          if (pojoData.profile.profilePic != null) {
            _profileImagePojo.clear();
            _profileImagePojo.add(ImagePojo(pojoData.profile.thumbnail,
                pojoData.profile.profilePic, "", null));
          }

          List<Pic> picsProfile = pojoData.profile.pics;
          for (var i = 0; i < picsProfile.length; i++) {
            Pic picTemp = picsProfile[i];
            String thumbUrl = picTemp.thumbnail;
            String regular = picTemp.regular;

            const start = "media/";

            if (!regular.isEmpty && regular.contains(start)) {
              final startIndex = regular.indexOf(start);
              final endIndex = regular.length;

              String forDeleteFileName =
                  regular.substring(startIndex + start.length, endIndex);

              _listImagePojo.add(ImagePojo(
                  thumbUrl, regular, forDeleteFileName, _imageUpload));
            }
          }
        }

        if (pojoData.profile != null && pojoData.profile.description != null) {
          textDescriptionController.text = pojoData.profile.description;
        }

        if (pojoData.profile != null && pojoData.profile.isSeller != null) {
          isSwitchedSeller = pojoData.profile.isSeller;
          initialSwitchedSeller = pojoData.profile.isSeller;
        }

        if (pojoData.profile != null &&
            pojoData.profile.isSellingAdultContent != null) {
          isSwitchedAdult = pojoData.profile.isSellingAdultContent;
        }

        if (pojoData.profile != null && pojoData.profile.country != null) {
          dropdownCountryValue = listCountryDisplay[
              listCountryPassToApi.indexOf(pojoData.profile.country)];
        }

        if (pojoData.profile != null && pojoData.profile.gender != null) {
          dropdownGenderValue = listGenderDisplay[
              listGenderPassToApi.indexOf(pojoData.profile.gender)];
        }

        // Set physical_appearance data
        if (pojoData.profile != null &&
            pojoData.profile.physicalAppearance != null) {
          if (pojoData.profile.physicalAppearance.heightCm != null) {
            textHeightController.text =
                pojoData.profile.physicalAppearance.heightCm.toString();
          }

          if (pojoData.profile.physicalAppearance.weightKg != null) {
            textWeightController.text =
                pojoData.profile.physicalAppearance.weightKg.toString();
          }

          if (pojoData.profile.physicalAppearance.race != null) {
            dropdownEthnicityValue = listEthnicityDisplay[listEthnicityPassToApi
                .indexOf(pojoData.profile.physicalAppearance.race)];
          }

          if (pojoData.profile.physicalAppearance.body != null) {
            dropdownBodyValue = listbodyDisplay[listBodyPassToApi
                .indexOf(pojoData.profile.physicalAppearance.body)];
          }
        }

        if (pojoData.profile != null &&
            pojoData.profile.isAgeVerified != null) {
          _is_age_verified_status = pojoData.profile.isAgeVerified;
        }
      });
    }
  }

  @override
  void onEditError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onEditSuccess(GetUserDetailsPojo pojoData) {
    if (pojoData != null) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate("msg_edit_success"));
      //Navigator.pop(context, true);

      MyConstants.currentSelectedBottomTab = 0;

      //Set in Pref is Seller or not
      if (pojoData.profile != null && pojoData.profile.isSeller != null) {
        if (pojoData.profile.isSeller) {
          MySharePreference().saveStringInPref(
              MyConstants.PREF_IS_SELLER, MyConstants.TEMP_YES_SELLER);
        } else {
          MySharePreference().saveStringInPref(MyConstants.PREF_IS_SELLER, "");
        }
      }

      if (!initialSwitchedSeller && isSwitchedSeller) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SellerWalkthrough()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UsersTabLayout()));
      }

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

          if (tapFromUserProfile) {
            _profileImagePojo.clear();
            _profileImagePojo.add(
                ImagePojo(user.thumbnail, user.url, forDeleteFileName, _image));
          } else if (tapFromUserAdultVerify) {
            tapFromUserAdultVerify = false;
            adultImageUrl = user.url;
            Navigator.of(context).pop();
            _openAdultDialog();
          } else {
            _listImagePojo.add(ImagePojo(
                user.thumbnail, user.url, forDeleteFileName, _imageUpload));
          }
        }
      });
    } else {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate("msg_error_server"));
    }
  }

  @override
  void onDeleteImageError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onDeleteImageSuccess(DeleteImagePojo pojoData) {
    if (pojoData != null) {
      if (pojoData.status != null && pojoData.status == "OK") {
        MyUtils().toastdisplay(
            AppLocalizations.of(context).translate("msg_delete_imge_success"));
        setState(() {
          _listImagePojo.removeAt(clickPos);
        });
      } else if (pojoData.error != null) {
        MyUtils().toastdisplay(pojoData.error);
      }
    }
  }

  @override
  void onAgeConfirmError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onAgeConfirmSuccess(AgeConfirmPojo pojodata) {
    if (pojodata != null) {
      if (pojodata.success != null) {
        setState(() {
          _is_age_verified_status = MyConstants.AGE_WAITING_VERIFICATION;

          MyUtils().customAlertDialogBox(
              context,
              'graphics/upload.png',
              AppLocalizations.of(context).translate("label_thanks_uploading"),
              AppLocalizations.of(context).translate("label_uploading_msg"),
              "",
              AppLocalizations.of(context).translate("label_close"));
        });
      } else if (pojodata.detail != null) {
        MyUtils().toastdisplay(pojodata.detail);
      }
    }
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

  @override
  void onDeleteUserError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onDeleteUserSuccess(DeleteUserPojo pojoData) {
    if (pojoData != null) {
      if (pojoData.detail != null) {
        MyUtils().toastdisplay(pojoData.detail);
      } else {
        MySharePreference().clearAllPref();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FirstScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> alertDialogAdult(
      BuildContext mContext,
      String imagePath,
      String topMsg,
      String bottomMsg,
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
                  top: 20,
                  bottom: MyConstants.bottombar_height-40,
                  left: MyConstants.layout_margin,
                  right: MyConstants.layout_margin),
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Image.asset(
                                  imagePath,
                                  alignment: Alignment.center,
                                  height: MyConstants.dialog_top_image_h_w,
                                  width: MyConstants.dialog_top_image_h_w,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text(
                                    topMsg,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  bottomMsg,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                                ),
                                adultImageUrl.isEmpty
                                    ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Image.asset(
                                        'graphics/adult_age_ok.png',
                                        height: MyConstants.adult_image_h_w,
                                      ),
                                    ),
                                    Flexible(
                                      child: Image.asset(
                                        'graphics/adult_age_cancel.png',
                                        height: MyConstants.adult_image_h_w,
                                      ),
                                    )
                                  ],
                                )
                                    : FadeInImage.assetNetwork(
                                    height: MediaQuery.of(context).size.height / 4,
                                    width: MyConstants.adult_image_h_w,
                                    fit: BoxFit.fitHeight,
                                    placeholder: "graphics/user_default_rectangle.png",
                                    image: adultImageUrl != null ? adultImageUrl : ""),
                                Container(
                                  margin:
                                  EdgeInsets.fromLTRB(0.0, MyConstants.space_20, 0.0, 0.0),
                                ),
                                adultImageUrl.isEmpty
                                    ? SizedBox(
                                  height: MyConstants.btn_height,
                                  width: double.infinity,
                                  child: RaisedButton(
                                    onPressed: () {
                                      tapFromUserProfile = false;
                                      tapFromUserAdultVerify = true;
                                      openCamera();
                                    },
                                    color:
                                    MyUtils().getColorFromHex(MyConstants.color_theme),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("label_use_camera"),
                                      style: TextStyle(
                                        fontSize: MyConstants.btn_round_text_size,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                    : SizedBox(
                                  height: MyConstants.btn_height,
                                  width: double.infinity,
                                  child: RaisedButton(
                                    onPressed: () {
                                      _ageConfirmPresenter = AgeConfirmPresenter(this);

                                      MyUtils().check().then((intenet) {
                                        if (intenet != null && intenet) {
                                          MySharePreference()
                                              .getStringInPref(
                                              MyConstants.PREF_KEY_LOGIN_TOKEN)
                                              .then((value) {
                                            if (!value.isEmpty) {
                                              Navigator.of(context).pop();
                                              _ageConfirmPresenter.doAgeConfirm(
                                                  context, adultImageUrl, value);
                                            }
                                          });
                                        } else {
                                          MyUtils().toastdisplay(
                                              AppLocalizations.of(context)
                                                  .translate('msg_no_internet'));
                                        }
                                      });
                                    },
                                    color:
                                    MyUtils().getColorFromHex(MyConstants.color_theme),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("label_send_picture"),
                                      style: TextStyle(
                                        fontSize: MyConstants.btn_round_text_size,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                  EdgeInsets.fromLTRB(0.0, MyConstants.space_20, 0.0, 0.0),
                                ),
                                Visibility(
                                  child: Column(
                                    children: <Widget>[
                                      InkWell(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("label_shoot_again"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                MyConstants.title_alert_dialog_top_msg / 1.3,
                                                color: MyUtils()
                                                    .getColorFromHex(MyConstants.color_theme),
                                              )),
                                          onTap: () {
                                            tapFromUserProfile = false;
                                            tapFromUserAdultVerify = true;
                                            openCamera();
                                          }),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                                      ),
                                    ],
                                  ),
                                  visible: !adultImageUrl.isEmpty,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                      child: Text(
                                        buttonNameRight.toUpperCase(),
                                        style: MyConstants.textStyle_dialog_btn,
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      }),
                                ),
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
}

Future<void> fullImageAlertDialogBox(BuildContext mContext,
    ImagePojo clickImagePojo, DeleteImagePresenter _deleteImagePresenter) {
  return showDialog(
      barrierDismissible: false,
      context: mContext,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.3,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2.3,
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: "graphics/user_default_rectangle.png",
                        image: clickImagePojo.largeUrl != null
                            ? clickImagePojo.largeUrl
                            : ""),
                  ),
                ]),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  AppLocalizations.of(context).translate("label_delete"),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MyConstants.btn_dialog_size,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  MyUtils().check().then((intenet) {
                    if (intenet != null && intenet) {
                      MySharePreference()
                          .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
                          .then((valueTokenLogin) {
                        if (!valueTokenLogin.isEmpty) {
                          _deleteImagePresenter.doDeleteImage(context,
                              clickImagePojo.fileNamePics, valueTokenLogin);
                        }
                      });
                    } else {
                      MyUtils().toastdisplay(AppLocalizations.of(context)
                          .translate('msg_no_internet'));
                    }
                  });
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text(
                  AppLocalizations.of(context).translate("label_close"),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MyConstants.btn_dialog_size,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      });
}
