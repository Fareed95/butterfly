import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/config/palette.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../widgets/custom_bar.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/register_button.dart';
import '../widgets/bottom_nav.dart';
import 'browse_events.dart';
import 'eventpg.dart';
import 'screen_type.dart';

class DisplayEvents extends StatefulWidget {
  // takes a paramter to customize the page name
  // final String pageName;
  final ScreenType screen;
  const DisplayEvents({Key? key, required this.screen}) : super(key: key);

  @override
  _DisplayEventsState createState() => _DisplayEventsState();
}

class _DisplayEventsState extends State<DisplayEvents> {
  @override
  Widget build(BuildContext context) {
    final String getAllEvents = """
        query getAllEvents {
          allEvents {
            id
            name
            date  
            tag
            organizer
            location
          }
        }
      """;

    // render each event as a card
    return Scaffold(
      // endDrawer: NavDrawer(),
      appBar: CustomBar(widget.screen, false), //display a custom title
      body: ListView(
        padding: EdgeInsets.fromLTRB(
            2, 5, 2, 5), //add padding to outside of the cards
        children: <Widget>[
          Query(
            options: QueryOptions(
              documentNode: gql(getAllEvents),
              fetchPolicy: FetchPolicy.networkOnly,
            ),
            builder: (QueryResult? result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              final events = result!.data['allEvents'];

              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  final event = events[index];
                  // return ListTile(
                  //   title: Text(event['name']),
                  //   // subtitle: Text(event['description']),
                  // );
                  return buildEventCard(event);
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        screen: widget.screen,
      ),
    );
  }

  //TODO: Based on param, determine type of request to make to the backend

  Widget buildEventCard(event) => Card(
      // make corners rounded
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      // add drop shadow
      shadowColor: Colors.grey.withOpacity(0.5),
      color: Palette.secondary_background,
      elevation: 5,
      margin: EdgeInsets.all(12),
      child: InkWell(
          // wrap in gesture detector to make card clickable
          onTap: _cardTapped,
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
                padding: EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCardLeft(
                        eventName: event['name'],
                        location: event['location'],
                        time: event['date'],
                        description: 'Celebrating Martha\'s 75th birthday'),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: buildCardRight(
                        month: event['date'].substring(5, 7),
                        day: event['date'].substring(8, 10),
                      ),
                    )
                  ],
                )),
          )));

  // card text in left col
  Widget buildCardLeft(
      {required String eventName,
      required String location,
      required String time,
      required String description}) {
    print(eventName);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, //left-aligned
        children: [
          Container(
              child: Text(
            eventName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )),
          Container(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text(location,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic))),
          Container(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: Text(time,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic))),
          Container(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(description,
                  style: TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis))
        ]);
  }

  // date and registration button in card's right col
  Widget buildCardRight({required String month, required String day}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, //left-aligned
        children: [
          Container(
              child: Text(
            month,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          )),
          Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(day,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
          RegisterButton()
        ]);
  }

  void _cardTapped() {
    print('card tapped');
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EventPg()));
  }
}
