import 'package:flutter/material.dart';

class FutureLoader {
  static final _defaultLoading = Stack(
          children: const <Widget>[
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(
                dismissible: false,
                color: Colors.grey,
              ),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
    static final _defaultError = Stack(
          children: const <Widget>[
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(
                dismissible: false,
                color: Colors.grey,
              ),
            ),
            Center(
              child: Text("Error"),
            ),
          ],
        );
  // method that use FutureBuilder and show loading dialog and darken overlay
  static Widget showLoadingScreen<T>(
      {required BuildContext context, 
      required Future<T> future,
       required Widget Function(T) onSuccess,
        Widget Function()? onLoading,
        Widget Function()? onError,
       }) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return onError != null ? onError() : _defaultError;
          } else if (snapshot.hasData) {
            return onSuccess(snapshot.data!);
          }
        }
        return onLoading != null ? onLoading() : _defaultLoading;
      },
    );
  }

  // function that use FutureBuilder and show loading indicator
  static showLoadingIndicator<T>(
      {required BuildContext context,
      required Future<T> future,
      required Widget Function(T) onSuccess,
      dynamic Function()? onLoading,
      dynamic Function()? onError,
      }) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return onError != null ? onError() : _defaultError;
          } else if (snapshot.hasData) {
            return onSuccess(snapshot.data!);
          }
        }
        return onLoading != null ? onLoading() : _defaultLoading;
      },
    );
  }


  
}