//lib\ui\views\signIN\sign_in_view.dart
import 'package:flutter/material.dart';
import 'package:noti_chat/ui/views/home/home_view.dart';
import 'package:noti_chat/ui/views/signIN/sign_in_view_model.dart';
import 'package:noti_chat/ui/views/signUp/sign_up_view.dart';
import 'package:provider/provider.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInViewModel>(
      builder: (context, vM, child) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    if (vM.errorMessage != null) ...[
                      SizedBox(
                        child: Text(
                          vM.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: vM.emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Your email Here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: vM.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Your Password Here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: .spaceEvenly,
                      children: [
                        Text('Not Registered? '),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpView(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'create Account',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        if (vM.emailController.text.isEmpty ||
                            vM.passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('email or password is not entered'),
                            ),
                          );
                          return;
                        }
                        await vM.signInUser(
                          vM.emailController.text,
                          vM.passwordController.text,
                        );
                        if (vM.errorMessage == null && !vM.isLoading) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomeView()),
                            (route) => false,
                          );
                          vM.emailController.clear();
                          vM.passwordController.clear();
                        }
                      },
                      child: vM.isLoading
                          ? CircularProgressIndicator()
                          : Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
