import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:offland_monitor/utils/api.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OFFICELAND MONITOR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'OFFICELAND MONITOR'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void>? _launched;
  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  double total = 0;
  double total_cf = 0;
  List data = [];
  List taskassing = [];
  List taskassing_list = [];
  List data_list = [];
  var ac_name;
  var wax_balance;
  var ocoin_ingame_balance;
  var daily_profit;
  var wax_price = 0.00;
  var ocoin_price = 0.00;

  itemList() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return (data.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int i) {
              DateTime date1 = DateTime.fromMillisecondsSinceEpoch(
                  (data[i]['finish_time'] + 432000) * 1000);
              DateTime date2 = DateTime.fromMillisecondsSinceEpoch(
                  (data[i]['finish_time']) * 1000);
              // print(DateFormat('dd/MM/yyyy HH:mm:ss').format(date1));
              var secondDate = (((data[i]['finish_time'] + 432000)) -
                  ((DateTime.now().millisecondsSinceEpoch) / 1000));

              var day = 00.00;
              day = secondDate / 86400;
              var fee = 0.00;
              fee = day * 10.00;
              if (fee <= 0.00) {
                fee = 0.00;
              }
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (fee <= 0.00) ? Color(0xffa5d6a7) : Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Reward : ${double.parse(data[i]['reward']).toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('Fee : ${(fee.toStringAsFixed(2))}%',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Text(
                            "FinishTask :",
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          Text(DateFormat('dd/MM/yy HH:mm:ss').format(date2),
                              style: TextStyle(fontSize: 11))
                        ]),
                        Row(children: [
                          const Text("FinishFee0% : ",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold)),
                          Text(DateFormat('dd/MM/yy HH:mm:ss').format(date1),
                              style: TextStyle(fontSize: 11))
                        ]),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
        : Container(
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(
                  color: Colors.yellowAccent,
                ),
                // Text('Loading ...',
                //     style: TextStyle(
                //       color: Colors.white,
                //     ))
              ],
            )),
            height: height / 3,
          );
  }

  tasklist() {
    final height = MediaQuery.of(context).size.height;
    return (taskassing_list.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: taskassing_list.length,
            itemBuilder: (BuildContext context, int i) {
              req_name() async {
                final res = await API.get(
                    "https://wax.api.atomicassets.io/atomicassets/v1/assets/${taskassing[i]['asset_id']}");
                // print(res['data']['name'].toString());
              }

              // DateTime date1 = DateTime.fromMillisecondsSinceEpoch(
              //     (taskassing[i]['task_end']) * 1000);
              // // print(DateFormat('dd/MM/yyyy HH:mm:ss').format(date1));
              var second_date = (((taskassing_list[i]['task_end'])) -
                  ((DateTime.now().millisecondsSinceEpoch) / 1000));
              final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(
                  (taskassing_list[i]['task_end']) * 1000);

              double temp_sec = second_date;
              double temp_hh = (temp_sec / 3600);
              int hh = 0;
              int mm = 0;
              int ss = 0;
              var text_success_color = Color(0xffD61C1C);
              if (temp_hh < 0) {
                hh = 0;
                mm = 0;
                ss = 0;
              } else {
                hh = (temp_sec / 3600).toInt();
                mm = (temp_sec % 3600 / 60).toInt();
                ss = ((temp_sec % 3600) - (mm * 60)).toInt();
              }
              print('daliy = ${taskassing_list[i]['task_id']}');
              // print("${hh} : ${mm} :${ss}");
              var xcolor = Colors.grey[600];
              (taskassing_list[i]['rarity'] == 'boss')
                  ? xcolor = Color(0xff003355)
                  : (taskassing_list[i]['rarity'] == 'leader')
                      ? xcolor = Color(0xff7F3191)
                      : (taskassing_list[i]['rarity'] == 'manager')
                          ? xcolor = Color(0xffff1100)
                          : (taskassing_list[i]['rarity'] == 'senior')
                              ? xcolor = Color(0xFFddaa33)
                              : (taskassing_list[i]['rarity'] == 'junior')
                                  ? xcolor = Color(0xFF049101)
                                  : Color(0xffcfdee3);

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),

                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(6), color: xcolor),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Text('task_id : ${taskassing_list[i]['task_id']}',
                        //     style: TextStyle(fontSize: 12)),
                        Flexible(
                          flex: 2,
                          child: Container(
                            // width: MediaQuery.of(context).size.width / 3.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: xcolor),
                            padding: EdgeInsets.all(2),
                            child: Center(
                              child: Text(
                                  '${taskassing_list[i]['name']} : ${taskassing_list[i]['rarity']}',
                                  // Text("${name}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfff9f6ee))),
                            ),
                          ),
                        ),
                        // Text('${hh}:${mm}:${ss}',
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //       color: (hh == 0 && mm == 0 && ss == 0)
                        //           ? text_success_color
                        //           : Color(0xfff9f6ee),
                        //       fontWeight: FontWeight.bold,
                        //     )),
                        Flexible(
                          flex: 2,
                          child: Container(
                            // width: MediaQuery.of(context).size.width / 3,
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: (hh == 0 && mm == 0 && ss == 0)
                                    ? Colors.green
                                    : Colors.blueGrey[900]),
                            padding: EdgeInsets.all(2),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(DateFormat('dd/MM/yy').format(date1),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xfff9f6ee),
                                      )),
                                  Text(DateFormat('HH:mm').format(date1),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xfff9f6ee),
                                      )),
                                ]),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            // width: MediaQuery.of(context).size.width / 5.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: (hh == 0 && mm == 0 && ss == 0)
                                    ? Colors.green
                                    : Colors.blueGrey[900]),
                            padding: EdgeInsets.all(2),
                            child: Center(
                              child: Text("${hh}:${mm}:${ss}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xfff9f6ee),
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                    // Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    //   const Text(
                    //     "FinishTask @ ",
                    //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    //   ),
                    //   Text(DateFormat('dd/MM/yyyy HH:mm:ss').format(date2),
                    //       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
                    // ]),
                    // Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    //   const Text("Fee 0% @ ",
                    //       style:
                    //           TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    //   Text(DateFormat('dd/MM/yyyy HH:mm:ss').format(date1),
                    //       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
                    // ]),
                  ],
                ),
              );
            },
          )
        : Container(
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(
                  color: Colors.yellowAccent,
                ),
                // Text('Loading ...',
                //     style: TextStyle(
                //       color: Colors.white,
                //     ))
              ],
            )),
            height: height / 3,
          );
  }

  callapi(wallet) async {
    taskassing_list = [];
    // data = [];
    total = 0;
    total_cf = 0;
    final playload = {
      "json": true,
      "code": "officegameio",
      "scope": "officegameio",
      "table": "finishtask",
      "lower_bound": wallet,
      "upper_bound": wallet,
      "index_position": 2,
      "key_type": "name",
      "limit": 500,
      "reverse": false,
      "show_payer": false
    };
    final payload2 = {"account_name": wallet};
    final payload3 = {
      "code": "officegameio",
      "index_position": 1,
      "json": true,
      "key_type": "",
      "limit": 1,
      "lower_bound": wallet,
      "reverse": false,
      "scope": "officegameio",
      "show_payer": false,
      "table": "balances",
      "upper_bound": wallet
    };

    var temp = await API.post(playload);
    var temp2 = await API.post1(payload2);
    var temp3 = await API.post(payload3);

    var temp4 = await API.get(
        "https://api.coingecko.com/api/v3/simple/price?ids=wax&vs_currencies=thb");
    var temp5 = await API.get("https://wax.alcor.exchange/api/markets/258");

    final payload6 = {
      "json": true,
      "code": "officegameio",
      "table": "taskassign",
      "scope": "officegameio",
      "index_position": "3",
      "key_type": "name",
      "upper_bound": wallet,
      "lower_bound": wallet
    };
    var temp6 = await API.post(payload6);

    // print(temp);
    // print(temp3["rows"]);
    // print(temp4);
    // print(temp5);
    // print(temp6);

    test(i) {
      var second_date = (((i['finish_time'] + 432000)) -
          ((DateTime.now().millisecondsSinceEpoch) / 1000));
      var day = second_date / 86400;
      var fee = day * 10.00;
      if (fee <= 0.00) {
        total_cf = total_cf + double.parse(i['reward']);
      } else {
        total = total + double.parse(i['reward']);
      }
    }

    await temp['rows'].forEach((i) => {test(i)});
    setState(() {
      data = temp['rows'];
      taskassing = temp6['rows'];
      wax_balance = temp2['core_liquid_balance'];
      ac_name = temp2['account_name'];
      ocoin_ingame_balance =
          (temp3['rows'].length == 0) ? 0 : temp3['rows'][0]['quantity'];
      wax_price = temp4['wax']['thb'];
      ocoin_price = temp5['last_price'] * temp4['wax']['thb'];
      total;
    });

    taskassing.forEach((element) async {
      final res = await API.get(
          "https://wax.api.atomicassets.io/atomicassets/v1/assets/${element['asset_id']}");
      // print("name : ${res['data']['template']['immutable_data']['name']}");
      // print("rarity : ${res['data']['template']['immutable_data']['rarity']}");
      // print('task_id : ${element['task_id']}');
      // print('task_end : ${element['task_end']}');
      Map data_list = {
        "name": res['data']['template']['immutable_data']['name'],
        "rarity": res['data']['template']['immutable_data']['rarity'],
        "task_id": element['task_id'],
        "task_end": element['task_end']
      };
      setState(() {
        taskassing_list.add(data_list);
      });
      taskassing_list.sort((a, b) => a['task_end'].compareTo(b['task_end']));
      // print(taskassing_list);
    });
  }

  final walletcontorller = TextEditingController();
  void _printLastValue() {
    print(walletcontorller.text);
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = await prefs.getString("wallet_address");
    if (value != Null) {
      setState(() {
        walletcontorller.text = value!;
      });
      print('temp : ${walletcontorller.text}');
      callapi(walletcontorller.text);
    }
  }

  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer.periodic(Duration(seconds: 10), (timer) {
    getdata();
    if (walletcontorller.text != Null) {
      timer = Timer.periodic(
          Duration(seconds: 30), (Timer t) => callapi(walletcontorller.text));
    }
    // });
    walletcontorller.addListener(_printLastValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    walletcontorller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        title: Text(widget.title),
        // actions: <Widget>[
        //   IconButton(
        //       onPressed: () {
        //         showDialog(
        //             barrierDismissible: false,
        //             context: context,
        //             builder: (BuildContext context) {
        //               return Dialog(
        //                   backgroundColor: Colors.transparent,
        //                   child: Stack(
        //                     alignment: Alignment.center,
        //                     children: [
        //                       Center(
        //                         child: CircularProgressIndicator(),
        //                         // child: Container(
        //                         //   // height: MediaQuery.of(context).size.height,
        //                         //   child: CircularProgressIndicator(),
        //                         // ),
        //                       )
        //                     ],
        //                   ));
        //             });
        //         if (walletcontorller.text != "") {
        //           data = [];
        //           taskassing_list = [];
        //           callapi(walletcontorller.text);
        //         }

        //         Timer(const Duration(seconds: 5), () {
        //           Navigator.pop(context);
        //         });
        //       },
        //       icon: Icon(Icons.refresh)),
        // ],
      ),
      body: Container(
        color: Color(0xff121212),
        child: Column(
          children: [
            Flexible(
                child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Column(children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    width: (MediaQuery.of(context).size.width / 10) * 8.5,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xff2c2c30),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'ACCOUNT INFO',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 35,
                          child: Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                      style: TextStyle(color: Colors.white),
                                      controller: walletcontorller,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          labelText: 'WAX Wallet',
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          border: OutlineInputBorder(),
                                          hintText:
                                              (walletcontorller.text == "")
                                                  ? 'Enter a WAX Wallet'
                                                  : walletcontorller.text,
                                          hintStyle: TextStyle(
                                              color: Colors.white54))),
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      if (walletcontorller.text != '') {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString("wallet_address",
                                            walletcontorller.text);
                                            Fluttertoast.showToast(msg: "wax wallet update !");
                                      } else {
                                        await getdata();
                                      }
                                      await callapi(walletcontorller.text);
                                    },
                                    child: Text('save'))
                              ],
                            ),
                          ),
                        ),
                        // Text(
                        //   "${ac_name} ",
                        //   style: const TextStyle(
                        //       color: Colors.white70, fontSize: 16),
                        // ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'WAX : ${wax_balance}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'InGame : ${ocoin_ingame_balance}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                        // Text(
                        //   'Daily Profit : ${daily_profit}',
                        //   style: const TextStyle(
                        //       color: Colors.white, fontSize: 16),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    width: (MediaQuery.of(context).size.width / 10) * 8.5,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xff2c2c30)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'FINISH TASK',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Total : ${data.length}',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ready to Claim : ${total_cf.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                ),
                                Text(
                                  'Waiting fee : ${total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[900],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 10),
                                  child: Text(
                                      'WAX : ${wax_price.toStringAsFixed(2)} THB',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                )),
                            Flexible(
                                flex: 1,
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[900],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 10),
                                    child: Text(
                                        'OCOIN :${ocoin_price.toStringAsFixed(2)} THB',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14)))),
                          ],
                        )
                      ],
                    ),
                  ),
                ]),
                Container(
                  constraints: BoxConstraints(
                      maxHeight: height / 1.85,
                      maxWidth: width,
                      minWidth: 150.0,
                      minHeight: 150.0),
                  margin: EdgeInsets.only(top: (height / 100)),
                  // child: itemList(),
                  child: Column(children: [
                    Flexible(child: itemList()),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 5),
                      width: (MediaQuery.of(context).size.width / 10) * 8.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Working Task',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'total :${taskassing_list.length}',
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Flexible(flex: 2, child: tasklist()),
                  ]),
                ),
              ],
            )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: Container(
          color: Color(0xff263d4d),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    const String toLaunch =
                        'https://wax.atomichub.io/market?collection_name=officelandio&order=desc&sort=created&symbol=WAX';
                    setState(() {
                      _launched = _launchInBrowser(toLaunch);
                    });
                  },
                  child: const Text('BUY STAFF')),
              ElevatedButton(
                  onPressed: () {
                    const String toLaunch =
                        'https://officeland.io/game/workspace/publicspace';
                    setState(() {
                      _launched = _launchInBrowser(toLaunch);
                    });
                  },
                  child: const Text('PUBLIC SPACE')),
            ],
          )),
    );
  }
}

xx(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}
