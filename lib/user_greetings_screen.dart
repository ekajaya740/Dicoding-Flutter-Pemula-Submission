import 'package:dicoding_submission/todo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserGreetings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserGreetings();
}

class _UserGreetings extends State<UserGreetings> {
  late SharedPreferences sharedPreferences;
  late String username;
  static const String usernameKey = 'username_data';
  late TextEditingController _usernameController = new TextEditingController();
  late final ButtonStyle _letsGoButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))));
  late final TextStyle _myTextFieldStyle =
      TextStyle(color: Colors.white, fontSize: 16);
  late final InputDecoration _myTextFieldInputDecoration = InputDecoration(
    hintText: 'Hello, What\'s Your Name?',
      hintStyle: TextStyle(
        color: Colors.grey
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.amber,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.all(8));

  void initState(){
    init();
    super.initState();
  }

  void init() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              controller: _usernameController,
              style: _myTextFieldStyle,
              decoration: _myTextFieldInputDecoration,
              textCapitalization: TextCapitalization.words,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
                width: double.infinity,
                child: ElevatedButton(
                  autofocus: true,
                  onPressed: () {
                    username = _usernameController.text.toString();
                    sharedPreferences.setString(usernameKey, username);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TodoScreen(
                        username: username,
                      );
                    }));
                  },
                  child: Text(
                    'Let\'s Go',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: _letsGoButtonStyle,
                ))
          ],
        )),
      ),
    );
  }
}
