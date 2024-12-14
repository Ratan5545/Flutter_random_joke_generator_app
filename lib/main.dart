import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Joke Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal, // Changed primary color
        scaffoldBackgroundColor: Colors.grey[100], // Light background
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87), // Text color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal, // Button text color
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
          ),
        ),
      ),
      home: const JokePage(),
    );
  }
}

class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  String _joke = "Press the button to get a joke!";

  Future<void> _fetchJoke() async {
    final response = await http
        .get(Uri.parse('https://official-joke-api.appspot.com/random_joke'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jokeData = json.decode(response.body);
      setState(() {
        _joke = "${jokeData['setup']} \n\n${jokeData['punchline']}";
      });
    } else {
      setState(() {
        _joke = "Failed to load joke.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchJoke(); // Fetch a joke when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Joke Generator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8, // Increased elevation for a better shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0), // Increased padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    _joke,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w500), // Increased font size and weight
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _fetchJoke,
                    child: const Text('Get Another Joke'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
