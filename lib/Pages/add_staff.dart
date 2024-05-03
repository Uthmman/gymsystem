import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/helper/db_helper.dart';
import 'package:gymsystem/model/staff.dart';
import 'package:gymsystem/widget/sl_btn.dart';
import 'package:gymsystem/widget/sl_input.dart';
import 'package:udp/udp.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  final _addStaffKey = GlobalKey<FormState>();
  final _phoneTc = TextEditingController();
  final _fullNameTc = TextEditingController();
  final _rfidTc = TextEditingController();
  final _roleTc = TextEditingController();
  final _startWorkingTc = TextEditingController();

  bool loading = false;

  SerialPort port = SerialPort('COM5');
  late SerialPortReader reader;
  late UDP sender;

  @override
  void initState() {
    super.initState();
//      sender = UDP(
//  port: Port(12346),
//  onReceive: _onReceive,
//  );
//  sender.send("Hello from Flutter!", Port(remotePort: 12345));
    testHttp();
    // // var res = true;
    // print('isport open; ${port.isOpen}');
    // var res = port.openReadWrite();
    // print('isport open; ${port.isOpen}');

    // if (!res) {
    //   print('Error opening port:${port.name}');
    // }
    // try {
    //   var portConfig = SerialPortConfig();
    //   portConfig.baudRate = 9600;
    //   portConfig.bits = 8;
    //   portConfig.parity = SerialPortParity.none;
    //   portConfig.stopBits = 1;
    //   // portConfig.xonXoff = 0;
    //   portConfig.rts = 0;
    //   // portConfig.cts = 0;
    //   // portConfig.dsr = 0;
    //   portConfig.dtr = 0;
    //   // portConfig.dispose();
    //   port.config = portConfig;
    //   print('isport open; ${port.isOpen}');
    // } catch (e) {
    //   print('isport open; ${port.isOpen}');
    //   print(e.toString());
    //   // showToast(context, e.toString());
    //   // yante ysemagnal mute aydelem
    // }

    // reader = SerialPortReader(port);

    // reader.stream.listen((event) {
    //   _rfidTc.text = utf8.decode(event).replaceAll(" ", "");
    //   String str = '4';
    //   Uint8List uint8list = Uint8List.fromList(str.codeUnits);
    //   print(port.write(uint8list));
    // }).onError((e) {
    //   print(e.toString());
    //   // Future.delayed(Duration(seconds: 3)).then((value) {
    //   //   if (mounted) {
    //   //     showToast(context, e.toString());
    //   //   }
    //   // });
    // });
  }

  // String generateRandom8DigitNumber() {
  //   final random = Random();
  //   final number = random.nextInt(90000000) + 10000000; // 10000000 - 99999999
  //   return number.toString();
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    port.close();
  }

  testHttp() async {
    try {
      final channel = IOWebSocketChannel.connect('ws://192.168.4.1:8080/');

      channel.stream.listen(
        (data) {
          // Process the RFID data received from the ESP8266
          print('RFID Data: $data');
          _rfidTc.text = data.toString().replaceAll(" ", '');
        },
        onError: (error) {
          print('Error: $error');
        },
        onDone: () {
          print('WebSocket connection closed');
        },
      );
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
    }
  }
  // @override
  // initState() {
  //   super.initState();
  //   Future.delayed(const Duration(seconds: 10)).then((value) {
  //     _rfidTc.text = generateRandom8DigitNumber();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 3,
        vertical: 50,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Add Staff"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _addStaffKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/card_verify.gif',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: "Full Name",
                  hint: 'Alemu Taye',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.name,
                  controller: _fullNameTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: "Phone",
                  hint: '0934988272',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.phone,
                  controller: _phoneTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: "Role",
                  hint: 'Manager',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.text,
                  controller: _roleTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: "Started Working from",
                  hint: 'Manager',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.text,
                  controller: _startWorkingTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: "RFID",
                  hint: '8972348762',
                  inputColor: Colors.black,
                  otherColor: Colors.black54,
                  keyboardType: TextInputType.phone,
                  controller: _rfidTc,
                  isOutlined: true,
                  readOnly: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SLBtn(
                        text: "Save",
                        onTap: () async {
                          if (_addStaffKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            await DatabaseHelper().insertStaff(
                              Staff(
                                fullName: _fullNameTc.text,
                                role: _roleTc.text,
                                startedWorkingFrom: _startWorkingTc.text,
                                phone: _phoneTc.text,
                                rfId: int.parse(_rfidTc.text),
                                isActive: 0,
                                shiftType: '',
                              ),
                            );
                            final staffs = await DatabaseHelper().getStaffs();
                            DatabaseHelper.staffs = staffs;
                            setState(() {
                              loading = false;
                            });
                            if (mounted) {
                              Navigator.pop(context, true);
                            }
                          }
                        },
                      ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
