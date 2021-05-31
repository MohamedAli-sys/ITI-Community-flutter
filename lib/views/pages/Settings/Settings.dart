import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iti_community_flutter/app_localizations.dart';
import 'package:iti_community_flutter/main.dart';
import 'package:iti_community_flutter/services/auth/Authentication.dart';
import 'package:provider/provider.dart';

class settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    final userDetails = authServices.storage.getItem("userDetails");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("801818"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: InkWell(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),
                  ),
                  onTap: () {
                    authServices.logout();
                    // print(belal.fb);
                    // var s = AuthServices.store.getItem('uid');
                    // print(s);
                    // var s = AuthServices.userID;
                    // print(s);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: InkWell(
                  child: Text(
                    'get data',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),
                  ),
                  onTap: () {
                    // belal.logout();
                    // print(belal.userDetails);
                    print(userDetails);
                    // var s = AuthServices.store.getItem('uid');
                    // print(s);
                    // var s = AuthServices.userID;
                    // print(s);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
