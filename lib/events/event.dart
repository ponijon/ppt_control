import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// import 'package:ppt_control/control/control.dart';
import 'package:ppt_control/control/control.dart';

class EventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        automaticallyImplyLeading: false,
      ),
      body: ListViewEvents(),
    );
  }
}

class ListViewEvents extends StatefulWidget {
  @override
  _ListViewEventsState createState() => _ListViewEventsState();
}

class _ListViewEventsState extends State<ListViewEvents> {
  List<Map<String, dynamic>> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final response = await http.get(
        Uri.parse('https://blue.ucasty.com/events'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          if (data.isNotEmpty) {
            events = data
                .map((event) => {
                      'title': event['name'],
                      'subtitle': event['_id'],
                      'id': event['_id'],
                    })
                .toList();
          }
          isLoading = false;
        });
      } else {
        showAlertDialog();
      }
    } catch (e) {
      showAlertDialog();
    }
  }

  void showAlertDialog() {
    setState(() {
      isLoading = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              'Failed to load events. Please check your internet connection.'),
          actions: <Widget>[
            TextButton(
              child: Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                });
                fetchEvents();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: ListTile(
            title: Text(events[index]['title']),
            subtitle: Text(events[index]['subtitle']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ControlPage(
                      title: events[index]['title'],
                      data: events[index]['url'],
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
