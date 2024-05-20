// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
runApp(MyApp());
}

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TranslationPage(),
  );
}
}

class TranslationPage extends StatefulWidget {
@override
_TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State
  with TickerProviderStateMixin {
String _inputText = '';
String _translatedVideoUrl = '';
String _selectedLanguage1 = 'English';
String _selectedLanguage2 = 'English';
String swap = 'English';

List<String> _languages = ['English', 'Arabic', 'Sign Language'];
////////// API
Future<void> _translateTextToSignLanguage() async {

  String apiKey = '65cf15ea4396bd63f20730cb';
  String textToTranslate = _inputText;
  String targetLanguage = '';
  String url = 'https://prod-in2.100ms.live/hmsapi/kalaiselvan-videoconf-1329.app.100ms.live/api/token';
  url += '&q=$textToTranslate&target=$targetLanguage';

  try {

    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {

      Map<String, dynamic> data = json.decode(response.body);
      String translatedText = data['data']['translations'][0]['translatedText'];

      setState(() {
        _translatedVideoUrl = 'https://example.com/sign-language-video?text=$translatedText';
      });
    } else {
      // Handle error response
      print('Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle network error
    print('Error: $e');
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: Text(
        'Ishara',
        style: TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          shadows: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 4,
              offset: Offset(2, 1),
            ),
          ],
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {}, // Add functionality
                  child: DropdownButton<String>(
                    value: _selectedLanguage1,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage1 = newValue!;
                      });
                    },
                    items: _languages.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      swap = _selectedLanguage1;
                      _selectedLanguage1 = _selectedLanguage2;
                      _selectedLanguage2 = swap;
                    });
                  },
                  child: Icon(
                    Icons.swap_horiz_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
              // SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: DropdownButton<String>(
                    value: _selectedLanguage2,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage2 = newValue!;
                      });
                    },
                    items: _languages.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            onChanged: (value) {
              setState(() {
                _inputText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter Text',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _translateTextToSignLanguage,
            child: Text('Translation'),
          ),
          SizedBox(height: 20),
          if (_translatedVideoUrl.isEmpty)
            Expanded(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 20,
                    ),
                    child:
                  Center(
                    child: Text(
                      'Display translated video here',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
}
