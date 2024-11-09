import 'dart:convert';

// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<List<dynamic>> getJSON() async {
    //API use: https://hp-api.herokuapp.com/
  var url = Uri.parse('https://hp-api.herokuapp.com/api/characters/students');
  var response = await http.get(url);
  return jsonDecode(response.body);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: const Text(
                  "Hogwarts Students",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                )),

              FutureBuilder<List<dynamic>>(
              future: getJSON(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  var results = snapshot.data ?? [];

                  return Expanded(
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, i) {
                        var character = results[i];
                        var name = character['name'];
                        var description = character['house'];
                        var actor = character['actor'];
                        var imageUrl = character['image'];
                        return Card(
                          child: ListTile(
                            leading: Image.network(imageUrl, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),),
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(description + "Actor : $actor"),
                          ),
                        );
                      },
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Text("An error has occurred: ${snapshot.error.toString()}");
                }

                return Container();
              },
            )
              
          ],
        ),
      ),
    );
  }
}
