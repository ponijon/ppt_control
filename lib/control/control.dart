import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter/services.dart';

class ControlPage extends StatefulWidget {
  final String title;
  final String? data;

  const ControlPage({
    Key? key,
    required this.title,
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

  void _connectWebSocket() {
    channel = IOWebSocketChannel.connect(
      'ws://127.0.0.1:5000',
    );

    channel!.stream.listen((message) {
      // setState(() {
      //   _status = message;
      // });

      if (message == "nextSlide") {
        _nextSlide(); // Invoke _nextSlide method
      } else if (message == "previousSlide") {
        _previousSlide(); // Invoke _previousSlide method
      }
    }, onError: (error) {
      setState(() {
        _status = 'Connection error: $error';
      });
    }, onDone: () {
      setState(() {
        _status = 'Disconnected';
      });
    });

    setState(() {
      _status = 'Connected';
    });
  }

  void _nextSlide() async {
    // channel?.sink.add('nextSlide');

    final result = await methodChannel.invokeMethod('nextSlide');
    print(result);
  }

  void _previousSlide() async {
    // channel?.sink.add('previousSlide');
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Status: $_status'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextSlide,
              child: Text('Next Slide'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _previousSlide,
              child: Text('Previous Slide'),
            ),
          ],
        ),
      ),
    );
  }
}
