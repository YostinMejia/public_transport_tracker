import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_transport_tracker/presentation/bloc/auth/auth_bloc.dart';
import 'package:public_transport_tracker/presentation/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text("Login"),

            TextButton.icon(onPressed: ()async{
              await context.read<AuthBloc>().signInAnonymously();
            }, label: Text("Sign in Anonymously"), icon: Icon(Icons.device_unknown),),
      
            LoginForm(),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => SignupScreen()));
              },
              child: Text("Don't you have an account? Create one"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter your email",
                border: OutlineInputBorder(),
                label: Text("Email", style: TextStyle(fontSize: 30)),
              ),
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter your password",
                border: OutlineInputBorder(),
                label: Text("Password", style: TextStyle(fontSize: 30)),
              ),
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            ElevatedButton(
              onPressed: () {
                _formKey.currentState!.validate();
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
