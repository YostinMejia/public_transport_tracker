import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_transport_tracker/domain/models/user_model.dart';
import 'package:public_transport_tracker/presentation/bloc/auth/auth_bloc.dart';
import 'package:public_transport_tracker/presentation/validators/validators.dart';

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
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
              validator: notNullOrEmpty,
              decoration: InputDecoration(label: Text("Name")),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(label: Text("Email")),
              validator: (value) {
                String? notEmpty = notNullOrEmpty(value);
                if (notEmpty != null) return notEmpty;
                String? email = emailValidator(value!);
                return email;
              },
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(label: Text("Password")),
              validator: (value) {
                String? notEmpty = notNullOrEmpty(value);
                if (notEmpty != null) return notEmpty;
                String? password = passwordValidator(value!);
                return password;
              },
            ),
            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(label: Text("Confirm the password")),
              validator: (value) {
                String? notEmpty = notNullOrEmpty(value);
                if (notEmpty != null) return notEmpty;
                String? confirmPassword = confirmPasswordValidator(
                  passwordController.text,
                  value!,
                );
                return confirmPassword;
              },
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
                  Navigator.pop(context);
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
