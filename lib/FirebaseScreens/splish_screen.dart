import 'package:flutter/material.dart';
import 'package:testproject/FirebaseScreens/login_screen.dart';

class SplishScreen extends StatefulWidget {
  const SplishScreen({super.key});

  @override
  State<SplishScreen> createState() => _SplishScreenState();
}

class _SplishScreenState extends State<SplishScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splish Screen', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 200,),
            SizedBox(height: 20,),

            Row(
              children: [
                Expanded(child:
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(onPressed: (){

                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){

                      return LogInScreen();
                    }));

                  }, child: Text('Enter', style: TextStyle(fontSize: 20),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,

                    ),
                  ),
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
