import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clock_stream/timer_bloc.dart';
import 'package:clock_stream/timer_painter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock Demo',
      theme: ThemeData.dark(),
      home: Provider<TimerBloc>(
        create: (context) => TimerBloc(),
        dispose: (context, bloc) => bloc.dispose(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<TimerBloc>(context);
    return Scaffold(
      body: StreamBuilder<DateTime>(
        stream: bloc.time,
        builder: (context, AsyncSnapshot<DateTime> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          return Stack(
            children: [
              AspectRatio(
                aspectRatio: 5 / 3,
                child: TimerBuilder(time: snapshot.data),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  createDigitalTime(
                    snapshot.data,
                  ),
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.primaries[snapshot.data.hour % 17],
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

String createDigitalTime(DateTime time) {
  return "${convertHours(time.hour).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
}

int convertHours(int hour) {
  int h = hour > 12 ? hour - 12 : hour;

  return h == 0 ? 12 : h;
}

class TimerBuilder extends StatelessWidget {
  final DateTime time;

  const TimerBuilder({Key key, this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TimerPainter(time: time),
    );
  }
}
