
class TaskModel{

  late String taskId;
  late String taskName;
  late int dt;

  TaskModel({

    required this.taskId,
    required this.taskName,
    required this.dt,
   });


  static TaskModel fromMap(Map<String, dynamic> map){

   // return TaskModel(taskID: map['taskID'], taskName: map['taskName'], dt: map['dt']);

    return TaskModel(
      taskId: map['taskId']?.toString() ?? '',
      taskName: map['taskName']?.toString() ?? '',
      dt: map['dt'] ?? 0,
    );

  }

}