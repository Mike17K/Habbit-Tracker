
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}


class _TimerWidgetState extends State<TimerWidget> {
  late CountDownController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CountDownController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => stopCountdown(),
      onTap: () {
        // Call the startCountdown method when tapped
        handleTap();
      },
      child: CircularCountDownTimer(
        duration: 10 * 60,
        initialDuration: 0,
        controller: _controller,
        width: MediaQuery.of(context).size.width / 2,
        height: 200,
        ringColor: const Color.fromARGB(169, 27, 48, 18),
        fillColor: const Color(0xFF4AB818),
        backgroundColor: const Color(0xFF4AB818),
        strokeWidth: 20.0,
        strokeCap: StrokeCap.round,
        textStyle: const TextStyle(fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.S,
        isReverse: true,
        isReverseAnimation: false,
        isTimerTextShown: true,
        autoStart: false,
        onStart: () {
          debugPrint('Countdown Started');
        },
        onComplete: () {
          debugPrint('Countdown Ended');
        },
        onChange: (String timeStamp) {
          debugPrint('Countdown Changed $timeStamp');
        },
        timeFormatterFunction: (defaultFormatterFunction, duration) {
          if (duration.inSeconds == 0) {
            return "Start";
          } else {
            return Function.apply(defaultFormatterFunction, [duration]);
          }
        },
      ),
    );
  }

  // Method to start the countdown manually
  void handleTap() {
    if (_controller.isResumed) {
      pauseCountdown();
    } else {
      resumeCountdown();
    }

    if (_controller.isRestarted) {
      stopCountdown();
    }
  }

  // Method to pause the countdown manually
  void pauseCountdown() {
    _controller.pause();
  }

  // Method to resume the countdown manually
  void resumeCountdown() {
    _controller.resume();
  }

  // Method to stop the countdown manually
  void stopCountdown() {
    _controller.restart(duration: 10 * 60);
  }
}