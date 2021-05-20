
import 'dart:io';

class ImagePojo{

  String largeUrl = "";
  String thumbUrl = "";
  File imageFile;
  String fileNamePics="";

  ImagePojo(String thumbUrl,String largeUrl,String fileNamePics,File imageFile){
    this.thumbUrl = thumbUrl;
    this.largeUrl = largeUrl;
    this.imageFile= imageFile;
    this.fileNamePics = fileNamePics;
  }
}