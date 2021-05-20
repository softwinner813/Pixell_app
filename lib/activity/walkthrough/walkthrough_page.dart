import 'package:flutter/material.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';

class WalkthroughPage extends StatelessWidget {
  WalkthroughPage({Key key, this.step, this.title, this.subtitle, this.subsubtitle, this.imageName, this.footer, this.showArrow = false})
      : super(key: key);

  final String step;
  final String title;
  final String subtitle;
  final String subsubtitle;
  final String imageName;
  final String footer;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.fromLTRB(MyConstants.space_20, MyConstants.space_50 * 2, MyConstants.space_20, MyConstants.space_50 * 2),
      child: Column(
        children: <Widget>[
          Visibility(
            child: Container(
              color: Colors.black,
              padding: new EdgeInsets.fromLTRB(MyConstants.space_5, MyConstants.space_5, MyConstants.space_5, MyConstants.space_5),
              margin: new EdgeInsets.only(bottom: MyConstants.space_20),
              child: Text(
                (step ?? "").toUpperCase(),
                style: MyConstants.textStyle_walkthrough_step,
              ),
            ),
            visible: (step != null && step.isNotEmpty),
          ),
          Visibility(
            child: Container(
              margin: new EdgeInsets.only(bottom: MyConstants.space_20),
              child: Text(
                title ?? "",
                style: MyConstants.textStyle_walkthrough_title,
                textAlign: TextAlign.center,
              ),
            ),
            visible: (title != null && title.isNotEmpty),
          ),
          Visibility(
            child: Container(
              margin: new EdgeInsets.only(bottom: MyConstants.space_20),
              child: Text(
                subtitle ?? "",
                style: MyConstants.textStyle_walkthrough_subtitle,
                textAlign: TextAlign.center,
              ),
            ),
            visible: (subtitle != null && subtitle.isNotEmpty),
          ),
          Visibility(
            child: Container(
              child: Text(
                subsubtitle ?? "",
                style: MyConstants.textStyle_walkthrough_subsubtitle,
                textAlign: TextAlign.center,
              ),
            ),
            visible: (subsubtitle != null && subsubtitle.isNotEmpty),
          ),
          Spacer(),
          new Image.asset(
            imageName ?? "",
            height: 200,
            width: 200,
          ),
          Spacer(),
          Text(
            footer ?? "",
            style: MyConstants.textStyle_walkthrough_footer,
            textAlign: TextAlign.center,
          ),
          Container(
            margin: new EdgeInsets.fromLTRB(0, MyConstants.space_20, 0, MyConstants.space_20),
            child: new Image.asset(
              showArrow ? 'graphics/walkthrough-arrow.png' : '',
              width: 50,
            ),
          ),
        ],
      ),
    );
  }
}
