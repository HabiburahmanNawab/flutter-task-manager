import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  var taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 40,),

            TextField(
              controller: taskController,
              decoration: InputDecoration(
                  hintText: 'Task Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),
SizedBox(height: 40,),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: ()async{

                        var taskName = taskController.text.trim();

                        if(taskName.isEmpty){
                          Fluttertoast.showToast(msg: 'Please add Task Name.', backgroundColor: Colors.red);
                        }

                        User? user = FirebaseAuth.instance.currentUser;

                        ProgressDialog proD = ProgressDialog(
                            context,
                            title: Text('Adding Task'),
                            message: Text('Please Wait'));

                        proD.show();


                        if(user != null){

                          String uid = user.uid;
                          int dt = DateTime.now().millisecondsSinceEpoch;

                          DatabaseReference taskRef = FirebaseDatabase.instance.ref().child('tasks').child(uid);

                          var taskId = taskRef.push().key;
                          
                          await taskRef.child(taskId!).set({

                            'taskName': taskName,
                            'dt': dt,
                            'taskId': taskId,

                          });

                         Fluttertoast.showToast(msg: "Saved",backgroundColor: Colors.green);

                        }else{
                         Fluttertoast.showToast(msg: 'Failed',backgroundColor: Colors.red);
                           }
                          proD.dismiss();
                          taskController.clear();


                      }, child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 20),),
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