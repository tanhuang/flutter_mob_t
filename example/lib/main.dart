import 'package:flutter/material.dart';
import 'package:flutter_mob_t/flutter_mob_t.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var phone = '', code = '';

  @override
  void initState() {
    FlutterMob.init("moba6b6c6d6", "b89d2427a3bc7ad1aea1e1e8c1d36bf3");
    MobRegister register = MobRegister();
    register.setupWechat("wx617c77c82218ea2c", "c7253e5289986cf4c4c74d1ccc185fb1");
    register.setupQQ("100371282", "aed9b0303e3ed1e27bae87c33761161d");
    register.setupSina("568898243", "38a4f8204cc784f81f9f0daaf31e02e3", "http://www.sharesdk.cn");
    FlutterMob.register(register);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onChanged: (v) {
                  phone = v;
                },
              ),
            ),
            MaterialButton(
              onPressed: getCode,
              color: Colors.blueAccent,
              child: Text('getCode'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Code'),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  code = v;
                },
              ),
            ),
            MaterialButton(
              onPressed: submitCode,
              color: Colors.blueAccent,
              child: Text('submitCode'),
            ),
            dividerHorizontal,
            item('微信授权', authWechat),
            dividerHorizontal,
            item('QQ授权', authQQ),
            dividerHorizontal,
            item('新浪授权', authSina),
            dividerHorizontal,
            item('弹窗分享', share),
            dividerHorizontal,
          ],
        ),
      ),
    );
  }

  Widget item(String text, Function method) {
    return ListTile(
      onTap: method,
      dense: true,
      title: Text(text),
    );
  }

  static Widget dividerHorizontal = Container(
    height: 1,
    color: Colors.black54,
  );

  void getCode() {
    FlutterMob.getCode(phone).then((result) {
      print(result.status);
      print(result.msg);
    });
  }

  void submitCode() {
    FlutterMob.commitCode(phone, code).then((result) {
      print(result.status);
      print(result.msg);
    });
  }

  void authWechat() {
    FlutterMob.auth(Platforms.wechat).then((result) {
      print(result.status);
      print(result.msg);
      print(result.data);
    });
  }

  void authQQ() {
    FlutterMob.auth(Platforms.qq).then((result) {
      print(result.status);
      print(result.msg);
      print(result.data);
    });
  }

  void authSina() {
    FlutterMob.auth(Platforms.sina).then((result) {
      print(result.status);
      print(result.msg);
      print(result.data);
    });
  }

  void share() {
    FlutterMob.share('我是Title', '我是分享文本', 'https://github.com/MobClub/ShareSDK-for-iOS/blob/master/Sample/ShareSDKDemo/ShareSDKDemo/Resources/shareImg.png', 'http://www.mob.com/', '');
  }
}
