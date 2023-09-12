import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../functions/authFunctions.dart';
import '../validators.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final _formKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Signup'),
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
                        // ======== Full Name ========
                        TextFormField(
                          key: ValueKey('fullname'),
                          decoration: InputDecoration(
                            hintText: 'Enter Full Name',
                          ),
                          validator: Validators.nameValidator,
                          onSaved: (value) {
                            authController.fullname.value = value.toString();
                          },
                        ),
                        // ======== Email ========
                        TextFormField(
                          // key: ValueKey('email'),
                          decoration: InputDecoration(hintText: 'Enter Email'),
                          validator: Validators.emailValidator,
                          onChanged: (value) {
                            authController.email.value = value!;
                          },
                        ),
                        // ======== Phone ========
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Enter Phone'),
                          validator: Validators.phoneValidator,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            authController.phone.value = value.toString();
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: authController.gender.value,
                          hint: Text('Salutation'),
                          onChanged: (salutation) => authController
                              .gender.value = salutation.toString(),
                          validator: (value) =>
                              value == authController.genderList[0]
                                  ? 'Select you gender'
                                  : null,
                          items: authController.genderList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),

                        // ======== Password ========
                        Obx(
                          () => TextFormField(
                            obscureText: authController.isObservable.value,
                            decoration: InputDecoration(
                                hintText: 'Enter Password',
                                suffixIcon: IconButton(
                                  icon: Icon(authController.isObservable.value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    authController.isObservable(
                                        authController.isObservable.value ==
                                                true
                                            ? false
                                            : true);
                                  },
                                )),
                            validator: Validators.passwordValidator,
                            onChanged: (value) {
                              authController.password.value = value.toString();
                            },
                          ),
                        ),

                        // ======== Confirm Password ========
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm Enter Password',
                          ),
                          validator: (password) {
                            if (password!.isEmpty) {
                              return "Enter confirm password";
                            } else if (password !=
                                authController.password.value) {
                              return "Password must be same";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            authController.cnfPassword.value = value.toString();
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
                                  authController.signupUser(context);
                                }
                              },
                              child: Text('Signup')),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              authController
                                  .loginUpdate(!authController.login.value);
                            },
                            child: Text("Already have an account? Login"))
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
