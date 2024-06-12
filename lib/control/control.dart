import 'package:flutter/material.dart';
import 'package:ppt_control/ppt_control.dart';

class ControlPage extends StatelessWidget {
  final String title;
  final String? data;

  const ControlPage({
    Key? key,
    required this.title,
    this.data, // Make eventId nullable
  }) : super(key: key);

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
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: () {PptControl.initialize();},
                    child: Text('Initialize PowerPoint'),
                  ),
                ),

              ElevatedButton(
                onPressed: () {
                  PptControl.nextSlide();
                },
                child: Text('Next Slide'),
              ),
              ElevatedButton(
                onPressed: () {
                  PptControl.previousSlide();
                },
                child: Text('Previous Slide'),
              ),
            ],
          ),
        ),

    );
  }
}
