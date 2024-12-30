import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AutoScrollText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const AutoScrollText({
    Key? key,
    required this.text,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Medir o tamanho do texto renderizado
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (textPainter.size.width > constraints.maxWidth) {
          // Se o texto for maior que o espaço disponível, usar Marquee
          return Marquee(
            text: text,
            style: style,
            scrollAxis: Axis.horizontal,
            blankSpace: 20.0,
            velocity: 30.0,
            pauseAfterRound: Duration(seconds: 1),
            startPadding: 10.0,
            accelerationDuration: Duration(seconds: 1),
            decelerationDuration: Duration(milliseconds: 500),
          );
        } else {
          // Exibir texto normalmente se ele couber
          return Text(
            text,
            style: style,
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }
}
