import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ControlPage extends StatelessWidget {
  final String title;
  final String? data;

  const ControlPage({
    Key? key,
    required this.title,
    this.data, // Make eventId nullable
  }) : super(key: key);

  static const platform = MethodChannel('open_app_channel');
  static int _slideCount = 0;


  Future<void> _getSlideCount() async {
    try {
      final int result = await platform.invokeMethod('getSlideCount');
      // setState(() {
      //   _slideCount = result;
      //   // _statusMessage = 'Slide count retrieved successfully';
      // });
      _slideCount = result;
    } on PlatformException catch (e) {
      // setState(() {
      //   _statusMessage = "Failed to get slide count: '${e.message}'";
      // });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Status: '),
              SizedBox(height: 20),
                // Container(
                //   margin: const EdgeInsets.only(right: 8.0),
                //   child: ElevatedButton(
                //     onPressed: () {PptControl.initialize();},
                //     child: Text('Initialize PowerPoint'),
                //   ),
                // ),

              ElevatedButton(
                onPressed: () async {
                  final result = await platform.invokeMethod('nextSlide');
                  print(result);
                },
                child: Text('Next Slide'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await platform.invokeMethod('previousSlide');
                  print(result);
                },
                child: Text('Previous Slide'),
              ),
              ElevatedButton(
                onPressed: _getSlideCount,
                child: Text('Get Slide Count'),
              ),
              if (_slideCount > 0)
                Text('Slide Count: $_slideCount'),
            ],
          ),
        ),

    );
  }
}
