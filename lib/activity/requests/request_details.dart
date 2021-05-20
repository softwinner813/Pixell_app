import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_geolocation/geolocation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixell_app/activity/requests/request_image_full.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/charge_card_pojo.dart';
import 'package:pixell_app/models/get_creditcard_pojo.dart';
import 'package:pixell_app/models/get_rates_pojo.dart';
import 'package:pixell_app/models/get_request_tree_pojo.dart';
import 'package:pixell_app/models/get_request_pojo.dart';
import 'package:pixell_app/models/post_image_pojo.dart';
import 'package:pixell_app/models/requests_pojo.dart';
import 'package:pixell_app/models/update_request_pojo.dart';
import 'package:pixell_app/payment/card_input_formatters.dart';
import 'package:pixell_app/payment/payment_card.dart';
import 'package:pixell_app/presenter/charge_card_presenter.dart';
import 'package:pixell_app/presenter/get_creditcard_presenter.dart';
import 'package:pixell_app/presenter/get_rates_presenter.dart';
import 'package:pixell_app/presenter/get_request_detail_presenter.dart';
import 'package:pixell_app/presenter/post_image_presenter.dart';
import 'package:pixell_app/presenter/request_builder_presenter.dart';
import 'package:pixell_app/presenter/update_reques_presenter.dart';
import 'package:pixell_app/utils/login_after_bottom_tab_widget.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:pixell_app/utils/share_preference.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../view_profile.dart';
import 'package:pixell_app/models/get_hints_pojo.dart';
import 'package:pixell_app/presenter/get_hints_presenter.dart';

class RequestDetails extends StatefulWidget {
  RequestDetails({Key key, this.requestDetailsPojo, this.loginUserId, this.requestId}) : super(key: key);

  Result requestDetailsPojo;
  int loginUserId;
  dynamic requestId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RequestDetailsStateful();
  }
}

class _RequestDetailsStateful extends State<RequestDetails>
    implements
        GetRequestContract,
        RequestTreeContract,
        UpdateRequestContract,
        GetRatesContract,
        ChargeCardContract,
        PostImageContract,
        GetCreditCardContract,
        GetHintsContract {
  RequestTreePresenter _requestTreePresenter;
  GetRequestPresenter _requestPresenter;
  UpdateRequestPresenter _updateRequestPresenter;
  GetRatesPresenter _getRatesPresenter;
  ChargeCardPresenter _chargeCardPresenter;
  PostImagePresenter _postImagePresenter;

  GetHintsPojo _hintsPojo;

  BottomWidgetAfterLogin _bottomWidgetAfterLogin = new BottomWidgetAfterLogin();

  String cc_last_four = "";

  Position _currentPosition;
  String _currentAddress;
  String sendImageUrl = "";

  var _formKey = new GlobalKey<FormState>();
  var _autoValidate = false;
  CardUtils _cardUtils = null;

  var _paymentCard = PaymentCard();

  final textNameController = TextEditingController();
  final textCardNumberController = TextEditingController();
  final textExpDateController = TextEditingController();
  final textSecurityCodeController = TextEditingController();
  final textAmountController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _cardNumberFocus = FocusNode();
  final FocusNode _expDateFocus = FocusNode();
  final FocusNode _securityCodeFocus = FocusNode();

  bool checkedSaveCard = false;
  bool isLogin = false;
  bool needtoAddCardDetails = false;
  bool needToUsePrevCard = false;
  bool allFieldValidate = false;

  double spaceAroundRequests = 20;
  double spaceBetweenRequests = 2.0;
  double pixellRates = 0.0;
  int scrollingTextField = 100;
  bool isEnableConfirm = false;
  List<String> requestFinalTree = [];
  List<int> tempRequestsIdList = [];

  double requestreeBoxMinWidth = 0;
  double requestreeBoxMaxWidth = 0;
  String myCurrencyName = "";
  String tokenLogin = "";
  Token _paymentTokenStripe;

  @override
  void initState() {
    StripePayment.setOptions(StripeOptions(publishableKey: "pk_live_Q9ZXHpuSj5nvKu7QKsaz0YNa00cvZmKK8A", merchantId: "Live-Pixell", androidPayMode: 'Live-Pixell'));

    checkIsLogin();

    _cardUtils = new CardUtils(context);

    _paymentCard.type = CardType.Others;
    textCardNumberController.addListener(_getCardTypeFrmNumber);

    _requestTreePresenter = new RequestTreePresenter(this);
    _requestPresenter = new GetRequestPresenter(this);

    _getCurrentLocation();

    MyUtils().check().then((internet) {
      if (internet != null && internet) {
        // Get hints
        GetHintsPresenter _getHintsPresenter = GetHintsPresenter(this);
        _getHintsPresenter.doGetHints(context);
        _callApiForGetRequestDetailIfNeeded();
      } else {
        MyUtils().toastdisplay(AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });

    textAmountController.addListener(() {
      setState(() {
        isEnableConfirm = textAmountController.text.isEmpty ? false : true;
      });
    });

    allFocusListener();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container(
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              left: MyConstants.layout_margin,
              right: MyConstants.layout_margin,
            ),
            child: (widget.requestDetailsPojo != null) ? createMiddleSection() : Center(child: CircularProgressIndicator()),
          ),
          createTopbar(),
          Align(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Container(
                    child: isLogin
                        ? Container(
                            height: MyConstants.bottombar_height,
                            child: _bottomWidgetAfterLogin.calllBottomTabWidget(context),
                          )
                        : Container())
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(resizeToAvoidBottomInset: false, backgroundColor: MyUtils().getColorFromHex(MyConstants.color_screeb_bg), body: body);
  }

  Widget createTopbar() {
    return Container(
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
          Expanded(
            child: Text(
              AppLocalizations.of(context).translate("label_request_details"),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: MyConstants.toolbar_text_size, color: Colors.white),
            ),
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
  }

  Widget createGoConfirm() {
    return new Container(
      margin: const EdgeInsets.only(
        top: MyConstants.vertical_control_space * 4,
      ),
      child: Column(
        children: <Widget>[
          Visibility(
            child: SizedBox(
              height: MyConstants.btn_height,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: () {
                  if (isEnableConfirm) {
                    _updateRequest(textAmountController.text, MyConstants.STATUS_PAYMENT_PENDING, "");
                  }
                },
                color:
                    isEnableConfirm ? MyUtils().getColorFromHex(MyConstants.color_theme) : MyUtils().getColorFromHex(MyConstants.color_gray_button),
                child: Text(
                  AppLocalizations.of(context).translate("label_confirm"),
                  style: TextStyle(
                    fontSize: MyConstants.btn_round_text_size,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            visible: widget.requestDetailsPojo.userTo.id == widget.loginUserId,
          ),
          Visibility(
            child: Container(
              margin: EdgeInsets.all(
                MyConstants.vertical_control_space * 2,
              ),
            ),
            visible: widget.requestDetailsPojo.userTo.id == widget.loginUserId,
          ),
          Visibility(
            child: InkWell(
              onTap: () {
                _updateRequest("", MyConstants.STATUS_CANCELED_BY_SELLER, "");
              },
              child: Text(
                AppLocalizations.of(context).translate('label_cancel_req'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MyConstants.title_text_size,
                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                ),
              ),
            ),
            visible: (widget.requestDetailsPojo.status == MyConstants.STATUS_QUOTATION_PENDING &&
                widget.requestDetailsPojo.userTo.id == widget.loginUserId),
          ),
        ],
      ),
    );
  }

  Widget createTopProfileSection() {
    return Container(
      height: MyConstants.request_details_profile_image_h_w + spaceAroundRequests + 10,
      child: new Stack(
        children: <Widget>[_planetCard(), _planetThumbnail()],
      ),
    );
  }

  Widget createMiddleSection() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: MyConstants.vertical_control_space + MyConstants.topbar_height),
              ),
              createTopProfileSection(),
              _planetRequestTreeSection(),
              (widget.requestDetailsPojo.userTo.id != widget.loginUserId &&
                  (widget.requestDetailsPojo.status ==
                      MyConstants.STATUS_DELIVERED ||
                      widget.requestDetailsPojo.status ==
                          MyConstants.STATUS_CLOSED))
                  ? _planetReceivePhotoSection()
                  : Container(),
              widget.requestDetailsPojo.status == MyConstants.STATUS_QUOTATION_PENDING
                  ? (widget.requestDetailsPojo.userTo.id == widget.loginUserId ? _planetQuation_PendingPriceSection() : Container())
                  : _planetPayment_Pending_FullFillPriceSection(),
              widget.requestDetailsPojo.status == MyConstants.STATUS_QUOTATION_PENDING
                  ? createGoConfirm()
                  : (widget.requestDetailsPojo.userTo.id != widget.loginUserId
                      ? (widget.requestDetailsPojo.status == MyConstants.STATUS_FULFILLMENT_PENDING
                          ? Container()
                          : (widget.requestDetailsPojo.status == MyConstants.STATUS_DELIVERED
                              ? _planetDeliveredSection()
                              : (widget.requestDetailsPojo.status == MyConstants.STATUS_CLOSED ? Container() : _planetCreditCardSection())))
                      : Container()),
              (widget.requestDetailsPojo.userTo.id != widget.loginUserId && widget.requestDetailsPojo.status == MyConstants.STATUS_CLOSED)
                  ? _planetCloseSection()
                  : Container(),
            ],
          ),
        ),
        /*SliverList(
          delegate: SliverChildListDelegate(
            [
              middleviewBelowGrid(),
            ],
          ),
        ),*/
        SliverPadding(
          padding: EdgeInsets.only(bottom: MyConstants.bottombar_height + 100),
        )
      ],
    );
  }

  _planetThumbnail() {
    String displayThumb = null;

    if (widget.requestDetailsPojo.userTo != null && widget.requestDetailsPojo.userFrom != null) {
      if (widget.requestDetailsPojo.userTo.id == widget.loginUserId) {
        if (widget.requestDetailsPojo.userFrom.thumbnail != null) {
          displayThumb = widget.requestDetailsPojo.userFrom.thumbnail;
        }
      } else if (widget.requestDetailsPojo.userTo.thumbnail != null) {
        displayThumb = widget.requestDetailsPojo.userTo.thumbnail;
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
            height: MyConstants.request_details_profile_image_h_w,
            width: MyConstants.request_details_profile_image_h_w,
          ),
        ));
  }

  _planetCard() {
    return new InkWell(
      child: Container(
        width: double.infinity,
        margin: new EdgeInsets.only(left: MyConstants.request_details_profile_image_h_w / 3),
        padding: new EdgeInsets.only(
            left: MyConstants.request_details_profile_image_h_w / 1.3,
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
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        int detailUserId = widget.requestDetailsPojo.userTo.id == widget.loginUserId
                            ? widget.requestDetailsPojo.userFrom.id
                            : widget.requestDetailsPojo.userTo.id;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewProfile(
                                userID: detailUserId.toString(),
                              ),
                            ));
                      },
                      child: Text(
                        //widget.requestDetailsPojo.userTo.name,

                        widget.requestDetailsPojo.userTo.id == widget.loginUserId
                            ? widget.requestDetailsPojo.userFrom.name
                            : widget.requestDetailsPojo.userTo.name,

                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.requestDetailsPojo.userTo.id == widget.loginUserId
                          ? AppLocalizations.of(context).translate("label_buyer")
                          : AppLocalizations.of(context).translate("label_seller"),
                      overflow: TextOverflow.ellipsis,
                      style: MyConstants.textStyle_request_other,
                    ),
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
                        new DateFormat(MyConstants.format_mm_dd_yy).format(widget.requestDetailsPojo.updateTime),
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
                        new DateFormat(MyConstants.format_mm_dd_yy).format(widget.requestDetailsPojo.expirationDate),
                        overflow: TextOverflow.ellipsis,
                        style: MyConstants.textStyle_request_other,
                      ),
                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MyConstants.btn_request_height,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(image: AssetImage("graphics/request_pending_status.png"), fit: BoxFit.cover),
                      ),
                      child: Center(
                        child: Text(
                          _setStatus(widget.requestDetailsPojo.status),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _planetRequestTreeSection() {
    requestreeBoxMinWidth = MediaQuery.of(context).size.width / 3;
    requestreeBoxMaxWidth = (MediaQuery.of(context).size.width / 3) + 10;

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space * 3,
          ),
        ),
        Text(
          widget.requestDetailsPojo.userTo.id != widget.loginUserId
              ? AppLocalizations.of(context).translate('label_details_request')
              : AppLocalizations.of(context).translate('label_buyer_like_this'),
          overflow: TextOverflow.ellipsis,
          style: MyConstants.textStyle_request_detailsHeader,
        ),
        Container(
            margin: const EdgeInsets.only(
              top: MyConstants.vertical_control_space,
            ),
            height: 190.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: requestFinalTree.length,
                itemBuilder: (context, index) {
                  return new ConstrainedBox(
                      constraints: new BoxConstraints(
                        minWidth: requestreeBoxMinWidth,
                        maxWidth: requestreeBoxMaxWidth,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                          decoration: new BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(5, 5),
                                blurRadius: 10,
                              )
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [Colors.white, MyUtils().getColorFromHex(MyConstants.color_yellow)],
                            ),
                            borderRadius: new BorderRadius.circular(4.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _planetRequestTreeTitleSection(requestFinalTree[index].split(","))),
                          ),
                        ),
                      ));
                }))
      ],
    );
  }

  List<Widget> _planetRequestTreeTitleSection(splitRequestTreeName) {
    List<Widget> lines = [];
    for (var test = 0; test < splitRequestTreeName.length; test++) {
      if (test == 0) {
        lines.add(Padding(
          padding: EdgeInsets.all(2),
          child: AutoSizeText(
            splitRequestTreeName[test].toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ));
      } else if (test == splitRequestTreeName.length - 1) {
        lines.add(Padding(
          padding: EdgeInsets.all(2),
          child: AutoSizeText(
            splitRequestTreeName[test].toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ));
      } else {
        lines.add(Padding(
          padding: EdgeInsets.all(2),
          child: AutoSizeText(splitRequestTreeName[test].toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              )),
        ));
      }

      lines.add(ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: requestreeBoxMinWidth,
          maxWidth: requestreeBoxMaxWidth,
        ),
        child: Divider(
          color: MyUtils().getColorFromHex(MyConstants.color_forward_arrow),
          height: MyConstants.height_devider,
        ),
      ));
    }
    return lines;
  }

  _planetQuation_PendingPriceSection() {
    return new Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space * 3,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                AppLocalizations.of(context).translate('label_give_price'),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: MyConstants.textStyle_request_detailsHeader,
              ),
            ),
            InkWell(
              onTap: () {
                MyUtils().customAlertHintDialogBox(context, 'graphics/icon-pixell-point-white.png', _hintsPojo, "price_the_seller_offered");
              },
              child: Image.asset(
                'graphics/icon-info-white.png',
                height: MyConstants.bottomtab_icn_height_width,
                width: MyConstants.bottomtab_icn_height_width,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space,
          ),
          width: double.infinity,
          padding: new EdgeInsets.all(spaceAroundRequests),
          decoration: new BoxDecoration(
            color: MyUtils().getColorFromHex(MyConstants.color_theme),
            borderRadius: new BorderRadius.circular(5.0),
          ),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.9,
                  child: TextFormField(
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    controller: textAmountController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (term) {},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                      Text(
                        AppLocalizations.of(context).translate("label_pixell_points"),
                        overflow: TextOverflow.ellipsis,
                        style: MyConstants.textStyle_request_other,
                      ),
                    ],
                  ),
                  Text(
                    "= " + myCurrencyName + " " + pixellPointToPriceConvert(textAmountController.text),
                    style: new TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  String pixellPointToPriceConvert(String pixellPoint) {
    if (pixellPoint.isEmpty) {
      return "";
    } else {
      return (int.parse(pixellPoint) * pixellRates).toStringAsFixed(2);
    }
  }

  _planetPayment_Pending_FullFillPriceSection() {
    String tempHeaderDisplay = "";
    String tempRedMsg = "";

    if (widget.requestDetailsPojo.userTo.id == widget.loginUserId) {
      tempHeaderDisplay = AppLocalizations.of(context).translate('label_price_offered');
      if (widget.requestDetailsPojo.status == MyConstants.STATUS_DELIVERED) {
        tempRedMsg = AppLocalizations.of(context).translate('msg_checking_price');
      }
    } else if (widget.requestDetailsPojo.status == MyConstants.STATUS_FULFILLMENT_PENDING) {
      tempHeaderDisplay = AppLocalizations.of(context).translate('label_you_paid');
      tempRedMsg = AppLocalizations.of(context).translate('msg_csend_seller_picture');
    } else if (widget.requestDetailsPojo.status == MyConstants.STATUS_DELIVERED) {
      tempHeaderDisplay = AppLocalizations.of(context).translate('label_you_paid');
    } else {
      tempHeaderDisplay = AppLocalizations.of(context).translate('label_price_seller_offered');
    }

    return new Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space * 1.5,
          ),
        ),
        Visibility(
          child: Container(
            margin: const EdgeInsets.only(
              top: MyConstants.vertical_control_space,
            ),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: MyUtils().getColorFromHex(MyConstants.color_age_verifed_box),
            ),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'graphics/adult_pending.png',
                  height: 25,
                  width: 25,
                ),
                Container(
                  margin: EdgeInsets.all(5),
                ),
                Expanded(
                  child: Text(
                    tempRedMsg,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MyConstants.title_below_text_size,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ),
          visible: !tempRedMsg.isEmpty,
        ),
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space * 2.1,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                tempHeaderDisplay,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: MyConstants.textStyle_request_detailsHeader,
              ),
            ),
            InkWell(
              onTap: () {
                MyUtils().customAlertHintDialogBox(context, 'graphics/icon-pixell-point-white.png', _hintsPojo, "price_the_seller_offered");
              },
              child: Image.asset(
                'graphics/icon-info-white.png',
                height: MyConstants.bottomtab_icn_height_width,
                width: MyConstants.bottomtab_icn_height_width,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space,
          ),
          width: double.infinity,
          padding: new EdgeInsets.all(spaceAroundRequests),
          decoration: new BoxDecoration(
            color: MyUtils().getColorFromHex(MyConstants.color_theme),
            borderRadius: new BorderRadius.circular(5.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: AutoSizeText(
                  widget.requestDetailsPojo.amount.toString(),
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: MyConstants.font_size_request_detail_price),
                ),
              ),
              Container(
                margin: EdgeInsets.all(2.0),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MyConstants.padding_request_detail_price),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'graphics/icon-pixell-point-white.png',
                      height: MyConstants.bottomtab_icn_height_width,
                      width: MyConstants.bottomtab_icn_height_width,
                    ),
                    Container(
                      margin: new EdgeInsets.all(spaceBetweenRequests),
                    ),
                    Text(
                      "= " + myCurrencyName + " " + pixellPointToPriceConvert(widget.requestDetailsPojo.amount.toString()),
                      style: new TextStyle(
                        fontSize: MyConstants.font_size_request_detail_countrycode,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Text(
          AppLocalizations.of(context).translate('label_charge_amount') + " " + myCurrencyName + " " + pixellPointToPriceConvert(widget.requestDetailsPojo.chargeAmount.toString()),
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.red, fontSize: 14.0),
        ),
        Visibility(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(
                  MyConstants.vertical_control_space * 2,
                ),
              ),
              SizedBox(
                height: MyConstants.btn_height,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: () {
                    _optionsPhotoDialogBox(context, 'graphics/upload.png', AppLocalizations.of(context).translate("msg_top_add_photo_dialog"),
                        AppLocalizations.of(context).translate("label_close"));
                  },
                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                  child: Text(
                    AppLocalizations.of(context).translate("label_take_your_selfie"),
                    style: TextStyle(
                      fontSize: MyConstants.btn_round_text_size,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(
                  MyConstants.vertical_control_space * 2,
                ),
              ),
              InkWell(
                onTap: () {
                  _updateRequest("", MyConstants.STATUS_CANCELED_BY_SELLER, "");
                },
                child: Text(
                  AppLocalizations.of(context).translate('label_cancel_req'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MyConstants.title_text_size,
                    color: MyUtils().getColorFromHex(MyConstants.color_theme),
                  ),
                ),
              ),
            ],
          ),
          visible: (widget.requestDetailsPojo.userTo.id == widget.loginUserId &&
              widget.requestDetailsPojo.status == MyConstants.STATUS_FULFILLMENT_PENDING),
        ),
      ],
    );
  }

  _planetReceivePhotoSection() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin:
          const EdgeInsets.all(MyConstants.vertical_control_space * 1.5),
        ),
        Text(
          AppLocalizations.of(context).translate("label_picture_received"),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: MyConstants.textStyle_request_detailsHeader,
        ),
        Container(
          margin: EdgeInsets.only(
            top: MyConstants.vertical_control_space,
          ),
        ),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RequestedImageFull(
                        requestDetailsPojo: widget.requestDetailsPojo)),
              );
            },
            child: FadeInImage.assetNetwork(
                height: MediaQuery.of(context).size.height / 4,
                width: MyConstants.adult_image_h_w,
                fit: BoxFit.fitHeight,
                placeholder: "graphics/user_default_rectangle.png",
                image: widget.requestDetailsPojo.asset_link != null
                    ? widget.requestDetailsPojo.asset_link
                    : ""),
          ),
        ),
      ],
    );
  }

  _planetDeliveredSection() {
    return new Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(MyConstants.vertical_control_space * 2),
        ),
        SizedBox(
          height: MyConstants.btn_height,
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            onPressed: () {
              _updateRequest("", MyConstants.STATUS_CLOSED, "");
            },
            color: MyUtils().getColorFromHex(MyConstants.color_green_019807),
            child: Text(
              AppLocalizations.of(context).translate("label_accept_this_picture"),
              style: TextStyle(
                fontSize: MyConstants.btn_round_text_size,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(
            MyConstants.vertical_control_space * 2,
          ),
        ),
        SizedBox(
          height: MyConstants.btn_height,
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            onPressed: () {
              _updateRequest("", MyConstants.STATUS_REVIEW_PENDING, "");
            },
            color: Colors.red,
            child: Text(
              AppLocalizations.of(context).translate("label_or_request_pixell"),
              style: TextStyle(
                fontSize: MyConstants.btn_round_text_size,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _planetCloseSection() {
    return new Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space * 1.5,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space,
          ),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: MyUtils().getColorFromHex(MyConstants.color_accept_msg_bg),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.done,
                size: 25,
                color: MyUtils().getColorFromHex(MyConstants.color_green_019807),
              ),
              Container(
                margin: EdgeInsets.all(5),
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).translate('msg_thanks_accept_picture'),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MyConstants.title_below_text_size,
                    color: MyUtils().getColorFromHex(MyConstants.color_green_019807),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space * 2.1,
          ),
        ),
        SizedBox(
          height: MyConstants.btn_height,
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            onPressed: () {
              MyUtils().check().then((internet) {
                if (internet != null && internet && widget.requestDetailsPojo.asset_link != null) {
                  _downloadImageAndSaveToGallery(widget.requestDetailsPojo.asset_link);
                } else {
                  MyUtils().toastdisplay(AppLocalizations.of(context).translate('msg_no_internet'));
                }
              });
            },
            color: MyUtils().getColorFromHex(MyConstants.color_theme),
            child: Text(
              AppLocalizations.of(context).translate("label_download_picture"),
              style: TextStyle(
                fontSize: MyConstants.btn_round_text_size,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _planetCreditCardSection() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space * 2.1,
          ),
        ),
        Text(
          AppLocalizations.of(context).translate('label_pay_credit_card'),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: MyConstants.textStyle_request_detailsHeader,
        ),
        Container(
          margin: const EdgeInsets.only(
            top: MyConstants.vertical_control_space,
          ),
          width: double.infinity,
          padding: new EdgeInsets.all(spaceAroundRequests),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(5.0),
          ),
          child: Column(
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('msg_payment_picture_accept'),
                style: TextStyle(color: Colors.black, fontSize: 11.0),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          needToUsePrevCard = false;
                          needtoAddCardDetails = true;
                        });
                      },
                      child: Image.asset(
                        needtoAddCardDetails ? 'graphics/btn-enter-card-info-selected.png' : 'graphics/btn-enter-card-info-deselect.png',
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !cc_last_four.isEmpty,
                    child: Flexible(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                needToUsePrevCard = true;
                                needtoAddCardDetails = false;
                              });
                            },
                            child: Image.asset(
                              needToUsePrevCard ? 'graphics/btn-use-previous-card-selected.png' : 'graphics/btn-use-previous-card-deselect.png',
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context).translate('label_last_4_digit') + " " + cc_last_four,
                            style: TextStyle(
                              fontSize: 10,
                              color: MyUtils().getColorFromHex(MyConstants.color_edti_title_text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              needtoAddCardDetails ? _planetCreditCardDetailsSection() : Container(),
              needToUsePrevCard ? _widgetPayBtn() : Container(),
              Visibility(
                child: Padding(
                  padding: EdgeInsets.all(MyConstants.vertical_control_space),
                  child: InkWell(
                    onTap: () {
                      _updateRequest("", MyConstants.STATUS_CANCELED_BY_BUYER, "");
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('label_cancel_req'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MyConstants.title_text_size,
                        color: MyUtils().getColorFromHex(MyConstants.color_theme),
                      ),
                    ),
                  ),
                ),
                visible: ((widget.requestDetailsPojo.status == MyConstants.STATUS_PAYMENT_PENDING ||
                        widget.requestDetailsPojo.status == MyConstants.STATUS_DELIVERY_PAY_PENDING) &&
                    widget.requestDetailsPojo.userTo.id != widget.loginUserId),
              ),
            ],
          ),
        )
      ],
    );
  }

  _planetCreditCardDetailsSection() {
    return new Container(
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(MyConstants.vertical_control_space / 2),
            ),
            Row(children: <Widget>[
              Expanded(
                child: new Image.asset(
                  'graphics/powered_by_stripe.png',
                  height: 50,
                ),
              )
            ]),
            Container(
              padding: EdgeInsets.only(top: 2, bottom: 2),
            ),
            Row(children: <Widget>[
              Expanded(
                child: Image(
                  image: AssetImage('graphics/icon-visa.png'),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
              ),
              Expanded(
                child: Image(
                  image: AssetImage('graphics/icon-master-card.png'),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
              ),
              Expanded(
                child: Image(
                  image: AssetImage('graphics/icon-amex.png'),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
              ),
              Expanded(
                child: Image(
                  image: AssetImage('graphics/icon-discover.png'),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
              ),
              Expanded(
                child: Image(
                  image: AssetImage('graphics/icon-diners.png'),
                ),
              ),
            ]),
            Container(
              margin: EdgeInsets.all(MyConstants.vertical_control_space),
            ),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom: MyConstants.textformfield_scrollpadding + scrollingTextField),
              validator: (String value) => value.isEmpty ? AppLocalizations.of(context).translate('label_field_required') : null,
              controller: textNameController,
              textInputAction: TextInputAction.next,
              focusNode: _nameFocus,
              autofocus: false,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _nameFocus, _cardNumberFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: AppLocalizations.of(context).translate('label_card_name'),
                labelText: AppLocalizations.of(context).translate('label_hint_card_name'),
                labelStyle: TextStyle(
                    color: _nameFocus.hasFocus
                        ? MyUtils().getColorFromHex(MyConstants.color_theme)
                        : MyUtils().getColorFromHex(MyConstants.color_edti_title_text)),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyUtils().getColorFromHex(MyConstants.color_theme), width: 2.0),
                  borderRadius: BorderRadius.circular(MyConstants.input_box_radius),
                ),
              ),
            ),
            Container(
              margin: new EdgeInsets.fromLTRB(0.0, MyConstants.vertical_control_space, 0.0, 0.0),
            ),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom: MyConstants.textformfield_scrollpadding + scrollingTextField),
              validator: _cardUtils.validateCardNum,
              controller: textCardNumberController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, new LengthLimitingTextInputFormatter(19), new CardNumberInputFormatter()],
              focusNode: _cardNumberFocus,
              autofocus: false,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _cardNumberFocus, _expDateFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: _cardUtils.getCardIcon(_paymentCard.type), // icon is 48px widget.
                ),
                labelText: AppLocalizations.of(context).translate('label_hint_card_number'),
                hintText: AppLocalizations.of(context).translate('label_card_number'),
                labelStyle: TextStyle(
                    color: _cardNumberFocus.hasFocus
                        ? MyUtils().getColorFromHex(MyConstants.color_theme)
                        : MyUtils().getColorFromHex(MyConstants.color_edti_title_text)),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyUtils().getColorFromHex(MyConstants.color_theme), width: 2.0),
                  borderRadius: BorderRadius.circular(MyConstants.input_box_radius),
                ),
              ),
            ),
            Container(
              margin: new EdgeInsets.fromLTRB(0.0, MyConstants.vertical_control_space, 0.0, 0.0),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    scrollPadding: EdgeInsets.only(bottom: MyConstants.textformfield_scrollpadding + scrollingTextField),
                    validator: _cardUtils.validateDate,
                    keyboardType: TextInputType.number,
                    controller: textExpDateController,
                    textInputAction: TextInputAction.next,
                    focusNode: _expDateFocus,
                    autofocus: false,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                      new CardMonthInputFormatter()
                    ],
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _expDateFocus, _securityCodeFocus);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "MM/YY",
                      hintText: AppLocalizations.of(context).translate('label_card_expire_date'),
                      labelStyle: TextStyle(
                          color: _expDateFocus.hasFocus
                              ? MyUtils().getColorFromHex(MyConstants.color_theme)
                              : MyUtils().getColorFromHex(MyConstants.color_edti_title_text)),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyUtils().getColorFromHex(MyConstants.color_theme), width: 2.0),
                        borderRadius: BorderRadius.circular(MyConstants.input_box_radius),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: new EdgeInsets.all(5),
                ),
                Expanded(
                  child: TextFormField(
                    scrollPadding: EdgeInsets.only(bottom: MyConstants.textformfield_scrollpadding + scrollingTextField),
                    validator: _cardUtils.validateCVV,
                    controller: textSecurityCodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                    ],
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    focusNode: _securityCodeFocus,
                    autofocus: false,
                    onFieldSubmitted: (term) {
                      // _fieldFocusChange(context, _expDateFocus, _securityCodeFocus);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "xxx",
                      hintText: AppLocalizations.of(context).translate('label_card_security_code'),
                      labelStyle: TextStyle(
                          color: _securityCodeFocus.hasFocus
                              ? MyUtils().getColorFromHex(MyConstants.color_theme)
                              : MyUtils().getColorFromHex(MyConstants.color_edti_title_text)),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyUtils().getColorFromHex(MyConstants.color_theme), width: 2.0),
                        borderRadius: BorderRadius.circular(MyConstants.input_box_radius),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: new EdgeInsets.fromLTRB(0.0, MyConstants.vertical_control_space * 2, 0.0, 0.0),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: MyConstants.vertical_control_space + 10,
                  child: Checkbox(
                    value: checkedSaveCard,
                    materialTapTargetSize: null,
                    onChanged: (newValue) {
                      setState(() {
                        checkedSaveCard = newValue;
                        _validateInputs();
                      });
                    }, //  <-- leading Checkbox
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                ),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context).translate('label_card_check_msg'),
                    style: TextStyle(color: MyUtils().getColorFromHex(MyConstants.color_edti_title_text), fontSize: 12),
                  ),
                ),
              ],
            ),
            Container(
              margin: new EdgeInsets.fromLTRB(0.0, MyConstants.vertical_control_space * 2, 0.0, 0.0),
            ),
            Text(
              AppLocalizations.of(context).translate('label_price_seller_offered'),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: MyUtils().getColorFromHex(MyConstants.color_gray_button),
                fontSize: MyConstants.title_filter_text_size,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: AutoSizeText(
                    widget.requestDetailsPojo.amount.toString(),
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyUtils().getColorFromHex(MyConstants.color_gray_button),
                        fontSize: MyConstants.font_size_request_detail_price),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(2.0),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: MyConstants.padding_request_detail_price),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'graphics/icon-pixell-point-white.png',
                        height: MyConstants.bottomtab_icn_height_width,
                        width: MyConstants.bottomtab_icn_height_width,
                        color: MyUtils().getColorFromHex(MyConstants.color_gray_button),
                      ),
                      Container(
                        margin: new EdgeInsets.all(spaceBetweenRequests),
                      ),
                      Text(
                        "= " + myCurrencyName + " " + pixellPointToPriceConvert(widget.requestDetailsPojo.amount.toString()),
                        style: new TextStyle(
                          fontSize: MyConstants.font_size_request_detail_countrycode,
                          fontWeight: FontWeight.bold,
                          color: MyUtils().getColorFromHex(MyConstants.color_gray_button),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              AppLocalizations.of(context).translate('label_charge_amount') + " " + myCurrencyName + " " + pixellPointToPriceConvert(widget.requestDetailsPojo.chargeAmount.toString()),
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
            _widgetPayBtn(),
          ],
        ),
      ),
    );
  }

  _widgetPayBtn() {
    return new Padding(
        padding: EdgeInsets.only(top: MyConstants.vertical_control_space * 2.5, bottom: MyConstants.vertical_control_space * 2.5),
        child: SizedBox(
          height: MyConstants.btn_height,
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            onPressed: () {
              if (needToUsePrevCard) {
                _chargeCardPresenter = new ChargeCardPresenter(this);

                _chargeCardPresenter.doChargeCard(context, myCurrencyName, widget.requestDetailsPojo.id, tokenLogin, "", "");
              } else if (allFieldValidate) {
                _validateInputs();

                MyUtils().check().then((intenet) {
                  if (intenet != null && intenet) {
                    /*Call Stripe method for get token with card detaild*/
                    StripePayment.createTokenWithCard(
                      _getCreditCardCardDetails(),
                    ).then((token) {
                      setState(() {
                        _paymentTokenStripe = token;

                        _chargeCardPresenter = new ChargeCardPresenter(this);
                        _chargeCardPresenter.doChargeCard(
                            context, myCurrencyName, widget.requestDetailsPojo.id, tokenLogin, _paymentTokenStripe.tokenId, checkedSaveCard);
                      });
                    }).catchError(setError);
                  } else {
                    MyUtils().toastdisplay(AppLocalizations.of(context).translate('msg_no_internet'));
                  }
                });
              }
            },
            color: (allFieldValidate || needToUsePrevCard)
                ? MyUtils().getColorFromHex(MyConstants.color_theme)
                : MyUtils().getColorFromHex(MyConstants.color_gray_button),
            child: Text(
              AppLocalizations.of(context).translate("label_pay"),
              style: TextStyle(
                fontSize: MyConstants.btn_round_text_size,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ));
  }

  CreditCard _getCreditCardCardDetails() {
    String expMonthYearTemp = textExpDateController.text;

    String expMonth = expMonthYearTemp.substring(0, expMonthYearTemp.indexOf("/"));
    String expYear = expMonthYearTemp.substring(expMonthYearTemp.indexOf("/") + 1, expMonthYearTemp.length);

    CreditCard testCreditCard = new CreditCard(
        number: textCardNumberController.text,
        name: textNameController.text,
        cvc: textSecurityCodeController.text,
        expMonth: int.parse(expMonth),
        expYear: int.parse(expYear));

    return testCreditCard;
    //return CreditCard(number: '4000002760003184', expMonth: 12, expYear: 21);
  }

  void setError(dynamic error) {
    MyUtils().toastdisplay(error.toString());
  }

  _setStatus(statusValue) {
    if (statusValue == MyConstants.STATUS_QUOTATION_PENDING) {
      return AppLocalizations.of(context).translate("label_quotation_pending");
    }

    if (statusValue == MyConstants.STATUS_PAYMENT_PENDING) {
      return AppLocalizations.of(context).translate("label_payment_pending");
    }

    if (statusValue == MyConstants.STATUS_FULFILLMENT_PENDING) {
      return AppLocalizations.of(context).translate("label_fulfillment_pending");
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

    if (statusValue == MyConstants.STATUS_DELIVERY_PAY_PENDING) {
      return AppLocalizations.of(context).translate("label_delivery_pending");
    }

    return "";
  }

  void _updateRequest(String updateAmount, String updateStatus, String asset_link) {
    MyUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        MySharePreference().getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN).then((valueToken) {
          if (!valueToken.isEmpty) {
            _updateRequestPresenter = new UpdateRequestPresenter(this);
            _updateRequestPresenter.doUpdateRequest(context, updateStatus, updateAmount, asset_link, widget.requestDetailsPojo.id, valueToken);
          }
        });
      } else {
        MyUtils().toastdisplay(AppLocalizations.of(context).translate('msg_no_internet'));
      }
    });
  }

  void _getCardTypeFrmNumber() {
    String input = _cardUtils.getCleanedNumber(textCardNumberController.text);
    CardType cardType = _cardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void allFocusListener() {
    textNameController.addListener(() {
      _validateInputs();
    });

    textCardNumberController.addListener(() {
      _validateInputs();
    });

    textExpDateController.addListener(() {
      _validateInputs();
    });

    textSecurityCodeController.addListener(() {
      _validateInputs();
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      print('Please fix the errors in red before submitting.');
    } else {
      form.save();
      setState(() {
        /* if (checkedSaveCard) {
          allFieldValidate = true;
        } else {
          allFieldValidate = false;
        }*/
        allFieldValidate = true;
      });
      print('Payment card is valid');
    }
  }

  @override
  void dispose() {
    textNameController.dispose();
    textCardNumberController.removeListener(_getCardTypeFrmNumber);
    textCardNumberController.dispose();
    textExpDateController.dispose();
    textSecurityCodeController.dispose();
    textAmountController.dispose();
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

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void checkIsLogin() {
    if (this.mounted) {
      MySharePreference().getBoolInPref(MyConstants.PREF_KEY_ISLOGIN).then((valueIsLogedIn) {
        setState(() {
          isLogin = valueIsLogedIn;
        });
      });
    }
  }

  @override
  void onRequestSuccess(GetRequestPojo pojoData) {
    widget.requestDetailsPojo = pojoData.result;
    _callComplementaryApis();
  }

  @override
  void onRequestError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onRequestTreeError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  var buffer = new StringBuffer();

  @override
  void onRequestTreeSuccess(RequestTreePojo pojoData) {
    if (pojoData != null) {
      tempRequestsIdList.clear();

      tempRequestsIdList.addAll(widget.requestDetailsPojo.request);

      bool tempIsLast = false;

      for (var k = 0; k < pojoData.children.length; k++) {
        buffer.clear();
        buffer.write(pojoData.children[k].data.name);

        if (tempRequestsIdList.contains(pojoData.children[k].id)) {
          tempRequestsIdList.remove(pojoData.children[k].id);

          if (pojoData.children[k].children != null) {
            /*For to add Any into list if selected Any*/
            if (!buffer.isEmpty) {
              buffer.write(",");
            }
            buffer.write(MyConstants.ANY);
          }

          requestFinalTree.add(buffer.toString());
          //break;
        }

        if (pojoData.children[k].children != null) {
          childRequestTreeCreate(pojoData.children[k].children);
        }
      }

      setState(() {
        print("shivtech" + requestFinalTree.toString());
      });
    }
  }

  void childRequestTreeCreate(childRequestData) {
    for (var tt = 0; tt < childRequestData.length; tt++) {
      if (tempRequestsIdList.contains(childRequestData[tt].id)) {
        /*For remove previus tree name*/
        if (tt > 0 && buffer.isNotEmpty && buffer.toString().contains("," + childRequestData[tt - 1].data.name)) {
          String tempRemoveLast = buffer.toString();
          tempRemoveLast = tempRemoveLast.substring(0, tempRemoveLast.indexOf("," + childRequestData[tt - 1].data.name));
          buffer.clear();
          buffer.write(tempRemoveLast.toString());
        }

        if (!buffer.isEmpty) {
          buffer.write(",");
        }
        buffer.write(childRequestData[tt].data.name);

        tempRequestsIdList.remove(childRequestData[tt].id);

        if (childRequestData[tt].children != null) {
          /*For to add Any into list if selected Any*/
          if (!buffer.isEmpty) {
            buffer.write(",");
          }
          buffer.write(MyConstants.ANY);
        }

        requestFinalTree.add(buffer.toString());

        break;
      }

      /* if(tempPrevPos!=tt && buffer.isNotEmpty && buffer.toString().contains(",")){
        String tempRemoveLast  = buffer.toString();
        tempRemoveLast = tempRemoveLast.substring(0,tempRemoveLast.lastIndexOf(","));
        print("PSATPIYUSH---"+tempRemoveLast);
        buffer.clear();
        buffer.write(tempRemoveLast.toString());
      }*/

      if (childRequestData[tt].children != null) {
        /*For remove previus tree name*/
        if (tt > 0 && buffer.isNotEmpty && buffer.toString().contains("," + childRequestData[tt - 1].data.name)) {
          String tempRemoveLast = buffer.toString();
          tempRemoveLast = tempRemoveLast.substring(0, tempRemoveLast.indexOf("," + childRequestData[tt - 1].data.name));
          buffer.clear();
          buffer.write(tempRemoveLast.toString());
        }

        if (!buffer.isEmpty) {
          buffer.write(",");
        }
        buffer.write(childRequestData[tt].data.name);

        childRequestTreeCreate(childRequestData[tt].children);
      }
      /*else{

        if(tt==childRequestData.length-1 && buffer.isNotEmpty && buffer.toString().contains(",")){
          String tempRemoveLast  = buffer.toString();
          tempRemoveLast = tempRemoveLast.substring(0,tempRemoveLast.lastIndexOf(","));
          //tempRemoveLast = tempRemoveLast.substring(0,tempRemoveLast.lastIndexOf(","));
          print("PSATPIYUSH---"+tempRemoveLast);
          buffer.clear();
          buffer.write(tempRemoveLast.toString());
        }
      }*/
    }
  }

  @override
  void onUpdateRequestError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onUpdateRequestSuccess(UpdateRequestPojo pojodata) {
    if (pojodata != null) {
      if (pojodata.code == "P005") {
        String token = pojodata.meta["action_token"];
        print(token);
        StripePayment.authenticatePaymentIntent(clientSecret: token).then((result) {
          if (result.status == "succeeded") {
            _updateRequest("", MyConstants.STATUS_CLOSED, "");
          } else {
            // Show error
            MyUtils().toastdisplay(AppLocalizations.of(context).translate("msg_error_payment_stripe"));
            setState(() {
              widget.requestDetailsPojo.status = MyConstants.STATUS_DELIVERY_PAY_PENDING;
            });
          }
        }).catchError(setError);
      } else if (pojodata.detail != null) {
        MyUtils().toastdisplay(pojodata.detail.toString());
      } else {
        if (pojodata.status == MyConstants.STATUS_CLOSED) {
          setState(() {
            widget.requestDetailsPojo.status = MyConstants.STATUS_CLOSED;
          });
        } else {
          String dialogImage = "";
          String dialogTopMsg = "";
          String dialogBottomMsg = "";

          if (sendImageUrl.isNotEmpty) {
            dialogImage = 'graphics/upload.png';
            dialogTopMsg = AppLocalizations.of(context).translate("label_thanks_uploading");
            dialogBottomMsg = AppLocalizations.of(context).translate("label_send_picture_msg");
          } else if (needtoAddCardDetails || needToUsePrevCard) {
            dialogImage = 'graphics/img-mailbox.png';
            dialogTopMsg = AppLocalizations.of(context).translate("msg_top_pay_success_dialog");
            dialogBottomMsg = AppLocalizations.of(context).translate("msg_bottom_pay_success_dialog");
          } else if (textAmountController.text.isNotEmpty) {
            dialogImage = 'graphics/img-mailbox.png';
            dialogTopMsg = AppLocalizations.of(context).translate("msg_top_quatation_price_dialog");
            dialogBottomMsg = AppLocalizations.of(context).translate("msg_bottom_quatation_price_dialog");
          } else if (pojodata.status == MyConstants.STATUS_CANCELED_BY_BUYER || pojodata.status == MyConstants.STATUS_CANCELED_BY_SELLER) {
            dialogImage = 'graphics/img-mailbox.png';
            dialogTopMsg = AppLocalizations.of(context).translate("msg_top_request_cancel_dialog");
            dialogBottomMsg = AppLocalizations.of(context).translate("msg_bottom_request_cancel_dialog");
          } else {
            dialogImage = 'graphics/img-mailbox.png';
            dialogTopMsg = AppLocalizations.of(context).translate("label_request_sent");
            dialogBottomMsg = AppLocalizations.of(context).translate("label_request_sent_msg");
          }

          MyUtils().customAlertDialogBox(
              context, dialogImage, dialogTopMsg, dialogBottomMsg, "", AppLocalizations.of(context).translate("label_go_requestlist"));
        }
      }
    }
  }

  @override
  void onGetRatesError(String errorTxt) {}

  @override
  void onGetRatesSuccess(GetRatesPojo pojodata) {
    if (pojodata != null) {
      setState(() {
        pixellRates = pojodata.rate;
      });
    }
  }

  @override
  void onChargeCardError(String errorTxt) {
    // TODO: implement onChargeCardError
  }

  @override
  void onChargeCardSuccess(ChargeCardPojo pojodata) {
    if (pojodata != null) {
      if (pojodata.detail != null) {
        MyUtils().toastdisplay(pojodata.detail.toString());
      } else if (pojodata.success != null && pojodata.success) {
        if (widget.requestDetailsPojo.status == MyConstants.STATUS_DELIVERY_PAY_PENDING) {
          //Handle case if user will try to pay again with new card if previous card was failure by stripe
          _updateRequest("", MyConstants.STATUS_CLOSED, "");
        } else {
          _updateRequest(textAmountController.text, MyConstants.STATUS_FULFILLMENT_PENDING, "");
        }
      }
    }
  }

  _getCurrentLocation() async {
    final GeolocationResult result = await Geolocation.requestLocationPermission(const LocationPermission(
      android: LocationPermissionAndroid.fine,
      ios: LocationPermissionIOS.always,
    ));

    LocationResult resultLocation = await Geolocation.lastKnownLocation();

    if (result.isSuccessful) {
      // location request successful, location is guaranteed to not be null
      double lat = resultLocation.location.latitude;
      double lng = resultLocation.location.longitude;

      _currentPosition = new Position(latitude: lat, longitude: lng);

      if (_currentPosition != null) {
        _getAddressFromLatLng();
      }
    } else {
      switch (result.error.type) {
        case GeolocationResultErrorType.runtime:
          // runtime error, check result.error.message
          break;
        case GeolocationResultErrorType.locationNotFound:
          // location request did not return any result
          break;
        case GeolocationResultErrorType.serviceDisabled:
          // location services disabled on device
          // might be that GPS is turned off, or parental control (android)
          break;
        case GeolocationResultErrorType.permissionDenied:
          // user denied location permission request
          // rejection is final on iOS, and can be on Android
          // user will need to manually allow the app from the settings
          break;
        case GeolocationResultErrorType.playServicesUnavailable:
          // android only
          // result.error.additionalInfo contains more details on the play services error
          switch (result.error.additionalInfo as GeolocationAndroidPlayServices) {
            // do something, like showing a dialog inviting the user to install/update play services
            case GeolocationAndroidPlayServices.missing:
            case GeolocationAndroidPlayServices.updating:
            case GeolocationAndroidPlayServices.versionUpdateRequired:
            case GeolocationAndroidPlayServices.disabled:
            case GeolocationAndroidPlayServices.invalid:
          }
          break;
      }
    }
  }

  _getAddressFromLatLng() async {
    try {
      var geolocator = Geolocator();

      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      _currentAddress = "${place.locality}, ${place.postalCode},${place.isoCountryCode}, ${place.country}";
      print("CURRENCY ADDRESS" + _currentAddress); // $

      setState(() {
        /*Locale deviceLocale = await DeviceLocale.getCurrentLocale();
        Locale locale = new Locale(deviceLocale.languageCode, place.isoCountryCode.toString());
        var format = NumberFormat.simpleCurrency(locale: locale.toString());

        print("CURRENCY SYMBOL ${format.currencySymbol}"); // $
        print("CURRENCY NAME ${format.currencyName}");*/

        String tempCurrencyName = MyUtils().getCurrencyNameFromCountryCode(place.isoCountryCode.toString());
        print("CURRENCY NAME --- " + tempCurrencyName);

        if (!tempCurrencyName.isEmpty) {
          MySharePreference().saveStringInPref(MyConstants.PREF_KEY_CURRENCY_NAME, tempCurrencyName);
        }

        _callApiForGetRates();
      });
    } catch (e) {
      print(e);
    }
  }

  _callApiForGetRates() {
    //Get Rates
    MySharePreference().getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN).then((valueToken) {
      if (!valueToken.isEmpty) {
        tokenLogin = valueToken;

        MySharePreference().getStringInPref(MyConstants.PREF_KEY_CURRENCY_NAME).then((valueCurrencyName) {
          _getRatesPresenter = new GetRatesPresenter(this);

          if (!valueCurrencyName.isEmpty) {
            if (valueCurrencyName != myCurrencyName) {
              myCurrencyName = valueCurrencyName;

              _getRatesPresenter.doGetRates(context, valueCurrencyName, valueToken);
            }
          } else {
            myCurrencyName = "USD";
            _getRatesPresenter.doGetRates(context, myCurrencyName, valueToken);
          }
        });
      }
    });
  }

  _callApiForGetCreditCard() {
    if (widget.requestDetailsPojo.userTo.id != widget.loginUserId &&
        (widget.requestDetailsPojo.status == MyConstants.STATUS_PAYMENT_PENDING ||
            widget.requestDetailsPojo.status == MyConstants.STATUS_DELIVERY_PAY_PENDING)) {
      //Get save credit card
      MySharePreference().getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN).then((valueToken) {
        if (!valueToken.isEmpty) {
          tokenLogin = valueToken;
          GetCreditCardPresenter getCreditCardPresenter = new GetCreditCardPresenter(this);
          getCreditCardPresenter.doGetCreditCard(context, valueToken);
        }
      });
    }
  }

  _callApiForGetRequestDetailIfNeeded() {
    if (widget.requestDetailsPojo != null) {
      _callComplementaryApis();
      return;
    }
    if (widget.requestId == null) {
      return;
    }
    MySharePreference().getStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN).then((valueToken) {
      if (valueToken.isNotEmpty) {
        _requestPresenter.doGetRequest(context, valueToken, widget.requestId);
      }
    });
  }

  _callComplementaryApis() {
    _callApiForGetRates();
    _callApiForGetCreditCard();

    //Get Request Tree
    _requestTreePresenter = new RequestTreePresenter(this);
    _requestTreePresenter.doRequestTree(context,
        widget.requestDetailsPojo.userTo.id == widget.loginUserId ? widget.requestDetailsPojo.userFrom.id : widget.requestDetailsPojo.userTo.id);
  }

  @override
  void onGetCreditCardError(String errorTxt) {
    // TODO: implement onGetCreditCardError
  }

  @override
  void onGetCreditCardSuccess(GetCreditCardPojo pojodata) {
    if (pojodata != null) {
      if (pojodata.detail != null) {
        MyUtils().toastdisplay(pojodata.detail.toString());
      } else if (pojodata.results != null && pojodata.results.length > 0) {
        if (this.mounted) {
          setState(() {
            cc_last_four = pojodata.results[0].cc_last_four;
          });
        }
      }
    }
  }

//=================== Take Selfie flow START
  ///Open Camera and Gallery dialog
  Future<void> _optionsPhotoDialogBox(
    BuildContext mContext,
    String imagePath,
    String topMsg,
    String buttonNameRight,
  ) {
    _postImagePresenter = PostImagePresenter(this);
    return showDialog(
      barrierDismissible: false,
      context: mContext,
      builder: (BuildContext context) => Material(
          type: MaterialType.transparency,
          child: WillPopScope(
            onWillPop: () {},
            child: Container(
              margin: EdgeInsets.only(
                  top: MyConstants.topbar_height,
                  bottom: MediaQuery.of(context).size.width / 2,
                  left: MyConstants.layout_margin,
                  right: MyConstants.layout_margin),
              child: Container(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Image.asset(
                            imagePath,
                            alignment: Alignment.center,
                            height: MyConstants.dialog_top_image_h_w,
                            width: MyConstants.dialog_top_image_h_w,
                          ),
                          Text(
                            topMsg,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                      decoration: BoxDecoration(
                          color: MyUtils().getColorFromHex(MyConstants.color_alert_top),
                          borderRadius: new BorderRadius.only(topLeft: const Radius.circular(3.0), topRight: const Radius.circular(3.0))),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                height: MyConstants.btn_height,
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  onPressed: () {
                                    openCamera();
                                  },
                                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                                  child: Text(
                                    AppLocalizations.of(context).translate("label_take_picture"),
                                    style: TextStyle(
                                      fontSize: MyConstants.btn_round_text_size,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MyConstants.btn_height,
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  onPressed: () {
                                    openGallery();
                                  },
                                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                                  child: Text(
                                    AppLocalizations.of(context).translate("label_from_gallery"),
                                    style: TextStyle(
                                      fontSize: MyConstants.btn_round_text_size,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                child: Text(
                                  buttonNameRight.toUpperCase(),
                                  style: MyConstants.textStyle_dialog_btn,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(bottomLeft: const Radius.circular(3.0), bottomRight: const Radius.circular(3.0))),
                  )),
                ]),
              ),
            ),
          )),
    );
  }

  openGallery() async {
    Navigator.of(context).pop();
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (gallery != null && this.mounted) {
      setState(() {
        MyUtils().check().then((internet) {
          if (internet != null && internet) {
            _postImagePresenter.doPostImage(context, gallery.readAsBytesSync());
          } else {
            MyUtils().toastdisplay(AppLocalizations.of(context).translate('msg_no_internet'));
          }
        });
      });
    }
  }

  openCamera() async {
    Navigator.of(context).pop();
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);

    if (picture != null && this.mounted) {
      setState(() {
        MyUtils().check().then((internet) {
          if (internet != null && internet) {
            _postImagePresenter.doPostImage(context, picture.readAsBytesSync());
          } else {
            MyUtils().toastdisplay(AppLocalizations.of(context).translate('msg_no_internet'));
          }
        });
      });
    }
  }

  @override
  void onPostImageError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onPostImageSuccess(PostImagePojo user) {
    if (user != null) {
      MyUtils().toastdisplay(AppLocalizations.of(context).translate("msg_upload_imge_success"));
      setState(() {
        String strPicUrl = user.url;

        const start = "media/";

        if (!strPicUrl.isEmpty && strPicUrl.contains(start)) {
          sendImageUrl = user.url;
          _openSendPictureDialog();
        }
      });
    } else {
      MyUtils().toastdisplay(AppLocalizations.of(context).translate("msg_error_server"));
    }
  }

  _openSendPictureDialog() {
    alertSendPictureDialog(
        context, AppLocalizations.of(context).translate("label_do_you_want"), "", AppLocalizations.of(context).translate("label_close"));
  }

  Future<void> alertSendPictureDialog(
    BuildContext mContext,
    String topMsg,
    String bottomMsg,
    String buttonNameRight,
  ) {
    return showDialog(
      barrierDismissible: false,
      context: mContext,
      builder: (BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Container(
          padding: EdgeInsets.all(15.0),
          margin: const EdgeInsets.only(
              top: MyConstants.bottombar_height - 50,
              bottom: MyConstants.bottombar_height,
              left: MyConstants.layout_margin,
              right: MyConstants.layout_margin),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(topMsg,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: MyConstants.title_alert_dialog_top_msg, fontWeight: FontWeight.bold, color: Colors.black)),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, MyConstants.space_20, 0.0, 0.0),
              ),
              Text(bottomMsg,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: MyConstants.title_alert_dialog_top_msg / 1.4,
                    color: MyUtils().getColorFromHex(MyConstants.color_dialog_bottom_msg),
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, MyConstants.vertical_control_space, 0.0, 0.0),
              ),
              FadeInImage.assetNetwork(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MyConstants.adult_image_h_w,
                  fit: BoxFit.fitHeight,
                  placeholder: "graphics/user_default_rectangle.png",
                  image: sendImageUrl != null ? sendImageUrl : ""),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, MyConstants.space_20, 0.0, 0.0),
              ),
              SizedBox(
                height: MyConstants.btn_height,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _updateRequest("", MyConstants.STATUS_DELIVERED, sendImageUrl);
                  },
                  color: MyUtils().getColorFromHex(MyConstants.color_theme),
                  child: Text(
                    AppLocalizations.of(context).translate("label_send_picture"),
                    style: TextStyle(
                      fontSize: MyConstants.btn_round_text_size,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, MyConstants.space_20, 0.0, 0.0),
              ),
              Visibility(
                child: Column(
                  children: <Widget>[
                    InkWell(
                        child: Text(AppLocalizations.of(context).translate("label_shoot_again"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MyConstants.title_alert_dialog_top_msg / 1.3,
                              color: MyUtils().getColorFromHex(MyConstants.color_theme),
                            )),
                        onTap: () {
                          openCamera();
                        }),
                    Container(
                      margin: EdgeInsets.fromLTRB(0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                    ),
                  ],
                ),
                visible: !sendImageUrl.isEmpty,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    child: Text(
                      buttonNameRight.toUpperCase(),
                      style: MyConstants.textStyle_dialog_btn,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

//=================== Take Selfie flow END

  Future<dynamic> downloadImage(urlImage) async {
    var request = await http.get(
      urlImage,
    );
    var bytes = request.bodyBytes;
    return bytes;
  }

  _downloadImageAndSaveToGallery(url) async {
    var fileName = "pixell_" + widget.requestDetailsPojo.id.toString() + ".jpg";
    final PermissionHandler _permissionHandler = PermissionHandler();
    var permissionStatus = await _permissionHandler.checkPermissionStatus((Platform.isIOS) ? PermissionGroup.photos : PermissionGroup.storage);
    switch (permissionStatus) {
      case PermissionStatus.granted:
        final result = await downloadAndSaveImage(fileName, url);
        print(result);
        break;
      case PermissionStatus.denied:
        MyUtils().toastdisplay(AppLocalizations.of(context).translate("msg_download_not_permission_error"));
        break;
      case PermissionStatus.disabled:
        MyUtils().toastdisplay(AppLocalizations.of(context).translate("msg_download_not_permission_error"));
        break;
      case PermissionStatus.restricted:
        MyUtils().toastdisplay(AppLocalizations.of(context).translate("msg_download_not_permission_error"));
        break;
      case PermissionStatus.unknown:
        break;
      default:
    }
  }

  Future<bool> downloadAndSaveImage(fileName, url) async {
    var value = await GallerySaver.saveImage(url);
    if (value) {
      MyUtils().toastdisplay(AppLocalizations.of(context).translate("msg_download_success"));
    } else {
      MyUtils().toastdisplay(AppLocalizations.of(context).translate("msg_download_failure"));
    }
    return value;
  }
}
