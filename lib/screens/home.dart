import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/image_body.dart';
import '../widgets/video_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0XFFFFFFFDE),
        child: ListView(
          children: [
            ImageBody(),
          ],
        ),
      ),
    );
  }
}
