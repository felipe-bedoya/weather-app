import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  final Function() toCities;
  final Function() toSearch;
  final Function() toWeather;
  final Function() toLogin;
  NavDrawer({this.toCities, this.toSearch, this.toWeather, this.toLogin});

  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Text(
                'The Weather App',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: ShapeDecoration(
                  color: Colors.blue, shape: Border.all(color: Colors.blue))),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text('Cities'),
            onTap: () {
              toCities();
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () {
              toSearch();
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud_queue),
            title: Text('My Weathers'),
            onTap: () {
              toWeather();
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
