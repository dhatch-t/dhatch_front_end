import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchOriginPage extends StatefulWidget {
  const SearchOriginPage({super.key});

  @override
  State<SearchOriginPage> createState() => _SearchOriginPageState();
}

class _SearchOriginPageState extends State<SearchOriginPage> {
  final TextEditingController _textController = TextEditingController();
  final String token = '123456';
  var uuid = const Uuid();
  List<dynamic> listOfLocation = [];
  @override
  void initState() {
    _textController.addListener(
      () {
        _onChange();
      },
    );
    super.initState();
  }

  _onChange() {
    placeSuggestion(_textController.text);
  }

  void placeSuggestion(String input) async {
    String apiKey = "AIzaSyDwEenlZcn-GZCfjjW7KSTMeJi_CUFv7qw";
    try {
      String baseUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String request = '$baseUrl?input=$input&key=$apiKey&sessiontoken=$token';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      if (kDebugMode) {
        print(data);
      }
      if (response.statusCode == 200) {
        setState(() {
          listOfLocation = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception("Fail to load");
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Origin")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: "Search Origin",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            Visibility(
              visible: _textController.text.isEmpty ? false : true,
              child: Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listOfLocation.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _textController.text =
                          listOfLocation[index]["description"];
                      Navigator.pop(context, _textController.text);
                    },
                    child: ListTile(
                      title: Text(
                        listOfLocation[index]["description"],
                      ),
                    ),
                  );
                },
              )),
            ),
            // Visibility(
            //   visible: _textController.text.isEmpty ? true : false,
            //   child: Container(
            //     margin: const EdgeInsets.only(top: 20),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         Navigator.pop(context, _textController.text);
            //       },
            //       child: const Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Icon(Icons.my_location),
            //           SizedBox(
            //             width: 10,
            //           ),
            //           Text("Submit"),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
