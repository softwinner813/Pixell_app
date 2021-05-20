import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pixell_app/activity/requests/request_details.dart';
import 'package:pixell_app/utils/share_preference.dart' as mypreference;

import 'activity/splash.dart';
import 'localization/app_localizations.dart';
import 'utils/my_constants.dart';
import 'utils/my_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static final navKey = new GlobalKey<NavigatorState>();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _PushMessagingState();
  }
}

class _PushMessagingState extends State<MyApp> {
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  Map<String, Map<String, dynamic>> pushNotifications = new Map();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _configureFCM();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Pixell',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: MyUtils().getColorFromHex(MyConstants.color_theme),
          accentColor: MyUtils().getColorFromHex(MyConstants.color_theme),
          splashColor: MyUtils().getColorFromHex(MyConstants.color_theme),
          textTheme: Theme.of(context).textTheme.copyWith(
                body1: new TextStyle(color: Colors.black, fontSize: 18.0),
                body2: new TextStyle(color: Colors.red, fontSize: 24.0), // new
              ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.red,
            textTheme: ButtonTextTheme.primary,
          )),
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en'),
        Locale('ja'),
        Locale('es'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      /*localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },*/
      home: MySplash(),
      navigatorKey: MyApp.navKey,
    );
  }

  ///Configure FCM
  void _configureFCM() {
    _localNotificationConfigure();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("📩 onMessage: $message");
        _showNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("🚀 onLaunch: $message");
        _notificationHandler(message);
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("🔄 onResume: $message");
        _notificationHandler(message);
      },
    );

    if (Platform.isIOS) {
      //Needed by iOS only
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
        mypreference.MySharePreference()
            .saveStringInPref(MyConstants.PREF_FCM_TOKEN, token.toString());
      });
      print(_homeScreenText);
    });
  }

  ///Local Notification Configure for show Notification
  void _localNotificationConfigure() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_notification');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _localNotificationHandler);
  }

  ///Show Notification
  Future _showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    var uniqueKey = (new UniqueKey()).toString();

    pushNotifications[uniqueKey] = message;
    print(message);

    if (Platform.isIOS) {
      var alert = message["aps"]["alert"];
      var title = alert["title"];
      var body = alert["body"];
      showCupertinoDialog(context: MyApp.navKey.currentState.overlay.context, builder: (context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop("Cancel"),
            isDestructiveAction: true,
            child: Text(AppLocalizations.of(context).translate('label_cancel')),
          ),
          CupertinoDialogAction(onPressed: () {
            _localNotificationHandler(uniqueKey);
            Navigator.of(context, rootNavigator: true).pop("See");
          },
            isDefaultAction: true,
            child: Text(AppLocalizations.of(context).translate('label_open_req')),
          )
        ],
      ));
      return;
    }
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: uniqueKey,
    );
  }

  Future<void> _localNotificationHandler(String uniqueId) {
    var notificationMessage = pushNotifications[uniqueId];
    if (notificationMessage == null) {
      return new Future<void>.value();
    }
    pushNotifications.remove(uniqueId);
    _notificationHandler(notificationMessage);
    return new Future<void>.value();
  }

  ///Handle Notification
  void _notificationHandler(Map<String, dynamic> message) {
    var requestId;
    if (Platform.isAndroid) {
      var nodeData = message['data'];
      requestId = nodeData['request_id'];
    } else {
      requestId = message['request_id'];
    }

    if (requestId != null) {
      print("Request id: $requestId");
      _tryToHandleRequestNotification(requestId);
    }
  }

  void _tryToHandleRequestNotification(requestId) {
    var state = MyApp.navKey.currentState;
    if (state == null) {
      Future.delayed(Duration(seconds: 2), () {
        _tryToHandleRequestNotification(requestId);
        return;
      });
      return;
    }
    _handleRequestNotification(requestId, state.overlay.context);
  }

  void _handleRequestNotification(requestId, BuildContext context) {
    mypreference.MySharePreference()
        .getIntegerInPref(MyConstants.PREF_KEY_USERID)
        .then((value) {
      if (value == null) {
        MyUtils().toastdisplay("Needs login");
        return;
      }
      if (Platform.isIOS) {
        showCupertinoDialog(
            context: context,
            builder: (context) => RequestDetails(
                  loginUserId: value,
                  requestId: requestId,
                ));
      } else {
        showDialog(
            context: context,
            builder: (context) => RequestDetails(
                  loginUserId: value,
                  requestId: requestId,
                ));
      }
    });
  }
}
