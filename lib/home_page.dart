import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:yemek/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Model> list = <Model>[];
  final url =
      "https://api.edamam.com/search?q=chicken&app_id=acdef953&app_key=465580451a2afa59d4a60d44818f5d68&from=0&to=100&calories=591-722&health=alcohol-free";

  getApiData() async {
    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);
    json['hits'].forEach((element) {
      Model model = Model(
        url: element['recipe']['url'],
        image: element['recipe']['image'],
        source: element['recipe']['source'],
        label: element['recipe']['label'],
      );
      setState(() {
        list.add(model);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("DENEME"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.green.withOpacity(0.2),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              GridView.builder(
                shrinkWrap: true,
                primary: true,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
                itemBuilder: (context, index) {
                  final x = list[index];
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(x.image.toString()),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.grey.withOpacity(0.2),
                          child: Text(x.label.toString()),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.grey.withOpacity(0.2),
                          child: Text("Source: " + x.source.toString()),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: list.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
