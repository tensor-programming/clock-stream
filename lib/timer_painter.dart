import 'dart:math' as math;

import 'package:flutter/material.dart';

const kFullCircle = math.pi * 2;
const kNegQuarterCircle = -math.pi / 2;

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.time,
    this.backgroundColor,
    this.color,
  });

  final DateTime time;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPainter = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = size.width / 10
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    Paint timerPainter = Paint()
      ..color = Colors.green
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    double secondTime = (fixSecAndMin(time.second) / 60) * kFullCircle;
    double minuteTime = (fixSecAndMin(time.minute) / 60) * kFullCircle;
    double hourTime = (fixHour(time.hour) / 12) * kFullCircle;

    createCircle(
      canvas,
      size,
      4.5,
      backgroundPainter,
    );

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    for (var i = 0; i < 60; i++) {
      canvas.drawLine(
        Offset(size.width / 3.9, size.height / 3.9),
        Offset(size.width / 6, size.height / 6),
        timerPainter..color = Colors.primaries[i % 17],
      );

      canvas.rotate(kFullCircle / 60);
    }

    canvas.restore();

    createArc(
      canvas,
      size,
      4,
      secondTime,
      backgroundPainter..color = Colors.green,
    );

    createArc(
      canvas,
      size,
      4.9,
      minuteTime,
      backgroundPainter..color = Colors.red,
    );

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    for (var i = 0; i < 12; i++) {
      canvas.drawLine(
        Offset(size.width / 3.7, size.height / 3.7),
        Offset(size.width / 8, size.height / 8),
        timerPainter
          ..color = Colors.primaries[i % 17]
          ..strokeWidth = 3.0,
      );

      canvas.rotate(kFullCircle / 12);
    }

    canvas.restore();

    createArc(
      canvas,
      size,
      6,
      hourTime,
      backgroundPainter..color = Colors.deepPurple,
    );
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return time.second != old.time.second ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

void createCircle(Canvas canvas, Size size, double width, Paint paint) {
  canvas.drawCircle(
    size.center(Offset.zero),
    size.width / width,
    paint,
  );
}

void createArc(
    Canvas canvas, Size size, double width, double time, Paint paint) {
  canvas.drawArc(
    Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.width / width,
    ),
    kNegQuarterCircle,
    time,
    false,
    paint,
  );
}

int fixSecAndMin(int time) {
  return time == 0 ? 60 : time;
}

int fixHour(int time) {
  int h = time > 12 ? time - 12 : time;

  return h == 0 ? 12 : h;
}
