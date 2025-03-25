
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_transport_tracker/domain/models/user_model.dart';
import 'package:public_transport_tracker/presentation/bloc/auth/auth_bloc.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpFormState();
}

class _UserSignUpFormState extends State<UserSignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(label: Text("Name")),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(label: Text("Email")),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(label: Text("Password")),
            ),
            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(label: Text("Confirm the password")),
            ),
        
            ElevatedButton(
              onPressed: () {
                //Validates and verify all the form fields
                if (_formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                    SignUpUser(
                      user: UserSignUpDTO(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    ),
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}