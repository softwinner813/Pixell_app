import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pixell_app/activity/walkthrough/first_walkthrough.dart';
import 'package:pixell_app/fragments/users_tab_layout.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => new _MySplashState();
}

class _MySplashState extends State<MySplash> {
  dynamic redirectScreen = null;

  Timer _timer;

  @override
  void initState() {
    super.initState();

    MyConstants.currentSelectedBottomTab = 0;

    getCredential();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'graphics/top-logo.png',
              width: 120.0,
              height: 150.0,
            ),
          ],
        ),
      ),
    );
  }

  getCredential() {
    MySharePreference()
        .getBoolInPref(MyConstants.PREF_KEY_ISLOGIN)
        .then((value) {
      if (value) {
        redirectScreen = UsersTabLayout();
      } else {
        MySharePreference().saveBoolInPref(MyConstants.PREF_AS_GUEST, true);
        redirectScreen = UsersTabLayout();
      }

      MySharePreference().getBoolInPref(MyConstants.PREF_KEY_INITIAL_WALKTHROUGH_SHOWN).then((value) {
        if (!value) {
          redirectScreen = FirstWalkthrough();
          MySharePreference().saveBoolInPref(MyConstants.PREF_KEY_INITIAL_WALKTHROUGH_SHOWN, true);
        }
        loadNextScreenData();
      });

    });
  }

  Future<Timer> loadNextScreenData() async {
    _timer = new Timer(Duration(seconds: 1), onDoneLoading);
    return _timer;
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => redirectScreen));
  }
  @override
  void dispose() {
    super.dispose();
    if(_timer!=null) {
      _timer.cancel();
    }
  }

}
