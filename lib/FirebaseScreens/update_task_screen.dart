import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testproject/Models/tasklist_model.dart';

class UpdateTaskScreen extends StatefulWidget {

  final TaskModel task;

  const UpdateTaskScreen({super.key, required this.task});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {

     var updateNameController = TextEditingController();

     @override
  void initState() {
    updateNameController.text = widget.task.taskName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Task',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 40,),

            TextField(
              controller: updateNameController,
              decoration: InputDecoration(
                  hintText: 'Update Task',
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

                        var updateTask = updateNameController.text.trim();
                        
                        if(updateTask.isEmpty){
                          Fluttertoast.showToast(msg: 'Please, add the updated Task Name!',backgroundColor: Colors.red);
                          return;
                        }

                        User? user = FirebaseAuth.instance.currentUser;
                        
                        if(user != null){
                          
                          DatabaseReference updateRef = FirebaseDatabase.instance
                              .ref().child('tasks')
                              .child(user!.uid)
                              .child(widget.task.taskId);

                         await  updateRef.update({'taskName': updateTask});
                        }
                        Fluttertoast.showToast(msg: 'Record Updated Successfully!',backgroundColor: Colors.deepPurple);
                        Navigator.of(context).pop();


                      }, child: Text('Update', style: TextStyle(color: Colors.white, fontSize: 20),),
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