import 'package:flutter/material.dart';

import 'my_utils.dart';

class MyConstants {
  static const URL_TERMS_CONDITIONS =
      "https://www.pixell.me/terms_and_conditions_raw";
  static const URL_DATA_POLICY = "https://www.pixell.me/data_policy_raw";

  static const String fieldReq = 'This field is required';
  static const String numberIsInvalid = 'Card is invalid';

  //Constant strings
  static const String my_canvas_view = "My Canvas View";

  static String format_mm_dd_yy = 'MM/dd/yyyy';

  static const int TEMP_TREE_ANY_ID = -101010;
  static const int TEMP_TREE_NOT_SELECTID = -005005;

  static String selectedLanguageCode = "en";
  static int currentSelectedBottomTab = 0;

  static const double inputtext_height = 40;
  static const double layout_margin = 18;
  static const double space_30 = 30;
  static const double space_20 = 20;
  static const double space_40 = 40;
  static const double space_50 = 50;
  static const double space_5 = 5;
  static const double vertical_control_space = 15;
  static const double vertical_control_space_half = 7;
  static const double profile_image_height_width = 100;
  static const double adult_image_h_w = 165;
  static const double btn_height = 44;
  static const double btn_request_height = 42;
  static const double toolbar_space_left_right = 10;
  static const double toolbar_icon_height_width = 16;
  static const double round_step_height_width = 50;
  static const double round_step_space = 50;
  static const double topbar_height = 100;
  static const double bottombar_height = 100;
  static const double textformfield_scrollpadding = bottombar_height + 150;
  static const double input_box_radius = 2.0;
  static const double toolbar_text_size = 20;
  static const double btn_text_size = 22;
  static const double btn_round_text_size = 16;
  static const double bottomtab_icn_height_width = 20;
  static const double bottomtab_icn_top_space = 10;
  static const double bottomtab_text_size = 14;
  static const double bottom_tab_icon_align = 50;
  static const double title_text_size = 16;
  static const double title_below_text_size = 14;
  static const double title_filter_text_size = 18;
  static const double btn_dialog_size = 18;
  static const double edit_profile_image_h_w = 110;
  static const double request_profile_image_h_w = 100;
  static const double request_details_profile_image_h_w = 150;
  static const double textsize_terms_conditions = 14;
  static const double height_devider = 5;
  static const double title_chipls_text_size = 16;
  static const double title_alert_dialog_top_msg = 20;
  static const double profile_riht_details_title_size = 14;
  static const double profile_grid_height = profile_riht_details_title_size + 20;
  static const double profile_riht_details_space = 5;
  static const double font_size_request_detail_price = 45.0;
  static const double font_size_request_detail_countrycode = 18.0;
  static const double padding_request_detail_price = 10.0;
  static const double dialog_top_image_h_w = 70.0;

  static const String STATUS_QUOTATION_PENDING = "QUOTATION_PENDING";
  static const String STATUS_PAYMENT_PENDING = "PAYMENT_PENDING";
  static const String STATUS_FULFILLMENT_PENDING = "FULFILLMENT_PENDING";
  static const String STATUS_DELIVERED = "DELIVERED";
  static const String STATUS_CLOSED = "CLOSED";
  static const String STATUS_EXPIRED = "EXPIRED";
  static const String STATUS_CANCELED_BY_BUYER = "CANCELED_BY_BUYER";
  static const String STATUS_CANCELED_BY_SELLER = "CANCELED_BY_SELLER";
  static const String STATUS_REVIEW_PENDING = "REVIEW_PENDING";
  static const String STATUS_DELIVERY_PAY_PENDING = "DELIV_PAY_PEND";

  static const String FROM_SIGNUP = "from_signup";
  static const String AGE_NOT_VERIFIED = "NOT_VERIFIED";
  static const String AGE_WAITING_VERIFICATION = "WAITING_VERIFICATION";
  static const String AGE_VERIFIED = "VERIFIED";

  static const String PREF_KEY_INITIAL_WALKTHROUGH_SHOWN = "initial_walkthrough_shown";
  static const String PREF_KEY_ISLOGIN = "is_login";
  static const String PREF_KEY_USERID = "userid";
  static const String PREF_KEY_LOGIN_TOKEN = "login_token";
  static const String PREF_KEY_CURRENCY_NAME = "current_currency_name";
  static const String PREF_AS_GUEST = "as_guest";
  static const String PREF_FCM_TOKEN = "fcm_token";
  static const String PREF_IS_SELLER = "is_seller_user";

  static const String TEMP_YES_SELLER = "yes_seller";
  static const String ANY = "Any";

  //All color for app
  static const String color_first_screen_bg = "#EBBF10";
  static const String color_first_btn = "#E51C20";
  static const String color_screeb_bg = "#FDF2B8";
  static const String color_yellow = "#FFED5F";
  static const String color_theme = "#B78602";
  static const String color_error_msg = "#000000";
  static const String color_alert_top = "#F5D536";
  static const String color_top_tab_text = "#808080";
  static const String color_edti_title_text = "#666666";
  static const String color_forward_arrow = "#666666";
  static const String color_filter_header_value = "#5b5b5b";
  static const String color_range_slider = "#EAD091";
  static const String color_fb_btn = "#1877F2";
  static const String color_dialog_bottom_msg = "#222222";
  static const String color_age_verifed_box = "#FCE5E6";
  static const String color_gray_button = "#BCBCBC";
  static const String color_accept_msg_bg = "#EAFFB1";
  static const String color_E2A604 = "#E2A604";
  static const String color_835F00 = "#835F00";
  static const String color_green_019807 = "#019807";
  static const String color_light_grey = "#efeeee";
  static const String color_request_selected = "#d9ce9f";


  static const String color_walkthrough_bg_top= "#fed050";
  static const String color_walkthrough_bg_mid= "#efbe23";
  static const String color_walkthrough_bg_bottom= "#e4b20c";
  static const String color_walkthrough_title= "#da0519";
  static const String color_walkthrough_dot= "#B78602";

  static TextStyle textStyle_searchFilterHeader = new TextStyle(
      fontSize: MyConstants.title_filter_text_size,
      fontWeight: FontWeight.bold,
      color: MyUtils().getColorFromHex(MyConstants.color_filter_header_value));

  static TextStyle textStyle_request_detailsHeader = new TextStyle(
      fontSize: MyConstants.title_filter_text_size,
      fontWeight: FontWeight.bold,
      color: Colors.black);

  static TextStyle textStyle_searchFilterValue = new TextStyle(
      fontSize: MyConstants.title_filter_text_size,
      color: MyUtils().getColorFromHex(MyConstants.color_filter_header_value));

  static TextStyle textStyle_chipsValue = new TextStyle(
      fontSize: MyConstants.title_chipls_text_size,
      color: MyUtils().getColorFromHex(MyConstants.color_theme));

  static TextStyle textStyle_dialog_btn = new TextStyle(
    fontSize: MyConstants.btn_round_text_size,
    color: MyUtils().getColorFromHex(MyConstants.color_theme),
  );

  static TextStyle textStyle_red_dialog_btn = new TextStyle(
    fontSize: MyConstants.btn_round_text_size,
    color: Colors.red,
  );

  static TextStyle textStyle_request_title = new TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static TextStyle textStyle_request_other = new TextStyle(
    fontSize: 12,
    color: Colors.white,
  );
  //Same size as above
  static TextStyle textStyle_request_other_bold = new TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: Colors.white,
  );

  static const String walkthrough_font_family = "Aqua Grotesque";
  static TextStyle textStyle_walkthrough_step = new TextStyle(
      fontFamily: walkthrough_font_family,
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.white
  );
  static TextStyle textStyle_walkthrough_title = new TextStyle(
      fontFamily: walkthrough_font_family,
      fontSize: 40,
      color: MyUtils().getColorFromHex(color_walkthrough_title)
  );
  static TextStyle textStyle_walkthrough_subtitle = new TextStyle(
      fontFamily: walkthrough_font_family,
      fontSize: 30,
      color: MyUtils().getColorFromHex(color_walkthrough_title)
  );
  static TextStyle textStyle_walkthrough_subsubtitle = new TextStyle(
      fontFamily: walkthrough_font_family,
      fontSize: 20,
      color: Colors.black
  );
  static TextStyle textStyle_walkthrough_footer = new TextStyle(
      fontFamily: walkthrough_font_family,
      fontSize: 16,
      color: Colors.black
  );
  static TextStyle textStyle_walkthrough_buttons = new TextStyle(
      fontFamily: walkthrough_font_family,
      fontSize: 16,
      color: Colors.black,
  );

  static TextStyle textStyle_walkthrough_cta = new TextStyle(
    fontFamily: walkthrough_font_family,
    fontSize: 24,
    color: MyUtils().getColorFromHex(color_walkthrough_title),
  );
}

enum GET_CURRENCY_NAME {
  JPN,
  IND,
  US,
  ESP,
  MEX,
}
