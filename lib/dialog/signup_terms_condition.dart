import 'package:flutter/material.dart';
import 'package:pixell_app/localization/app_localizations.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsCondition extends StatefulWidget {

  TermsCondition({Key key, this.title,this.loadUrl}) : super(key: key);

  final String loadUrl;
  final String title;

  @override
  State<StatefulWidget> createState() => _TermsConditionStateful();
}

class _TermsConditionStateful extends State<TermsCondition>
    with SingleTickerProviderStateMixin {

  bool isLoading=true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
            margin: const EdgeInsets.all(MyConstants.layout_margin),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0))),
            child: Container(
              margin: const EdgeInsets.fromLTRB(MyConstants.layout_margin / 2,
                  0, MyConstants.layout_margin / 2, 0),
              child: Column(
                children: <Widget>[
                  new Container(
                    margin: new EdgeInsets.all(
                        MyConstants.vertical_control_space_half),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  new Container(
                    margin: new EdgeInsets.fromLTRB(
                        0.0, MyConstants.vertical_control_space, 0.0, 0.0),
                  ),
                  Expanded(
                    child: WebView(
                        onWebViewCreated: (controller) {
                          controller.loadUrl(widget.loadUrl, headers: { "Accept-Language": MyConstants.selectedLanguageCode });
                        },
                        onPageFinished: (_) {
                          setState(() {
                            isLoading = false;
                          });
                        },
                        javascriptMode: JavascriptMode.unrestricted),

                  ),
                  isLoading ? Center( child: CircularProgressIndicator()) : Container(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                        child: Text(
                          AppLocalizations.of(context).translate("label_close"),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: MyConstants.btn_dialog_size,
                            color: MyUtils()
                                .getColorFromHex(MyConstants.color_theme),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
