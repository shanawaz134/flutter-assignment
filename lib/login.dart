import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/components/constants.dart';
import 'package:flutter_assignment/services/firebase_service.dart';

User? user;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool isLogin = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        key: _scaffoldKey,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.lightBlueAccent,
                Colors.lightBlue,
                AppColor.color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Center(
                    child: Text(isLogin ? 'Login' : 'Register',
                        style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500
                    )
                    )
                )
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                controller: emailController,
                style: const TextStyle(
                    fontSize: 18
                ),
                decoration: const InputDecoration(
                  labelText: 'Email',
                    labelStyle: TextStyle(
                        color: Colors.white
                    )
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                controller: passController,
                style: const TextStyle(
                    fontSize: 18
                ),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.white
                  )
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async{
                    UserCredential? userCredential;
                    if(emailController.text.isNotEmpty && passController.text.isNotEmpty){
                      if(isLogin){
                        userCredential = await FirebaseServices().signInWithEmail(email, password);
                      }else{
                        userCredential = await FirebaseServices().createUserWithEmailAndPassword(email, password);
                      }
                      if(userCredential != null){
                        if(isLogin){
                          user = userCredential.user;
                          Navigator.pushNamed(context, '/main_screen');
                        }else{
                          showInSnackBar(context, 'User created successfully');
                          Future.delayed(const Duration(seconds: 1),(){
                            setState(() {
                              isLogin = true;
                              emailController.clear();
                              passController.clear();
                            });
                          });
                        }
                      }else{
                        if(errorText.isNotEmpty){
                          showInSnackBar(context, errorText);
                        }
                      }
                    }else{
                      showInSnackBar(context, 'Please Enter username and password');
                    }
                  },
                  child:  Text(isLogin ? 'Login' : 'Register',
                    style: const TextStyle(
                      fontSize: 18
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: isLogin ?
                Row(
                  children: [
                    const Text('Don\'t have an account? ',
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          isLogin = false;
                          emailController.clear();
                          passController.clear();
                        });
                      },
                      child: const Text('Register',
                        style: TextStyle(
                            fontSize: 18,
                          // color: Colors.white
                        ),
                      ),
                    )
                  ],
                ):
                Row(
                  children: [
                    const Text('Already have an account? ',
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          isLogin = true;
                          emailController.clear();
                          passController.clear();
                        });
                      },
                      child: const Text('Login',
                        style: TextStyle(
                            fontSize: 18,
                            // color: Colors.white
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showInSnackBar(BuildContext context, String value) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(value),
  ));
}
