import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:firebase_database/firebase_database.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 40,),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                  hintText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),

            SizedBox(height: 15,),
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

            SizedBox(height: 15,),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Confirm Password',
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
                      onPressed: () async{
                        var fullName = fullNameController.text.trim();
                        var email = emailController.text.trim();
                        var password = passwordController.text.trim();
                        var confirmPass = confirmController.text.trim();

                        if(fullName.isEmpty){
                          Fluttertoast.showToast(msg: "Please Enter your Name", backgroundColor: Colors.deepPurple);
                          return;
                        }else if(email.isEmpty){
                          Fluttertoast.showToast(msg: "Please Enter your Email", backgroundColor: Colors.deepPurple);
                          return;
                        }else if(password.isEmpty){
                          Fluttertoast.showToast(msg: "Please Enter your Password", backgroundColor: Colors.deepPurple);
                          return;
                        }else if(confirmPass.isEmpty){
                          Fluttertoast.showToast(msg: "Please Enter Confirm Password", backgroundColor: Colors.deepPurple);
                          return;
                        }

                        if(password.length < 6){
                          Fluttertoast.showToast(msg: "Week Password, Password Mush be greater then Six digit", backgroundColor: Colors.deepPurple);
                          return;
                        }

                        if(password != confirmPass){
                          Fluttertoast.showToast(msg: "Your Password and Confirm Password Not Matched", backgroundColor: Colors.deepPurple);
                          return;
                        }

                        // Request to Firebase Auth............

                        ProgressDialog progressD = ProgressDialog(
                            context,
                            title: Text('Signing Up'),
                            message: Text('Please Wait')
                        );

                        progressD.show();


                       try{

                         FirebaseAuth auth = FirebaseAuth.instance;
                         UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

                         if(userCredential.user != null){

                           // Store User Information on Firebase Realtime Database

                           DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users');

                           String uid = userCredential.user!.uid;
                           int dt = DateTime.now().millisecondsSinceEpoch;

                           await userRef.child(uid).set({
                             'fullName': fullName,
                             'email': email,
                             'uid': uid,
                             'dt': dt,

                           });




                           Fluttertoast.showToast(msg: "Success",backgroundColor: Colors.orange);

                           Navigator.of(context).pop();

                         }else{
                           Fluttertoast.showToast(msg: 'Failed',backgroundColor: Colors.orange);
                         }

                         progressD.dismiss();

                       }
                        on FirebaseAuthException catch(e){

                         progressD.dismiss();
                          if(e.code == 'email-already-in-use'){
                            Fluttertoast.showToast(msg: 'Email is Already in Use',backgroundColor: Colors.red);
                          }else if(e.code == 'weak-password'){
                            Fluttertoast.showToast(msg: 'Password is Week',backgroundColor: Colors.red);
                          }
                        }
                        catch(e){
                        //  progressD.dismiss();
                       //   Fluttertoast.showToast(msg: 'Something went wrong.',backgroundColor: Colors.red);
                          progressD.dismiss();

                          print("ERROR: $e");

                          Fluttertoast.showToast(
                            msg: e.toString(),
                            backgroundColor: Colors.red,
                            toastLength: Toast.LENGTH_LONG,
                          );
                        }


                      }, child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 20),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}