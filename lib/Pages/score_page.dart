import 'package:flutter/material.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  // SerialPort port = SerialPort('COM5');
  // late SerialPortReader reader;

  // Future<void> writeData(String data) async {
  //   bool res = port.openWrite();

  //   if (!res) {
  //     print("Failed to open serial port!");
  //     return;
  //   }
  //   // Configure serial port settings
  //   try {
  //     var portConfig = SerialPortConfig()
  //       ..baudRate = 9600
  //       ..bits = 8
  //       ..stopBits = 1;
  //     port.config = portConfig;
  //   } catch (e) {
  //     print(e.toString());
  //   }

  //   // Convert string to byte list
  //   Uint8List dataBytes = Uint8List.fromList(data.codeUnits);

  //   // Write data to serial port
  //   port.write(dataBytes);

  //   print("Data written successfully!");
  // }

  @override
  void initState() {
    super.initState();
    // var res = port.openRead();

    // if (!res) {
    //   print('Error opening port:${port.name}');
    //   // handle to close reconnect
    // }
    // try {
    //   var portConfig = SerialPortConfig()
    //     ..baudRate = 9600
    //     ..bits = 8
    //     ..stopBits = 1;
    //   port.config = portConfig;
    // } catch (e) {
    //   print(e.toString());
    // }

    // reader = SerialPortReader(port);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Things are not freed up")
        // StreamBuilder<Uint8List>(
        //   stream: reader.stream,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) {
        //       return Text('Error: ${snapshot.error}');
        //     }
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Text('Awaiting result...');
        //     }

        //     var decodedString = utf8
        //         .decode(snapshot.data!); //String.fromCharCodes(snapshot.data!);
        //     return Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         const Text(
        //           'Counter from Arduino:',
        //         ),
        //         Text(
        //           decodedString,
        //           style: Theme.of(context).textTheme.headlineMedium,
        //         ),
        //       ],
        //     );
        //   },
        // ),
      ),
    );
  }

  @override
  void dispose() {
    // port.close();
    super.dispose();
  }
}