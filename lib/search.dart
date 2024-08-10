import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InputField(),
    );
  }
}

class InputField extends StatefulWidget {
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0XFFFFFFFDE),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (text) {
                setState(() {
                  query = text;
                });
              },
              decoration: InputDecoration(
                hintText: '태그 또는 제목 검색',
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Image.asset(
                    'assets/search.png',
                    width: 40,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Search query: $query'), //추후에 삭제 필요
          ],
        ),
      ),
    );
  }
}
