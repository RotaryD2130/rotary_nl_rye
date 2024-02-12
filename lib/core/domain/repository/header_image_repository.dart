// 🎯 Dart imports:
import 'dart:async';

// 🌎 Project imports:
import 'package:rotary2130_2140_rye/core/domain/entities/image.dart';

abstract class HeaderImageRepository {
  Stream<HeaderImage> get headerImage;

  Future<void> dispose();
}
