import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(new MyApp());

class MyApp extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return new MyRenderBox();
  }
}

class MyRenderBox extends RenderConstrainedBox {
  double x, y;
  double width, height;
  ui.Image image;

  MyRenderBox() : super(additionalConstraints: BoxConstraints.expand()) {
    x = 50.0;
    y = 50.0;
    width = 64.0;
    height = 64.0;
  }

  void loadImage(String path) async {
    if (rootBundle == null) {
      throw new StateError('rootBundle is null.');
    }

    ImageStream stream = new AssetImage(path, bundle: rootBundle)
        .resolve(ImageConfiguration.empty);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener);
    }

    stream.addListener(listener);
    image = await completer.future;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (image == null) {
      loadImage("assets/texture.png");
      markNeedsPaint();
    }

    final Canvas canvas = context.canvas;
    final Paint paint = new Paint()
      ..color = new Color.fromARGB(0xff, 0xff, 0xff, 0xff);

    if (image != null) {
      // Offset point = new Offset(x, y);
      // canvas.drawImage(image, point, paint);
      Rect src = Rect.fromLTWH(64.0, 64.0, width, height);
      Rect dst = Rect.fromLTWH(x, y, width, height);
      canvas.drawImageRect(image, src, dst, paint);
    }
  }
}
