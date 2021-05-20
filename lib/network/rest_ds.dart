import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/models/account_pojo.dart';
import 'package:pixell_app/models/age_confirm_pojo.dart';
import 'package:pixell_app/models/balance_summary_pojo.dart';
import 'package:pixell_app/models/change_password_pojo.dart';
import 'package:pixell_app/models/charge_card_pojo.dart';
import 'package:pixell_app/models/dele_image_pojo.dart';
import 'package:pixell_app/models/delete_user_pojo.dart';
import 'package:pixell_app/models/get_creditcard_pojo.dart';
import 'package:pixell_app/models/get_hints_pojo.dart';
import 'package:pixell_app/models/get_rates_pojo.dart';
import 'package:pixell_app/models/get_request_pojo.dart';
import 'package:pixell_app/models/get_request_tree_pojo.dart';
import 'package:pixell_app/models/get_user_derails.dart';
import 'package:pixell_app/models/get_user_pojo.dart';
import 'package:pixell_app/models/get_values_pojo.dart';
import 'package:pixell_app/models/logout_pojo.dart';
import 'package:pixell_app/models/post_fcm_device_token_pojo.dart';
import 'package:pixell_app/models/post_image_pojo.dart';
import 'package:pixell_app/models/post_request_pojo.dart';
import 'package:pixell_app/models/raw_data_create.dart';
import 'package:pixell_app/models/redeem_pojo.dart';
import 'package:pixell_app/models/report_user_pojo.dart';
import 'package:pixell_app/models/requests_pojo.dart';
import 'package:pixell_app/models/reset_password_pojo.dart';
import 'package:pixell_app/models/signup_pojo.dart';
import 'package:pixell_app/models/update_request_pojo.dart';
import 'package:pixell_app/models/user_pojo.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'network_util.dart';

class RestDatasource {
  BuildContext mContext;
  ProgressDialog _progressDialog;
  ProgressDialog _percentageProgressDialog;

  String TAG = "";

  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://www.pixell.me/api";
  static final USER_MODEL_URL = BASE_URL + "/model/users/";
  static final LOGIN_URL = BASE_URL + "/action/login";
  static final FB_LOGIN_URL = BASE_URL + "/action/fb-login/";
  static final APPLE_LOGIN_URL = BASE_URL + "/action/apple-login/";
  static final AGE_CONFIRM_URL = BASE_URL + "/action/age-confirm/";
  static final LOGOUT_URL = BASE_URL + "/action/logout";
  static final GET_SELLERS_FILTER = BASE_URL + "/filter/sellers?limit=100";
  static final GET_VALUES = BASE_URL + "/model/values";
  static final GET_HINTS = BASE_URL + "/model/requestHintText/";
  static final RESET_PASSWORD = BASE_URL + "/action/reset-password-token";
  static final IMAGE_URL = BASE_URL + "/image";
  static final POST_REQUEST_URL = BASE_URL + "/model/requests/";
  static final POST_FCM_TOKEN_URL = BASE_URL + "/fcm/devices";
  static final GET_REQUEST_TREE = BASE_URL + "/model/requestTree/";
  static final GET_REQUESTS = BASE_URL + "/model/requests?";
  static final GET_REQUEST = BASE_URL + "/model/requests/";
  static final UPDATE_REQUEST = BASE_URL + "/model/requests/";
  static final GET_RATES = BASE_URL + "/action/convert?";
  static final CHARGE_CARD = BASE_URL + "/action/charge-card";
  static final GET_BALANCE_SUMMARY = BASE_URL + "/action/balance_summary";
  static final POST_REDEEM = BASE_URL + "/action/redeem/";
  static final GET_CREDIT_CRAD = BASE_URL + "/model/creditcard";
  static final GET_ACCOUNTS = BASE_URL + "/model/accounts";
  static final ADD_UPDATE_ACCOUNT = BASE_URL + "/model/accounts/";
  static final REPORT_URL = BASE_URL + "/action/report/";

  static final _API_KEY = "somerandomkey";

  String KEY_token = "token";
  String KEY_success_code = "200";
  String KEY_error = "Error";
  String KEY_status = "status";
  String KEY_message = "messages";
  String KEY_data = "data";
  String KEY_id = "id";
  String KEY_first_name = "first_name";
  String KEY_last_name = "last_name";
  String KEY_email = "email";
  String KEY_date_of_birth = "date_of_birth";
  String KEY_mobile_no = "mobile_no";
  String KEY_country_code = "country_code";
  String KEY_otp = "otp";
  String KEY_username = "username";
  String KEY_password = "password";
  String KEY_password_confirmation = "password_confirmation";
  String KEY_profile_image = "profile_image";
  String KEY_MALE = "MALE";
  String KEY_FEMALE = "FEMALE";
  String KEY_pic = "pic";
  String KEY_file = "file";
  String KEY_thumbnail = "thumbnail";
  String KEY_profile = "profile";
  String KEY_profile_pic = "profile_pic";
  String KEY_gender = "gender";
  String KEY_description = "description";
  String KEY_is_seller = "is_seller";
  String KEY_is_selling_adult_content = "is_selling_adult_content";
  String KEY_country = "country";
  String KEY_physical_appearance = "physical_appearance";
  String KEY_height_cm = "height_cm";
  String KEY_weight_kg = "weight_kg";
  String KEY_race = "race";
  String KEY_body = "body";
  String KEY_pics = "pics";
  String KEY_is_age_verified = "is_age_verified";
  String KEY_user_to = "user_to";
  String KEY_amount = "amount";
  String KEY_request = "request";
  String KEY_registration_id = "registration_id";
  String KEY_user_id = "user_id";
  String KEY_type = "type";
  String KEY_device_id = "device_id";
  String KEY_name = "name";
  String KEY_token_with_space = "Token ";
  String KEY_Authorization = "Authorization";
  String KEY_asset_link = "asset_link";
  String KEY_currency = "currency";
  String KEY_request_id = "request_id";
  String KEY_save = "save";
  String KEY_bank_account = "bank_account";
  String KEY_amazon_account = "amazon_account";
  String KEY_owner_name = "owner_name";
  String KEY_bank_name = "bank_name";
  String KEY_number = "number";
  String KEY_swift = "swift";
  String KEY_branch_name = "branch_name";
  String KEY_branch_address = "branch_address";

  Map<String, String> headersMy = {
    "Content-Type": "application/json",
    "Accept-Language": MyConstants.selectedLanguageCode,
  };

  Future<UserPojo> login(
      BuildContext getContext, String username, String password) {
    TAG = "login";
    mContext = getContext;

    initProgressDialog();

    Map mapRawBodyData = RawDataCreate().loginPostRawMap(username, password);

    return _netUtil.postRaw(LOGIN_URL, mapRawBodyData).then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      /* if (res[KEY_status] != KEY_success_code)
        throw new Exception(res[KEY_message]);*/

      return new UserPojo.fromJson(res);
    });
  }

  Future<UserPojo> facebook_login(BuildContext getContext, String token) {
    TAG = "facebook_login";
    mContext = getContext;

    initProgressDialog();

    Map mapRawBodyData = RawDataCreate().facebookloginPostRawMap(token);

    return _netUtil.postRaw(FB_LOGIN_URL, mapRawBodyData).then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new UserPojo.fromJson(res);
    });
  }

  Future<UserPojo> apple_login(BuildContext getContext, String token) {
    TAG = "apple_login";
    mContext = getContext;

    initProgressDialog();

    Map mapRawBodyData = RawDataCreate().appleloginPostRawMap(token);

    return _netUtil.postRaw(APPLE_LOGIN_URL, mapRawBodyData).then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new UserPojo.fromJson(res);
    });
  }

  Future<SignupPojo> signup(
      BuildContext getContext,
      String username,
      String email,
      String date_of_birth,
      String password,
      bool is_seller,
      String profile_image,
      String profile_thumbnail) {
    TAG = "signup";
    mContext = getContext;

    initProgressDialog();

    Map mapRawBodyData = RawDataCreate()
        .signupPostRawMap(username, email, date_of_birth, password, is_seller, profile_image, profile_thumbnail);

    return _netUtil.postRaw(USER_MODEL_URL, mapRawBodyData).then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          if (status_code == "E001") {
            throw new Exception(
                AppLocalizations.of(mContext).translate("msg_agelimit_exist"));
          } else if (status_code == "invalid") {
            throw new Exception(AppLocalizations.of(mContext)
                .translate("msg_error_email_exist"));
          } else if (status_code == "E013") {
            throw new Exception(AppLocalizations.of(mContext)
                .translate("msg_error_username_exist"));
          }
        }
      }

      return new SignupPojo.fromJson(res);
    });
  }

  Future<ResetPojo> resetPassword(BuildContext getContext, String email) {
    TAG = "resetPassword";
    mContext = getContext;

    initProgressDialog();

    Map mapRawBodyData = RawDataCreate().resetPasswordRawMap(email);

    return _netUtil.postRaw(RESET_PASSWORD, mapRawBodyData).then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          if (status_code == "invalid") {
            throw new Exception(AppLocalizations.of(mContext)
                .translate("msg_error_reset_password"));
          }
        }
      }

      return new ResetPojo.fromJson(res);
    });
  }

  Future<ChangePasswordPojo> changePassword(
      BuildContext getContext, userID, String password, login_token) {
    TAG = "changePassword";
    mContext = getContext;

    initProgressDialog();

    Map mapRawBodyData = RawDataCreate().changePassPostRawMap(password);

    return _netUtil
        .putRaw(USER_MODEL_URL + userID.toString() + "/", login_token,
            mapRawBodyData)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      /* if (res[KEY_status] != KEY_success_code)
        throw new Exception(res[KEY_message]);*/

      return new ChangePasswordPojo.fromJson(res);
    });
  }

  Future<GetUserDetailsPojo> editUser(
    BuildContext getContext,
    userID,
    Map mapRawBodyData,
    login_token,
  ) {
    TAG = "editUser";
    mContext = getContext;

    initProgressDialog();

    return _netUtil
        .putRaw(USER_MODEL_URL + userID.toString() + "/", login_token,
            mapRawBodyData)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      /* if (res[KEY_status] != KEY_success_code)
        throw new Exception(res[KEY_message]);*/

      return new GetUserDetailsPojo.fromJson(res);
    });
  }

  Future<GetUserDetailsPojo> getUserDetails(BuildContext getContext, userID) {
    TAG = "getUserDetails";
    mContext = getContext;

    initProgressDialog();

    return _netUtil
        .get(USER_MODEL_URL + userID.toString(), headersMy)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          throw new Exception(
              AppLocalizations.of(mContext).translate("msg_error_server"));
        }
      }

      return new GetUserDetailsPojo.fromJson(res);
    });
  }

  Future<GetSellersPojo> getSellers(
      BuildContext getContext, String filter_type) {
    TAG = "getSellers";
    mContext = getContext;

    //initProgressDialog();

    String finalSelleresUrl = GET_SELLERS_FILTER;
    if (!filter_type.isEmpty) {
      finalSelleresUrl = GET_SELLERS_FILTER + "&profile__gender=" + filter_type;
    }

    return _netUtil.get(finalSelleresUrl, headersMy).then((dynamic res) {
      //dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          throw new Exception(
              AppLocalizations.of(mContext).translate("msg_error_server"));
        }
      }

      return new GetSellersPojo.fromJson(res);
    });
  }

  Future<GetSellersPojo> getSellersFiltered(
      BuildContext getContext, String filterUrl) {
    TAG = "getSellersFiltered";
    mContext = getContext;

    //initProgressDialog();

    String finalSelleresUrl = GET_SELLERS_FILTER;
    if (!filterUrl.isEmpty) {
      finalSelleresUrl = GET_SELLERS_FILTER + filterUrl;
    }

    return _netUtil.get(finalSelleresUrl, headersMy).then((dynamic res) {
      //dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];

        if (status_code == "invalid") {
          var profile__physical_appearance__race =
              res["profile__physical_appearance__race"];

          if (profile__physical_appearance__race != null) {
            throw new Exception(profile__physical_appearance__race[0]);
          } else {
            throw new Exception(
                AppLocalizations.of(mContext).translate("msg_error_server"));
          }
        } else if (status_code != null) {
          throw new Exception(
              AppLocalizations.of(mContext).translate("msg_error_server"));
        }
      }

      return new GetSellersPojo.fromJson(res);
    });
  }

  Future<GetSellersPojo> getSellersNextLoad(
      BuildContext getContext, String filter_typen, String nextLoadUrl) {
    TAG = "getSellersNextLoad--->" + nextLoadUrl;
    mContext = getContext;

    //initProgressDialog();

    return _netUtil.get(nextLoadUrl, headersMy).then((dynamic res) {
      //dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          throw new Exception(
              AppLocalizations.of(mContext).translate("msg_error_server"));
        }
      }

      return new GetSellersPojo.fromJson(res);
    });
  }

  Future<GetValuesPojo> getValues(BuildContext getContext) {
    TAG = "getValues";
    mContext = getContext;

    return _netUtil.get(GET_VALUES, headersMy).then((dynamic res) {
      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          throw new Exception(
              AppLocalizations.of(mContext).translate("msg_error_server"));
        }
      }

      return new GetValuesPojo.fromJson(res);
    });
  }

  Future<GetHintsPojo> getHints(BuildContext getContext) {
    TAG = "getHints";
    mContext = getContext;

    return _netUtil.get(GET_HINTS, headersMy).then((dynamic res) {
      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          throw new Exception(
              AppLocalizations.of(mContext).translate("msg_error_server"));
        }
      }

      return new GetHintsPojo.fromJson(res);
    });
  }

  Future<RequestTreePojo> getRequestTree(BuildContext getContext, userID) {
    TAG = "requestTree";
    mContext = getContext;

    initProgressDialog();

    return _netUtil
        .get(GET_REQUEST_TREE + "?userId=" + userID.toString(), headersMy)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new RequestTreePojo.fromJson(res[0]);
    });
  }

  Future<RequestsPojo> getRequests(BuildContext getContext, login_token) {
    TAG = "requests";
    mContext = getContext;

    headersMy[RestDatasource().KEY_Authorization] =
        RestDatasource().KEY_token_with_space + login_token;

    return _netUtil.get(GET_REQUESTS, headersMy).then((dynamic res) {
      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new RequestsPojo.fromJson(res);
    });
  }

  Future<RequestsPojo> getRequestsNextLoad(
      BuildContext getContext, login_token, nextLoadUrl) {
    TAG = "requestsNext";
    mContext = getContext;

    headersMy[RestDatasource().KEY_Authorization] =
        RestDatasource().KEY_token_with_space + login_token;

    return _netUtil.get(nextLoadUrl, headersMy).then((dynamic res) {
      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new RequestsPojo.fromJson(res);
    });
  }

  Future<GetRequestPojo> getRequest(BuildContext getContext, String login_token, dynamic requestId) {
    TAG = "getRequest";
    mContext = getContext;

    initProgressDialog();

    headersMy[RestDatasource().KEY_Authorization] =
        RestDatasource().KEY_token_with_space + login_token;

    return _netUtil
      .get(GET_REQUEST + requestId, headersMy)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      final detailKey = "detail";
      if (res[detailKey] != null)
        throw new Exception(res[detailKey]);

      return new GetRequestPojo.fromJson(res);
    });
  }

  Future<BalanceSummaryPojo> getBalanceSummary(
      BuildContext getContext, login_token) {
    TAG = "balance_summary";
    mContext = getContext;

    headersMy[RestDatasource().KEY_Authorization] =
        RestDatasource().KEY_token_with_space + login_token;

    return _netUtil.get(GET_BALANCE_SUMMARY, headersMy).then((dynamic res) {
      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new BalanceSummaryPojo.fromJson(res);
    });
  }

  Future<PostImagePojo> postImage(BuildContext getContext, File file) async {
    TAG = "postImage";
    mContext = getContext;

    initPercentageProgressDialog();

   // Map mapRawBodyData = RawDataCreate().postImagePostRawMap(base64File);

    return _netUtil.postImage(IMAGE_URL, file, true, updatePercentageProgressDialog).then((dynamic res) {
      dismissPercentageProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      /* if (res[KEY_status] != KEY_success_code)
        throw new Exception(res[KEY_message]);*/

      return new PostImagePojo.fromJson(res);
    });
  }

  Future<AgeConfirmPojo> ageConfirm(
      BuildContext getContext, String imageForVefiyAge, String login_token) {
    TAG = "ageConfirm";
    mContext = getContext;

    initProgressDialog();

    Map mapRawBodyData = RawDataCreate().postAgeConfirm(imageForVefiyAge);

    return _netUtil
        .postRawWithLoginToken(AGE_CONFIRM_URL, login_token, mapRawBodyData)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      /* if (res[KEY_status] != KEY_success_code)
        throw new Exception(res[KEY_message]);*/

      return new AgeConfirmPojo.fromJson(res);
    });
  }

  Future<PostRequestPojo> postRequest(BuildContext getContext,
      String user_to_id, String login_token, List<dynamic> requestsId) {
    TAG = "postRequest";
    mContext = getContext;

    initProgressDialog();

    Map mapRawBodyData =
        RawDataCreate().postRequest(user_to_id, "500", requestsId);

    return _netUtil
        .postRawWithLoginToken(POST_REQUEST_URL, login_token, mapRawBodyData)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      /* if (res[KEY_status] != KEY_success_code)
        throw new Exception(res[KEY_message]);*/

      return new PostRequestPojo.fromJson(res);
    });
  }

  Future<RedeemPojo> postRedeem(
      BuildContext getContext, currency,type, String login_token) {
    TAG = "redeem";
    mContext = getContext;

    initProgressDialog();

    Map mapRawBodyData = RawDataCreate().postRedeem(currency,type);

    return _netUtil
        .postRawWithLoginToken(POST_REDEEM, login_token, mapRawBodyData)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      /* if (res[KEY_status] != KEY_success_code)
        throw new Exception(res[KEY_message]);*/

      return new RedeemPojo.fromJson(res);
    });
  }

  Future<UpdateRequestPojo> updateRequest(BuildContext getContext, status,
      String amount, asset_link, requestsId, login_token) {
    TAG = "updateRequest";
    mContext = getContext;

    initProgressDialog();

    if (amount.isEmpty) {
      amount = "-1";
    }
    Map mapRawBodyData =
        RawDataCreate().updateRequest(status, amount, asset_link);

    if (mapRawBodyData.containsKey("")) {
      mapRawBodyData.remove("");
    }

    return _netUtil
        .putRaw(UPDATE_REQUEST + requestsId.toString() + "/", login_token,
            mapRawBodyData)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new UpdateRequestPojo.fromJson(res);
    });
  }

  Future<ChargeCardPojo> chargeCard(BuildContext getContext, currency, req_id,
      login_token, stripeToken, needSaveCard) {
    TAG = "chargeCard";
    mContext = getContext;

    initProgressDialog();

    Map mapRawBodyData = RawDataCreate()
        .chargeCardRawMap(currency, req_id, stripeToken, needSaveCard);

    if (mapRawBodyData.containsKey("")) {
      mapRawBodyData.remove("");
    }

    return _netUtil
        .postRawWithLoginToken(CHARGE_CARD, login_token, mapRawBodyData)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new ChargeCardPojo.fromJson(res);
    });
  }

  Future<PostFcmToken> postFCMToken(BuildContext getContext, registration_id,
      type, user_id, device_id, name) {
    TAG = "postFCMToken";
    mContext = getContext;

    Map mapRawBodyData = RawDataCreate()
        .postFCMDetails(registration_id, type, user_id, device_id, name);

    return _netUtil
        .postRaw(POST_FCM_TOKEN_URL, mapRawBodyData)
        .then((dynamic res) {
      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      /* if (res[KEY_status] != KEY_success_code)
        throw new Exception(res[KEY_message]);*/

      return new PostFcmToken.fromJson(res);
    });
  }

  Future<LogoutPojo> logout(BuildContext getContext, String login_token) {
    TAG = "logout";
    mContext = getContext;

    initProgressDialog();

    return _netUtil
        .postRawWithLoginToken(LOGOUT_URL, login_token, "")
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      /* if (res[KEY_status] != KEY_success_code)
        throw new Exception(res[KEY_message]);*/

      return new LogoutPojo.fromJson(res);
    });
  }

  Future<DeleteImagePojo> deleteImage(
      BuildContext getContext, String fileName,login_token) {
    TAG = "deleteImage";
    mContext = getContext;

    initProgressDialog();

    return _netUtil.deleteParams(IMAGE_URL + "?file=" + fileName,login_token, body: {
      KEY_file: fileName,
    }).then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new DeleteImagePojo.fromJson(res);
    });
  }

  Future<DeleteUserPojo> deletePixellAccount(
      BuildContext getContext, String userId,login_token) {
    TAG = "deleteuser";
    mContext = getContext;

    initProgressDialog();

    return _netUtil
        .deleteParams(USER_MODEL_URL + userId + "/",login_token)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new DeleteUserPojo.fromJson(res);
    });
  }

  Future<GetRatesPojo> getRates(
      BuildContext getContext, currency_code, login_token) {
    TAG = "getRates";
    mContext = getContext;

    headersMy[RestDatasource().KEY_Authorization] =
        RestDatasource().KEY_token_with_space + login_token;

    String finalGetRateUrl = GET_RATES;
    if (!currency_code.isEmpty) {
      finalGetRateUrl = GET_RATES + "&currency_code=" + currency_code;
    }

    return _netUtil.get(finalGetRateUrl, headersMy).then((dynamic res) {
      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          throw new Exception(
              AppLocalizations.of(mContext).translate("msg_error_server"));
        }
      }

      return new GetRatesPojo.fromJson(res);
    });
  }

  Future<GetCreditCardPojo> getCrediCrad(BuildContext getContext, login_token) {
    TAG = "creditcard";
    mContext = getContext;

    headersMy[RestDatasource().KEY_Authorization] =
        RestDatasource().KEY_token_with_space + login_token;

    return _netUtil.get(GET_CREDIT_CRAD, headersMy).then((dynamic res) {
      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          throw new Exception(
              AppLocalizations.of(mContext).translate("msg_error_server"));
        }
      }

      return new GetCreditCardPojo.fromJson(res);
    });
  }

  //==================== Account related Api START ====================
  Future<AccountPojo> getAccounts(BuildContext getContext, login_token) {
    TAG = "getaccounts";
    mContext = getContext;

    initProgressDialog();

    headersMy[RestDatasource().KEY_Authorization] =
        RestDatasource().KEY_token_with_space + login_token;

    return _netUtil.get(GET_ACCOUNTS, headersMy).then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          throw new Exception(
              AppLocalizations.of(mContext).translate("msg_error_server"));
        }
      }

      return new AccountPojo.fromJson(res);
    });
  }

  Future<AccountPojo> addAccount(
      BuildContext getContext, Map mapRawBodyData, String login_token) {
    TAG = "addaccount";
    mContext = getContext;

    initProgressDialog();

    return _netUtil
        .postRawWithLoginToken(ADD_UPDATE_ACCOUNT, login_token, mapRawBodyData)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      } else {
        String status_code = res["status_code"];
        if (status_code != null) {
          if (status_code == "invalid") {
            var user = res["user"];
            if (user != null) {
              throw new Exception(user);
            }
            throw new Exception(AppLocalizations.of(mContext)
                .translate("msg_error_email_exist"));
          }
        }
      }

      return new AccountPojo.fromJson(res);
    });
  }

  Future<AccountPojo> updatepdateAccount(
    BuildContext getContext,
    Map mapRawBodyData,
    String accountId,
    login_token,
  ) {
    TAG = "updateaccount";
    mContext = getContext;

    initProgressDialog();

    return _netUtil
        .putRaw(
            ADD_UPDATE_ACCOUNT + accountId + "/", login_token, mapRawBodyData)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      return new AccountPojo.fromJson(res);
    });
  }

  Future<ReportUserPojo> reportUser(
      BuildContext getContext,
      userID,
      login_token
      ) {
    TAG = "reportUser";
    mContext = getContext;

    initProgressDialog();
    Map mapRawBodyData = {
      RestDatasource().KEY_user_id: userID,
    };


    return _netUtil
        .postRawWithLoginToken(REPORT_URL + userID.toString() + "/", login_token, mapRawBodyData)
        .then((dynamic res) {
      dismissProgressDialog();

      print(TAG + "--->" + res.toString());

      if (res == null) {
        throw new Exception(
            AppLocalizations.of(mContext).translate("msg_error_server"));
      }

      /* if (res[KEY_status] != KEY_success_code)
        throw new Exception(res[KEY_message]);*/

      return new ReportUserPojo.fromJson(res);
    });
  }

  //==================== Account related Api END ======================

  //Progress dialog
  void initProgressDialog() async {
    //For normal dialog
    if (_progressDialog == null && mContext != null) {
      _progressDialog = new ProgressDialog(mContext,
          type: ProgressDialogType.Normal,
          isDismissible: true,
          showLogs: false);
      _progressDialog.style(
        message: AppLocalizations.of(mContext).translate('label_loading'),
        progressWidget: new Image(image: new AssetImage("graphics/loader.gif"))
      );
    }

    if (_progressDialog != null) {
      dismissProgressDialog();
      await _progressDialog.show();
    }
  }

  void dismissProgressDialog() {
    if (_progressDialog != null && _progressDialog.isShowing()) {
      _progressDialog.hide();
    }
  }

  void initPercentageProgressDialog() async {
    print("Show percentage");
    if (_percentageProgressDialog == null && mContext != null) {
      _percentageProgressDialog = new ProgressDialog(mContext,
          type: ProgressDialogType.Download,
          isDismissible: true,
          showLogs: false);
      _percentageProgressDialog.style(
          message: AppLocalizations.of(mContext).translate('label_loading'),
          progressWidget: new Image(image: new AssetImage("graphics/loader.gif"))
      );
    } else {
      updatePercentageProgressDialog(0);
    }

    if (_percentageProgressDialog != null) {
      dismissPercentageProgressDialog();
      await _percentageProgressDialog.show();
    }
  }

  void updatePercentageProgressDialog(double percentage) {
    if (_percentageProgressDialog != null && _percentageProgressDialog.isShowing()) {
      _percentageProgressDialog.update(progress: (percentage*100).floorToDouble(), maxProgress: 100);
    }
  }


  void dismissPercentageProgressDialog() {
    if (_percentageProgressDialog != null && _percentageProgressDialog.isShowing()) {
      _percentageProgressDialog.hide();
    }
  }
}
