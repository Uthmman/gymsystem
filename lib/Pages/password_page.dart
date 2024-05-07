import 'package:flutter/material.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/widget/sl_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/sl_input.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  String? password;
  bool newPasswordRegistering = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordTc = TextEditingController();
  final _confirmPasswordTc = TextEditingController();
  final _previousPasswordTc = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPassword();
  }

  getPassword() {
    SharedPreferences.getInstance().then((pref) {
      password = pref.getString('password') ?? "12345678";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      // .symmetric(
      //   horizontal: MediaQuery.of(context).size.width / 3,
      //   vertical: 200,
      // ),
      child: Dialog(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    newPasswordRegistering
                        ? IconButton(
                            onPressed: () {
                              _passwordTc.text = "";
                              _confirmPasswordTc.text = "";
                              _previousPasswordTc.text = "";
                              setState(() {
                                newPasswordRegistering = false;
                              });
                            },
                            icon: const Icon(Icons.keyboard_backspace_outlined),
                          )
                        : const SizedBox(
                            width: 60,
                          ),
                    Text(
                      newPasswordRegistering
                          ? "Changing Password"
                          : "Password Confirmation",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 60,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                newPasswordRegistering
                    ? SLInput(
                        title: "Previous Password",
                        hint: "********",
                        keyboardType: TextInputType.text,
                        isObscure: true,
                        controller: _previousPasswordTc,
                        isOutlined: true,
                        inputColor: Colors.black,
                        otherColor: Colors.black26,
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 20,
                ),
                SLInput(
                  title: newPasswordRegistering ? "New Password" : "Password",
                  hint: "********",
                  keyboardType: TextInputType.text,
                  isObscure: true,
                  controller: _passwordTc,
                  isOutlined: true,
                  inputColor: Colors.black,
                  otherColor: Colors.black26,
                ),
                const SizedBox(
                  height: 20,
                ),
                newPasswordRegistering
                    ? SLInput(
                        title: "Password Confirmation",
                        hint: "********",
                        keyboardType: TextInputType.text,
                        isObscure: true,
                        controller: _confirmPasswordTc,
                        isOutlined: true,
                        inputColor: Colors.black,
                        otherColor: Colors.black26,
                      )
                    : const SizedBox(),
                newPasswordRegistering
                    ? const SizedBox(
                        height: 20,
                      )
                    : const SizedBox(),
                !newPasswordRegistering
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                newPasswordRegistering = true;
                              });
                            },
                            child: const Text("Change Password"),
                          ),
                        ),
                      )
                    : const SizedBox(),
                SLBtn(
                  text: newPasswordRegistering ? "Change Password" : "Continue",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      if (newPasswordRegistering) {
                        if (_passwordTc.text.length < 8) {
                          showToast(context, "Password less than 8 digits.",
                              redColor);
                        } else if (_previousPasswordTc.text != password) {
                          showToast(context, "Password incorrect.", redColor);
                        } else if (_passwordTc.text !=
                            _confirmPasswordTc.text) {
                          showToast(context, "Your Password did not match.",
                              redColor);
                        } else {
                          final pref = await SharedPreferences.getInstance();
                          await pref.setString(
                              'password', _confirmPasswordTc.text);
                          if (mounted) {
                            showToast(
                                context,
                                "Your Password changed successfully.",
                                redColor);
                            _passwordTc.text = "";
                            _confirmPasswordTc.text = "";
                            _previousPasswordTc.text = "";
                            setState(() {
                              newPasswordRegistering = false;
                            });
                          }
                        }
                      } else {
                        if (password == _passwordTc.text) {
                          Navigator.pop(context, true);
                        } else {
                          Navigator.pop(context, false);
                        }
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
