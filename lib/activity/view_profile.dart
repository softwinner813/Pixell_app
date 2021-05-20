import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pixell_app/activity/carousel_image_full.dart';
import 'package:pixell_app/activity/requests/request_builder.dart';
import 'package:pixell_app/activity/search_user.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/get_user_derails.dart';
import 'package:pixell_app/models/get_values_pojo.dart';
import 'package:pixell_app/models/image_pojo.dart';
import 'package:pixell_app/models/post_request_pojo.dart';
import 'package:pixell_app/models/report_user_pojo.dart';
import 'package:pixell_app/presenter/get_userdetails_presenter.dart';
import 'package:pixell_app/presenter/get_values_presenter.dart';
import 'package:pixell_app/presenter/report_user_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';

import 'first_screen.dart';

class ViewProfile extends StatefulWidget {
  ViewProfile({Key key, this.userID}) : super(key: key);

  final String userID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ViewProfileStateful();
  }
}

class _ViewProfileStateful extends State<ViewProfile>
    implements GetValuesContract, GetUserDetailsContract, ReportUserContract {
  GetUserDetailsPresenter _getUserDetailsPresenter;
  GetValuesPresenter _getValuesPresenter;
  ReportUserPresenter _reportUserPresenter;

  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  File _imageUpload = null;
  String adultImageUrl = "";
  List<ImagePojo> _listImagePojo = [];
  List<ImagePojo> _profileImagePojo = [];
  List<String> listCountryDisplay = [];
  List<String> listCountryPassToApi = [];

  List<String> listGenderDisplay = [];
  List<String> listGenderPassToApi = [];

  List<String> listEthnicityDisplay = [];
  List<String> listEthnicityPassToApi = [];

  List<String> listbodyDisplay = [];
  List<String> listBodyPassToApi = [];

  List<ProfileDetailsSection> _profileDetailsSection = [];

  final textNameController = TextEditingController();
  String descriptionProfile = "";

  bool isLogin = false;

  String dropdownCountryValue = '';
  String dropdownGenderValue = '';
  String dropdownEthnicityValue = '';
  String dropdownBodyValue = '';
  String displayFlagPath = '';

  String dropdownPassCountryValue = '';
  int clickPos = 1;

  @override
  void initState() {
    checkIsLogin();

    _getValuesPresenter = GetValuesPresenter(this);
    _getUserDetailsPresenter = GetUserDetailsPresenter(this);
    _reportUserPresenter = ReportUserPresenter(this);

    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        _getValuesPresenter.doGetValues(context);

        _getUserDetailsPresenter.doGetUserDetails(context, widget.userID);
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
          IconButton(
              icon: Image.asset(
                'graphics/arrow-left.png',
                height: MyConstants.toolbar_icon_height_width,
                width: MyConstants.toolbar_icon_height_width,
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context, true);
              }),
          Text(
            AppLocalizations.of(context).translate("label_detailed_profile"),
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

    Widget _rightProfileDetails(imagepath, title) {
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              top: MyConstants.vertical_control_space_half,
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                child: Image.asset(
                  imagepath,
                  height: MyConstants.profile_riht_details_title_size,
                  width: MyConstants.profile_riht_details_title_size,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MyConstants.profile_riht_details_title_size,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    }

    List<Widget> _buildRightProfileRowList() {
      var test = 0;
      var lastIndex = 0;
      List<Widget> lines =
          []; // this will hold Rows according to available lines
      for (var line = 0;
          line <
              (((_profileDetailsSection.length % 3) == 0)
                  ? (_profileDetailsSection.length / 3)
                  : ((_profileDetailsSection.length % 3) + 1));
          line++) {
        List<Widget> placesForLine =
            []; // this will hold the places for each line

        if (_profileDetailsSection.length == 3) {
          lastIndex = 3;
        } else if (_profileDetailsSection.length < 3) {
          lastIndex = _profileDetailsSection.length;
        } else if (lastIndex == 0) {
          lastIndex = 3;
        } else {
          lastIndex = _profileDetailsSection.length;
        }

        for (test; test < lastIndex; test++) {
          placesForLine.add(Flexible(
            child: _rightProfileDetails(_profileDetailsSection[test].imagePath,
                _profileDetailsSection[test].title),
          ));
        }

        lines.add(Row(children: placesForLine));
      }
      return lines;
    }

    Widget topProfileSection = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0,
                MyConstants.vertical_control_space + MyConstants.topbar_height,
                0.0,
                MyConstants.vertical_control_space),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    "graphics/user_default_rectangle.png",
                    height: MyConstants.edit_profile_image_h_w,
                    width: MyConstants.edit_profile_image_h_w,
                  ),
                  imageUrl: (_profileImagePojo != null &&
                          _profileImagePojo.length > 0)
                      ? _profileImagePojo[0].thumbUrl
                      : "",
                  height: MyConstants.edit_profile_image_h_w,
                  width: MyConstants.edit_profile_image_h_w,
                ),
                onTap: () {
                  List<ImagePojo> prifilePhotoTemp = [];
                  prifilePhotoTemp.add(
                      ImagePojo(_profileImagePojo[0].thumbUrl,_profileImagePojo[0].largeUrl, "", null));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CarouselImageFull(
                              userID: widget.userID,
                              currentIndex: 0,
                              listImagePojo: prifilePhotoTemp,
                              userName: textNameController.text,
                              onlyProfilePic: true,
                            )),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.all(5),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      textNameController.text,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Visibility(
                      child: _rightProfileDetails(
                          displayFlagPath, dropdownCountryValue),
                      visible: !dropdownCountryValue.isEmpty,
                    ),
                    Column(
                      children: _buildRightProfileRowList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                0.0, MyConstants.vertical_control_space, 0.0, 0.0),
          ),
          Text(descriptionProfile),
        ],
      ),
    );

    Widget middleSubSection = Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0.0, MyConstants.space_20, 0.0, 0.0),
          ),
          Visibility(
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
                color: MyUtils().getColorFromHex(MyConstants.color_theme),
                child: Text(
                  AppLocalizations.of(context).translate("label_send_request"),
                  style: TextStyle(
                    fontSize: MyConstants.btn_round_text_size,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            visible: isLogin,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, MyConstants.space_20, 0.0, 0.0),
          ),
        ],
      ),
    );

    Widget middleSection = CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              topProfileSection,
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[middleSubSection],
          ),
        ),
        loadProfileSilverGridData(),
        SliverPadding(
          padding: EdgeInsets.only(bottom: MyConstants.space_40),
        ),
        SliverToBoxAdapter(
          child: Visibility(
            child: Column(
              children: <Widget>[SizedBox(
                height: MyConstants.btn_height,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: () {
                    MyUtils().alertDialogBox(
                      context,
                      'graphics/info_large.png',
                      AppLocalizations.of(context).translate("label_alert_report_user_title"),
                      AppLocalizations.of(context).translate("label_alert_report_user_body"),
                      <Widget>[
                        FlatButton(
                            child: Text(
                              AppLocalizations.of(context).translate("label_alert_report_user_button").toUpperCase(),
                              style: MyConstants.textStyle_red_dialog_btn,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              report();
                            }),
                        FlatButton(
                            child: Text(
                              AppLocalizations.of(context).translate("label_cancel").toUpperCase(),
                              style: MyConstants.textStyle_dialog_btn,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    );
                  },
                  color: Colors.red,
                  child: Text(
                    AppLocalizations.of(context).translate("label_report_user"),
                    style: TextStyle(
                      fontSize: MyConstants.btn_round_text_size,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),],
            ),
            visible: isLogin,
          )
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: MyConstants.bottombar_height),
        ),
      ],
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
                right: MyConstants.layout_margin),
            child: middleSection,
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
                        : bottomBanner),
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

  SliverGrid loadProfileSilverGridData() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
              alignment: Alignment.center,
              child: Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    clickPos = index;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarouselImageFull(
                                userID: widget.userID,
                                currentIndex: clickPos,
                                listImagePojo: _listImagePojo,
                                userName: textNameController.text,
                                onlyProfilePic: false,
                              )),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            "graphics/user_default_rectangle.png",
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          ),
                          imageUrl: _listImagePojo[index].thumbUrl,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
        addAutomaticKeepAlives: true,
        childCount: _listImagePojo.length,
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    textNameController.dispose();
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

  @override
  void onGetValuesError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onGetValuesSuccess(GetValuesPojo pojoData) {
    if (pojoData != null) {
      if (pojoData.country != null) {
        Map<String, String> _mapData = pojoData.country.toJsonStringType();
        listCountryPassToApi.addAll(_mapData.keys.toList());
        listCountryDisplay.addAll(_mapData.values.toList());
      }

      if (pojoData.gender != null) {
        Map<String, String> _mapData = pojoData.gender.toJsonStringType();
        listGenderPassToApi.addAll(_mapData.keys.toList());
        listGenderDisplay.addAll(_mapData.values.toList());
      }

      if (pojoData.race != null) {
        Map<String, String> _mapData = pojoData.race.toJsonStringType();
        listEthnicityPassToApi.addAll(_mapData.keys.toList());
        listEthnicityDisplay.addAll(_mapData.values.toList());
      }

      if (pojoData.body != null) {
        Map<String, String> _mapData = pojoData.body.toJsonStringType();
        listBodyPassToApi.addAll(_mapData.keys.toList());
        listbodyDisplay.addAll(_mapData.values.toList());
      }
    }
  }

  @override
  void onDetailsError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onDetailsSuccess(GetUserDetailsPojo pojoData) {
    if (pojoData != null) {
      _profileDetailsSection.clear();

      setState(() {
        textNameController.text = pojoData.username;
        if (pojoData.profile != null && pojoData.profile.pics != null) {
          //For to add Profile pic here
          if (pojoData.profile.profilePic != null) {
            _profileImagePojo.clear();
            _profileImagePojo.add(ImagePojo(pojoData.profile.thumbnail,
                pojoData.profile.profilePic, "", null));
          }

          List<Pic> picsProfile = pojoData.profile.pics;
          for (var i = 0; i < picsProfile.length; i++) {
            Pic picTemp = picsProfile[i];
            String thumbUrl = picTemp.thumbnail;
            String regular = picTemp.regular;

            const start = "media/";

            if (!regular.isEmpty && regular.contains(start)) {
              final startIndex = regular.indexOf(start);
              final endIndex = regular.length;

              String forDeleteFileName =
                  regular.substring(startIndex + start.length, endIndex);

              _listImagePojo.add(ImagePojo(
                  thumbUrl, regular, forDeleteFileName, _imageUpload));
            }
          }
        }

        if (pojoData.profile != null && pojoData.profile.description != null) {
          descriptionProfile = pojoData.profile.description;
        }

        if (pojoData.profile != null && pojoData.profile.isSeller != null) {
          if (pojoData.profile.isSeller) {
            _profileDetailsSection.add(new ProfileDetailsSection(
                title: AppLocalizations.of(context).translate('label_seller'),
                imagePath: "graphics/profile_icn.png"));
          } else {
            _profileDetailsSection.add(new ProfileDetailsSection(
                title: AppLocalizations.of(context).translate('label_buyer'),
                imagePath: "graphics/profile_icn.png"));
          }
        }

        if (pojoData.profile != null && pojoData.profile.country != null) {
          dropdownCountryValue = listCountryDisplay[
              listCountryPassToApi.indexOf(pojoData.profile.country)];

          displayFlagPath = "graphics/flag_" + pojoData.profile.country + ".png";

        }

        if (pojoData.profile != null && pojoData.profile.gender != null) {
          dropdownGenderValue = listGenderDisplay[
              listGenderPassToApi.indexOf(pojoData.profile.gender)];

          _profileDetailsSection.add(new ProfileDetailsSection(
              title: dropdownGenderValue,
              imagePath: "graphics/profile_gender.png"));
        }

        // Set physical_appearance data
        if (pojoData.profile != null &&
            pojoData.profile.physicalAppearance != null) {
          if (pojoData.profile.physicalAppearance.heightCm != null) {
            _profileDetailsSection.add(new ProfileDetailsSection(
                title: pojoData.profile.physicalAppearance.heightCm.toString(),
                imagePath: "graphics/profile_height.png"));
          }

          if (pojoData.profile.physicalAppearance.weightKg != null) {
            _profileDetailsSection.add(new ProfileDetailsSection(
                title: pojoData.profile.physicalAppearance.weightKg.toString(),
                imagePath: "graphics/profile_weight.png"));
          }

          if (pojoData.profile.physicalAppearance.race != null) {
            dropdownEthnicityValue = listEthnicityDisplay[listEthnicityPassToApi
                .indexOf(pojoData.profile.physicalAppearance.race)];

            _profileDetailsSection.add(new ProfileDetailsSection(
                title: dropdownEthnicityValue,
                imagePath: "graphics/profile_ethnicity.png"));
          }

          if (pojoData.profile.physicalAppearance.body != null) {
            dropdownBodyValue = listbodyDisplay[listBodyPassToApi
                .indexOf(pojoData.profile.physicalAppearance.body)];

            _profileDetailsSection.add(new ProfileDetailsSection(
                title: dropdownBodyValue,
                imagePath: "graphics/profile_body.png"));
          }
        }
      });
    }
  }

  @override
  void onPostRequestError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  void report() {
    MyUtils().check().then((internet) {
      if (internet != null && internet) {
        MySharePreference()
            .getIntegerInPref(MyConstants.PREF_KEY_USERID)
            .then((value) {
          if (value != -1) {
            MySharePreference()
                .getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN)
                .then((valueToken) {
              if (valueToken.isNotEmpty) {
                _reportUserPresenter.doReport(context, widget.userID, valueToken);
              }
            });
          }
        });
      } else {
        MyUtils().toastdisplay(
            AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });
  }

  @override
  void onPostRequestSuccess(PostRequestPojo pojodata) {
    if (pojodata != null) {
      if (pojodata.detail != null) {
        MyUtils().toastdisplay(pojodata.detail);
      } else if (pojodata.status != null) {
        MyUtils().toastdisplay(pojodata.status);
      }
    }
  }

  @override
  void onReportUserSuccess(ReportUserPojo pojoData) {
    MyUtils().alertDialogBox(
      context,
      'graphics/icon-checkmark.png',
      AppLocalizations.of(context).translate("label_alert_report_user_success_title"),
      AppLocalizations.of(context).translate("label_alert_report_user_success_body"),
      <Widget>[
        FlatButton(
            child: Text(
              AppLocalizations.of(context).translate("label_accept").toUpperCase(),
              style: MyConstants.textStyle_dialog_btn,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ]
    );
  }

  @override
  void onReportUserError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }
}

class ProfileDetailsSection {
  String title;
  String imagePath;

  ProfileDetailsSection({this.title, this.imagePath});
}
