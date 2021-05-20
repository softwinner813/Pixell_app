import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixell_app/activity/first_screen.dart';
import 'package:pixell_app/activity/search_user.dart';
import 'package:pixell_app/activity/view_profile.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/get_user_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';
import 'package:pixell_app/presenter/get_user_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

class UsersTabLayout extends StatefulWidget {
  final String fromScreen;

  const UsersTabLayout({Key key, this.fromScreen}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _UsersTabLayoutStateFul();
  }
}

class _UsersTabLayoutStateFul extends State<UsersTabLayout>
    with SingleTickerProviderStateMixin
    implements GetSellersContract {
  GetSellersPresenter _getSellersPresenter;
  GetSellersPojo getSellerMaleData;
  GetSellersPojo getSellerFemaleData;
  GetSellersPojo getSellerHotData;

  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  final GlobalKey<RefreshIndicatorState> _refreshHotIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshFemaleIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshMaleIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollHotGridController;
  ScrollController _scrollFemaleGridController;
  ScrollController _scrollMaleGridController;
  TabController _tabController;
  int _currentIndex = 0;
  int _totoalTab = 3;
  bool isLogin = false;

  String nextHot = '';
  String nextFemale = '';
  String nextMale = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget topbar = new Container(
        child: new DefaultTabController(
      length: _totoalTab,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TabBar(
                controller: _tabController,
                labelColor: MyUtils().getColorFromHex(MyConstants.color_theme),
                indicatorColor:
                    MyUtils().getColorFromHex(MyConstants.color_theme),
                indicatorWeight: 1.0,
                unselectedLabelColor:
                    MyUtils().getColorFromHex(MyConstants.color_top_tab_text),
                tabs: [
                  Tab(
                      text:
                          AppLocalizations.of(context).translate("label_hot")),
                  Tab(
                      text: AppLocalizations.of(context)
                          .translate("label_female")),
                  Tab(
                      text:
                          AppLocalizations.of(context).translate("label_male")),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            getSellerHotData == null
                ? new Center(
                    child: new CircularProgressIndicator(),
                  )
                : ((getSellerHotData.results != null &&
                        getSellerHotData.results.length > 0)
                    ? RefreshIndicator(
                        key: _refreshHotIndicatorKey,
                        onRefresh: _pullTORefresh,
                        child: loadCategoryGridData(
                            getSellerHotData, _scrollHotGridController),
                      )
                    : new Center(
                        child: new Text(AppLocalizations.of(context)
                            .translate("msg_noany_records_found")),
                      )),
            getSellerFemaleData == null
                ? new Center(
              child: new CircularProgressIndicator(),
            )
                : ((getSellerFemaleData.results != null &&
                getSellerFemaleData.results.length > 0)
                ? RefreshIndicator(
              key: _refreshFemaleIndicatorKey,
              onRefresh: _pullTORefresh,
              child: loadCategoryGridData(
                  getSellerFemaleData, _scrollFemaleGridController),
            )
                : new Center(
              child: new Text(AppLocalizations.of(context)
                  .translate("msg_noany_records_found")),
            )),
            getSellerMaleData == null
                ? new Center(
              child: new CircularProgressIndicator(),
            )
                : ((getSellerMaleData.results != null &&
                getSellerMaleData.results.length > 0)
                ? RefreshIndicator(
              key: _refreshMaleIndicatorKey,
              onRefresh: _pullTORefresh,
              child: loadCategoryGridData(
                  getSellerMaleData, _scrollMaleGridController),
            )
                : new Center(
              child: new Text(AppLocalizations.of(context)
                  .translate("msg_noany_records_found")),
            )),
          ],
        ),
      ),
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

    Widget body = Container(
        child: InkWell(
      child: Stack(
        children: <Widget>[
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
    ));

    /* Widget bodyOld = new Column(
      // This makes each child fill the full width of the screen
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        topbar,
        bottomBanner,
      ],
    );*/

    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: body,
      ),
    );
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Tab Changed Tap to a new tab
      onTabTapOrSwipe();
    } else if (_tabController.index != _currentIndex) {
      // Tab Changed swiping to a new tab
      onTabTapOrSwipe();
    }
  }

  void onTabTapOrSwipe() {
    if (this.mounted) {
      setState(() {
        _currentIndex = _tabController.index;

        MyUtils().check().then((intenet) {
          if (intenet != null && intenet) {
            _getSellersPresenter = new GetSellersPresenter(this);
            if (_currentIndex == 0 /*&& getSellerHotData == null*/) {
              getSellerHotData = null;
              _getSellersPresenter.doGetSellers(context, "");
            } else if (_currentIndex == 1 /*&& getSellerFemaleData == null*/) {
              getSellerFemaleData = null;
              _getSellersPresenter.doGetSellers(
                  context, RestDatasource().KEY_FEMALE);
            } else if (_currentIndex == 2 /*&& getSellerMaleData == null*/) {
              getSellerMaleData = null;
              _getSellersPresenter.doGetSellers(
                  context, RestDatasource().KEY_MALE);
            }
          } else {
            MyUtils().toastdisplay(
                AppLocalizations.of(context).translate('msg_no_internet'));
          }
        });
      });
    }
  }

  @override
  void initState() {
    checkIsLogin();
    _scrollHotGridController = new ScrollController()
      ..addListener(_scrollHotGridListener);
    _scrollFemaleGridController = new ScrollController()
      ..addListener(_scrollFemaleGridListener);
    _scrollMaleGridController = new ScrollController()
      ..addListener(_scrollMaleGridListener);

    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);

    _getSellersPresenter = new GetSellersPresenter(this);

    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        _getSellersPresenter.doGetSellers(context, "");
      } else {
        MyUtils().toastdisplay(
            AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });

    super.initState();
    _openDialog();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _tabController.dispose();
    _scrollHotGridController.dispose();
    _scrollFemaleGridController.dispose();
    _scrollMaleGridController.dispose();

    super.dispose();
  }

  GridView loadCategoryGridData(
      GetSellersPojo _usersData, ScrollController scrollController) {
    return new GridView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        padding: EdgeInsets.only(bottom: MyConstants.bottombar_height),
        itemCount: _usersData.results.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              alignment: Alignment.center,
              child: Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    MyUtils().check().then((intenet) {
                      if (intenet != null && intenet) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewProfile(userID: _usersData.results[index].id.toString(),),
                            ));
                      } else {
                        MyUtils().toastdisplay(
                            AppLocalizations.of(context).translate('msg_no_internet'));
                      }
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Align(
                        child: Container(
                          width: double.infinity,
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.fitWidth,
                              placeholder:
                                  "graphics/user_default_rectangle.png",
                              image: (_usersData.results[index].profile !=
                                          null &&
                                      _usersData.results[index].profile
                                              .thumbnail !=
                                          null)
                                  ? _usersData.results[index].profile.thumbnail
                                  : ""),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          verticalDirection: VerticalDirection.up,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              color: Colors.black.withOpacity(.5),
                              child: Text(
                                _usersData.results[index].username,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  Future<void> _pullTORefresh() async {
    print('refreshing pics...');

    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        _getSellersPresenter = new GetSellersPresenter(this);

        if (_currentIndex == 0) {
          nextHot = null;
          getSellerHotData = null;
          _getSellersPresenter.doGetSellers(context, "");
        } else if (_currentIndex == 1) {
          nextFemale = null;
          getSellerFemaleData = null;
          _getSellersPresenter.doGetSellers(
              context, RestDatasource().KEY_FEMALE);
        } else if (_currentIndex == 2) {
          nextMale = null;
          getSellerMaleData = null;
          _getSellersPresenter.doGetSellers(context, RestDatasource().KEY_MALE);
        }
      } else {
        MyUtils().toastdisplay(
            AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });
  }

  void _scrollHotGridListener() {
    if (_scrollHotGridController.position.pixels ==
        _scrollHotGridController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _scrollFemaleGridListener() {
    if (_scrollFemaleGridController.position.pixels ==
        _scrollFemaleGridController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _scrollMaleGridListener() {
    if (_scrollMaleGridController.position.pixels ==
        _scrollMaleGridController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");

    await Future.delayed(Duration(seconds: 0, milliseconds: 1));

    loadNextMoreData();

    return true;
  }

  void loadNextMoreData() {
    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        _getSellersPresenter = new GetSellersPresenter(this);

        if (_currentIndex == 0 && nextHot != null) {
          _getSellersPresenter.doGetSellersNextLoad(context, "", nextHot);
        } else if (_currentIndex == 1 && nextFemale != null) {
          _getSellersPresenter.doGetSellersNextLoad(
              context, RestDatasource().KEY_FEMALE, nextFemale);
        } else if (_currentIndex == 2 && nextMale != null) {
          _getSellersPresenter.doGetSellersNextLoad(
              context, RestDatasource().KEY_MALE, nextMale);
        }
      }
    });
  }

  void tapDialog(int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      child: new CupertinoAlertDialog(
        title: new Column(
          children: <Widget>[
            new Text("GridView"),
            new Icon(
              Icons.favorite,
              color: MyUtils().getColorFromHex(MyConstants.color_green_019807),
            ),
          ],
        ),
        content: new Text("Selected Item $index"),
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("OK"))
        ],
      ),
    );
  }

  @override
  void onError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onSuccess(GetSellersPojo pojoData, String filter_type) {
    if (this.mounted) {
      setState(() {
        if (filter_type == RestDatasource().KEY_FEMALE) {
          nextFemale = pojoData.next;
          if (getSellerFemaleData == null) {
            getSellerFemaleData = pojoData;
          } else {
            getSellerFemaleData.results.addAll(pojoData.results);
          }
        } else if (filter_type == RestDatasource().KEY_MALE) {
          nextMale = pojoData.next;
          if (getSellerMaleData == null) {
            getSellerMaleData = pojoData;
          } else {
            getSellerMaleData.results.addAll(pojoData.results);
          }
        } else {
          nextHot = pojoData.next;
          if (getSellerHotData == null) {
            getSellerHotData = pojoData;
          } else {
            getSellerHotData.results.addAll(pojoData.results);
          }
        }
      });
    }
  }

  void _openDialog() {
    if (widget.fromScreen == MyConstants.FROM_SIGNUP) {
      Timer.run(() {
        MyUtils().customAlertDialogBox(
            context,
            'graphics/img-mailbox.png',
            AppLocalizations.of(context).translate("label_reset_top_dialog"),
            AppLocalizations.of(context).translate("msg_guest_bottom_dialog"),
            AppLocalizations.of(context).translate("label_edit_profile"),
            AppLocalizations.of(context).translate("label_continue"));
      });
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
}
