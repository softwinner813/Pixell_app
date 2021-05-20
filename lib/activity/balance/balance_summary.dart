import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_geolocation/geolocation.dart';
import 'package:pixell_app/activity/edit_profile.dart';
import 'package:pixell_app/activity/search_user.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/balance_summary_pojo.dart';
import 'package:pixell_app/models/get_hints_pojo.dart';
import 'package:pixell_app/models/get_rates_pojo.dart';
import 'package:pixell_app/models/get_user_derails.dart';
import 'package:pixell_app/models/get_values_pojo.dart';
import 'package:pixell_app/models/redeem_pojo.dart';
import 'package:pixell_app/presenter/balance_summary_presenter.dart';
import 'package:pixell_app/presenter/get_hints_presenter.dart';
import 'package:pixell_app/presenter/get_rates_presenter.dart';
import 'package:pixell_app/presenter/get_userdetails_presenter.dart';
import 'package:pixell_app/presenter/get_values_presenter.dart';
import 'package:pixell_app/presenter/redeem_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

import '../first_screen.dart';

class BalanceSummary extends StatefulWidget {
  BalanceSummary({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BalanceSummaryStateful();
  }
}

class _BalanceSummaryStateful extends State<BalanceSummary>
    implements
        BalanceSummaryContract,
        GetRatesContract,
        RedeemContract,
        GetUserDetailsContract,
        GetValuesContract,
        GetHintsContract {
  BalanceSummaryPresenter _balanceSummaryPresenter;
  GetUserDetailsPresenter _getUserDetailsPresenter;
  GetRatesPresenter _getRatesPresenter;
  GetHintsPojo _hintsPojo;

  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();
  BalanceSummaryPojo _balanceSummaryPojo = null;

  List<String> listRedeemTypeDisplay = [];
  List<String> listRedeemTypePassToApi = [];

  bool isLogin = false;
  int loginUserId;
  double spaceBetweenRequests = 2.0;
  String tokenLogin = "";
  String myCurrencyName = "";
  double pixellRates = 0.0;
  double extraSpaceHandle = 40;
  bool isReddemBtnClick = false;

  Position _currentPosition;
  String _currentAddress;
  int _groupValue = 1;

  @override
  void initState() {
    checkIsLogin();

    _balanceSummaryPresenter = new BalanceSummaryPresenter(this);
    _getUserDetailsPresenter = new GetUserDetailsPresenter(this);

    _getCurrentLocation();

    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        //First check user is Seller or Buyer

        MySharePreference()
            .getStringInPref(MyConstants.PREF_IS_SELLER)
            .then((valueIsSeller) {
          if (!valueIsSeller.isEmpty) {
            //Get values for redeem type
            GetValuesPresenter _getValuesPresenter = GetValuesPresenter(this);
            _getValuesPresenter.doGetValues(context);
            // Get hints
            GetHintsPresenter _getHintsPresenter = GetHintsPresenter(this);
            _getHintsPresenter.doGetHints(context);
            //If Seller
            _callApiGetRates_Summary();
          } else {
            MySharePreference()
                .getIntegerInPref(MyConstants.PREF_KEY_USERID)
                .then((valueUserId) {
              if (valueUserId != -1) {
                _getUserDetailsPresenter.doGetUserDetails(context, valueUserId);
              }
            });
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
          isLogin
              ? new Container(
                  margin: new EdgeInsets.fromLTRB(15, 0.0, 0.0, 0.0),
                )
              : new IconButton(
                  icon: new Image.asset(
                    'graphics/arrow-left.png',
                    height: MyConstants.toolbar_icon_height_width,
                    width: MyConstants.toolbar_icon_height_width,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context, true);
                  }),
          Text(
            AppLocalizations.of(context).translate("label_balance"),
            style: TextStyle(
                fontSize: MyConstants.toolbar_text_size, color: Colors.white),
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

    Widget bottomBanner = new GestureDetector(
        onTap: () {},
        child: new Container(
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    child: new Column(
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchUser(),
                          ))
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: new Column(
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
            image: new DecorationImage(
              image: new AssetImage('graphics/surface_bottom_tab.png'),
              fit: BoxFit.fill,
            ),
          ),
        ));

    Widget body = Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: (_balanceSummaryPojo != null)
                ? SingleChildScrollView(
                    padding: EdgeInsets.only(
                        top: MyConstants.topbar_height - extraSpaceHandle,
                        bottom: MyConstants.bottombar_height),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _summarySection()),
                  )
                : Center(child: CircularProgressIndicator()),
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

  List<Widget> _summarySection() {
    List<Widget> lines = [];

    if (_balanceSummaryPojo != null) {
      if (_balanceSummaryPojo.earned != null) {
        lines.add(_balanceCreditRow(
            AppLocalizations.of(context).translate("label_credit"),
            _balanceSummaryPojo.earned,
            true,
            Colors.black));
        lines.add(Container(
          margin: EdgeInsets.all(8.0),
        ));
      }

      if (_balanceSummaryPojo.earnedPending != null) {
        lines.add(_balanceRow(
            AppLocalizations.of(context).translate("label_pending_point"),
            _balanceSummaryPojo.earnedPending,
            false,
            MyUtils().getColorFromHex(MyConstants.color_alert_top),
            Colors.black,
            "pending_point"));

        lines.add(Container(
          margin: EdgeInsets.all(8.0),
        ));
      }
      if (_balanceSummaryPojo.redeemedPending != null) {
        lines.add(_balanceRow(
            AppLocalizations.of(context).translate("label_waiting_redeem"),
            _balanceSummaryPojo.redeemedPending,
            false,
            MyUtils().getColorFromHex(MyConstants.color_E2A604),
            Colors.black,
            "waiting_for_redeem"));
        lines.add(Container(
          margin: EdgeInsets.all(8.0),
        ));
      }
      if (_balanceSummaryPojo.redeemed != null) {
        lines.add(_balanceRow(
            AppLocalizations.of(context).translate("label_redeemed"),
            _balanceSummaryPojo.redeemed,
            false,
            MyUtils().getColorFromHex(MyConstants.color_835F00),
            Colors.white,
            "redeemed"));
        lines.add(Container(
          margin: EdgeInsets.all(8.0),
        ));
      }
    }

    return lines;
  }

  _balanceCreditRow(
      String title, double getAmount, bool needReddem, textColor) {
    return new Container(
      width: double.infinity,
      padding: new EdgeInsets.fromLTRB(
          MyConstants.vertical_control_space,
          MyConstants.vertical_control_space + extraSpaceHandle,
          MyConstants.vertical_control_space,
          MyConstants.vertical_control_space),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MyUtils().getColorFromHex(MyConstants.color_alert_top),
            MyUtils().getColorFromHex(MyConstants.color_E2A604)
          ],
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.all(spaceBetweenRequests),
                    ),
                    InkWell(
                      onTap: () {
                        MyUtils().customAlertHintDialogBox(context, 'graphics/icon-pixell-point-white.png', _hintsPojo, "credit");
                      },
                      child: Image.asset(
                        'graphics/icon-info-white.png',
                        height: MyConstants.bottomtab_icn_height_width,
                        width: MyConstants.bottomtab_icn_height_width,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          getAmount.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              height: 1,
                              fontSize: 60),
                        ),
                        Container(
                          margin: EdgeInsets.all(2.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MyConstants.padding_request_detail_price),
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                'graphics/icon-pixell-point-white.png',
                                height: MyConstants.bottomtab_icn_height_width,
                                width: MyConstants.bottomtab_icn_height_width,
                                color: textColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MyConstants.vertical_control_space_half,
                          bottom: MyConstants.vertical_control_space_half),
                      child: Text(
                        "= " +
                            myCurrencyName +
                            " " +
                            pixellPointToPriceConvert(getAmount.toString()),
                        style: new TextStyle(
                          fontSize:
                              MyConstants.font_size_request_detail_countrycode,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: (needReddem && isReddemBtnClick),
                  child: _widgetEnterPoints(),
                ),
                Visibility(
                  visible: (needReddem),
                  child: _widgetReddemBtn(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _balanceRow(
      String title, double getAmount, bool needReddem, bgColor, textColor, hintId) {
    return new Container(
      margin: const EdgeInsets.only(
        left: MyConstants.layout_margin,
        right: MyConstants.layout_margin,
      ),
      width: double.infinity,
      padding: new EdgeInsets.all(MyConstants.vertical_control_space),
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.circular(5.0),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.all(spaceBetweenRequests),
                    ),
                    InkWell(
                      onTap: () {
                        MyUtils().customAlertHintDialogBox(context, 'graphics/icon-pixell-point-white.png', _hintsPojo, hintId);
                      },
                      child: Image.asset(
                        'graphics/icon-info-white.png',
                        height: MyConstants.bottomtab_icn_height_width,
                        width: MyConstants.bottomtab_icn_height_width,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: AutoSizeText(
                        getAmount.toString(),
                        maxLines: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            height: 1,
                            fontSize:
                                MyConstants.font_size_request_detail_price),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(2.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MyConstants.padding_request_detail_price),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'graphics/icon-pixell-point-white.png',
                            height: MyConstants.bottomtab_icn_height_width,
                            width: MyConstants.bottomtab_icn_height_width,
                            color: textColor,
                          ),
                          Container(
                            margin: new EdgeInsets.all(spaceBetweenRequests),
                          ),
                          Text(
                            "= " +
                                myCurrencyName +
                                " " +
                                pixellPointToPriceConvert(getAmount.toString()),
                            style: new TextStyle(
                              fontSize: MyConstants
                                  .font_size_request_detail_countrycode,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _widgetEnterPoints() {
    return new Padding(
      padding: EdgeInsets.only(top: MyConstants.vertical_control_space),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              listRedeemTypeDisplay.length > 0
                  ? _myRadioButton(
                      title: listRedeemTypeDisplay[0],
                      value: 0,
                      onChanged: (newValue) =>
                          setState(() => _groupValue = newValue),
                    )
                  : Container(),
              listRedeemTypeDisplay.length > 1
                  ? _myRadioButton(
                      title: listRedeemTypeDisplay[1],
                      value: 1,
                      onChanged: (newValue) =>
                          setState(() => _groupValue = newValue),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return Flexible(
      fit: FlexFit.loose,
      child: RadioListTile(
        activeColor: Colors.black,
        value: value,
        groupValue: _groupValue,
        onChanged: onChanged,
        title: Text(title,
            style: TextStyle(
              fontSize: MyConstants.title_filter_text_size,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  _widgetReddemBtn() {
    return new Padding(
      padding: EdgeInsets.only(top: MyConstants.vertical_control_space),
      child: SizedBox(
        height: MyConstants.btn_height,
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () {
            if (isReddemBtnClick) {
              MyUtils().check().then((intenet) {
                if (intenet != null && intenet) {
                  RedeemPresenter redeemPresenterCall =
                      new RedeemPresenter(this);
                  redeemPresenterCall.doRedeem(context, myCurrencyName,
                      listRedeemTypePassToApi[_groupValue], tokenLogin);
                } else {
                  MyUtils().toastdisplay(AppLocalizations.of(context)
                      .translate('msg_no_internet'));
                }
              });
            }

            setState(() {
              isReddemBtnClick = true;
            });
          },
          color: isReddemBtnClick
              ? MyUtils().getColorFromHex(MyConstants.color_835F00)
              : MyUtils().getColorFromHex(MyConstants.color_gray_button),
          child: Text(
            AppLocalizations.of(context).translate("label_btn_redeem"),
            style: TextStyle(
              fontSize: MyConstants.btn_round_text_size,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkIsLogin() {
    if (this.mounted) {
      MySharePreference()
          .getBoolInPref(MyConstants.PREF_KEY_ISLOGIN)
          .then((valueIsLogedIn) {
        isLogin = valueIsLogedIn;
        MySharePreference()
            .getIntegerInPref(MyConstants.PREF_KEY_USERID)
            .then((value) {
          setState(() {
            loginUserId = value;
          });
        });
      });
    }
  }

  String pixellPointToPriceConvert(String pixellPoint) {
    if (pixellPoint.isEmpty) {
      return "";
    } else {
      return (double.parse(pixellPoint) * pixellRates).toStringAsFixed(2);
    }
  }

  _getCurrentLocation() async {
    final GeolocationResult result =
        await Geolocation.requestLocationPermission(const LocationPermission(
      android: LocationPermissionAndroid.fine,
      ios: LocationPermissionIOS.always,
    ));

    LocationResult resultLocation = await Geolocation.lastKnownLocation();

    if (result.isSuccessful) {
      // location request successful, location is guaranteed to not be null
      double lat = resultLocation.location.latitude;
      double lng = resultLocation.location.longitude;

      _currentPosition = new Position(latitude: lat, longitude: lng);

      if (_currentPosition != null) {
        _getAddressFromLatLng();
      }
    } else {
      switch (result.error.type) {
        case GeolocationResultErrorType.runtime:
          // runtime error, check result.error.message
          break;
        case GeolocationResultErrorType.locationNotFound:
          // location request did not return any result
          break;
        case GeolocationResultErrorType.serviceDisabled:
          // location services disabled on device
          // might be that GPS is turned off, or parental control (android)
          break;
        case GeolocationResultErrorType.permissionDenied:
          // user denied location permission request
          // rejection is final on iOS, and can be on Android
          // user will need to manually allow the app from the settings
          break;
        case GeolocationResultErrorType.playServicesUnavailable:
          // android only
          // result.error.additionalInfo contains more details on the play services error
          switch (
              result.error.additionalInfo as GeolocationAndroidPlayServices) {
            // do something, like showing a dialog inviting the user to install/update play services
            case GeolocationAndroidPlayServices.missing:
            case GeolocationAndroidPlayServices.updating:
            case GeolocationAndroidPlayServices.versionUpdateRequired:
            case GeolocationAndroidPlayServices.disabled:
            case GeolocationAndroidPlayServices.invalid:
          }
          break;
      }
    }
  }

  _getAddressFromLatLng() async {
    try {
      var geolocator = Geolocator();

      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      _currentAddress =
          "${place.locality}, ${place.postalCode},${place.isoCountryCode}, ${place.country}";
      print("CURRENCY ADDRESS" + _currentAddress); // $

      setState(() {
        /*Locale deviceLocale = await DeviceLocale.getCurrentLocale();
        Locale locale = new Locale(deviceLocale.languageCode, place.isoCountryCode.toString());
        var format = NumberFormat.simpleCurrency(locale: locale.toString());

        print("CURRENCY SYMBOL ${format.currencySymbol}"); // $
        print("CURRENCY NAME ${format.currencyName}");*/

        String tempCurrencyName = MyUtils()
            .getCurrencyNameFromCountryCode(place.isoCountryCode.toString());
        print("CURRENCY NAME --- " + tempCurrencyName);

        if (!tempCurrencyName.isEmpty) {
          MySharePreference().saveStringInPref(
              MyConstants.PREF_KEY_CURRENCY_NAME, tempCurrencyName);
        }

        _callApiForGetRates();
      });
    } catch (e) {
      print(e);
    }
  }

  //Caall below api if login use be a Seller
  _callApiGetRates_Summary() {
    _callApiForGetRates();

    MySharePreference()
        .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
        .then((valueToken) {
      if (!valueToken.isEmpty) {
        tokenLogin = valueToken;
        _balanceSummaryPresenter.doBalanceSummary(context, tokenLogin);
      }
    });
  }

  _callApiForGetRates() {
    //Get Rates
    MySharePreference()
        .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
        .then((valueToken) {
      if (!valueToken.isEmpty) {
        tokenLogin = valueToken;
        MySharePreference()
            .getStringInPref(MyConstants.PREF_KEY_CURRENCY_NAME)
            .then((valueCurrencyName) {
          _getRatesPresenter = new GetRatesPresenter(this);

          if (!valueCurrencyName.isEmpty) {
            if (valueCurrencyName != myCurrencyName) {
              myCurrencyName = valueCurrencyName;

              _getRatesPresenter.doGetRates(
                  context, valueCurrencyName, valueToken);
            }
          } else {
            myCurrencyName = "USD";
            _getRatesPresenter.doGetRates(context, myCurrencyName, valueToken);
          }
        });
      }
    });
  }

  @override
  void onBalanceSummaryError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onBalanceSummarySuccess(BalanceSummaryPojo pojoData) {
    if (pojoData != null) {
      if (pojoData.detail != null) {
        MyUtils().toastdisplay(pojoData.detail);
      } else if (this.mounted) {
        setState(() {
          _balanceSummaryPojo = pojoData;
        });
      }
    }
  }

  @override
  void onGetRatesError(String errorTxt) {}

  @override
  void onGetRatesSuccess(GetRatesPojo pojodata) {
    if (pojodata != null) {
      if (this.mounted) {
        setState(() {
          pixellRates = pojodata.rate;
        });
      }
    }
  }

  @override
  void onRedeemError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onRedeemSuccess(RedeemPojo pojoData) {
    if (pojoData != null) {
      if (pojoData.detail != null) {
        MyUtils().toastdisplay(pojoData.detail);
      } else if (pojoData.success != null &&
          pojoData.success &&
          pojoData.data != null &&
          pojoData.data.redeemCash != null) {
        String dynamicMsgMIddleText = pojoData.data.redeemCash.toString() +
            " " +
            AppLocalizations.of(context)
                .translate("msg_bottom_redeem_middle_dialog") +
            " " +
            listRedeemTypePassToApi[_groupValue];

        String msgForRedeem = AppLocalizations.of(context)
                .translate("msg_bottom_redeem_first_dialog") +
            " " +
            dynamicMsgMIddleText +
            " " +
            AppLocalizations.of(context)
                .translate("msg_bottom_redeem_last_dialog");

        MyUtils().customAlertDialogBoxNew(
            context,
            'graphics/img-mailbox.png',
            AppLocalizations.of(context).translate("label_reset_top_dialog"),
            msgForRedeem,
            "",
            AppLocalizations.of(context).translate("label_close"));

        isReddemBtnClick = false;
        _balanceSummaryPresenter = new BalanceSummaryPresenter(this);
        _balanceSummaryPresenter.doBalanceSummary(context, tokenLogin);
      }
    }
  }

  @override
  void onDetailsError(String errorTxt) {}

  @override
  void onDetailsSuccess(GetUserDetailsPojo pojoData) {
    if (pojoData != null) {
      if (this.mounted) {
        setState(() {
          if (pojoData.profile != null &&
              pojoData.profile.isSeller != null &&
              pojoData.profile.isSeller) {
            MySharePreference().saveStringInPref(
                MyConstants.PREF_IS_SELLER, MyConstants.TEMP_YES_SELLER);

            _callApiGetRates_Summary();
          } else {
            customAlertDialogBeSeller(
                context,
                'graphics/info_large.png',
                AppLocalizations.of(context)
                    .translate("msg_top_be_seller_dialog"),
                AppLocalizations.of(context)
                    .translate("msg_bottom_be_seller_dialog"),
                "",
                AppLocalizations.of(context)
                    .translate("label_go_to_edit_profile"));
          }
        });
      }
    }
  }

  @override
  void onGetValuesError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onGetValuesSuccess(GetValuesPojo pojoData) {
    if (pojoData != null) {
      if (pojoData.redeemType != null) {
        Map<String, String> _mapData = pojoData.redeemType.toJsonStringType();
        listRedeemTypePassToApi.addAll(_mapData.keys.toList());
        listRedeemTypeDisplay.addAll(_mapData.values.toList());
      }
    }
  }

  @override
  void onGetHintsError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onGetHintsSuccess(GetHintsPojo pojoData) {
    if (pojoData != null) {
      _hintsPojo = pojoData;
    }
  }

  Future<void> customAlertDialogBeSeller(
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
                  top: MyConstants.topbar_height,
                  bottom: MediaQuery.of(context).size.width / 2.7,
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
                              height: 80,
                              width: 80,
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              bottomMsg,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Image.asset(
                              'graphics/alert_be_seller.png',
                              alignment: Alignment.center,
                            ),
                            InkWell(
                              child: Text(
                                buttonNameRight.toUpperCase(),
                                style: MyConstants.textStyle_dialog_btn,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                MyConstants.currentSelectedBottomTab = 4;

                                Navigator.push(
                                  mContext,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()),
                                );
                              },
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
