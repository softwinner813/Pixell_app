import 'package:flutter/material.dart';
import 'package:pixell_app/activity/walkthrough/walkthrough_page.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Walkthrough extends StatefulWidget {
  Walkthrough({Key key, this.pages, this.onSkipPressed, this.onDonePressed, this.cta = "", this.onCTAPressed}) : super(key: key);

  @required
  final List<WalkthroughPage> pages;
  @required
  VoidCallback onSkipPressed;
  @required
  VoidCallback onDonePressed;

  final String cta;
  VoidCallback onCTAPressed;

  @override
  State<StatefulWidget> createState() {
    return new _WalkthroughStateful();
  }
}

class _WalkthroughStateful extends State<Walkthrough> {
  bool _lastPage = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: 0);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              MyUtils().getColorFromHex(MyConstants.color_walkthrough_bg_top),
              MyUtils().getColorFromHex(MyConstants.color_walkthrough_bg_mid),
              MyUtils().getColorFromHex(MyConstants.color_walkthrough_bg_bottom)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Stack(
            children: <Widget>[
              PageView(
                controller: pageController,
                children: widget.pages,
                onPageChanged: (int page) {
                  setState(() {
                    _lastPage = page == widget.pages.length - 1;
                  });
                },
              ),
              Column(
                children: <Widget>[
                  Spacer(),
                  Visibility(
                    child: Center(
                        child: SmoothPageIndicator(
                      controller: pageController, // PageController
                      count: widget.pages.length,
                      effect: SwapEffect(activeDotColor: MyUtils().getColorFromHex(MyConstants.color_walkthrough_dot), dotColor: Colors.black),
                    )),
                    visible: !_lastPage,
                  ),
                  Visibility(
                    child: Center(
                      child: new FlatButton(
                        onPressed: widget.onCTAPressed,
                        child: new Text(widget.cta, style: MyConstants.textStyle_walkthrough_cta)),
                    ),
                    visible: _lastPage && widget.cta.isNotEmpty,
                  ),
                  Container(margin: new EdgeInsets.only(bottom: MyConstants.space_50))
                ],
              ),
              Column(
                children: <Widget>[
                  Spacer(),
                  Row(
                    //new EdgeInsets.only(bottom: MyConstants.space_20/2)
                    children: <Widget>[
                      Visibility(
                        child: new FlatButton(
                            onPressed: widget.onSkipPressed,
                            child: new Text(AppLocalizations.of(context).translate("walkthrough_skip"),
                                style: MyConstants.textStyle_walkthrough_buttons)),
                        visible: !_lastPage,
                      ),
                      Spacer(),
                      Visibility(
                        child: new FlatButton(
                            onPressed: widget.onDonePressed,
                            child: new Text(AppLocalizations.of(context).translate("walkthrough_done"),
                                style: MyConstants.textStyle_walkthrough_buttons)),
                        visible: _lastPage && widget.cta.isEmpty,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
