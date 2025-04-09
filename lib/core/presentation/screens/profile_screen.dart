import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String email;
  const ProfileScreen({super.key, required this.email});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: TextButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
            },
            child: Text("Sign out"),
          ),
        ),
      ],
    );
  }
}
