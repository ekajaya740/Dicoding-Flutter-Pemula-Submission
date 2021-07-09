import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GreetingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GreetingScreen();
}

class _GreetingScreen extends State<GreetingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 98,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Stack(children: [
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.add_a_photo),
                            splashRadius: 30,
                            splashColor: Colors.black,
                            iconSize: 24,
                          )),
                    ]),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hello, ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Flexible(
                          child: Container(
                              margin: const EdgeInsets.only(left: 4),
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: 'Your Name',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.amber))),
                              )))
                    ],
                  ))
            ],
          )),
    ));
  }
}
