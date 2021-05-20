import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixell_app/models/get_user_pojo.dart';
import 'package:pixell_app/presenter/get_user_presenter.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';

class HomeFragment extends StatefulWidget {
  final String title;

  const HomeFragment({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomeFragmentStateFul();
  }
}

class _HomeFragmentStateFul extends State<HomeFragment>
    implements GetSellersContract {
  GetSellersPresenter _getSellersPresenter;
  GetSellersPojo getCategoryPojo;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: getCategoryPojo == null
          ? new Center(
              child: new CircularProgressIndicator(),
            )
          : loadCategoryGridData(getCategoryPojo),
    );
  }

  @override
  void initState() {
    _getSellersPresenter = new GetSellersPresenter(this);
    _getSellersPresenter.doGetSellers(context, "");
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  GridView loadCategoryGridData(GetSellersPojo _usersData) {
    return new GridView.builder(
        itemCount: _usersData.results.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              alignment: Alignment.center,
              child: Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    //tapDialog(index);
                  },
                  child: Stack(
                    children: <Widget>[
                      Align(
                        child: Container(
                          width: double.infinity,
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.fitWidth,
                              placeholder:
                                  "graphics/user_default_rectangle.png",
                              image: _usersData.results[index].profile != null
                                  ? _usersData.results[index].profile.pics[0]
                                  : ""),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          verticalDirection: VerticalDirection.up,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              color: Colors.black.withOpacity(.4),
                              child: Text(
                                _usersData.results[index].username,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  void tapDialog(int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      child: new CupertinoAlertDialog(
        title: new Column(
          children: <Widget>[
            new Text("GridView"),
            new Icon(
              Icons.favorite,
              color: MyUtils().getColorFromHex(MyConstants.color_green_019807),
            ),
          ],
        ),
        content: new Text("Selected Item $index"),
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("OK"))
        ],
      ),
    );
  }

  @override
  void onError(String errorTxt) {
    MyUtils().toastdisplay(errorTxt);
  }

  @override
  void onSuccess(GetSellersPojo pojoData, String filter_type) {
    getCategoryPojo = pojoData;
    setState(() {
      print('UI Updated');
    });
  }
}
