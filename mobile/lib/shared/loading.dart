import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  factory Loading.failed() {
    return Loading(
      opacity: 0,
      ignorring: true,
    );
  }

  factory Loading.loading() {
    return Loading(
      opacity: 1,
      ignorring: false,
    );
  }

  factory Loading.initial() {
    return Loading(
      opacity: 0,
      ignorring: true,
    );
  }

  const Loading({
    Key key,
    this.ignorring,
    this.opacity,
  }) : super(key: key);

  final bool ignorring;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignorring,
      child: Opacity(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
            ),
            Align(
              alignment: Alignment.center,
              child: Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
        opacity: opacity,
      ),
    );
  }
}
