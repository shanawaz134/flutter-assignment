import 'package:flutter/material.dart';

import 'package:flutter_assignment/add_task.dart';
import 'package:flutter_assignment/provider/firesbase_prodvider.dart';
import 'package:flutter_assignment/services/firebase_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_assignment/model/task_model.dart';

TaskModel? task;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            coverContainer()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Increment',
        child: const Icon(Icons.add_outlined, size: 40,),
      ),
    );
  }

  void _addTask() {
    task = null;
    Navigator.pushNamed(context, '/add_task');
  }

  coverContainer(){
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/image.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                margin: const EdgeInsets.only(top: 65),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: const Icon(Icons.menu_rounded, color: Colors.white, size: 40,)),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: appText(text: 'Your\nThings', size: 48, color: Colors.white, fontWeight: FontWeight.w300))),
                    Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: appText(text: 'sep 5, 2015', size: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 5,
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.black12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 80,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                size: 20,
                                text: '24'
                            ),
                            appText(
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                                size: 13,
                                text: 'Personal'
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                size: 20,
                                text: '15'
                            ),
                            appText(
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                                size: 13,
                                text: 'Business'
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          value: 0.65,
                          strokeWidth: 5,
                          backgroundColor: Colors.blueGrey,
                          semanticsLabel: 'Circular progress indicator',
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        const SizedBox(width: 10,),
                        appText(
                            text: '65% Done',
                            size: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.57,
            margin: const EdgeInsets.all(10),
            child: Consumer<FirebaseProvider>(
              builder: (context, data, child){
                return FutureBuilder<List<TaskModel>>(
                    future: data.fetchData(),
                    builder: (context, snapshot){
                      if (snapshot.hasData) {
                        final documents = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 10, bottom: 8),
                              child: const Text('Inbox',
                                  style: TextStyle(
                                      fontSize: 20
                                  )
                              ),
                            ),
                            Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    final document = documents[index];
                                    // Display document data here
                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blueAccent
                                            ),
                                              child: const Icon(Icons.image)
                                          ),
                                          title: Text(document.task.toString(),
                                            style: const TextStyle(
                                              fontSize: 20
                                            ),),
                                          subtitle: Text(document.description.toString(),
                                              style: const TextStyle(
                                                  fontSize: 16
                                              )
                                          ),
                                          trailing: Text(document.date.toString(),
                                              style: const TextStyle(
                                                  fontSize: 16
                                              )
                                          ),
                                          onLongPress: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: SizedBox(
                                                    height: 200,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            IconButton(
                                                              onPressed: (){
                                                                Navigator.pop(context);
                                                              },
                                                              icon: const Icon(Icons.close),

                                                            ),
                                                          ]
                                                        ),
                                                        ListTile(
                                                          contentPadding: EdgeInsets.all(0),
                                                          title: const Text('Edit Task'),
                                                          onTap: (){
                                                            task = document;
                                                            Navigator.pop(context);
                                                            Navigator.pushNamed(context, '/add_task');
                                                          },
                                                        ),
                                                        ListTile(
                                                          contentPadding: EdgeInsets.all(0),
                                                          title: const Text('Delete Task'),
                                                          onTap: (){
                                                            FirebaseServices().deleteData(document.id.toString());
                                                            Navigator.pop(context);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );

                                          },
                                        ),
                                        const Divider(height: 2,)
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }
                );
              },
            ),
          ),
        )
      ],
    );
  }




  Widget appText({String? text, double? size, FontWeight? fontWeight, Color? color}){
    return Text(
      text!,
      style: TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          color: color
      ),
    );
  }
}
