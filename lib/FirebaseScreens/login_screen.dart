import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:testproject/FirebaseScreens/add_task_screen.dart';
import 'package:testproject/FirebaseScreens/signup_screen.dart';
import 'package:testproject/FirebaseScreens/task_list_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 40,),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),

            SizedBox(height: 20,),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: ()async{

                        var email = emailController.text.trim();
                        var password = passwordController.text.trim();

                        if(email.isEmpty){
                          Fluttertoast.showToast(msg: "Please Enter Your Email!",backgroundColor: Colors.deepPurple);
                          return;
                        }else if(password.isEmpty){
                          Fluttertoast.showToast(msg: "Please Enter Your Password!",backgroundColor: Colors.deepPurple);
                          return;
                        }

                        // Request to Firebase Auth........................

                        ProgressDialog pro = ProgressDialog(
                            context,
                            title: Text('Logging In'),
                            message: Text('Please Wait!'));
                        pro.show();

                        try{

                          FirebaseAuth auth = FirebaseAuth.instance;
                          UserCredential cred = await auth.signInWithEmailAndPassword(email: email, password: password);

                          if(cred.user != null){

                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){

                              return TaskListScreen();
                            }));

                          }
                        }
                        on FirebaseAuthException catch(e){

                          pro.dismiss();
                          if(e.code == 'user-not-found'){
                            Fluttertoast.showToast(msg: 'User Not found',backgroundColor: Colors.red);

                          }else if(e.code == 'wrong-password'){
                            Fluttertoast.showToast(msg: 'Incorrect password',backgroundColor: Colors.red);

                          }
                        }
                        catch(e){
                          Fluttertoast.showToast(msg: 'Something went wrong',backgroundColor: Colors.red);
                        }


                      }, child: Text('Log In', style: TextStyle(color: Colors.white, fontSize: 20),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      )
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 80.0, top: 30.0),
              child: Row(
                children: [
                  SizedBox(height: 40,),
                  Text('Not Registered Yet!'),
                  TextButton(onPressed: (){

                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return SignUpScreen();
                    }));

                  }, child: Text('Register Now')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}