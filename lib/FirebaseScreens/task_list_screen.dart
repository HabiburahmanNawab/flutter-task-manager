import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testproject/FirebaseScreens/add_task_screen.dart';
import 'package:testproject/FirebaseScreens/login_screen.dart';
import 'package:testproject/FirebaseScreens/update_task_screen.dart';
import 'package:testproject/FirebaseScreens/user_profile_screen.dart';
import 'package:testproject/Models/tasklist_model.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {


  User? user;
  DatabaseReference? taskRef;

  @override
  void initState() {

    user = FirebaseAuth.instance.currentUser;
    if(user != null){
      taskRef = FirebaseDatabase.instance.ref().child('tasks').child(user!.uid);

    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,

        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return UserProfileScreen();
            }));
          }, icon: Icon(Icons.person,color: Colors.white,)),

          IconButton(onPressed: (){

            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text('Confirmation!'),
                content: Text('Are You Sure to Log Out?'),
                actions: [
                  TextButton(onPressed: (){

                    Navigator.of(context).pop();

                  }, child: Text('NO')),

                  TextButton(onPressed: (){
                    Navigator.of(context).pop();

                    FirebaseAuth.instance.signOut();

                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return LogInScreen();
                    }));


                  }, child: Text('Yes')),

                ],
              );
            });

          }, icon: Icon(Icons.logout,color: Colors.white,)),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return AddTaskScreen();
          }));
        },
        child: Icon(Icons.add,color: Colors.white,),backgroundColor: Colors.deepPurple,),


      body: StreamBuilder<DatabaseEvent>(
        stream: taskRef?.onValue,
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          DatabaseEvent event = snapshot.data!;

          final data = event.snapshot.value;

          if (data == null) {
            return const Center(
              child: Text('No Tasks Added Yet'),
            );
          }

          Map<dynamic, dynamic> showMap =
          data as Map<dynamic, dynamic>;

          List<TaskModel> tasks = [];

          for (var taskMap in showMap.values) {
            tasks.add(
              TaskModel.fromMap(
                Map<String, dynamic>.from(taskMap),
              ),
            );
          }

          return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index){

                TaskModel task = tasks[index];

                return Container(
                  padding: EdgeInsets.all(8.0),

                  child: Card(
                    child: ListTile(
                      leading: IconButton(onPressed: (){

                        showDialog(context: context, builder: (ctx){

                          return AlertDialog(
                            title: Text('Confirmation!'),
                            content: Text('Are you Sure to Delete?'),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.of(ctx).pop();
                              }, child: Text('No')),

                              TextButton(onPressed: ()async{

                                if(taskRef != null){

                                  await taskRef!.child(task.taskId).remove();
                                }

                                Navigator.of(ctx).pop();

                              }, child: Text('Yes')),
                            ],
                          );
                        });

                      }, icon: Icon(Icons.delete)),

                      title: Text(task.taskName, style: TextStyle(fontSize: 18, color: Colors.deepPurple),),
                      subtitle: Text(getHumanReadableDate(task.dt), style: TextStyle(color: Colors.deepPurple),),
                      trailing: Column(
                       children: [

                         IconButton(onPressed: (){

                           Navigator.of(context).push(MaterialPageRoute(builder: (context){

                             return UpdateTaskScreen(task: task);
                           }));
                         }, icon: Icon(Icons.edit)),

                       ],
                      ),

                    ),
                  )
                );

          });


        },
      ),

     );

  }

  String getHumanReadableDate (int dt){

    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(dt);

    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
