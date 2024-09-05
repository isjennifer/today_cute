import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;
  static const int maxLinesBeforeExpand = 2;

  @override
  Widget build(BuildContext context) {
    final linkText = isExpanded ? ' 접기' : ' 더보기';

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textSpan = TextSpan(
          text: widget.text,
          style: TextStyle(color: Colors.black),
        );

        final linkTextSpan = TextSpan(
          text: linkText,
          style: TextStyle(color: Colors.blue),
        );

        final textPainter = TextPainter(
          text: TextSpan(
            text: widget.text,
            style: TextStyle(color: Colors.black),
          ),
          maxLines: maxLinesBeforeExpand,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines && !isExpanded) {
          final pos = textPainter.getPositionForOffset(
            Offset(textPainter.width - linkTextSpan.toPlainText().length * 7,
                textPainter.height),
          );
          final endIndex = pos.offset - linkTextSpan.toPlainText().length;

          final truncatedText = widget.text.substring(0, endIndex) + '...';

          return GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: truncatedText,
                    style: TextStyle(color: Colors.black),
                  ),
                  linkTextSpan,
                ],
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: RichText(
            text: TextSpan(
              text: widget.text,
              style: TextStyle(color: Colors.black),
              children: [
                if (isExpanded) linkTextSpan,
              ],
            ),
          ),
        );
      },
    );
  }
}
