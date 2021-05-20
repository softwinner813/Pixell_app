import 'package:flutter/material.dart';
import 'package:pixell_app/activity/walkthrough/walkthrough_base.dart';
import 'package:pixell_app/activity/walkthrough/walkthrough_page.dart';
import 'package:pixell_app/fragments/users_tab_layout.dart';
import 'package:pixell_app/localization/app_localizations.dart';

class LoginWalkthrough extends StatelessWidget {
  LoginWalkthrough({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Walkthrough(pages: <WalkthroughPage>[
      pageForIndex(0, context),
      pageForIndex(1, context),
      pageForIndex(2, context),
      pageForIndex(3, context),
      pageForIndex(4, context),
      pageForIndex(5, context),
    ], onDonePressed: () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UsersTabLayout()));
    }, onSkipPressed: () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UsersTabLayout()));
    },);
  }

  WalkthroughPage pageForIndex(int index, context) {
    return  WalkthroughPage(
      step: AppLocalizations.of(context).translate("walkthrough_login_${index}_step"),
      title: AppLocalizations.of(context).translate("walkthrough_login_${index}_title"),
      subtitle: AppLocalizations.of(context).translate("walkthrough_login_${index}_subtitle"),
      subsubtitle: AppLocalizations.of(context).translate("walkthrough_login_${index}_subsubtitle"),
      footer: AppLocalizations.of(context).translate("walkthrough_login_${index}_footer"),
      imageName: "graphics/walkthrough-login-$index.png",
      showArrow: index == 0,
    );
  }
}

