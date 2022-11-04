import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'imin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const MethodChannel channel = MethodChannel('com.imin.printersdk');

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<String> stateNotifier = ValueNotifier("");
  ValueNotifier<String> libsNotifier = ValueNotifier("");
  ValueNotifier<String> scanNotifier = ValueNotifier("");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Text("iminPrinterSDK.jar:"),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        clickBtn("init", () async {
                          Imin().init();
                        }),
                        clickBtn("getStatus", () async {
                          stateNotifier.value =
                              "getStatus : ${await channel.invokeMethod("getStatus")}";
                        }),
                        clickBtn("printText", () async {
                          Imin().printText('12345');
                        }),
                        ValueListenableBuilder(
                            valueListenable: stateNotifier,
                            builder: (context, String value, child) {
                              return Text(value);
                            })
                      ],
                    ),
                  )
                ],
              ),
              const Divider(
                color: Colors.red,
              ),
              Row(
                children: [
                  const Text("IminLibs1.0.15.jar:"),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        clickBtn("getSn", () async {
                          libsNotifier.value =
                              "sn:${await channel.invokeMethod("getSn")}";
                          print('sn=${libsNotifier.value}');
                        }),
                        clickBtn("opencashBox", () async {
                          libsNotifier.value =
                              "${await channel.invokeMethod("opencashBox")}";
                        }),
                        ValueListenableBuilder(
                            valueListenable: libsNotifier,
                            builder: (context, String value, child) {
                              return Text(value);
                            })
                      ],
                    ),
                  )
                ],
              ),
              const Divider(
                color: Colors.red,
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget clickBtn(String title, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: MaterialButton(
        onPressed: onPressed,
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(title),
      ),
    );
  }
}
