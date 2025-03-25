import 'package:flutter/material.dart';
import 'package:public_transport_tracker/presentation/widgets/bus_signup_form.dart';
import 'package:public_transport_tracker/presentation/widgets/user_signup_form.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _userSignUp = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Switch(
              thumbIcon: WidgetStateProperty<Icon>.fromMap(
                <WidgetStatesConstraint, Icon>{
                  WidgetState.selected: Icon(Icons.person),
                  WidgetState.any: Icon(Icons.bus_alert),
                },
              ),
              activeColor: Colors.green,

              value: _userSignUp,
              onChanged: (value) {
                setState(() {
                  _userSignUp = value;
                });
              },
            ),
            _userSignUp ? UserSignUp() : BusSignUp(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Do you already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
