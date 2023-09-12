import 'package:assignment/functions/authFunctions.dart';
import 'package:assignment/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final _formKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Login'),
      ),
      body: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (authController) {
            return ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ======== Email ========
                        TextFormField(
                          // key: ValueKey('email'),
                          decoration: InputDecoration(hintText: 'Enter Email'),
                          validator: Validators.emailValidator,
                          onChanged: (value) {
                            authController.email.value = value!;
                          },
                        ),

                        // ======== Password ========
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                          ),
                          validator: Validators.passwordValidator,
                          onSaved: (value) {
                            authController.password.value = value.toString();
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 55,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  authController.signinUser(context)
                                     ;
                                }
                              },
                              child: Text('Login')),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              authController
                                  .loginUpdate(!authController.login.value);
                            },
                            child: Text("Don't have an account? Signup"))
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
