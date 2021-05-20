import 'package:flutter/material.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

import 'first_screen.dart';
import 'search_user.dart';

class SelectRadioFilter extends StatefulWidget {
  SelectRadioFilter(
      {Key key,
      this.typeTitle,
      this.typeTitleDisplay,
      this.listDisplayRadio,
      this.listPassToApiRadio,
      this.previousSelectedValue})
      : super(key: key);

  String typeTitle = "";
  String typeTitleDisplay = "";

  List<String> listDisplayRadio = [];
  List<String> listPassToApiRadio = [];

  List<String> previousSelectedValue = [];

  @override
  State<StatefulWidget> createState() {
    return new _SelectRadioFilterStateful();
  }
}

class _SelectRadioFilterStateful extends State<SelectRadioFilter> {
  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  int _currentIndex = -1;

  bool isLogin = false;
  bool isEnableClear = false;

  List<GroupModel> _radioGenderGroup = [];

  @override
  void initState() {
    checkIsLogin();
    setRadioValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget topbar = new Container(
      child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Expanded(child: Text(
            widget.typeTitleDisplay,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: MyConstants.toolbar_text_size, color: Colors.white),
          ),),
          Align(
            alignment: Alignment.centerRight,
            child: new IconButton(
                icon: new Image.asset(
                  'graphics/check.png',
                  height: MyConstants.toolbar_icon_height_width,
                  width: MyConstants.toolbar_icon_height_width,
                ),
                onPressed: () {
                  saveChanges();
                }),
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
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0.0),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: _radioGenderGroup.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      title: Text(
                        _radioGenderGroup[index].text,
                        style: MyConstants.textStyle_searchFilterHeader,
                      ),
                      value: _radioGenderGroup[index].index,
                      groupValue: _currentIndex,
                      onChanged: (val) {
                        setState(() {
                          isEnableClear = true;
                          _currentIndex = val;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return new Divider(
                      color: MyUtils()
                          .getColorFromHex(MyConstants.color_forward_arrow),
                      height: MyConstants.height_devider,
                    );
                  },
                ),
                new Divider(
                  color: MyUtils()
                      .getColorFromHex(MyConstants.color_forward_arrow),
                  height: MyConstants.height_devider,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Widget clearSection = new Align(
        alignment: Alignment.center,
        child: InkWell(
          child: Text(
            AppLocalizations.of(context).translate('label_clear_options'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MyConstants.title_text_size,
              color: MyUtils()
                  .getColorFromHex(MyConstants.color_theme)
                  .withOpacity(isEnableClear ? 1.0 : 0.5),
            ),
          ),
          onTap: () {
            if (isEnableClear) {
              clearChanges();
            }
          },
        ));

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
        clearSection,
        new Container(
          margin: new EdgeInsets.all(MyConstants.vertical_control_space_half),
        ),
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

    return new WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg),
        body: new Padding(
          padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: body,
        ),
      ),
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  void saveChanges() {
    if (_currentIndex >= 0) {
      Navigator.pop(context, _radioGenderGroup[_currentIndex].text);
    } else {
      Navigator.pop(context, "");
    }
  }

  void clearChanges() {
    setState(() {
      isEnableClear = false;
      _currentIndex = -1;
    });
  }

  void setRadioValue() {
    for (var i = 0; i < widget.listDisplayRadio.length; i++) {
      GroupModel groupModel = new GroupModel(
        text: widget.listDisplayRadio[i],
        textPassApi: widget.listPassToApiRadio[i],
        index: i,
      );

      if (widget.previousSelectedValue.contains(widget.listDisplayRadio[i])) {
        _currentIndex = i;
        isEnableClear = true;
      }

      _radioGenderGroup.add(groupModel);
    }

    onSetGenderAnyValue();
  }

  onSetGenderAnyValue() async {
    if (widget.typeTitle == "GENDER") {
      GroupModel groupModel = new GroupModel(
        text: MyConstants.ANY,
        textPassApi: "",
        index: widget.listDisplayRadio.length,
      );
      _radioGenderGroup.add(groupModel);

      if (widget.previousSelectedValue.contains(MyConstants.ANY)) {
        _currentIndex = 2;
        isEnableClear = true;
      }
    }
  }

  void checkIsLogin() {
    MySharePreference()
        .getBoolInPref(MyConstants.PREF_KEY_ISLOGIN)
        .then((valueIsLogedIn) {
      setState(() {
        isLogin = valueIsLogedIn;
      });
    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class GroupModel {
  String text;
  String textPassApi;
  int index;

  GroupModel({this.text, this.textPassApi, this.index});
}
