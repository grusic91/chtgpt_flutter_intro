import 'dart:convert';
import 'package:chat_gpt_intro/models/chat_completion.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:chat_gpt_intro/sicret.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatGPTHome(title: 'Flutter Demo Home Page'),
    );
  }
}

class ChatGPTHome extends StatefulWidget {
  const ChatGPTHome({super.key, required this.title});

  final String title;

  @override
  State<ChatGPTHome> createState() => _ChatGPTHomeState();
}

class _ChatGPTHomeState extends State<ChatGPTHome> {
  TextEditingController controller = TextEditingController();
  String results = "results to be shown here";
  bool _isLoading = false;

  Future<void> completeWithHttp() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('https://api.openai.com/v1/chat/completions');
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "max_tokens": 200,
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": controller.text}
          ]
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Parse the JSON response into a ChatCompletionResponse object
        ChatCompletionResponse chatResponse =
            ChatCompletionResponse.fromJson(data);

        // Access the choices and other data from the chatResponse object
        results = chatResponse.choices.last.message.content;
        setState(() {
          results;
        });
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text(results)),
                Row(
                  children: [
                    Expanded(
                        child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller,
                          autocorrect: false,
                          decoration:
                              const InputDecoration(hintText: 'Type here...'),
                        ),
                      ),
                    )),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: _isLoading
                          ? null // Disable button when loading
                          : () async {
                              await completeWithHttp();
                            },
                      child: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.purple),
                              ),
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
