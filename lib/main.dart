import 'dart:convert';
import 'package:chat_gpt_intro/models/chat_completion.dart';
import 'package:chat_gpt_intro/models/image.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:chat_gpt_intro/sicret.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

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

  List<ChatMessage> messages = <ChatMessage>[];

  ChatUser userMe = ChatUser(
    id: "1",
    firstName: "Me",
  );
  ChatUser openAiUser = ChatUser(id: "2", firstName: "ChatGPT");

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
          "max_tokens": 100,
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": controller.text}
          ]
        }),
      );

      if (response.statusCode == 200) {
        controller.text = "";
        var data = jsonDecode(response.body);

        // Parse the JSON response into a ChatCompletionResponse object
        ChatCompletionResponse chatResponse =
            ChatCompletionResponse.fromJson(data);

        // Access the choices and other data from the chatResponse object
        //results = chatResponse.choices.last.message.content;
        for (var chat in chatResponse.choices) {
          results = chat.message.content;
          ChatMessage msg = ChatMessage(
            user: openAiUser,
            createdAt: DateTime.now(),
            text: results,
          );
          messages.insert(0, msg);
          setState(() {
            messages;
          });
        }
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

  Future<void> generateImage() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('https://api.openai.com/v1/images/generations');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "model": "dall-e-3",
          "prompt": controller.text,
          "n": 1,
          "size": "1024x1024"
        }),
      );
      controller.text = "";
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Parse the JSON response into an ImageGenerationResult object
        ImageGenerationResult imageResult =
            ImageGenerationResult.fromJson(data);

        // Now you can access the image data
        if (imageResult.data.isNotEmpty) {
          // For example, print the URL of the first image

          ChatMessage msg =
              ChatMessage(user: openAiUser, createdAt: DateTime.now(), medias: [
            ChatMedia(
              url: imageResult.data.first.url,
              fileName: "image",
              type: MediaType.image,
            )
          ]);

          messages.insert(0, msg);
          setState(() {
            messages;
          });
        }
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
                Expanded(
                    child: DashChat(
                        currentUser: userMe,
                        onSend: (m) {},
                        readOnly: true,
                        messages: messages)),
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
                              ChatMessage msg = ChatMessage(
                                user: userMe,
                                createdAt: DateTime.now(),
                                text: controller.text,
                              );
                              messages.insert(0, msg);
                              setState(() {
                                messages;
                              });
                              if (controller.text
                                  .toLowerCase()
                                  .startsWith("generate image")) {
                                generateImage();
                              } else {
                                await completeWithHttp();
                              }
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
