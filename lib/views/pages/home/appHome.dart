import 'dart:async';

import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:iti_community_flutter/services/auth/Authentication.dart';
import 'package:iti_community_flutter/views/pages/Settings/Settings.dart';
import 'package:iti_community_flutter/views/pages/profile/profile.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    final userDetails = authServices.storage.getItem("userDetails");

    if (userDetails == null) {
      authServices.logout();
    }

    return Scaffold(
      body: Container(
        color: HexColor("801818"),
        child: SafeArea(
          child: Container(
            color: HexColor("e4e1e1"),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: 58,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Profile(AuthServices.userID)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userDetails["avatar"]),
                                    radius: 30.0,
                                  ),
                                ),
                              ),
                              InkWell(
                                child: SizedBox(
                                  width: 65,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DecoratedBox(
                                        child: Center(
                                            child: Text("+",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20))),
                                        decoration: BoxDecoration(
                                          color: HexColor("e4e1e1"),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        )),
                                  ),
                                ),
                                onTap: () {
                                  print(authServices.user);
                                },
                              ),
                              InkWell(
                                  child: Icon(Icons.settings),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Settings(),
                                        ));
                                  })
                            ],
                          ),
                        ),
                      )),
                  SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
