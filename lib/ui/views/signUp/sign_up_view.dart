import 'package:flutter/material.dart';
import 'package:noti_chat/ui/views/home/home_view.dart';
import 'package:noti_chat/ui/views/signIN/sign_in_view.dart';
import 'package:noti_chat/ui/views/signUp/sign_up_view_model.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(
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
                      'Sign Up',
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
                        Text('Already Have An Account'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInView(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Sign In',
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
                        await vM.signUpUser(
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
                          : Text('Sign Up'),
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
