import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixell_app/activity/requests/child_request_builder.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/get_request_tree_pojo.dart';
import 'package:pixell_app/models/post_request_pojo.dart';
import 'package:pixell_app/presenter/post_request_presenter.dart';
import 'package:pixell_app/presenter/request_builder_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';
import 'dart:collection';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../first_screen.dart';
import '../search_user.dart';

class RequestBuilder extends StatefulWidget {
  RequestBuilder({Key key, this.sellerId}) : super(key: key);

  String sellerId = '';

  @override
  State<StatefulWidget> createState() {
    return new _RequestBuilderStateful();
  }
}

class _RequestBuilderStateful extends State<RequestBuilder> with TickerProviderStateMixin implements RequestTreeContract, PostRequestContract {
  RequestTreePresenter _requestTreePresenter;
  PostRequestPresenter _postRequestPresenter;

  RequestTreePojo getTreePojoData = null;

  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  List<dynamic> requestsId = [];
  bool isLogin = false;

  String defaultTempValue = "";

  bool isEnableGoNext = false;
  int backPress = 0;

  double requestreeBoxMinWidth = 0;
  double requestreeBoxMaxWidth = 0;

  TabController _tabController;
  Queue selectQueue = new Queue();

  @override
  void initState() {
    backPress = 0;
    checkIsLogin();

    _tabController = TabController(vsync: this, length: 0);
    _requestTreePresenter = new RequestTreePresenter(this);
    _postRequestPresenter = new PostRequestPresenter(this);

    MyUtils().check().then((internet) {
      if (internet != null && internet) {
        _requestTreePresenter = new RequestTreePresenter(this);
        _requestTreePresenter.doRequestTree(context, widget.sellerId);
      } else {
        MyUtils().toastdisplay(AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    requestreeBoxMinWidth = (MediaQuery.of(context).size.width / 3) + 10;
    requestreeBoxMaxWidth = (MediaQuery.of(context).size.width / 3) + 10;
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
                _backPressApp(context);
              }),
          Expanded(
            child: Text(
              AppLocalizations.of(context).translate("label_request_builder"),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: MyConstants.toolbar_text_size, color: Colors.white),
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

    Widget middleSection = new Expanded(
      child: new Container(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: (getTreePojoData != null && getTreePojoData.children != null && getTreePojoData.children.length > 0)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                          top: MyConstants.vertical_control_space * 3,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: MyConstants.vertical_control_space,
                          right: MyConstants.vertical_control_space,
                        ),
                        child: Text(
                          AppLocalizations.of(context).translate('label_request_your_selection'),
                          overflow: TextOverflow.ellipsis,
                          style: MyConstants.textStyle_request_detailsHeader,
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                            top: MyConstants.vertical_control_space,
                          ),
                          height: 200.0,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: getTreePojoData.children.length,
                              itemBuilder: (context, index) {
                                return new Container(
                                    child: Container(
                                  padding: EdgeInsets.only(
                                    left: (index == 0) ? MyConstants.vertical_control_space : 0,
                                    right: MyConstants.vertical_control_space,
                                    bottom: 20,
                                  ),
                                  child: Container(
                                    width: requestreeBoxMinWidth,
                                    padding: EdgeInsets.all(15),
                                    decoration: new BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(5, 5),
                                          blurRadius: 10,
                                        )
                                      ],
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white,
                                          getTreePojoData.children[index].selectedId == MyConstants.TEMP_TREE_NOT_SELECTID
                                              ? Colors.white
                                              : MyUtils().getColorFromHex(MyConstants.color_yellow),
                                        ],
                                      ),
                                      borderRadius: new BorderRadius.circular(4.0),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(getTreePojoData.children[index].selectedImg == null
                                            ? getTreePojoData.children[index].data.img == null ? "" : getTreePojoData.children[index].data.img
                                            : getTreePojoData.children[index].selectedImg),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          getTreePojoData.children[index].data.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                            getTreePojoData.children[index].selectedName.isEmpty
                                                ? AppLocalizations.of(context).translate('label_request_no_selected')
                                                : getTreePojoData.children[index].selectedName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black,
                                            ))
                                      ],
                                    ),
                                  ),
                                ));
                              })),
                      Container(
                        margin: const EdgeInsets.only(
                          top: MyConstants.vertical_control_space,
                          left: MyConstants.vertical_control_space,
                          right: MyConstants.vertical_control_space,
                        ),
                        child: Text(
                          AppLocalizations.of(context).translate('label_request_tell_preferences'),
                          overflow: TextOverflow.ellipsis,
                          style: MyConstants.textStyle_request_detailsHeader,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: MyConstants.vertical_control_space,
                        ),
                        color: Colors.white,
                        child: TabBar(
                            controller: _tabController,
                            labelColor: MyUtils().getColorFromHex(MyConstants.color_theme),
                            indicatorColor: MyUtils().getColorFromHex(MyConstants.color_theme),
                            indicatorWeight: 1.0,
                            unselectedLabelColor: MyUtils().getColorFromHex(MyConstants.color_top_tab_text),
                            tabs: getTreePojoData.children
                                .map((child) => Tab(
                                      text: child.data.name,
                                    ))
                                .toList()),
                      ),
                      (selectQueue.length > 1)
                          ? SizedBox(
                              width: double.infinity,
                              child: Container(
                                  padding: EdgeInsets.only(
                                    top: MyConstants.vertical_control_space,
                                    left: MyConstants.vertical_control_space,
                                    right: MyConstants.vertical_control_space,
                                  ),
                                  color: Colors.white,
                                  child: BreadCrumb.builder(
                                    itemCount: selectQueue.length,
                                    builder: (index) {
                                      return BreadCrumbItem(
                                        content: InkWell(
                                          // When the user taps the button, show a snackbar.
                                          onTap: () {
                                            setState(() {
                                              if (index == selectQueue.length - 1) {
                                                // Nothing
                                              } else {
                                                int numberOfSelectionsToRemove = selectQueue.length - index - 1;
                                                for (var i = 0; i < numberOfSelectionsToRemove; i++) {
                                                  selectQueue.removeLast();
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(selectQueue.elementAt(index).data.name,
                                                style: new TextStyle(color: Colors.black, fontSize: MyConstants.bottomtab_text_size)),
                                          ),
                                        ),
                                      );
                                    },
                                    divider: Icon(Icons.chevron_right),
                                  )))
                          : Container(),
                      (selectQueue.isNotEmpty)
                          ? Container(
                              padding: EdgeInsets.only(
                                bottom: MyConstants.vertical_control_space,
                              ),
                              color: Colors.white,
                              height: 200.0,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: selectQueue.last.children.length + 1,
                                  itemBuilder: (context, index) {
                                    return card(
                                        (selectQueue.last.children.length == index)
                                            ? AppLocalizations.of(context).translate('label_request_selection_any')
                                            : selectQueue.last.children[index].data.name,
                                        (selectQueue.last.children.length == index) ? selectQueue.last.data.img : selectQueue.last.children[index].data.img,
                                        index,
                                        selectQueue.first.selectedId == ((selectQueue.last.children.length == index) ? "" : selectQueue.last.children[index].id)
                                        || selectQueue.first.selectedId == ((selectQueue.last.children.length == index) ? selectQueue.last.id : "" ),
                                        selectQueue.last.children.length != index && selectQueue.last.children[index].children != null && selectQueue.last.children[index].children.isNotEmpty,
                                    () {
                                      setState(() {
                                        bool anySelected = (selectQueue.last.children.length == index);
                                        dynamic selected = anySelected ? selectQueue.last : selectQueue.last.children[index];
                                        if (selected.children == null || anySelected) {
                                          var name = AppLocalizations.of(context).translate('label_request_selection_any');
                                          var img = selected.data.img;
                                          for (int i = 1; i < selectQueue.length; i++) {
                                            if (i == 1) {
                                              name = selectQueue.elementAt(i).data.name;
                                            } else {
                                              name += " > ${selectQueue.elementAt(i).data.name}";
                                            }
                                          }
                                          if (!anySelected) {
                                            if (selectQueue.length == 1) {
                                              name = selected.data.name;
                                            } else {
                                              name += " > ${selected.data.name}";
                                            }
                                          }
                                          selectQueue.first.selectedName = name;
                                          selectQueue.first.selectedImg = img;
                                          selectQueue.first.selectedId = selected.id;
                                        } else {
                                          selectQueue.add(selected);
                                        }

                                        _enableGoButtonCheck();
                                      });
                                    });
                                  }))
                          : Container()
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );

    Widget goNext = new Padding(
      padding: const EdgeInsets.fromLTRB(MyConstants.layout_margin, 0, MyConstants.layout_margin, MyConstants.space_20),
      child: SizedBox(
        height: MyConstants.btn_height,
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () {
            if (isEnableGoNext) {
              MyUtils().check().then((internet) {
                if (internet != null && internet) {
                  _sendRequestGoClick();
                } else {
                  MyUtils().toastdisplay(AppLocalizations.of(context).translate('msg_no_internet'));
                }
              });
            }
          },
          color: isEnableGoNext ? MyUtils().getColorFromHex(MyConstants.color_theme) : MyUtils().getColorFromHex(MyConstants.color_gray_button),
          child: Text(
            AppLocalizations.of(context).translate("label_go_next"),
            style: TextStyle(
              fontSize: MyConstants.btn_round_text_size,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
                          margin: const EdgeInsets.only(left: MyConstants.bottom_tab_icon_align, right: 0),
                          child: Image(
                            image: AssetImage('graphics/icon-search-1.png'),
                            height: MyConstants.bottomtab_icn_height_width,
                            width: MyConstants.bottomtab_icn_height_width,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: MyConstants.bottom_tab_icon_align, right: 0),
                            child: Text(
                              AppLocalizations.of(context).translate("label_search"),
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
                          margin: const EdgeInsets.only(left: 0, right: MyConstants.bottom_tab_icon_align),
                          child: Image(
                            image: AssetImage('graphics/icon-login-1.png'),
                            height: MyConstants.bottomtab_icn_height_width,
                            width: MyConstants.bottomtab_icn_height_width,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 0, right: MyConstants.bottom_tab_icon_align),
                            child: Text(
                              AppLocalizations.of(context).translate("label_log_in"),
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
        goNext,
        Align(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Container(
                  child: isLogin
                      ? Container(
                          height: MyConstants.bottombar_height,
                          child: _bottomWidgetAfterLogin.calllBottomTabWidget(context),
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

  Widget card(String name, String img, int index, bool selected, bool hasChildren, GestureTapCallback onTap) {
    var selectedColor = MyUtils().getColorFromHex(MyConstants.color_request_selected);
    return new Container(
      padding: EdgeInsets.only(
        top: MyConstants.vertical_control_space,
        left: (index == 0) ? MyConstants.vertical_control_space : 0,
        right: MyConstants.vertical_control_space,
        bottom: MyConstants.vertical_control_space,
      ),
      child: new Material(
        child: new InkWell(
          onTap: onTap,
          child: Container(
            width: requestreeBoxMinWidth,
            padding: EdgeInsets.all(15),
            decoration: new BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                color: selected ? selectedColor : Colors.white,
                borderRadius: new BorderRadius.circular(4.0),
                image: DecorationImage(image: CachedNetworkImageProvider(img == null ? "" : img))),
            child: Container(
              decoration: new BoxDecoration(
                  image: selected ? DecorationImage(image: AssetImage("graphics/icon-checkmark.png")) : null
              ),
              child:
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Row(children: <Widget>[
                    Text(name,
                        style: TextStyle(
                          fontSize: 12,
                        )),
                    Spacer(),
                    hasChildren ? new Image.asset(
                      'graphics/arrow-bottom.png',
                      height: MyConstants.toolbar_icon_height_width,
                      width: MyConstants.toolbar_icon_height_width,
                      color: Colors.black
                    ) : Container()
                  ],)
                ],
              ),
            )

          ),
        ),
        color: Colors.transparent,
      ),
    );
  }

  Future<bool> _backPressApp(BuildContext context) {
    if (backPress > 0) {
      SystemNavigator.pop();
    } else {
      Navigator.pop(context, true);
    }
    backPress++;
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _tabController.dispose();
    super.dispose();
  }

  _navigateAndDisplaySelection(BuildContext context, tapIndex) async {
    var result = null;

    result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChildRequestBuilder(
                titleSelectedTree: getTreePojoData.children[tapIndex].data.name,
                childRequestTree: getTreePojoData.children[tapIndex].children,
                previousSelectedTreeId: getTreePojoData.children[tapIndex].selectedId,
                previousSelectedName: getTreePojoData.children[tapIndex].selectedName,
                previousSelectedParentName: getTreePojoData.children[tapIndex].previousSelectedParentName,
              )),
    );

    if (result != null) {
      setState(() {
        getTreePojoData.children[tapIndex].selectedName = result[0];

        getTreePojoData.children[tapIndex].previousSelectedParentName = result[2];

        if (result[1] == MyConstants.TEMP_TREE_ANY_ID) {
          getTreePojoData.children[tapIndex].selectedId = getTreePojoData.children[tapIndex].id;
          getTreePojoData.children[tapIndex].previousSelectedParentName = getTreePojoData.children[tapIndex].data.name;
        } else {
          getTreePojoData.children[tapIndex].selectedId = result[1];
        }

        _enableGoButtonCheck();
      });
    }
  }

  void _enableGoButtonCheck() {
    requestsId.clear();

    isEnableGoNext = false;
    for (var i = 0; i < getTreePojoData.children.length; i++) {
      if (getTreePojoData.children[i].selectedId != MyConstants.TEMP_TREE_NOT_SELECTID) {
        isEnableGoNext = true;
        requestsId.add(getTreePojoData.children[i].selectedId);
      }
    }

    print("RequestedId" + requestsId.toString());
  }

  void checkIsLogin() {
    MySharePreference().getBoolInPref(MyConstants.PREF_KEY_ISLOGIN).then((valueIsLogedIn) {
      if (this.mounted) {
        setState(() {
          isLogin = valueIsLogedIn;
        });
      }
    });
  }

  void _sendRequestGoClick() {
    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        MySharePreference().getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN).then((value) {
          if (!value.isEmpty) {
            _postRequestPresenter = new PostRequestPresenter(this);
            _postRequestPresenter.doPostRequest(context, widget.sellerId, value, requestsId);
          }
        });
      } else {
        MyUtils().toastdisplay(AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });
  }

  @override
  void onRequestTreeError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onRequestTreeSuccess(RequestTreePojo pojoData) {
    if (pojoData != null) {
      setState(() {
        getTreePojoData = pojoData;

        _tabController.dispose();
        _tabController = TabController(vsync: this, length: pojoData.children.length);
        _tabController.addListener(_handleTabSelection);
        _handleTabSelection();
      });
    }
  }

  void _handleTabSelection() {
    setState(() {
      selectQueue.clear();
      selectQueue.add(getTreePojoData.children[_tabController.index]);
    });
  }

  @override
  void onPostRequestError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onPostRequestSuccess(PostRequestPojo pojodata) {
    if (pojodata != null) {
      if (pojodata.detail != null) {
        MyUtils().toastdisplay(pojodata.detail);
      } else if (pojodata.status != null) {
        //MyUtils().toastdisplay(pojodata.status);

        MyUtils().customAlertDialogBox(context, 'graphics/img-mailbox.png', AppLocalizations.of(context).translate("label_request_sent"),
            AppLocalizations.of(context).translate("label_request_sent_msg"), "", AppLocalizations.of(context).translate("label_go_home"));
      }
    }
  }
}
