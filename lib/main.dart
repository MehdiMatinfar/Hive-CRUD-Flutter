import 'dart:math';

import 'package:animationflutter/Adapter_/student.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
   Hive.registerAdapter(StudentAdapter());

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box box1;
String name="";
String field="";
late int id;
  final _formKey = GlobalKey<FormState>();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBox();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [

          TextFormField(validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },decoration: const InputDecoration(
              hintText: 'Add Name '
          ),
              onChanged: (value){
                setState(() {
                  name=value;
                });
              }),
          TextFormField(validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },decoration: const InputDecoration(
              hintText: 'Add Field '
          ),
              onChanged: (value){
                setState(() {
                  field=value;
                });
              })
        ,  ElevatedButton(
            onPressed: () async{
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                Box<Student> box=await Hive.openBox<Student>('todos');
                box.add(Student(Random.secure().nextInt(100),name, field));
                Navigator.push(context,MaterialPageRoute(builder: (context) => ShowData(),) );

              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            child: const Text('Submit'),
          )],),
      ),
    );
  }

  void createBox() async {
    box1 = await Hive.openBox("database");
  }
}
class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Todo Items'),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Student>('todos').listenable(),
          builder: (context, Box<Student> box, widget) {
            if (box.values.isEmpty) {
              print("Gooooz");

              return const Center(
                child: Text("No data available"),
              );
            }
            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Student? obj = box.getAt(index);
                return ListTile(
                  title: Text(obj!.name),
                  subtitle: Text(obj.field),
                  onLongPress: () {
                    box.deleteAt(index).then((value) => print("Item deleted"));
                  },
                );
              },
            );
          }),

    );
  }
}
