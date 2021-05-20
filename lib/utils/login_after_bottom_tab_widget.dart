import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pixell_app/activity/balance/balance_summary.dart';
import 'package:pixell_app/activity/edit_profile.dart';
import 'package:pixell_app/activity/requests/request_list.dart';
import 'package:pixell_app/activity/search_user.dart';
import 'package:pixell_app/fragments/profile_fragment.dart';
import 'package:pixell_app/fragments/users_tab_layout.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/utils/my_constants.dart';

import 'my_utils.dart';

class BottomWidgetAfterLogin {
  Widget calllBottomTabWidget(BuildContext context) {
    if (context != null) {
      return new Align(
          alignment: Alignment.bottomCenter,
          child: new GestureDetector(
              onTap: () {},
              child: new Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: new EdgeInsets.all(
                                  MyConstants.bottomtab_icn_top_space),
                            ),
                            Container(
                              child: MyConstants.currentSelectedBottomTab == 0
                                  ? new Image.asset(
                                      'graphics/icon-home.png',
                                      height: MyConstants
                                          .bottomtab_icn_height_width,
                                      width: MyConstants
                                          .bottomtab_icn_height_width,
                                    )
                                  : new Image.asset(
                                      'graphics/icon-home-1.png',
                                      height: MyConstants
                                          .bottomtab_icn_height_width,
                                      width: MyConstants
                                          .bottomtab_icn_height_width,
                                    ),
                            ),
                            Container(
                                child: AutoSizeText(
                                    AppLocalizations.of(context)
                                        .translate("label_home"),
                                    maxLines: 1,
                                    style: new TextStyle(
                                        color: MyConstants
                                                    .currentSelectedBottomTab ==
                                                0
                                            ? MyUtils().getColorFromHex(
                                                MyConstants.color_alert_top)
                                            : Colors.white,
                                        fontSize:
                                            MyConstants.bottomtab_text_size))),
                          ],
                        ),
                        onTap: () {
                          if (MyConstants.currentSelectedBottomTab != 0) {
                            MyConstants.currentSelectedBottomTab = 0;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UsersTabLayout()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: new EdgeInsets.all(
                                  MyConstants.bottomtab_icn_top_space),
                            ),
                            Container(
                              child: MyConstants.currentSelectedBottomTab == 1
                                  ? new Image.asset(
                                      'graphics/icon-requests.png',
                                      height: MyConstants
                                          .bottomtab_icn_height_width,
                                      width: MyConstants
                                          .bottomtab_icn_height_width,
                                    )
                                  : new Image.asset(
                                      'graphics/icon-requests-1.png',
                                      height: MyConstants
                                          .bottomtab_icn_height_width,
                                      width: MyConstants
                                          .bottomtab_icn_height_width,
                                    ),
                            ),
                            Container(
                                child: AutoSizeText(
                                    AppLocalizations.of(context)
                                        .translate("label_requests"),
                                    maxLines: 1,
                                    style: new TextStyle(
                                        color: MyConstants
                                                    .currentSelectedBottomTab ==
                                                1
                                            ? MyUtils().getColorFromHex(
                                                MyConstants.color_alert_top)
                                            : Colors.white,
                                        fontSize:
                                            MyConstants.bottomtab_text_size))),
                          ],
                        ),
                        onTap: () {
                          if (MyConstants.currentSelectedBottomTab != 1) {
                            MyConstants.currentSelectedBottomTab = 1;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestsList()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: new EdgeInsets.all(
                                  MyConstants.bottomtab_icn_top_space),
                            ),
                            Container(
                              child: MyConstants.currentSelectedBottomTab == 2
                                  ? new Image.asset(
                                      'graphics/icon-search.png',
                                      height: MyConstants
                                          .bottomtab_icn_height_width,
                                      width: MyConstants
                                          .bottomtab_icn_height_width,
                                    )
                                  : new Image.asset(
                                      'graphics/icon-search-1.png',
                                      height: MyConstants
                                          .bottomtab_icn_height_width,
                                      width: MyConstants
                                          .bottomtab_icn_height_width,
                                    ),
                            ),
                            Container(
                                child: AutoSizeText(
                                    AppLocalizations.of(context)
                                        .translate("label_search"),
                                    maxLines: 1,
                                    style: new TextStyle(
                                        color: MyConstants
                                                    .currentSelectedBottomTab ==
                                                2
                                            ? MyUtils().getColorFromHex(
                                                MyConstants.color_alert_top)
                                            : Colors.white,
                                        fontSize:
                                            MyConstants.bottomtab_text_size))),
                          ],
                        ),
                        onTap: () {
                          if (MyConstants.currentSelectedBottomTab != 2) {
                            MyConstants.currentSelectedBottomTab = 2;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchUser()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: new EdgeInsets.all(
                                  MyConstants.bottomtab_icn_top_space),
                            ),
                            Container(
                              child: MyConstants.currentSelectedBottomTab == 3
                                  ? new Image.asset(
                                      'graphics/icon-balance.png',
                                      height: MyConstants
                                          .bottomtab_icn_height_width,
                                      width: MyConstants
                                          .bottomtab_icn_height_width,
                                    )
                                  : new Image.asset(
                                      'graphics/icon-balance-1.png',
                                      height: MyConstants
                                          .bottomtab_icn_height_width,
                                      width: MyConstants
                                          .bottomtab_icn_height_width,
                                    ),
                            ),
                            Container(
                                child: AutoSizeText(
                                    AppLocalizations.of(context)
                                        .translate("label_balance"),
                                    maxLines: 1,
                                    style: new TextStyle(
                                        color: MyConstants
                                                    .currentSelectedBottomTab ==
                                                3
                                            ? MyUtils().getColorFromHex(
                                                MyConstants.color_alert_top)
                                            : Colors.white,
                                        fontSize:
                                            MyConstants.bottomtab_text_size))),
                          ],
                        ),
                        onTap: () {
                          if (MyConstants.currentSelectedBottomTab != 3) {
                            MyConstants.currentSelectedBottomTab = 3;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BalanceSummary()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: new EdgeInsets.all(
                                  MyConstants.bottomtab_icn_top_space),
                            ),
                            Container(
                              child: MyConstants.currentSelectedBottomTab == 4
                                  ? new Image.asset(
                                      'graphics/icon-profile.png',
                                      height: MyConstants
                                          .bottomtab_icn_height_width,
                                      width: MyConstants
                                          .bottomtab_icn_height_width,
                                    )
                                  : new Image.asset(
                                      'graphics/icon-profile-1.png',
                                      height: MyConstants
                                          .bottomtab_icn_height_width,
                                      width: MyConstants
                                          .bottomtab_icn_height_width,
                                    ),
                            ),
                            Container(
                                child: AutoSizeText(
                                    AppLocalizations.of(context)
                                        .translate("label_profile"),
                                    maxLines: 1,
                                    style: new TextStyle(
                                        color: MyConstants
                                                    .currentSelectedBottomTab ==
                                                4
                                            ? MyUtils().getColorFromHex(
                                                MyConstants.color_alert_top)
                                            : Colors.white,
                                        fontSize:
                                            MyConstants.bottomtab_text_size))),
                          ],
                        ),
                        onTap: () {
                          if (MyConstants.currentSelectedBottomTab != 4) {
                            MyConstants.currentSelectedBottomTab = 4;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                height: MyConstants.bottombar_height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('graphics/surface_bottom_tab.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              )));
    }
  }
}
