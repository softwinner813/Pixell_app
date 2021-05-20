import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/image_pojo.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

import 'requests/request_builder.dart';

class CarouselImageFull extends StatefulWidget {
  CarouselImageFull(
      {Key key,
      this.userID,
      this.listImagePojo,
      this.currentIndex,
      this.userName,
      this.onlyProfilePic})
      : super(key: key);

  List<ImagePojo> listImagePojo = [];
  int currentIndex = 1;
  String userName = "";
  bool onlyProfilePic;
  final String userID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CarouselImageFullStateful();
  }
}

class _CarouselImageFullStateful extends State<CarouselImageFull> {
  bool isLogin = false;
  List<dynamic> requestsId = [];

  @override
  void initState() {
    checkIsLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget topbar = Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            icon: Image.asset(
              'graphics/close.png',
              height: MyConstants.toolbar_icon_height_width,
              width: MyConstants.toolbar_icon_height_width,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context, true);
            }),
      ),
      height: MyConstants.topbar_height,
      width: MediaQuery.of(context).size.width,
    );

    Widget body = Container(
      child: Stack(
        children: <Widget>[
          CarouselSlider(
            items: widget.listImagePojo.map((getImages) {
              return new Builder(
                builder: (BuildContext context) {
                  return new Container(
                    width: MediaQuery.of(context).size.width,
                    margin: new EdgeInsets.symmetric(horizontal: 0.0),
                    decoration: new BoxDecoration(color: Colors.black),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset("graphics/user_default_rectangle.png"),
                            imageUrl: getImages.thumbUrl,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          ),
                          imageUrl: getImages.largeUrl,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
            onPageChanged: (value) {
              setState(() {
                widget.currentIndex = value;
              });
            },
            viewportFraction: 1.0,
            initialPage: widget.currentIndex,
            height: MediaQuery.of(context).size.height,
            autoPlay: false,
          ),
          topbar,
          Visibility(
            visible: !this.widget.onlyProfilePic,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                verticalDirection: VerticalDirection.up,
                children: <Widget>[
                  Visibility(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                          MyConstants.vertical_control_space,
                          MyConstants.vertical_control_space,
                          MyConstants.vertical_control_space,
                          MyConstants.vertical_control_space),
                      color: Colors.black.withOpacity(.5),
                      child: SizedBox(
                        height: MyConstants.btn_height,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestBuilder(
                                        sellerId: widget.userID,
                                      )),
                            );
                          },
                          color: MyUtils()
                              .getColorFromHex(MyConstants.color_theme),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("label_send_request"),
                            style: TextStyle(
                              fontSize: MyConstants.btn_round_text_size,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    visible: isLogin,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                        MyConstants.vertical_control_space,
                        MyConstants.vertical_control_space,
                        MyConstants.vertical_control_space,
                        isLogin ? 0.0 : MyConstants.vertical_control_space),
                    color: Colors.black.withOpacity(.5),
                    child: Text(
                      widget.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.listImagePojo
                        .asMap()
                        .map((index, value) {
                          return MapEntry(
                              index,
                              Container(
                                width: 10.0,
                                height: 10.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors
                                          .white, //                   <--- border color
                                    ),
                                    shape: BoxShape.circle,
                                    color: widget.currentIndex == index
                                        ? Colors.white
                                        : Color.fromRGBO(0, 0, 0, 0.4)),
                              ));
                        })
                        .values
                        .toList(),
                  ),
                ],
              ),
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

  @override
  void dispose() {
    super.dispose();
  }

  void checkIsLogin() {
    if (this.mounted) {
      MySharePreference()
          .getBoolInPref(MyConstants.PREF_KEY_ISLOGIN)
          .then((valueIsLogedIn) {
        setState(() {
          isLogin = valueIsLogedIn;
        });
      });
    }
  }
}
