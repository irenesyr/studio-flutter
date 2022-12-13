import 'package:flutter/material.dart';
import 'menu_data.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // Application name
//       title: 'Studio - Flutter',
//       // Application theme data, you can set the colors for the application as
//       // you want
//       theme: ThemeData(
//         primarySwatch: Colors.brown,
//       ),
//       // A widget which will be started on application startup
//       home: MyHomePage(title: 'Studio - Flutter'),
//     );
//   }
// }

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // The title text which will be shown on the action bar
          title: Text(title),
        ),
        body: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) => MenuItem(
                name: menuItems[index]["name"] ?? "",
                description: menuItems[index]["description"] ?? "",
                imageUrl: menuItems[index]["imageUrl"] ?? "",
                price: menuItems[index]["price"] ?? "")));
  }
}

class MenuItem extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  const MenuItem(
      {Key? key,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        height: 200,
        //BoxDecoration Widget
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ), //DecorationImage
          border: Border.all(
            color: Color(0xffeae057),
            width: 8,
          ), //Border.all
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: const Offset(
                5.0,
                5.0,
              ), //Offset
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ), //BoxShadow
          ],
        ), //Center
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(name,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 24)),
          Text(price,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 24))
        ])));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Column(children: [
  //     Text(name),
  //     Text(description),
  //     Text(price),
  //     Image.network(imageUrl)
  //   ]);
  // }
}

Future<Math> getMath() async {
  //final response = await http
  //    .get(Uri.parse('https://jsonplaceholder.typicode.com/Maths/1'));

  final response = await http.get(Uri.parse('https://v2.jokeapi.dev/joke/Any'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Math.generate(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

class Math {
  final String text;

  const Math({required this.text});

  factory Math.generate(Map<String, dynamic> json) {
    String joke = json['joke'];
    if (json['joke'] == null) {
      joke = json['setup'];
    }
    return Math(text: joke);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String mathurl = "";
  late Future<Math> futureMath;

  @override
  void initState() {
    super.initState();
    futureMath = getMath();
  }

  void _refresh() async {
    setState(() {
      futureMath = getMath();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Press Button for Another Joke'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _refresh(); // Add your onPressed code here!
          },
          backgroundColor: Color(0xffb51d95),
          child: const Icon(Icons.add),
        ),
        body: Container(
          decoration: BoxDecoration(
            //DecorationImage
            border: Border.all(
              color: Color(0xffeae057),
              width: 8,
            ), //Border.all
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: const Offset(
                  5.0,
                  5.0,
                ), //Offset
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ), //BoxShadow
              BoxShadow(
                color: Colors.white,
                offset: const Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ), //BoxShadow
            ],
          ),
          child: Center(
            child: FutureBuilder<Math>(
              future: futureMath,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.text,
                    style: const TextStyle(
                        color: Color(0xffef6cbd),
                        fontWeight: FontWeight.bold,
                        fontSize: 32),
                    textAlign: TextAlign.center,
                  );
                  // return Image(image: NetworkImage(snapshot.data!.message));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
