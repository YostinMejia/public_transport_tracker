import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_transport_tracker/domain/models/bus_model.dart';
import 'package:public_transport_tracker/presentation/bloc/auth/auth_bloc.dart';
import 'package:public_transport_tracker/presentation/bloc/bus/bus_bloc.dart';
import 'package:public_transport_tracker/presentation/validators/validators.dart';

class BusSignUp extends StatefulWidget {
  const BusSignUp({super.key});

  @override
  State<BusSignUp> createState() => _BusSignUpFormState();
}

class _BusSignUpFormState extends State<BusSignUp> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: BusForm());
  }
}

class BusForm extends StatefulWidget {
  const BusForm({super.key});

  @override
  State<BusForm> createState() => _BusFormState();
}

class _BusFormState extends State<BusForm> {
  final List<Map<String, dynamic>> stopsControllers = [];
  List<Widget> stopsFormsWidgets = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignUpCorrectly) {
          context.read<BusBloc>().add(
            CreateBus(
              busSignUpDTO: BusSignUpDTO(
                email: emailController.text,
                password: passwordController.text,
                stops:
                    stopsControllers
                        .map(
                          (stop) => {
                            "id": stop["id"],
                            "address": stop["address"].text,
                            "position": {
                              "latitude": double.parse(stop["latitude"].text),
                              "longitude": double.parse(stop["longitude"].text),
                            },
                          },
                        )
                        .toList(),
              ),
              authId: state.userCredential.user!.uid,
            ),
          );

          Navigator.pop(context);
        } else if (state is SignUpError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
        }
      },
      child: Form(
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
                decoration: InputDecoration(
                  label: Text("Confirm the password"),
                ),
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
              SizedBox(height: 30),
              Text("Add a bus stop"),
              Expanded(child: ListView(children: stopsFormsWidgets)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        stopsControllers.add({
                          "id": stopsFormsWidgets.length,
                          "address": TextEditingController(),
                          "latitude": TextEditingController(),
                          "longitude": TextEditingController(),
                        });

                        StopForm newStop = StopForm(
                          id: stopsFormsWidgets.length,
                          addressController: stopsControllers.last["address"],
                          latitudeController: stopsControllers.last["latitude"],
                          longitudeController:
                              stopsControllers.last["longitude"],
                        );

                        stopsFormsWidgets = List.from(stopsFormsWidgets);
                        stopsFormsWidgets.add(newStop);
                      });
                    },
                    icon: Icon(Icons.plus_one),
                  ),

                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (stopsFormsWidgets.isNotEmpty) {
                          stopsControllers.removeAt(
                            stopsControllers.length - 1,
                          );
                          stopsFormsWidgets = List.from(stopsFormsWidgets);
                          stopsFormsWidgets.removeAt(
                            stopsFormsWidgets.length - 1,
                          );
                        }
                      });
                    },
                    icon: Icon(Icons.exposure_minus_1),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () async {
                  //Validates and verify all the form fields
                  if (_formKey.currentState!.validate()) {
                    BusSignUpDTO busSignUpDTO = BusSignUpDTO(
                      email: emailController.text,
                      password: passwordController.text,
                      stops:
                          stopsControllers
                              .map(
                                (stop) => {
                                  "id": stop["id"],
                                  "address": stop["address"].text,
                                  "position": {
                                    "latitude": double.parse(
                                      stop["latitude"].text,
                                    ),
                                    "longitude": double.parse(
                                      stop["longitude"].text,
                                    ),
                                  },
                                },
                              )
                              .toList(),
                    );
                    context.read<AuthBloc>().add(SignUpBus(bus: busSignUpDTO));
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StopForm extends StatelessWidget {
  final int id;
  final TextEditingController addressController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  const StopForm({
    super.key,
    required this.id,
    required this.addressController,
    required this.latitudeController,
    required this.longitudeController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("${id + 1}"),
          TextFormField(
            controller: addressController,
            validator: notNullOrEmpty,
            decoration: InputDecoration(label: Text("Stop Address")),
          ),
          TextFormField(
            controller: latitudeController,
            decoration: InputDecoration(label: Text("Latitude")),
            validator: notNullOrEmpty,
          ),
          TextFormField(
            controller: longitudeController,
            decoration: InputDecoration(label: Text("Longitude")),
            validator: notNullOrEmpty,
          ),
        ],
      ),
    );
  }
}
