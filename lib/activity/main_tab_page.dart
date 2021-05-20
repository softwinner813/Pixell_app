import 'package:flutter/material.dart';
import 'package:pixell_app/activity/search_user.dart';
import 'package:pixell_app/fragments/profile_fragment.dart';
import 'package:pixell_app/fragments/users_tab_layout.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';

class MyHomePageMain extends StatefulWidget {
  MyHomePageMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return new _MyHomePageMainStateFul();
  }
}

class _MyHomePageMainStateFul extends State<MyHomePageMain> {
  int currentTabIndex = 0;
  Widget currentScreen;

  List<Widget> tabs = [
    UsersTabLayout(),
    MyProfileFragment(),
    SearchUser(),
    MyProfileFragment(),
    MyProfileFragment()
  ];

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
      /*if (index == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyLogin(),
            ));
      } else {
        currentTabIndex = index;
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container(
      child: Stack(
        children: <Widget>[
         /* CustomNavigator(
            home: IndexedStack(
              index: currentTabIndex,
              children: tabs,
            ),
            //Specify your page route [PageRoutes.materialPageRoute] or [PageRoutes.cupertinoPageRoute]
            pageRoute: PageRoutes.materialPageRoute,
          ),*/
          IndexedStack(
            index: currentTabIndex,
            children: tabs,
          ),
          Align(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'graphics/surface_bottom_tab_curve.png',
                    fit: BoxFit.fill,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: body,
      //body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: onTapped,
        currentIndex: currentTabIndex,
        items: [
          new BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: currentTabIndex == 0
                  ? new Image.asset(
                      'graphics/icon-home.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    )
                  : new Image.asset(
                      'graphics/icon-home-1.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    ),
              title: new Text(
                  AppLocalizations.of(context).translate("label_home"),
                  style: new TextStyle(
                      color: currentTabIndex == 0
                          ? MyUtils()
                              .getColorFromHex(MyConstants.color_alert_top)
                          : Colors.white,
                      fontSize: MyConstants.bottomtab_text_size))),
          new BottomNavigationBarItem(
              icon: currentTabIndex == 1
                  ? new Image.asset(
                      'graphics/icon-requests.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    )
                  : new Image.asset(
                      'graphics/icon-requests-1.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    ),
              title: new Text(
                  AppLocalizations.of(context).translate("label_requests"),
                  style: new TextStyle(
                      color: currentTabIndex == 1
                          ? MyUtils()
                              .getColorFromHex(MyConstants.color_alert_top)
                          : Colors.white,
                      fontSize: MyConstants.bottomtab_text_size))),
          new BottomNavigationBarItem(
              icon: currentTabIndex == 2
                  ? new Image.asset(
                      'graphics/icon-search.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    )
                  : new Image.asset(
                      'graphics/icon-search-1.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    ),
              title: new Text(
                  AppLocalizations.of(context).translate("label_search"),
                  style: new TextStyle(
                      color: currentTabIndex == 2
                          ? MyUtils()
                              .getColorFromHex(MyConstants.color_alert_top)
                          : Colors.white,
                      fontSize: MyConstants.bottomtab_text_size))),
          new BottomNavigationBarItem(
              icon: currentTabIndex == 3
                  ? new Image.asset(
                      'graphics/icon-balance.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    )
                  : new Image.asset(
                      'graphics/icon-balance-1.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    ),
              title: new Text(
                  AppLocalizations.of(context).translate("label_balance"),
                  style: new TextStyle(
                      color: currentTabIndex == 3
                          ? MyUtils()
                              .getColorFromHex(MyConstants.color_alert_top)
                          : Colors.white,
                      fontSize: MyConstants.bottomtab_text_size))),
          new BottomNavigationBarItem(
              icon: currentTabIndex == 4
                  ? new Image.asset(
                      'graphics/icon-profile.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    )
                  : new Image.asset(
                      'graphics/icon-profile-1.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    ),
              title: new Text(
                  AppLocalizations.of(context).translate("label_profile"),
                  style: new TextStyle(
                      color: currentTabIndex == 4
                          ? MyUtils()
                              .getColorFromHex(MyConstants.color_alert_top)
                          : Colors.white,
                      fontSize: MyConstants.bottomtab_text_size))),
        ],
      ),
    );
  }
}
