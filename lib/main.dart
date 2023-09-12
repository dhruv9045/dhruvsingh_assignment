import 'package:assignment/auth/signup.dart';
import 'package:assignment/firebase_options.dart';
import 'package:assignment/functions/authFunctions.dart';
import 'package:assignment/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'auth/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Handling a background message: ${message.messageId}");
  await Firebase.initializeApp(
      // name: "waiterapp", options: DefaultFirebaseOptions.currentPlatform
      );

  await setupFlutterNotifications();
  // showFlutterNotification(message);
  // showFlutterNotification(message);
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;
//
// Future initNotification() async {
//   // var initializationSettingsAndroid =
//   //     AndroidInitializationSettings("@mipmap/ic_launcher");
//   // // var initializationSettingsIOS = DarwinInitializationSettings(
//   // //     requestAlertPermission: false,
//   // //     requestBadgePermission: false,
//   // //     requestSoundPermission: false,
//   // //     onDidReceiveLocalNotification:
//   // //         (int? id, String? title, String? body, String? payload) async {});
//   //
//   // var initializationSettings =
//   //     InitializationSettings(android: initializationSettingsAndroid, iOS: null);
//
//   final NotificationAppLaunchDetails? notificationAppLaunchDetails =
//       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//   final didNotificationLaunchApp =
//       notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
//   print("did Notification $didNotificationLaunchApp");
//   if (didNotificationLaunchApp) {
//     var payload = notificationAppLaunchDetails!.notificationResponse!;
//     onSelectNotification(payload);
//   }
//   // else {
//   //   await flutterLocalNotificationsPlugin.initialize(
//   //     initializationSettings,
//   //     onDidReceiveNotificationResponse: onSelectNotification,
//   //     onDidReceiveBackgroundNotificationResponse: onSelectNotification,
//   //   );
//   // }
// }
//
// onSelectNotification(NotificationResponse notificationResponse) async {
//   print("payload ${notificationResponse.payload}");
//   print("payload FUNKY");
//   await Get.to(() => NotificationPage());
// }

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    playSound: true,
    showBadge: true,
    enableVibration: true,
    vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true, badge: true, sound: true);
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            playSound: true, enableVibration: true, channelShowBadge: true,
            vibrationPattern: Int64List.fromList(
                [0, 500, 200, 500]), // Sample vibration pattern
            channelDescription: channel.description,

            importance: Importance.high,
            icon: AndroidInitializationSettings('@mipmap/ic_launcher')
                .defaultIcon,
          ),
        ),
        payload: 'data');
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    initFirebase();
    // setupInteractedMessage();

    super.initState();
  }

  final AuthController authController = Get.put(AuthController());
  initFirebase() async {
    await Firebase.initializeApp();

    _firebaseMessaging = await FirebaseMessaging.instance;
    await _firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      print("HELLO");
    });
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      // _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen(showFlutterNotification);

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    // });

    // FirebaseMessaging.onMessage.listen(showFlutterNotification);
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   // Navigator.pushNamed(
    //   //   context,
    //   //   '/message',
    //   //   arguments: MessageArguments(message, true),
    //   // );
    // });
    _firebaseMessaging.getToken().then((token) {
      debugPrint('Device Token FCM: $token');
      authController.fcmUpdate(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Home();
        } else {
          return GetBuilder(
              init: AuthController(),
              builder: (authcontroller) {
                return authcontroller.login.value ? Signup() : LoginForm();
              });
        }
      },
    ));
  }
}
