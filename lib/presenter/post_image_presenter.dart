import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pixell_app/models/post_image_pojo.dart';
import 'package:pixell_app/network/rest_ds.dart';
import 'package:path_provider/path_provider.dart';

abstract class PostImageContract {
  void onPostImageSuccess(PostImagePojo user);

  void onPostImageError(String errorTxt);
}

class PostImagePresenter {
  PostImageContract _view;
  RestDatasource api = new RestDatasource();

  PostImagePresenter(this._view);

  doPostImage(
      BuildContext getContext,
      Uint8List fileAsBytes, {
        bool compress = false,
        int minWidth = 1920,
        int minHeight = 1080,
        int quality = 50,
      }) async {

    final fileList =  List.from(fileAsBytes).cast<int>();

    var fileToUpload = fileList;
    if (compress) {
      fileToUpload = await FlutterImageCompress.compressWithList(
        fileList,
        minHeight: minWidth,
        minWidth: minHeight,
        quality: quality,
      );
    }

    //String base64File = base64Encode(Uint8List.fromList(fileToUpload));

    String dir = (await getTemporaryDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(Uint8List.fromList(fileToUpload));

    try {
      await api
          .postImage(getContext, file)
          .then((PostImagePojo pojoData) {
        _view.onPostImageSuccess(pojoData);
      });
    } catch (error) {
      print('Error occured: $error');
      _view.onPostImageError(error.toString());
    }
  }
}
