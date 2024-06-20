import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter/services.dart';
// import 'package:win32/winsock2.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class ControlPage extends StatefulWidget {
  final String id;
  final String? data;

  const ControlPage({
    Key? key,
    required this.id,
    this.data, // Make data nullable
  }) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final methodChannel = MethodChannel('open_app_channel');
  IOWebSocketChannel? channel;
  int _slideCount = 0;
  String _status = 'Disconnected';

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _handleSlideEvent(String event, dynamic data) {
    // If data is a JSON string, decode it
    var decodedData;
    if (data is String) {
      try {
        decodedData = json.decode(data);
      } catch (e) {
        // Data is not JSON encoded, handle as plain string
        decodedData = data;
      }
    } else {
      // If data is not a string, use it as-is
      decodedData = data;
    }

    // Check if decodedData is a Map and contains an 'event' key
    if (decodedData is Map && decodedData.containsKey('event')) {
      print(decodedData['event']);

      if (decodedData['event'] == widget.id) {
        if (event == 'nextSlide') {
          _nextSlide();
        } else if (event == 'previousSlide') {
          _previousSlide();
        }
      }
    } else {
      // Handle cases where data is not a Map or does not contain 'event'
      if (decodedData == event) {
        if (event == 'nextSlide') {
          _nextSlide();
        } else if (event == 'previousSlide') {
          _previousSlide();
        }
      }
    }
  }

  void _connectWebSocket() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      // Log token
      print('Token: $token');

      // Ensure token is not null or empty
      if (token == null || token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      final socket = IO.io(dotenv.env['SOCKET_URL'], <String, dynamic>{
        'transports': ['websocket'],
        'auth': {'token': token}
      });

      socket.connect();

      socket.onConnect((_) {
        print('ws connect connected');
        setState(() {
          _status = 'Connected';
        });
        socket.emit('nextSlide', 'test');
      });

      socket.onConnectError((data) {
        print('ws connect error');
        print(data);
        setState(() {
          _status = 'Connection error';
        });
      });

      socket.on('nextSlide', (data) => _handleSlideEvent('nextSlide', data));
      socket.on(
          'previousSlide', (data) => _handleSlideEvent('previousSlide', data));

      socket.onDisconnect((_) {
        print('ws disconnect');
        setState(() {
          _status = 'Disconnected';
        });
      });
    } catch (e) {
      print('Exception: $e');
      setState(() {
        _status = 'Failed to connect: $e';
      });
    }
  }

  void _nextSlide() async {
    final result = await methodChannel.invokeMethod('nextSlide');
    print(result);
  }

  void _previousSlide() async {
    final result = await methodChannel.invokeMethod('previousSlide');
    print(result);
  }

  @override
  void dispose() {
    channel?.sink.close(status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.id),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  // Your main content goes here
                  child: Text('Status: $_status'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width / 2,
                      color: Colors.blue,
                      child: TextButton(
                        onPressed: _nextSlide,
                        child: Text(
                          'Next Slide',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width / 2,
                      color: Colors.red,
                      child: TextButton(
                        onPressed: _previousSlide,
                        child: Text(
                          'Previous Slide',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]));
  }
}
// Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Status: $_status'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _nextSlide,
//               child: Text('Next Slide'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _previousSlide,
//               child: Text('Previous Slide'),
//             ),
//           ],
//         ),
//       ),