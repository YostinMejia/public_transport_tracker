import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_transport_tracker/features/auth/bloc/auth/auth_bloc.dart';
import 'package:public_transport_tracker/features/auth/presentation/signup_screen.dart';
import 'package:public_transport_tracker/core/validators/validators.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is SignInError,
      listener: (context, state) {
        if (state is SignInError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Text("Login"),

              LoginForm(),

              TextButton.icon(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                    LogIn(email: "", password: "", isAnonymous: true),
                  );
                },
                label: Text("Sign in Anonymously"),
                icon: Icon(Icons.device_unknown),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text("Don't you have an account? Create one"),
              ),
            ],
          ),
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
                String? notEmpty = notNullOrEmpty(value);
                if (notEmpty != null) return notEmpty;
                String? email = emailValidator(value!);
                return email;
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
              validator: notNullOrEmpty,
            ),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  //TODO: handle when the user is not found
                  context.read<AuthBloc>().add(
                    LogIn(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
                  );
                }
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
