import 'dart:async';
import 'package:dicoding_submission/user_greetings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SplashScreen();

}

class _SplashScreen extends State<SplashScreen>{

  void initState(){
    super.initState();
    splashScreen();

  }

  splashScreen() async{
    return Timer(Duration(milliseconds: 3000), (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserGreetings()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SvgPicture.asset('assets/logo.svg', semanticsLabel: 'Logo',),
        ),
      ),
    );
  }

}