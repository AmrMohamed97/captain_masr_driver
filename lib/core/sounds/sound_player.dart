import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class SoundPlayer {
  static Future<void> alertSound() async {
    final player = AudioPlayer();
    try {
      await player.setAsset("assets/sounds/alert.mp3");
      await player.play();
    } catch (e) {
      if (!kReleaseMode) log("Error playing sound: $e");
    } finally {
      await player.dispose();
    }
  }
}
