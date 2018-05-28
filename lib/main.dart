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
  ui.Image image;

  MyRenderBox() : super(additionalConstraints: BoxConstraints.expand()) {
    x = 50.0;
    y = 50.0;
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
    }

    final Canvas canvas = context.canvas;
    final Paint paint = new Paint()
      ..color = new Color.fromARGB(0xff, 0xff, 0xff, 0xff);
    Offset point = new Offset(x, y);

    if (image != null) {
      canvas.drawImage(image, point, paint);
    }
  }
}
