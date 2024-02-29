import 'dart:ui';

class DisplaySize {

  DisplaySize._privateConstructor();

  static final DisplaySize _instance = DisplaySize._privateConstructor();

  static DisplaySize get instance => _instance;

  late double _displayHeight;
  late double _displayWidth;

  void setDisplayHeight(Size size) {
    _displayHeight = size.height;
  }

  double get displayHeight => _displayHeight;

  void setDisplayWidth(Size size) {
    _displayWidth = size.width;
  }

  double get displayWidth => _displayWidth;
}