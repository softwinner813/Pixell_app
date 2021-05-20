import 'package:flutter/material.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

import '../first_screen.dart';
import '../search_user.dart';

class ChildRequestBuilder extends StatefulWidget {
  ChildRequestBuilder(
      {Key key,
      this.titleSelectedTree,
      this.childRequestTree,
      this.previousSelectedTreeId,
      this.previousSelectedName,
      this.previousSelectedParentName})
      : super(key: key);

  List<dynamic> childRequestTree;
  var titleSelectedTree = '';
  String previousSelectedName = "";
  int previousSelectedTreeId;
  bool isSelectedIdContains = false;
  String previousSelectedParentName = "";

  @override
  State<StatefulWidget> createState() {
    return new _ChildRequestBuilderStateful();
  }
}

class _ChildRequestBuilderStateful extends State<ChildRequestBuilder> {
  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  String selectedGenderValue = '';

  bool isLogin = false;

  String clickNextMoveType = "";
  String defaultTempValue = "";

  bool isEnableClear = false;
  List<GroupModel> _radioGenderGroup = [];
  List<dynamic> childChildrenDataForDisplay = [];
  int _currentIndex = -1;

  int tempRadioItemIndex = 0;

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
        children: <Widget>[
          new IconButton(
              icon: new Image.asset(
                'graphics/arrow-left.png',
                height: MyConstants.toolbar_icon_height_width,
                width: MyConstants.toolbar_icon_height_width,
              ),
              onPressed: () {
                saveChanges(false);
              }),
          Expanded(
            child: Text(
              widget.titleSelectedTree,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: MyConstants.toolbar_text_size, color: Colors.white),
            ),
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

    Widget _listRadioRadioItemForSelect = new ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0.0),
      primary: false,
      shrinkWrap: true,
      itemCount: _radioGenderGroup.length,
      itemBuilder: (context, index) {
        return RadioListTile(
          title: Text(
            _radioGenderGroup[index].titleDisplay,
            style: MyConstants.textStyle_searchFilterHeader,
          ),
          value: _radioGenderGroup[index].radioIndex,
          groupValue: _currentIndex,
          onChanged: (val) {
            setState(() {
              isEnableClear = true;
              _currentIndex = val;

              widget.previousSelectedParentName = "";
              widget.previousSelectedName =
                  _radioGenderGroup[_currentIndex].titleDisplay;
              widget.previousSelectedTreeId =
                  _radioGenderGroup[_currentIndex].treeId;

              if (widget.previousSelectedName != MyConstants.ANY) {
                widget.previousSelectedParentName = widget.previousSelectedName;
              }

              saveChanges(true);
            });
          },
          controlAffinity: ListTileControlAffinity.trailing,
        );
      },
      separatorBuilder: (context, index) {
        return new Divider(
          color: MyUtils().getColorFromHex(MyConstants.color_forward_arrow),
          height: MyConstants.height_devider,
        );
      },
    );

    Widget middleSection = new Expanded(
      child: new Container(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: (widget.childRequestTree != null &&
                    widget.childRequestTree.length > 0)
                ? Column(
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
                      Visibility(
                        child: Column(
                          children: <Widget>[
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(0.0),
                              primary: false,
                              shrinkWrap: true,
                              itemCount: childChildrenDataForDisplay.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        MyConstants.layout_margin,
                                        0,
                                        MyConstants.layout_margin,
                                        0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            childChildrenDataForDisplay[index]
                                                .data
                                                .name,
                                            textAlign: TextAlign.start,
                                            style: MyConstants
                                                .textStyle_searchFilterHeader,
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                selectedGenderValue,
                                                textAlign: TextAlign.end,
                                                style: MyConstants
                                                    .textStyle_searchFilterValue,
                                              ),
                                              InkResponse(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .fromLTRB(
                                                      MyConstants.space_5,
                                                      MyConstants
                                                          .vertical_control_space,
                                                      0.0,
                                                      MyConstants
                                                          .vertical_control_space),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: MyConstants
                                                        .title_filter_text_size,
                                                    color: MyUtils()
                                                        .getColorFromHex(MyConstants
                                                            .color_forward_arrow),
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
                                        AppLocalizations.of(context)
                                            .translate('label_gender');
                                    _navigateAndDisplaySelection(
                                        context, index);
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return new Divider(
                                  color: MyUtils().getColorFromHex(
                                      MyConstants.color_forward_arrow),
                                  height: MyConstants.height_devider,
                                );
                              },
                            ),
                            Divider(
                              color: MyUtils().getColorFromHex(
                                  MyConstants.color_forward_arrow),
                              height: MyConstants.height_devider,
                            ),
                          ],
                        ),
                        visible: (childChildrenDataForDisplay != null &&
                            childChildrenDataForDisplay.length > 0),
                      ),
                      Visibility(
                        child: Column(
                          children: <Widget>[
                            _listRadioRadioItemForSelect,
                            Divider(
                              color: MyUtils().getColorFromHex(
                                  MyConstants.color_forward_arrow),
                              height: MyConstants.height_devider,
                            ),
                          ],
                        ),
                        visible: (_radioGenderGroup != null &&
                            _radioGenderGroup.length > 0),
                      ),
                    ],
                  )
                : Container(),
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
            clearChanges();
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
        clearSection,
        Container(
          margin: EdgeInsets.all(MyConstants.vertical_control_space_half),
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
        saveChanges(false);
        return false;
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  _navigateAndDisplaySelection(BuildContext context, tapIndex) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    var result = null;

    result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChildRequestBuilder(
                titleSelectedTree: widget.childRequestTree[tapIndex].data.name,
                childRequestTree: widget.childRequestTree[tapIndex].children,
                previousSelectedTreeId: widget.previousSelectedTreeId,
                previousSelectedName: widget.previousSelectedName,
                previousSelectedParentName: widget.previousSelectedParentName,
              )),
    );

    if (result != null) {
      widget.previousSelectedName = result[0];
      widget.previousSelectedParentName = result[2];

      if (widget.previousSelectedParentName == MyConstants.ANY ||
          widget.previousSelectedParentName.isEmpty) {
        widget.previousSelectedParentName =
            widget.childRequestTree[tapIndex].data.name;
      }

      widget.previousSelectedTreeId = result[1];
      if (widget.previousSelectedTreeId == MyConstants.TEMP_TREE_ANY_ID) {
        widget.previousSelectedTreeId = widget.childRequestTree[tapIndex].id;
      }

      if (result[3]) {
        saveChanges(result[3]);
      }
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

  void saveChanges(clearAllBtwRoute) {
    /* if (_currentIndex >= 0 && _radioGenderGroup.length > 0) {
      Navigator.pop(context, [
        _radioGenderGroup[_currentIndex].titleDisplay,
        _radioGenderGroup[_currentIndex].treeId,
        _currentIndex
      ]);
    } else {
      Navigator.pop(context, [
        widget.previousSelectedName,
        widget.previousSelectedTreeId,
        _currentIndex
      ]);
    }*/

    Navigator.pop(context, [
      widget.previousSelectedName,
      widget.previousSelectedTreeId,
      widget.previousSelectedParentName,
      clearAllBtwRoute
    ]);
  }

  void clearChanges() {
    setState(() {
      isEnableClear = false;
      _currentIndex = -1;
      widget.previousSelectedName = "";
      widget.previousSelectedTreeId = MyConstants.TEMP_TREE_NOT_SELECTID;
    });
  }

  void setRadioValue() {
    childChildrenDataForDisplay.clear();
    _radioGenderGroup.clear();

    for (var i = 0; i < widget.childRequestTree.length; i++) {
      if (widget.childRequestTree[i].children == null) {
        GroupModel groupModel = new GroupModel(
            titleDisplay: widget.childRequestTree[i].data.name,
            treeId: widget.childRequestTree[i].id,
            radioIndex: i);

        if (widget.previousSelectedTreeId == widget.childRequestTree[i].id) {
          _currentIndex = i;
          isEnableClear = true;
        }

        _radioGenderGroup.add(groupModel);
      } else {
        childChildrenDataForDisplay.add(widget.childRequestTree[i]);
      }
    }

    //if (!_radioGenderGroup.isEmpty) {
    onSetRadioAnyValue(_radioGenderGroup.length);
    //}
  }

  onSetRadioAnyValue(tempSelectedIndex) async {
    GroupModel groupModel = new GroupModel(
        titleDisplay: MyConstants.ANY,
        treeId: MyConstants.TEMP_TREE_ANY_ID,
        radioIndex: tempSelectedIndex);
    _radioGenderGroup.add(groupModel);

    if ((widget.previousSelectedTreeId == MyConstants.TEMP_TREE_ANY_ID) ||
        (widget.previousSelectedTreeId != MyConstants.TEMP_TREE_NOT_SELECTID &&
            widget.titleSelectedTree == widget.previousSelectedParentName)) {
      _currentIndex = tempSelectedIndex;
      isEnableClear = true;
    }
  }
}

class GroupModel {
  String titleDisplay;
  int treeId;
  int radioIndex;

  GroupModel({this.titleDisplay, this.treeId, this.radioIndex});
}
