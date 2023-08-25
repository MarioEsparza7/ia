import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class ElevenLabs {
  static const apiKey = 'c32f74222a9479cea37f6200f41014e4';

  static Future speak(String text) async {
    try {
      final player = AudioPlayer();
      final bytes = await _fetch(text);
      player.play(DeviceFileSource(bytes.path));
    } catch (ex) {
      print('Error: $ex');
    }
  }

  static Future<File> _fetch(String text) async {
    const voiceId = 'EXAVITQu4vr4xnSDxMaL';
    const url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceId';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'xi-api-key': apiKey,
        'Content-Type': 'application/json',
        'accept': 'audio/mpeg',
      },
      body: convert.json.encode({
        "text": text,
        "model_id": "eleven_multilingual_v1",
        "voice_settings": {"stability": 0, "similarity_boost": 1}
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Eleven Labs API Failed.');
    }

    log('Response: ${response.bodyBytes}');
    //convert bytes to file
    final file = File('${Directory.systemTemp.path}/audio.mp3');
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }
}
