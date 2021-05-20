import 'package:pixell_app/network/rest_ds.dart';

import 'get_user_derails.dart';

class RawDataCreate {
  Map<String, dynamic> loginPostRawMap(String username, String password) => {
        RestDatasource().KEY_email: username,
        RestDatasource().KEY_password: password,
      };

  Map<String, String> facebookloginPostRawMap(String token) => {
        RestDatasource().KEY_token: token,
      };
  Map<String, String> appleloginPostRawMap(String token) => {
    RestDatasource().KEY_token: token,
  };

  Map<String, dynamic> signupPostRawMap(String username, String email,
          String date_of_birth, String password, bool is_seller, String profile_image, String profile_thumbnail) =>
      {
        RestDatasource().KEY_username: username,
        RestDatasource().KEY_password: password,
        RestDatasource().KEY_date_of_birth: date_of_birth,
        RestDatasource().KEY_email: email,
        RestDatasource().KEY_profile: {
          RestDatasource().KEY_is_seller: is_seller,
          profile_image.isEmpty ? ("") : RestDatasource().KEY_profile_pic:
          profile_image,
          profile_thumbnail.isEmpty ? ("") : RestDatasource().KEY_thumbnail: profile_thumbnail,
        },
      };

  Map<String, dynamic> changePassPostRawMap(String password) => {
        RestDatasource().KEY_password: password,
      };

  Map<String, dynamic> resetPasswordRawMap(String email) => {
        RestDatasource().KEY_email: email,
      };

  Map<String, dynamic> postImagePostRawMap(String base64File) => {
        RestDatasource().KEY_file: base64File,
        RestDatasource().KEY_thumbnail: true,
      };

  Map<String, dynamic> postAgeConfirm(String imageForVefiyAge) =>
      {RestDatasource().KEY_pic: imageForVefiyAge};

  Map<String, dynamic> postRequest(user_to_id, amount, requestsId) => {
        RestDatasource().KEY_user_to: user_to_id,
        /* RestDatasource().KEY_amount: amount,*/
        RestDatasource().KEY_request: requestsId,
      };

  Map<String, dynamic> postRedeem(
    currency,
    type,
  ) =>
      {
        RestDatasource().KEY_currency: currency,
        RestDatasource().KEY_type: type,
      };

  Map<String, dynamic> updateRequest(status, String amountGet, asset_link) => {
        RestDatasource().KEY_status: status,
        amountGet == "-1" ? ("") : RestDatasource().KEY_amount:
            int.parse(amountGet),
        asset_link.toString().isEmpty ? "" : RestDatasource().KEY_asset_link:
            asset_link,
      };

  Map<String, dynamic> chargeCardRawMap(
          currency, req_id, stripeToken, needSaveCard) =>
      {
        RestDatasource().KEY_currency: currency,
        RestDatasource().KEY_request_id: req_id,
        stripeToken.toString().isEmpty ? "" : RestDatasource().KEY_token:
            stripeToken.toString(),
        needSaveCard.toString().isEmpty ? "" : RestDatasource().KEY_save:
            needSaveCard,
      };

  Map<String, dynamic> postFCMDetails(
          registration_id, type, user_id, device_id, name) =>
      {
        RestDatasource().KEY_registration_id: registration_id,
        RestDatasource().KEY_type: type,
        RestDatasource().KEY_user_id: user_id,
        RestDatasource().KEY_device_id: device_id,
        RestDatasource().KEY_name: name,
      };

  Map<String, dynamic> editProfileMainPostRawMap(
          String username,
          String first_name,
          String last_name,
          String email,
          String date_of_birth,
          String password,
          String description,
          String thumbnail,
          String profile_pic,
          bool is_seller,
          is_selling_adult_content,
          String is_age_verified,
          String gender,
          String country,
          String height_cm,
          String weight_kg,
          String race,
          String body,
          List<Pic> pics) =>
      {
        username.isEmpty ? ("") : RestDatasource().KEY_username: username,
        first_name.isEmpty ? ("") : RestDatasource().KEY_first_name: first_name,
        last_name.isEmpty ? ("") : RestDatasource().KEY_last_name: last_name,
        email.isEmpty ? ("") : RestDatasource().KEY_email: email,
        date_of_birth.isEmpty ? ("") : RestDatasource().KEY_date_of_birth:
            date_of_birth,
        password.isEmpty ? ("") : RestDatasource().KEY_password: password,
        RestDatasource().KEY_profile: editProfileSubRawMap(
            description,
            thumbnail,
            profile_pic,
            is_seller,
            is_selling_adult_content,
            is_age_verified,
            gender,
            country,
            height_cm,
            weight_kg,
            race,
            body,
            pics),
      };

  Map<String, dynamic> editProfileSubRawMap(
          String description,
          String thumbnail,
          String profile_pic,
          bool is_seller,
          is_selling_adult_content,
          String is_age_verified,
          String gender,
          String country,
          String height_cm,
          String weight_kg,
          String race,
          String body,
          List<Pic> pics) =>
      {
        profile_pic.isEmpty ? ("") : RestDatasource().KEY_profile_pic:
            profile_pic,
        thumbnail.isEmpty ? ("") : RestDatasource().KEY_thumbnail: thumbnail,
        description.isEmpty ? ("") : RestDatasource().KEY_description:
            description,
        RestDatasource().KEY_is_seller: is_seller,
        RestDatasource().KEY_is_selling_adult_content: is_selling_adult_content,
        is_age_verified.isEmpty ? ("") : RestDatasource().KEY_is_age_verified:
            is_age_verified,
        gender.isEmpty ? ("") : RestDatasource().KEY_gender: gender,
        country.isEmpty ? ("") : RestDatasource().KEY_country: country,
        RestDatasource().KEY_pics: pics,
        RestDatasource().KEY_physical_appearance:
            editProfilePhysicalApperanceRawMap(height_cm, weight_kg, race, body)
      };

  Map<String, dynamic> editProfilePhysicalApperanceRawMap(
          String height_cm, String weight_kg, String race, String body) =>
      {
        height_cm.isEmpty ? ("") : RestDatasource().KEY_height_cm: height_cm,
        weight_kg.isEmpty ? ("") : RestDatasource().KEY_weight_kg: weight_kg,
        race.isEmpty ? ("") : RestDatasource().KEY_race: race,
        body.isEmpty ? ("") : RestDatasource().KEY_body: body,
      };

  //Create Add or Update Account Raw data
  Map<String, dynamic> addUpdateBankAccountPutRawMap(
          String owner_name,
          String bank_name,
          String number,
          String country,
          String swift,
          String branch_name,
          String branch_address,
          String type) =>
      {
        RestDatasource().KEY_bank_account: bankPutRawMap(owner_name, bank_name,
            number, country, swift, branch_name, branch_address, type)
      };

  Map<String, dynamic> bankPutRawMap(
          String owner_name,
          String bank_name,
          String number,
          String country,
          String swift,
          String branch_name,
          String branch_address,
          String type) =>
      {
        RestDatasource().KEY_owner_name: owner_name,
        RestDatasource().KEY_bank_name: bank_name,
        RestDatasource().KEY_number: number,
        RestDatasource().KEY_country: country,
        RestDatasource().KEY_swift: swift,
        RestDatasource().KEY_branch_name: branch_name,
        RestDatasource().KEY_branch_address: branch_address,
        RestDatasource().KEY_type: type,
      };

  Map<String, dynamic> addUpdateAmazonAccountPutRawMap(
          String username, String country) =>
      {RestDatasource().KEY_amazon_account: amazonPutRawMap(username, country)};

  Map<String, dynamic> amazonPutRawMap(String username, String country) => {
        username.isEmpty ? ("") : RestDatasource().KEY_username: username,
        country.isEmpty ? ("") : RestDatasource().KEY_country: country,
      };
}
