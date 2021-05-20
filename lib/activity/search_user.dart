import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixell_app/activity/search_filter_user_result.dart';
import 'package:pixell_app/activity/select_checkbox_other.dart';
import 'package:pixell_app/activity/select_radio_value.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/get_values_pojo.dart';
import 'package:pixell_app/presenter/get_values_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/range_slider_data.dart';
import 'package:pixell_app/utils/share_preference.dart';

import 'first_screen.dart';

class SearchUser extends StatefulWidget {
  SearchUser({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _SearchUserStateful();
  }
}

class _SearchUserStateful extends State<SearchUser>
    implements GetValuesContract {
  GetValuesPresenter _getValuesPresenter;

  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  List<String> listCountryDisplay = [];
  List<String> listCountryPassToApi = [];

  List<String> listGenderDisplay = [];
  List<String> listGenderPassToApi = [];

  List<String> listEthnicityDisplay = [];
  List<String> listEthnicityPassToApi = [];

  List<String> listbodyDisplay = [];
  List<String> listBodyPassToApi = [];

  List<String> listAdultDisplay = [];
  List<String> listAdultPassToApi = [];

  List<String> selectedFilterDisplayList = [];
  List<String> selectedFilterApiList = [];

  String selectedGenderValue = '';
  String selectedCountryValue = '';
  String selectedEthnicityValue = '';
  String selectedBodyValue = '';
  String selectedAdultValue = '';
  bool isLogin = false;

  String clickNextMoveType = "";
  String defaultTempValue = "";

  MyRangeSliderData rangeAgeSliders;
  MyRangeSliderData rangeHeightSliders;

  int backPress = 0;

  @override
  void initState() {
    backPress = 0;

    rangeAgeSliders = _rangeAgeSliderDefinitions();
    rangeHeightSliders = _rangeHeightSliderDefinitions();

    checkIsLogin();

    _getValuesPresenter = new GetValuesPresenter(this);

    MyUtils().check().then((intenet) {
      setDefaultValue();

      if (intenet != null && intenet) {
        _getValuesPresenter.doGetValues(context);
      } else {
        MyUtils().toastdisplay(
            AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });

    super.initState();
  }

  void setDefaultValue() {
    defaultTempValue =
        AppLocalizations.of(context).translate('label_not_selected');
    selectedGenderValue = defaultTempValue;
    selectedCountryValue = defaultTempValue;
    selectedEthnicityValue = defaultTempValue;
    selectedBodyValue = defaultTempValue;
    selectedAdultValue = defaultTempValue;
  }

  @override
  Widget build(BuildContext context) {
    Widget topbar = new Container(
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
                    _backPressApp(context);
                  }),
          Text(
            AppLocalizations.of(context).translate("label_search_users"),
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
                new Divider(
                  color: MyUtils()
                      .getColorFromHex(MyConstants.color_forward_arrow),
                  height: MyConstants.height_devider,
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        MyConstants.layout_margin,
                        0,
                        MyConstants.layout_margin,
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('label_gender'),
                            textAlign: TextAlign.start,
                            style: MyConstants.textStyle_searchFilterHeader,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                selectedGenderValue,
                                textAlign: TextAlign.end,
                                style: MyConstants.textStyle_searchFilterValue,
                              ),
                              InkResponse(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      MyConstants.space_5,
                                      MyConstants.vertical_control_space,
                                      0.0,
                                      MyConstants.vertical_control_space),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: MyConstants.title_filter_text_size,
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_forward_arrow),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    clickNextMoveType =
                        AppLocalizations.of(context).translate('label_gender');
                    _navigateAndDisplaySelection(context);
                  },
                ),
                new Divider(
                  color: MyUtils()
                      .getColorFromHex(MyConstants.color_forward_arrow),
                  height: MyConstants.height_devider,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      MyConstants.layout_margin,
                      MyConstants.vertical_control_space +
                          MyConstants.vertical_control_space_half,
                      MyConstants.layout_margin,
                      MyConstants.vertical_control_space),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).translate('label_age'),
                      textAlign: TextAlign.left,
                      style: MyConstants.textStyle_searchFilterHeader,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      MyConstants.layout_margin,
                      0,
                      MyConstants.layout_margin,
                      MyConstants.vertical_control_space),
                  child: Column(
                      children: <Widget>[]..addAll(_buildRangeSliders())),
                ),
                new Divider(
                  color: MyUtils()
                      .getColorFromHex(MyConstants.color_forward_arrow),
                  height: MyConstants.height_devider,
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        MyConstants.layout_margin,
                        0,
                        MyConstants.layout_margin,
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('label_country'),
                            textAlign: TextAlign.start,
                            style: MyConstants.textStyle_searchFilterHeader,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Flexible(
                                child: new Container(
                                  padding: new EdgeInsets.all(0),
                                  child: Text(
                                    selectedCountryValue,
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        MyConstants.textStyle_searchFilterValue,
                                  ),
                                ),
                              ),
                              InkResponse(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      MyConstants.space_5,
                                      MyConstants.vertical_control_space,
                                      0.0,
                                      MyConstants.vertical_control_space),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: MyConstants.title_filter_text_size,
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_forward_arrow),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    clickNextMoveType =
                        AppLocalizations.of(context).translate('label_country');
                    _navigateAndDisplaySelection(context);
                  },
                ),
                new Divider(
                  color: MyUtils()
                      .getColorFromHex(MyConstants.color_forward_arrow),
                  height: MyConstants.height_devider,
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        MyConstants.layout_margin,
                        0,
                        MyConstants.layout_margin,
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('label_ethnicity'),
                            textAlign: TextAlign.start,
                            style: MyConstants.textStyle_searchFilterHeader,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Flexible(
                                child: new Container(
                                  padding: new EdgeInsets.all(0),
                                  child: Text(
                                    selectedEthnicityValue,
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        MyConstants.textStyle_searchFilterValue,
                                  ),
                                ),
                              ),
                              InkResponse(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      MyConstants.space_5,
                                      MyConstants.vertical_control_space,
                                      0.0,
                                      MyConstants.vertical_control_space),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: MyConstants.title_filter_text_size,
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_forward_arrow),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    clickNextMoveType = AppLocalizations.of(context)
                        .translate('label_ethnicity');
                    _navigateAndDisplaySelection(context);
                  },
                ),
                new Divider(
                  color: MyUtils()
                      .getColorFromHex(MyConstants.color_forward_arrow),
                  height: MyConstants.height_devider,
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        MyConstants.layout_margin,
                        0,
                        MyConstants.layout_margin,
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('label_body'),
                            textAlign: TextAlign.start,
                            style: MyConstants.textStyle_searchFilterHeader,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Flexible(
                                child: new Container(
                                  padding: new EdgeInsets.all(0),
                                  child: Text(
                                    selectedBodyValue,
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        MyConstants.textStyle_searchFilterValue,
                                  ),
                                ),
                              ),
                              InkResponse(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      MyConstants.space_5,
                                      MyConstants.vertical_control_space,
                                      0.0,
                                      MyConstants.vertical_control_space),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: MyConstants.title_filter_text_size,
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_forward_arrow),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    clickNextMoveType =
                        AppLocalizations.of(context).translate('label_body');
                    _navigateAndDisplaySelection(context);
                  },
                ),
                new Divider(
                  color: MyUtils()
                      .getColorFromHex(MyConstants.color_forward_arrow),
                  height: MyConstants.height_devider,
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        MyConstants.layout_margin,
                        0,
                        MyConstants.layout_margin,
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('label_is_selling_adult'),
                            textAlign: TextAlign.start,
                            style: MyConstants.textStyle_searchFilterHeader,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Flexible(
                                child: new Container(
                                  padding: new EdgeInsets.all(0),
                                  child: Text(
                                    selectedAdultValue,
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        MyConstants.textStyle_searchFilterValue,
                                  ),
                                ),
                              ),
                              InkResponse(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      MyConstants.space_5,
                                      MyConstants.vertical_control_space,
                                      0.0,
                                      MyConstants.vertical_control_space),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: MyConstants.title_filter_text_size,
                                    color: MyUtils().getColorFromHex(
                                        MyConstants.color_forward_arrow),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    clickNextMoveType = AppLocalizations.of(context)
                        .translate('label_is_selling_adult');
                    _navigateAndDisplaySelection(context);
                  },
                ),
                new Divider(
                  color: MyUtils()
                      .getColorFromHex(MyConstants.color_forward_arrow),
                  height: MyConstants.height_devider,
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(
                      0.0, MyConstants.space_50, 0.0, 0.0),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(MyConstants.layout_margin,
                      0, MyConstants.layout_margin, MyConstants.space_20),
                  child: SizedBox(
                    height: MyConstants.btn_height,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () {
                        //Get selected value
                        getFilteredUrl();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchFilterUserResult(
                                selectedFilterDisplayList:
                                    selectedFilterDisplayList,
                                selectedFilterApiList: selectedFilterApiList,
                              ),
                            ));
                      },
                      color: MyUtils().getColorFromHex(MyConstants.color_theme),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("label_apply_filters"),
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

    Widget body = new Column(
      // This makes each child fill the full width of the screen
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        topbar,
        middleSection,
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
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg),
      body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: body,
      ),
    );
  }

  Future<bool> _backPressApp(BuildContext context) {
     if (backPress > 0) {
      SystemNavigator.pop();
    } else {
       Navigator.pop(context, true);
      //Navigator.of(context).popUntil((route) => route.isFirst);
    }

    //Navigator.pop(context, true);

    backPress++;
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  String getFilteredUrl() {
    String filterUrl = "";
    String gender = "";
    String country = "";
    String race = "";
    String body = "";

    selectedFilterDisplayList.clear();
    selectedFilterApiList.clear();

    List<String> selectedValueArray = [];

    //For to filter by Gender
    if (!selectedGenderValue.isEmpty &&
        selectedGenderValue != defaultTempValue &&
        selectedGenderValue != MyConstants.ANY) {
      if (listGenderDisplay.length > 0 &&
          listGenderDisplay.contains(selectedGenderValue)) {
        gender =
            listGenderPassToApi[listGenderDisplay.indexOf(selectedGenderValue)];

        filterUrl = filterUrl + "&profile__gender=" + gender;

        selectedFilterDisplayList.add(selectedGenderValue);
        selectedFilterApiList.add("&profile__gender=" + gender);
      }
    }

    //For to filter by Country
    if (!selectedCountryValue.isEmpty &&
        selectedCountryValue != defaultTempValue &&
        listCountryDisplay.length > 0) {
      selectedValueArray = selectedCountryValue.split(',');

      for (var i = 0; i < selectedValueArray.length; i++) {
        country = listCountryPassToApi[
            listCountryDisplay.indexOf(selectedValueArray[i])];
        filterUrl = filterUrl + "&profile__country=" + country;

        selectedFilterDisplayList.add(selectedValueArray[i]);
        selectedFilterApiList.add("&profile__country=" + country);
      }
    }

    //For to filter by Ethnicity
    if (!selectedEthnicityValue.isEmpty &&
        selectedEthnicityValue != defaultTempValue &&
        listEthnicityDisplay.length > 0) {
      selectedValueArray = selectedEthnicityValue.split(',');

      for (var i = 0; i < selectedValueArray.length; i++) {
        race = listEthnicityPassToApi[
            listEthnicityDisplay.indexOf(selectedValueArray[i])];
        filterUrl = filterUrl + "&profile__physical_appearance__race=" + race;

        selectedFilterDisplayList.add(selectedValueArray[i]);
        selectedFilterApiList
            .add("&profile__physical_appearance__race=" + race);
      }
    }

    //For to filter by Body
    if (!selectedBodyValue.isEmpty &&
        selectedBodyValue != defaultTempValue &&
        listbodyDisplay.length > 0) {
      selectedValueArray = selectedBodyValue.split(',');

      for (var i = 0; i < selectedValueArray.length; i++) {
        body =
            listBodyPassToApi[listbodyDisplay.indexOf(selectedValueArray[i])];
        filterUrl = filterUrl + "&profile__physical_appearance__body=" + body;

        selectedFilterDisplayList.add(selectedValueArray[i]);
        selectedFilterApiList
            .add("&profile__physical_appearance__body=" + body);
      }
    }

    //For to filter by Audlt
    if (!selectedAdultValue.isEmpty && selectedAdultValue != defaultTempValue) {
      if (listAdultDisplay.length > 0 &&
          listAdultDisplay.contains(selectedAdultValue)) {
        gender =
            listAdultPassToApi[listAdultDisplay.indexOf(selectedAdultValue)];

        filterUrl = filterUrl + "&profile__is_selling_adult_content=" + gender;

        selectedFilterDisplayList.add(selectedAdultValue);
        selectedFilterApiList
            .add("&profile__is_selling_adult_content=" + gender);
      }
    }

    //For to filter by Age
    if (rangeAgeSliders != null && !rangeAgeSliders.lowerValueText.isEmpty) {
      filterUrl = filterUrl + "&min_age=" + rangeAgeSliders.lowerValueText;
      filterUrl = filterUrl + "&max_age=" + rangeAgeSliders.upperValueText;

      selectedFilterDisplayList
          .add(AppLocalizations.of(context).translate("label_min_age")+": " + rangeAgeSliders.lowerValueText);
      selectedFilterApiList.add("&min_age=" + rangeAgeSliders.lowerValueText);

      selectedFilterDisplayList
          .add(AppLocalizations.of(context).translate("label_max_age")+": "  + rangeAgeSliders.upperValueText);
      selectedFilterApiList.add("&max_age=" + rangeAgeSliders.upperValueText);
    }

    //For to filter by Height
    if (rangeHeightSliders != null &&
        !rangeHeightSliders.lowerValueText.isEmpty) {
      filterUrl = filterUrl +
          "&profile__physical_appearance__height_cm__lte=" +
          rangeHeightSliders.upperValueText;
      filterUrl = filterUrl +
          "&profile__physical_appearance__height_cm__gte=" +
          rangeHeightSliders.lowerValueText;

      selectedFilterDisplayList
          .add(AppLocalizations.of(context).translate("label_height_lte")+": "  + rangeHeightSliders.upperValueText);
      selectedFilterApiList.add(
          "&profile__physical_appearance__height_cm__lte=" +
              rangeHeightSliders.upperValueText);

      selectedFilterDisplayList
          .add(AppLocalizations.of(context).translate("label_height_gte")+": "  + rangeHeightSliders.lowerValueText);
      selectedFilterApiList.add(
          "&profile__physical_appearance__height_cm__gte=" +
              rangeHeightSliders.lowerValueText);
    }

    print("FILTERURL" + filterUrl);

    return filterUrl;
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    List<String> listDisplayTemp = [];
    List<String> listPassToApiTemp = [];
    List<String> clickSelectedValue = [];

    var result = null;

    if (clickNextMoveType ==
        AppLocalizations.of(context).translate('label_gender')) {
      listDisplayTemp = listGenderDisplay;
      listPassToApiTemp = listGenderPassToApi;
      clickSelectedValue = selectedGenderValue.split(',');

      result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectRadioFilter(
                  typeTitle: "GENDER",
                  typeTitleDisplay: AppLocalizations.of(context).translate('label_gender'),
                  listDisplayRadio: listDisplayTemp,
                  listPassToApiRadio: listPassToApiTemp,
                  previousSelectedValue: clickSelectedValue,
                )),
      );
    } else if (clickNextMoveType ==
        AppLocalizations.of(context).translate('label_is_selling_adult')) {
      listDisplayTemp = listAdultDisplay;
      listPassToApiTemp = listAdultPassToApi;
      clickSelectedValue = selectedAdultValue.split(',');

      result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectRadioFilter(
                  typeTitle: "ADULT",
              typeTitleDisplay: AppLocalizations.of(context).translate('label_is_selling_adult'),
                  listDisplayRadio: listDisplayTemp,
                  listPassToApiRadio: listPassToApiTemp,
                  previousSelectedValue: clickSelectedValue,
                )),
      );
    } else {
      if (clickNextMoveType ==
          AppLocalizations.of(context).translate('label_ethnicity')) {
        listDisplayTemp = listEthnicityDisplay;
        listPassToApiTemp = listEthnicityPassToApi;
        clickSelectedValue = selectedEthnicityValue.split(',');
      } else if (clickNextMoveType ==
          AppLocalizations.of(context).translate('label_country')) {
        listDisplayTemp = listCountryDisplay;
        listPassToApiTemp = listCountryPassToApi;
        clickSelectedValue = selectedCountryValue.split(',');
      } else if (clickNextMoveType ==
          AppLocalizations.of(context).translate('label_body')) {
        listDisplayTemp = listbodyDisplay;
        listPassToApiTemp = listBodyPassToApi;
        clickSelectedValue = selectedBodyValue.split(',');
      }

      result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectCheckboxType(
                  typeTitle: clickNextMoveType,
                  listDisplay: listDisplayTemp,
                  listPassToApi: listPassToApiTemp,
                  previousSelectedValue: clickSelectedValue,
                )),
      );
    }

    if (clickNextMoveType ==
        AppLocalizations.of(context).translate('label_gender')) {
      if (result == "") {
        selectedGenderValue = defaultTempValue;
      } else {
        selectedGenderValue = result;
      }
    } else if (clickNextMoveType ==
        AppLocalizations.of(context).translate('label_country')) {
      if (result == "") {
        selectedCountryValue = defaultTempValue;
      } else {
        selectedCountryValue = result;
      }
    } else if (clickNextMoveType ==
        AppLocalizations.of(context).translate('label_ethnicity')) {
      if (result == "") {
        selectedEthnicityValue = defaultTempValue;
      } else {
        selectedEthnicityValue = result;
      }
    } else if (clickNextMoveType ==
        AppLocalizations.of(context).translate('label_body')) {
      if (result == "") {
        selectedBodyValue = defaultTempValue;
      } else {
        selectedBodyValue = result;
      }
    } else if (clickNextMoveType ==
        AppLocalizations.of(context).translate('label_is_selling_adult')) {
      if (result == "") {
        selectedAdultValue = defaultTempValue;
      } else {
        selectedAdultValue = result;
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

      listAdultDisplay.add(AppLocalizations.of(context).translate('label_yes'));
      listAdultPassToApi.add("yes");

      listAdultDisplay.add(AppLocalizations.of(context).translate('label_no'));
      listAdultPassToApi.add("no");
    }
  }

  void checkIsLogin() {
    MySharePreference()
        .getBoolInPref(MyConstants.PREF_KEY_ISLOGIN)
        .then((valueIsLogedIn) {
      if (this.mounted) {
        setState(() {
          isLogin = valueIsLogedIn;
        });
      }
    });
  }

  // -----------------------------------------------
  // Creates a list of RangeSliders, based on their
  // definition and SliderTheme customizations
  // -----------------------------------------------
  List<Widget> _buildRangeSliders() {
    List<Widget> children = <Widget>[];

    //Add age Range slider
    children.add(rangeAgeSliders.build(context, (double lower, double upper) {
      // adapt the RangeSlider lowerValue and upperValue
      if (this.mounted) {
        setState(() {
          rangeAgeSliders.lowerValue = lower;
          rangeAgeSliders.upperValue = upper;
        });
      }
    }));
    // Add an extra padding at the bottom of each RangeSlider
    children.add(SizedBox(height: 8.0));

    children.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(
            0.0,
            MyConstants.vertical_control_space +
                MyConstants.vertical_control_space_half,
            0.0,
            MyConstants.vertical_control_space),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context).translate('label_height_text'),
            textAlign: TextAlign.left,
            style: MyConstants.textStyle_searchFilterHeader,
          ),
        ),
      ),
    );

    //Add age Height slider
    children
        .add(rangeHeightSliders.build(context, (double lower, double upper) {
      // adapt the RangeSlider lowerValue and upperValue
      if (this.mounted) {
        setState(() {
          rangeHeightSliders.lowerValue = lower;
          rangeHeightSliders.upperValue = upper;
        });
      }
    }));
    // Add an extra padding at the bottom of each RangeSlider
    children.add(SizedBox(height: 8.0));

    return children;
  }

  // -------------------------------------------------
  // Creates Age slider
  // -------------------------------------------------
  MyRangeSliderData _rangeAgeSliderDefinitions() {
    return MyRangeSliderData(
      min: 18.0,
      max: 90.0,
      lowerValue: 25.0,
      upperValue: 70.0,
      showValueIndicator: true,
      valueIndicatorMaxDecimals: 0,
      thumbColor: MyUtils().getColorFromHex(MyConstants.color_theme),
      activeTrackColor: MyUtils().getColorFromHex(MyConstants.color_theme),
      inactiveTrackColor:
          MyUtils().getColorFromHex(MyConstants.color_range_slider),
      valueIndicatorColor: MyUtils().getColorFromHex(MyConstants.color_theme),
    );
  }

  // -------------------------------------------------
  // Creates Height slider
  // -------------------------------------------------
  MyRangeSliderData _rangeHeightSliderDefinitions() {
    return MyRangeSliderData(
      min: 90.0,
      max: 200.0,
      lowerValue: 100.0,
      upperValue: 190.0,
      showValueIndicator: true,
      valueIndicatorMaxDecimals: 0,
      thumbColor: MyUtils().getColorFromHex(MyConstants.color_theme),
      activeTrackColor: MyUtils().getColorFromHex(MyConstants.color_theme),
      inactiveTrackColor:
          MyUtils().getColorFromHex(MyConstants.color_range_slider),
      valueIndicatorColor: MyUtils().getColorFromHex(MyConstants.color_theme),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
