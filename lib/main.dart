import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors hide ListTile hide Tab;
import 'package:flutter_libserialport/flutter_libserialport.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: NavigationLayout(),
    );
  }
}

class NavigationLayout extends StatefulWidget {
  @override
  _NavigationLayoutState createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Management'),
      ),
      body: _buildBody(),
      drawer: NavigationDrawer(onItemSelected: _onNavigationItemSelected),
    );
  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return StaffsPage();
      case 1:
        return MembersPage();
      case 2: // Index for the ScorePage
        return ScorePage();
      default:
        return Container();
    }
  }
}

class NavigationDrawer extends StatelessWidget {
  final Function(int) onItemSelected;

  const NavigationDrawer({Key? key, required this.onItemSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Navigation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Staffs'),
            onTap: () {
              onItemSelected(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Members'),
            onTap: () {
              onItemSelected(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Score'),
            onTap: () {
              onItemSelected(2);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class StaffsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Staffs Page'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Staff List'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StaffList(),
            Center(child: Text('Tab 2')),
            Center(child: Text('Tab 3')),
          ],
        ),
      ),
    );
  }
}

class MembersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Members Page'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Member List'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MemberList(),
            Center(child: Text('Tab 2')),
            Center(child: Text('Tab 3')),
          ],
        ),
      ),
    );
  }
}

class StaffList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    List<String> staffNames = ['John Doe', 'Jane Smith', 'Alex Johnson'];

    return ListView.builder(
      itemCount: staffNames.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(staffNames[index]),
          // Add more details about each staff member here
        );
      },
    );
  }
}

class MemberList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    List<String> memberNames = ['Alice Johnson', 'Bob Smith', 'Eva Brown'];

    return ListView.builder(
      itemCount: memberNames.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(memberNames[index]),
          // Add more details about each member here
        );
      },
    );
  }
}

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  SerialPort port = SerialPort('COM5');
  late SerialPortReader reader;

  @override
  void initState() {
    super.initState();
    var res = port.openRead();

    if (!res) {
      print('Error opening port:${port.name}');
      // handle to close reconnect
    }
    try {
      var portConfig = SerialPortConfig()
        ..baudRate = 9600
        ..bits = 8
        ..stopBits = 1;
      port.config = portConfig;
    } catch (e) {
      print(e.toString());
    }

    reader = SerialPortReader(port);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<Uint8List>(
          stream: reader.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Awaiting result...');
            }

            var decodedString = utf8
                .decode(snapshot.data!); //String.fromCharCodes(snapshot.data!);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Counter from Arduino:',
                ),
                Text(
                  decodedString,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    port.close();
    super.dispose();
  }
}
