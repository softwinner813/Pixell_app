import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixell_app/activity/first_screen.dart';
import 'package:pixell_app/activity/search_user.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/get_user_pojo.dart';
import 'package:pixell_app/presenter/get_user_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

import 'multi_select_chip.dart';
import 'view_profile.dart';

class SearchFilterUserResult extends StatefulWidget {
  List<String> selectedFilterDisplayList;
  List<String> selectedFilterApiList;

  SearchFilterUserResult(
      {Key key, this.selectedFilterDisplayList, this.selectedFilterApiList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _SearchFilterUserResultStateFul();
  }
}

class _SearchFilterUserResultStateFul extends State<SearchFilterUserResult>
    with SingleTickerProviderStateMixin
    implements GetSellersContract {
  bool callApiForFiltered = true;

  GetSellersPresenter _getSellersPresenter;
  GetSellersPojo getSellerFilterData;

  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  final GlobalKey<RefreshIndicatorState> _refreshFilterIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollFilterGridController;
  bool isLogin = false;
  bool isChipsExpand = false;
  String nextAvaliable = '';
  String filteredUrl = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget topbar = new Container(
      child: Stack(
        children: <Widget>[
          new Container(
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
                  AppLocalizations.of(context).translate("label_filtered"),
                  style: TextStyle(
                      fontSize: MyConstants.toolbar_text_size,
                      color: Colors.white),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: new IconButton(
                        icon: Icon(
                          isChipsExpand ? Icons.expand_less : Icons.expand_more,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isChipsExpand = !isChipsExpand;

                            /* if (!isChipsExpand) {
                              getFilteredUpdatedUrl();
                              callFilteredApi();
                            }*/
                          });
                        }),
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
          ),
          Visibility(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  0.0, MyConstants.topbar_height - 25, 0.0, 0.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(MyConstants.layout_margin,
                    0.0, MyConstants.layout_margin, 0.0),
                child: MultiSelectChip(
                  getSelectedFilterDisplayList:
                      widget.selectedFilterDisplayList,
                  getSelectedFilterApiList: widget.selectedFilterApiList,
                  onRemoveFiltered: () {
                    callApiForFiltered = true;
                    setState(() {
                      getFilteredUpdatedUrl();
                      callFilteredApi();
                    });
                  },
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('graphics/surface_top_signup.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            visible: isChipsExpand,
          ),
        ],
      ),
    );

    Widget middleSection = Padding(
      padding:
          const EdgeInsets.fromLTRB(0.0, MyConstants.topbar_height, 0.0, 0.0),
      child: new Container(
        child: getSellerFilterData == null
            ? new Center(
                child: new CircularProgressIndicator(),
              )
            : RefreshIndicator(
                key: _refreshFilterIndicatorKey,
                onRefresh: _pullTORefresh,
                child: loadCategoryGridData(
                    getSellerFilterData, _scrollFilterGridController),
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
          middleSection,
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

    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: body,
      ),
    );
  }

  @override
  void initState() {
    getFilteredUpdatedUrl();

    checkIsLogin();
    _scrollFilterGridController = new ScrollController()
      ..addListener(_scrollMaleGridListener);

    callFilteredApi();

    super.initState();
  }

  void callFilteredApi() {
    getSellerFilterData = null;

    _getSellersPresenter = new GetSellersPresenter(this);
    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        _getSellersPresenter.doGetSellersFiltered(context, filteredUrl);
      } else {
        MyUtils().toastdisplay(
            AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });
  }

  @override
  void dispose() {
    _scrollFilterGridController.dispose();
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
    callFilteredApi();
  }

  void _scrollMaleGridListener() {
    if (_scrollFilterGridController.position.pixels ==
        _scrollFilterGridController.position.maxScrollExtent) {
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

        if (nextAvaliable != null && !nextAvaliable.isEmpty) {
          callApiForFiltered = false;
          _getSellersPresenter.doGetSellersNextLoad(context, "", nextAvaliable);
        }
      }
    });
  }

  String getFilteredUpdatedUrl() {
    filteredUrl = "";
    for (var i = 0; i < widget.selectedFilterDisplayList.length; i++) {
      filteredUrl = filteredUrl + widget.selectedFilterApiList[i];
    }

    if (widget.selectedFilterApiList.isEmpty) {
      isChipsExpand = false;
    }

    print("FILTERURL_UPDATED" + filteredUrl);
  }

  @override
  void onError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
    Navigator.pop(context, true);
  }

  @override
  void onSuccess(GetSellersPojo pojoData, String filter_type) {
    setState(() {
      nextAvaliable = pojoData.next;

      if (callApiForFiltered) {
        //For to fix duplicate record issue
        getSellerFilterData = null;
      }

      if (getSellerFilterData == null) {
        getSellerFilterData = pojoData;
      } else {
        getSellerFilterData.results.addAll(pojoData.results);
      }

      if (getSellerFilterData.results.length == 0) {
        MyUtils().toastdisplay(
          AppLocalizations.of(context).translate("msg_no_records_found"),
        );
        Navigator.pop(context, true);
      }
    });
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
