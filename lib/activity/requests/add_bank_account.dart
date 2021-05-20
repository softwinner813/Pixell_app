import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/account_pojo.dart';
import 'package:pixell_app/models/get_values_pojo.dart';
import 'package:pixell_app/models/raw_data_create.dart';
import 'package:pixell_app/presenter/add_update_account_presenter.dart';
import 'package:pixell_app/presenter/get_values_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

class AddBankAccount extends StatefulWidget {
  AddBankAccount({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AddBankAccountStateful();
  }
}

class _AddBankAccountStateful extends State<AddBankAccount>
    implements AddUpdateAccountContract, GetValuesContract {
  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  GetValuesPresenter _getValuesPresenter;
  AddUpdateAccountPresenter _addUpdateAccountPresenter;

  final textBankNameController = TextEditingController();
  final textBranchNameController = TextEditingController();
  final textBranchAddressController = TextEditingController();
  final textSWIFTnumberController = TextEditingController();
  final textAccNumberController = TextEditingController();
  final textOwnerNameController = TextEditingController();

  final FocusNode _bakNameFocus = FocusNode();
  final FocusNode _branchNameFocus = FocusNode();
  final FocusNode _branchAddressFocus = FocusNode();
  final FocusNode _swiftNumberFocus = FocusNode();
  final FocusNode _accNumberFocus = FocusNode();
  final FocusNode _ownerNameFocus = FocusNode();

  List<String> listCountryDisplay = [];
  List<String> listCountryPassToApi = [];
  List<String> listAccTypeDisplay = [];
  List<String> listAccTypePassToApi = [];

  bool allFieldValidate = false;
  String dropdownCountryValue = '';
  String dropdownAccTypeValue = '';
  String tokenLogin = "";
  String accountID = "";
  bool updateAddBtnClick = false;

  @override
  void initState() {
    allFocusListener();

    _getValuesPresenter = GetValuesPresenter(this);
    _addUpdateAccountPresenter = new AddUpdateAccountPresenter(this);

    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        _getValuesPresenter.doGetValues(context);

        MySharePreference()
            .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
            .then((valueToken) {
          if (!valueToken.isEmpty) {
            tokenLogin = valueToken;
            _addUpdateAccountPresenter.doGetAccount(context, tokenLogin);
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
                AppLocalizations.of(context).translate("label_bank_account"),
                style: TextStyle(
                    fontSize: MyConstants.toolbar_text_size,
                    color: Colors.white),
              ),
            ],
          )),
      height: MyConstants.topbar_height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('graphics/surface_top_signup.png'),
          fit: BoxFit.fill,
        ),
      ),
    );

    Widget middleSection = new SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
            left: MyConstants.layout_margin, right: MyConstants.layout_margin),
        padding: EdgeInsets.only(
            top: MyConstants.vertical_control_space + MyConstants.topbar_height,
            bottom: MyConstants.bottombar_height),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('label_country'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MyConstants.title_text_size,
                color: MyUtils()
                    .getColorFromHex(MyConstants.color_edti_title_text),
              ),
            ),
            DropdownButton<String>(
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
            Container(
              margin: EdgeInsets.only(top: MyConstants.vertical_control_space),
            ),
            TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MyConstants.textformfield_scrollpadding),
              controller: textBankNameController,
              textInputAction: TextInputAction.next,
              focusNode: _bakNameFocus,
              autofocus: false,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _bakNameFocus, _branchNameFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorText: MyUtils().validateFieldOnly(
                  context,
                  textBankNameController.text,
                  AppLocalizations.of(context)
                      .translate('label_error_bank_name'),
                ),
                labelText: AppLocalizations.of(context)
                    .translate('label_hint_bank_name'),
                labelStyle: TextStyle(
                    color: _bakNameFocus.hasFocus
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
              margin: new EdgeInsets.fromLTRB(
                  0.0, MyConstants.vertical_control_space * 1.5, 0.0, 0.0),
            ),
            TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MyConstants.textformfield_scrollpadding),
              controller: textBranchNameController,
              textInputAction: TextInputAction.next,
              focusNode: _branchNameFocus,
              autofocus: false,
              onFieldSubmitted: (term) {
                _fieldFocusChange(
                    context, _branchNameFocus, _branchAddressFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorText: MyUtils().validateFieldOnly(
                  context,
                  textBranchNameController.text,
                  AppLocalizations.of(context)
                      .translate('label_error_branch_name'),
                ),
                labelText: AppLocalizations.of(context)
                    .translate('label_hint_branch_name'),
                labelStyle: TextStyle(
                    color: _branchNameFocus.hasFocus
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
              margin: new EdgeInsets.fromLTRB(
                  0.0, MyConstants.vertical_control_space_half, 0.0, 0.0),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  MyUtils().customAlertDialogBox(
                      context,
                      'graphics/icon-pixell-point-white.png',
                      AppLocalizations.of(context)
                          .translate("label_what_is_pixell_points"),
                      "Coming soon...",
                      "",
                      AppLocalizations.of(context).translate("label_close"));
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
              margin: new EdgeInsets.fromLTRB(
                  0.0, MyConstants.vertical_control_space_half, 0.0, 0.0),
            ),
            TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MyConstants.textformfield_scrollpadding),
              controller: textBranchAddressController,
              textInputAction: TextInputAction.next,
              focusNode: _branchAddressFocus,
              autofocus: false,
              onFieldSubmitted: (term) {
                _fieldFocusChange(
                    context, _branchAddressFocus, _swiftNumberFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorText: MyUtils().validateFieldOnly(
                  context,
                  textBranchAddressController.text,
                  AppLocalizations.of(context)
                      .translate('label_error_branch_address_name'),
                ),
                labelText: AppLocalizations.of(context)
                    .translate('label_hint_branch_address_name'),
                labelStyle: TextStyle(
                    color: _branchAddressFocus.hasFocus
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
              margin: new EdgeInsets.fromLTRB(
                  0.0, MyConstants.vertical_control_space_half, 0.0, 0.0),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  MyUtils().customAlertDialogBox(
                      context,
                      'graphics/icon-pixell-point-white.png',
                      AppLocalizations.of(context)
                          .translate("label_what_is_pixell_points"),
                      "Coming soon...",
                      "",
                      AppLocalizations.of(context).translate("label_close"));
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
              margin: new EdgeInsets.fromLTRB(
                  0.0, MyConstants.vertical_control_space_half, 0.0, 0.0),
            ),
            TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MyConstants.textformfield_scrollpadding),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              controller: textSWIFTnumberController,
              textInputAction: TextInputAction.next,
              focusNode: _swiftNumberFocus,
              autofocus: false,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _swiftNumberFocus, _accNumberFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorText: MyUtils().validateFieldOnly(
                  context,
                  textSWIFTnumberController.text,
                  AppLocalizations.of(context)
                      .translate('label_error_swift_name'),
                ),
                labelText: AppLocalizations.of(context)
                    .translate('label_hint_swift_name'),
                labelStyle: TextStyle(
                    color: _swiftNumberFocus.hasFocus
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
              margin: new EdgeInsets.fromLTRB(
                  0.0, MyConstants.vertical_control_space * 1.5, 0.0, 0.0),
            ),
            Text(
              AppLocalizations.of(context).translate('label_acc_type'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: MyConstants.title_text_size,
                color: MyUtils()
                    .getColorFromHex(MyConstants.color_edti_title_text),
              ),
            ),
            DropdownButton<String>(
              hint: Text(
                dropdownAccTypeValue,
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
                  dropdownAccTypeValue = newValue;
                });
              },
              items: listAccTypeDisplay
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
            Container(
              margin: EdgeInsets.only(top: MyConstants.vertical_control_space),
            ),
            TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MyConstants.textformfield_scrollpadding),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              controller: textAccNumberController,
              textInputAction: TextInputAction.next,
              focusNode: _accNumberFocus,
              autofocus: false,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _accNumberFocus, _ownerNameFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorText: MyUtils().validateFieldOnly(
                  context,
                  textAccNumberController.text,
                  AppLocalizations.of(context)
                      .translate('label_error_acc_number_name'),
                ),
                labelText: AppLocalizations.of(context)
                    .translate('label_hint_acc_number_name'),
                labelStyle: TextStyle(
                    color: _accNumberFocus.hasFocus
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
              margin: new EdgeInsets.fromLTRB(
                  0.0, MyConstants.vertical_control_space * 1.5, 0.0, 0.0),
            ),
            TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MyConstants.textformfield_scrollpadding),
              controller: textOwnerNameController,
              textInputAction: TextInputAction.done,
              focusNode: _ownerNameFocus,
              autofocus: false,
              onFieldSubmitted: (term) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorText: MyUtils().validateFieldOnly(
                  context,
                  textOwnerNameController.text,
                  AppLocalizations.of(context)
                      .translate('label_error_owner_name'),
                ),
                labelText: AppLocalizations.of(context)
                    .translate('label_hint_owner_name'),
                labelStyle: TextStyle(
                    color: _ownerNameFocus.hasFocus
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
            Padding(
              padding: EdgeInsets.only(
                  top: MyConstants.space_40, bottom: MyConstants.space_40),
              child: SizedBox(
                height: MyConstants.btn_height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: RaisedButton(
                  onPressed: () {
                    _saveBankDetails();
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
            ),
          ],
        ),
      ),
    );

    Widget body = Container(
      child: Stack(
        children: <Widget>[
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (_) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: middleSection,
          ),
          topbar,
          Align(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                _bottomWidgetAfterLogin.calllBottomTabWidget(context),
              ],
            ),
          ),
        ],
      ),
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

  void allFocusListener() {
    textBankNameController.addListener(() {
      checkAllFieldValidate();
    });

    textBranchNameController.addListener(() {
      checkAllFieldValidate();
    });

    textBranchAddressController.addListener(() {
      checkAllFieldValidate();
    });

    textSWIFTnumberController.addListener(() {
      checkAllFieldValidate();
    });

    textAccNumberController.addListener(() {
      checkAllFieldValidate();
    });

    textOwnerNameController.addListener(() {
      checkAllFieldValidate();
    });
  }

  void checkAllFieldValidate() {
    setState(() {
      if (MyUtils().validateFieldOnly(
          context, textBankNameController.text, "") ==
          null &&
          MyUtils().validateFieldOnly(
              context, textBranchNameController.text, "") ==
              null &&
          MyUtils().validateFieldOnly(
              context, textBranchAddressController.text, "") ==
              null &&
          MyUtils().validateFieldOnly(
              context, textSWIFTnumberController.text, "") ==
              null &&
          MyUtils().validateFieldOnly(
              context, textAccNumberController.text, "") ==
              null &&
          MyUtils().validateFieldOnly(
              context, textOwnerNameController.text, "") ==
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
    textBankNameController.dispose();
    textBranchNameController.dispose();
    textBranchAddressController.dispose();
    textSWIFTnumberController.dispose();
    textAccNumberController.dispose();
    textOwnerNameController.dispose();

    super.dispose();
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,
      FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _saveBankDetails() {
    String country = "";
    String bankAccType = "";

    if (listCountryDisplay.length > 0 &&
        listCountryDisplay.contains(dropdownCountryValue)) {
      country = listCountryPassToApi[
      listCountryDisplay.indexOf(dropdownCountryValue)];
    }

    if (listAccTypeDisplay.length > 0 &&
        listAccTypeDisplay.contains(dropdownAccTypeValue)) {
      bankAccType = listAccTypePassToApi[
      listAccTypeDisplay.indexOf(dropdownAccTypeValue)];
    }

    if (country.isEmpty) {
      MyUtils().toastdisplay(AppLocalizations.of(context)
          .translate("dropdown_bank_country_default"));
      return;
    }

    if (bankAccType.isEmpty) {
      MyUtils().toastdisplay(
          AppLocalizations.of(context).translate("dropdown_acc_type_default"));

      return;
    }

    if (allFieldValidate) {
      MyUtils().check().then((intenet) {
        if (intenet != null && intenet) {
          MySharePreference()
              .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
              .then((valueToken) {
            if (!valueToken.isEmpty) {
              _addUpdateAccountPresenter = new AddUpdateAccountPresenter(this);

              updateAddBtnClick = true;

              if (accountID.isEmpty) {
                //Create Account if not created
                _addUpdateAccountPresenter.doCreateAccount(context,
                    addUpdateAccountPayload(country, bankAccType), valueToken);
              } else {
                //Update Account if already created
                _addUpdateAccountPresenter.doUpdateAccount(
                    context,
                    addUpdateAccountPayload(country, bankAccType),
                    accountID,
                    valueToken);
              }
            }
          });
        } else {
          MyUtils().toastdisplay(
              AppLocalizations.of(context).translate('msg_no_internet'));
        }
      });
    }
  }

  Map addUpdateAccountPayload(String country, String accType) {
    Map mapAccountDetails = RawDataCreate().addUpdateBankAccountPutRawMap(
        textOwnerNameController.text,
        textBankNameController.text,
        textAccNumberController.text,
        country,
        textSWIFTnumberController.text,
        textBranchNameController.text,
        textBranchAddressController.text,
        accType);

    return mapAccountDetails;
  }

  @override
  void onAccountError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onAccountSuccess(AccountPojo pojoData) {
    if (pojoData != null) {
      if (pojoData.detail != null) {
        MyUtils().toastdisplay(pojoData.detail);
      } else if (pojoData.results != null && pojoData.results.length > 0) {
        //Get first account details

        if (updateAddBtnClick) {
          //Redirect to previous screen
          MyUtils().toastdisplay(AppLocalizations.of(context)
              .translate('msg_account_details_success'));
          Navigator.pop(context);
        } else {
          ResultAccount resultAccount = pojoData.results[0];
          if (resultAccount != null && resultAccount.bankAccount != null) {
            BankAccount bankAccount = resultAccount.bankAccount;

            setState(() {
              accountID = resultAccount.id.toString();
              textOwnerNameController.text = bankAccount.ownerName;
              textBankNameController.text = bankAccount.bankName;
              textAccNumberController.text = bankAccount.number;
              textSWIFTnumberController.text = bankAccount.swift;
              textBranchNameController.text = bankAccount.branchName;
              textBranchAddressController.text = bankAccount.branchAddress;

              if (bankAccount.country != null) {
                dropdownCountryValue = listCountryDisplay[
                listCountryPassToApi.indexOf(bankAccount.country)];
              }

              if (bankAccount.type != null) {
                dropdownAccTypeValue = listAccTypeDisplay[
                listAccTypePassToApi.indexOf(bankAccount.type)];
              }
            });
          }
        }
      } else if (updateAddBtnClick) {
        MyUtils().toastdisplay(AppLocalizations.of(context)
            .translate('msg_account_details_success'));
        Navigator.pop(context);
      }
    }
  }

  @override
  void onGetValuesError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onGetValuesSuccess(GetValuesPojo pojoData) {
    dropdownCountryValue =
        AppLocalizations.of(context).translate("dropdown_bank_country_default");
    dropdownAccTypeValue =
        AppLocalizations.of(context).translate("dropdown_acc_type_default");

    if (pojoData != null) {
      if (pojoData.country != null) {
        Map<String, String> _mapData = pojoData.countriesWithPresence.toJsonStringType();
        listCountryPassToApi.addAll(_mapData.keys.toList());
        listCountryDisplay.addAll(_mapData.values.toList());
      }

      if (pojoData.bankAccountType != null) {
        Map<String, String> _mapData =
        pojoData.bankAccountType.toJsonStringType();
        listAccTypePassToApi.addAll(_mapData.keys.toList());
        listAccTypeDisplay.addAll(_mapData.values.toList());
      }
    }

    setState(() {
      //Reload dropdownvalue
    });
  }
}
