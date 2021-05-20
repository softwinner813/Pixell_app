import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixell_app/activity/requests/request_details.dart';
import 'package:pixell_app/activity/search_user.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/requests_pojo.dart';
import 'package:pixell_app/presenter/requests_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';
import 'package:pixell_app/models/get_hints_pojo.dart';
import 'package:pixell_app/presenter/get_hints_presenter.dart';

import '../first_screen.dart';

class RequestsList extends StatefulWidget {
  RequestsList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RequestsListStateful();
  }
}

class _RequestsListStateful extends State<RequestsList>
    implements RequestsContract,
        GetHintsContract {
  ScrollController _scrollLoadMoreController;
  RequestsPresenter _requestsPresenter;
  final GlobalKey<RefreshIndicatorState> _refreshRequestsIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();
  RequestsPojo _requestsPojoData = null;
  GetHintsPojo _hintsPojo;

  bool isLogin = false;
  int loginUserId;
  double spaceAroundRequests = 20;
  double spaceBetweenRequests = 2.0;
  String tokenLogin = "";
  String nextRequest = '';
  double setClickOacity = 1;
  bool showLoadMoreIndicator = false;

  @override
  void initState() {
    checkIsLogin();

    _requestsPresenter = new RequestsPresenter(this);

    _scrollLoadMoreController = new ScrollController()
      ..addListener(_scrollLoadMoreRequestListener);

    MyUtils().check().then((internet) {
      if (internet != null && internet) {
        // Get hints
        GetHintsPresenter _getHintsPresenter = GetHintsPresenter(this);
        _getHintsPresenter.doGetHints(context);
        MySharePreference()
            .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
            .then((valueToken) {
          if (!valueToken.isEmpty) {
            tokenLogin = valueToken;
            _requestsPresenter.doRequests(context, tokenLogin);
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
            AppLocalizations.of(context).translate("label_requests"),
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
            margin: const EdgeInsets.only(
                left: MyConstants.layout_margin,
                right: MyConstants.layout_margin,
                top: MyConstants.vertical_control_space +
                    MyConstants.topbar_height),
            child: (_requestsPojoData != null)
                ? RefreshIndicator(
                    key: _refreshRequestsIndicatorKey,
                    onRefresh: _pullTORefresh,
                    child: _requesListWidget(),
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
        resizeToAvoidBottomInset: true,
        backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg),
        body: body);
  }

  ListView _requesListWidget() {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollLoadMoreController,
      padding: EdgeInsets.only(
        bottom: MyConstants.bottombar_height + 25,
      ),
      itemCount: _requestsPojoData.results.length,
      itemBuilder: (context, index) {
        _disableClickOfRow(index);
        return Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              height: MyConstants.request_profile_image_h_w +
                  spaceAroundRequests +
                  10,
              child: InkWell(
                onTap: () {
                  if (_requestsPojoData.results[index].clickable) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestDetails(
                            requestDetailsPojo:
                                _requestsPojoData.results[index],
                            loginUserId: loginUserId,
                          ),
                        ));
                  }
                },
                child: Opacity(
                  opacity: setClickOacity,
                  child: Stack(
                    children: <Widget>[
                      _planetCard(index),
                      _planetThumbnail(index)
                    ],
                  ),
                ),
              ),
            ),
            (showLoadMoreIndicator &&
                    index == _requestsPojoData.results.length - 1)
                ? Center(
                    child: Container(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(),
                  ))
                : Container(),
          ],
        );
      },
    );
  }

  _planetThumbnail(int itemPos) {
    String displayThumb = null;

    if (_requestsPojoData.results[itemPos].userTo != null &&
        _requestsPojoData.results[itemPos].userFrom != null) {
      if (_requestsPojoData.results[itemPos].userTo.id == loginUserId) {
        if (_requestsPojoData.results[itemPos].userFrom.thumbnail != null) {
          displayThumb = _requestsPojoData.results[itemPos].userFrom.thumbnail;
        }
      } else if (_requestsPojoData.results[itemPos].userTo.thumbnail != null) {
        displayThumb = _requestsPojoData.results[itemPos].userTo.thumbnail;
      }
    }
    return new Container(
        /* margin: new EdgeInsets.symmetric(
              vertical: 16.0
            ),*/
        alignment: FractionalOffset.centerLeft,
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(5.0),
          child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            placeholder: "graphics/user_default_rectangle.png",
            image: (displayThumb != null ? displayThumb : ""),
            height: MyConstants.request_profile_image_h_w,
            width: MyConstants.request_profile_image_h_w,
          ),
        ));
  }

  _planetCard(int itemPos) {
    return new Container(
      width: double.infinity,
      margin:
          new EdgeInsets.only(left: MyConstants.request_profile_image_h_w / 3),
      padding: new EdgeInsets.only(
          left: MyConstants.request_profile_image_h_w / 1.3,
          top: spaceAroundRequests / 2,
          right: spaceAroundRequests / 2,
          bottom: spaceAroundRequests / 2),
      decoration: new BoxDecoration(
        color: MyUtils().getColorFromHex(MyConstants.color_theme),
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
                        _requestsPojoData.results[itemPos].userTo.id ==
                                loginUserId
                            ? _requestsPojoData.results[itemPos].userFrom.name
                            : _requestsPojoData.results[itemPos].userTo.name,
                        overflow: TextOverflow.ellipsis,
                        style: MyConstants.textStyle_request_title,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.all(spaceBetweenRequests),
                    ),
                    Text(
                      _requestsPojoData.results[itemPos].userTo.id ==
                              loginUserId
                          ? AppLocalizations.of(context)
                              .translate("label_buyer")
                          : AppLocalizations.of(context)
                              .translate("label_seller"),
                      overflow: TextOverflow.ellipsis,
                      style: MyConstants.textStyle_request_other,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      'graphics/icon-pixell-point-white.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    ),
                    Container(
                      margin: new EdgeInsets.all(spaceBetweenRequests),
                    ),
                    Flexible(
                      child: Text(
                        (_requestsPojoData.results[itemPos].amount != null &&
                                _requestsPojoData.results[itemPos].amount != 0)
                            ? _requestsPojoData.results[itemPos].amount
                                .toString()
                            : AppLocalizations.of(context)
                                .translate("label_tbd"),
                        overflow: TextOverflow.ellipsis,
                        style: MyConstants.textStyle_request_title,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.all(spaceBetweenRequests),
                    ),
                    (_requestsPojoData.results[itemPos].amount != null &&
                            _requestsPojoData.results[itemPos].amount != 0)
                        ? Container()
                        : InkWell(
                            onTap: () {
                              MyUtils().customAlertHintDialogBox(context, 'graphics/icon-pixell-point-white.png', _hintsPojo, "TBD");
                            },
                            child: Image.asset(
                              'graphics/icon-info-white.png',
                              height: MyConstants.bottomtab_icn_height_width,
                              width: MyConstants.bottomtab_icn_height_width,
                            ),
                          ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context).translate("label_updated"),
                        overflow: TextOverflow.ellipsis,
                        style: MyConstants.textStyle_request_other_bold,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.all(spaceBetweenRequests),
                    ),
                    Text(
                      new DateFormat(MyConstants.format_mm_dd_yy).format(
                          _requestsPojoData.results[itemPos].updateTime),
                      overflow: TextOverflow.ellipsis,
                      style: MyConstants.textStyle_request_other,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context).translate("label_exp"),
                        overflow: TextOverflow.ellipsis,
                        style: MyConstants.textStyle_request_other_bold,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.all(spaceBetweenRequests),
                    ),
                    Text(
                      new DateFormat(MyConstants.format_mm_dd_yy).format(
                          _requestsPojoData.results[itemPos].expirationDate),
                      overflow: TextOverflow.ellipsis,
                      style: MyConstants.textStyle_request_other,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              width: 80,
              height: MyConstants.btn_request_height,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(left: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                    image: AssetImage("graphics/request_pending_status.png"),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: Text(
                  _setStatus(_requestsPojoData.results[itemPos].status),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  _disableClickOfRow(itemPos) {
    setClickOacity = 1;
    _requestsPojoData.results[itemPos].clickable = true;

    if (_requestsPojoData.results[itemPos].status != null &&
        _requestsPojoData.results[itemPos].userTo != null &&
        _requestsPojoData.results[itemPos].userFrom != null) {
      if (_requestsPojoData.results[itemPos].userTo.id == loginUserId) {
        //I AM SELLER Opposite Buyer
        if (_requestsPojoData.results[itemPos].status ==
                MyConstants.STATUS_PAYMENT_PENDING ||
            _requestsPojoData.results[itemPos].status ==
                MyConstants.STATUS_DELIVERED ||
            _requestsPojoData.results[itemPos].status ==
                MyConstants.STATUS_CLOSED ||
            _requestsPojoData.results[itemPos].status ==
                MyConstants.STATUS_REVIEW_PENDING ||
            _requestsPojoData.results[itemPos].status ==
                MyConstants.STATUS_DELIVERY_PAY_PENDING) {
          setClickOacity = 0.5;
          _requestsPojoData.results[itemPos].clickable = false;
        }
      } else {
        //I AM BUYER Opposite Seller
        if (_requestsPojoData.results[itemPos].status ==
                MyConstants.STATUS_QUOTATION_PENDING ||
            _requestsPojoData.results[itemPos].status ==
                MyConstants.STATUS_FULFILLMENT_PENDING ||
            _requestsPojoData.results[itemPos].status ==
                MyConstants.STATUS_REVIEW_PENDING) {
          setClickOacity = 0.5;
          _requestsPojoData.results[itemPos].clickable = false;
        }
      }
    }
  }

  _setStatus(statusValue) {
    if (statusValue == MyConstants.STATUS_QUOTATION_PENDING) {
      return AppLocalizations.of(context).translate("label_quotation_pending");
    }

    if (statusValue == MyConstants.STATUS_PAYMENT_PENDING) {
      return AppLocalizations.of(context).translate("label_payment_pending");
    }

    if (statusValue == MyConstants.STATUS_FULFILLMENT_PENDING) {
      return AppLocalizations.of(context)
          .translate("label_fulfillment_pending");
    }

    if (statusValue == MyConstants.STATUS_DELIVERED) {
      return AppLocalizations.of(context).translate("label_delivered");
    }

    if (statusValue == MyConstants.STATUS_CLOSED) {
      return AppLocalizations.of(context).translate("label_closed");
    }

    if (statusValue == MyConstants.STATUS_EXPIRED) {
      return AppLocalizations.of(context).translate("label_expired");
    }

    if (statusValue == MyConstants.STATUS_REVIEW_PENDING) {
      return AppLocalizations.of(context).translate("label_review");
    }

    if (statusValue == MyConstants.STATUS_DELIVERY_PAY_PENDING) {
      return AppLocalizations.of(context).translate("label_delivery_pending");
    }

    return "";
  }

  void _scrollLoadMoreRequestListener() {
    if (_scrollLoadMoreController.position.pixels ==
        _scrollLoadMoreController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");

    await Future.delayed(Duration(seconds: 0, milliseconds: 1));

    loadNextMoreData();

    return true;
  }

  @override
  void dispose() {
    _scrollLoadMoreController.dispose();
    super.dispose();
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

  void checkIsLogin() {
    if (this.mounted) {
      MySharePreference()
          .getBoolInPref(MyConstants.PREF_KEY_ISLOGIN)
          .then((valueIsLogedIn) {
        isLogin = valueIsLogedIn;
        MySharePreference()
            .getIntegerInPref(MyConstants.PREF_KEY_USERID)
            .then((value) {
          if (this.mounted) {
            setState(() {
              loginUserId = value;
            });
          }
        });
      });
    }
  }

  Future<void> _pullTORefresh() async {
    print('refreshing requests...');

    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        _requestsPresenter = new RequestsPresenter(this);
        nextRequest = null;
        _requestsPojoData = null;
        _requestsPresenter.doRequests(context, tokenLogin);
      } else {
        MyUtils().toastdisplay(
            AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });
  }

  void loadNextMoreData() {
    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        _requestsPresenter = new RequestsPresenter(this);

        if (nextRequest != null) {
          setState(() {
            showLoadMoreIndicator = true;
          });
          _requestsPresenter.doRequestsNextLoad(
              context, tokenLogin, nextRequest);
        } else {
          setState(() {
            showLoadMoreIndicator = false;
          });
        }
      }
    });
  }

  @override
  void onRequestsError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onRequestsSuccess(RequestsPojo pojoData) {
    if (pojoData != null) {
      if (pojoData.detail != null) {
        MyUtils().toastdisplay(pojoData.detail);
      } else {
        if (pojoData.results != null && pojoData.results.length > 0) {
          if (this.mounted) {
            setState(() {
              showLoadMoreIndicator = false;
              nextRequest = pojoData.next;
              if (pojoData.previous == null) {
                //For to resolved add duplicate data when user do fast refresh
                _requestsPojoData = null;
              }
              if (_requestsPojoData == null) {
                _requestsPojoData = pojoData;
              } else {
                _requestsPojoData.results.addAll(pojoData.results);
              }
            });
          }
        } else {
          MyUtils().customAlertDialogBox(
              context,
              'graphics/emplty_box.png',
              AppLocalizations.of(context).translate("msg_top_request_empty_dialog"),
              AppLocalizations.of(context).translate("msg_bottom_request_empty_dialog"),
              "",
              AppLocalizations.of(context).translate("label_go_home"));
        }
      }
    }
  }
}
