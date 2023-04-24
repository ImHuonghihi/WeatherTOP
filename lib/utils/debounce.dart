import 'dart:async';

import 'package:flutter/material.dart';

class Debounce<R> {
  int milliseconds;
  late VoidCallback action;
  late Timer _timer;

  Debounce({required this.milliseconds});

  R run({R Function()? action}) {
    if (action != null) {
      this.action = action;
    }
    _timer = Timer(Duration(milliseconds: milliseconds), this.action);
    _timer.cancel();
    return action!();
  }

  void cancel() {
    _timer.cancel();
  }

  void reset() {
    _timer.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void setAction(VoidCallback action) {
    this.action = action;
  }

  void setMilliseconds(int milliseconds) {
    this.milliseconds = milliseconds;
  }

  int getMilliseconds() {
    return milliseconds;
  }

  VoidCallback getAction() {
    return action;
  }

  Timer getTimer() {
    return _timer;
  }

  void setTimer(Timer timer) {
    _timer = timer;
  }

  Debounce copy() {
    return Debounce(milliseconds: milliseconds);
  }

  Debounce copyWith(VoidCallback action) {
    return Debounce(milliseconds: milliseconds)..setAction(action);
  }

  Debounce copyWithMilliseconds(int milliseconds) {
    return Debounce(milliseconds: milliseconds);
  }

  Debounce copyWithTimer(Timer timer) {
    return Debounce(milliseconds: milliseconds)..setTimer(timer);
  }

  Debounce copyWithAction(VoidCallback action) {
    return Debounce(milliseconds: milliseconds)..setAction(action);
  }

  Debounce copyWithMillisecondsAndAction(
      int milliseconds, VoidCallback action) {
    return Debounce(milliseconds: milliseconds)..setAction(action);
  }

  Debounce copyWithMillisecondsAndTimer(int milliseconds, Timer timer) {
    return Debounce(milliseconds: milliseconds)..setTimer(timer);
  }

  Debounce copyWithTimerAndAction(Timer timer, VoidCallback action) {
    return Debounce(milliseconds: milliseconds)
      ..setAction(action)
      ..setTimer(timer);
  }

  Debounce copyWithMillisecondsAndTimerAndAction(
      int milliseconds, Timer timer, VoidCallback action) {
    return Debounce(milliseconds: milliseconds)
      ..setAction(action)
      ..setTimer(timer);
  }

  Debounce copyWithDebounce(Debounce debounce) {
    return Debounce(milliseconds: debounce.getMilliseconds())
      ..setAction(debounce.getAction())
      ..setTimer(debounce.getTimer());
  }

  Debounce copyWithDebounceAndMilliseconds(
      Debounce debounce, int milliseconds) {
    return Debounce(milliseconds: milliseconds)
      ..setAction(debounce.getAction())
      ..setTimer(debounce.getTimer());
  }

  Debounce copyWithDebounceAndAction(Debounce debounce, VoidCallback action) {
    return Debounce(milliseconds: debounce.getMilliseconds())
      ..setAction(action)
      ..setTimer(debounce.getTimer());
  }

  Debounce copyWithDebounceAndTimer(Debounce debounce, Timer timer) {
    return Debounce(milliseconds: debounce.getMilliseconds())
      ..setAction(debounce.getAction())
      ..setTimer(timer);
  }

  Debounce copyWithDebounceAndMillisecondsAndAction(
      Debounce debounce, int milliseconds, VoidCallback action) {
    return Debounce(milliseconds: milliseconds)
      ..setAction(action)
      ..setTimer(debounce.getTimer());
  }

  Debounce copyWithDebounceAndMillisecondsAndTimer(
      Debounce debounce, int milliseconds, Timer timer) {
    return Debounce(milliseconds: milliseconds)
      ..setAction(debounce.getAction())
      ..setTimer(timer);
  }

  Debounce copyWithDebounceAndTimerAndAction(
      Debounce debounce, Timer timer, VoidCallback action) {
    return Debounce(milliseconds: debounce.getMilliseconds())
      ..setAction(action)
      ..setTimer(timer);
  }

  Debounce copyWithDebounceAndMillisecondsAndTimerAndAction(
      Debounce debounce, int milliseconds, Timer timer, VoidCallback action) {
    return Debounce(milliseconds: milliseconds)
      ..setAction(action)
      ..setTimer(timer);
  }
}
