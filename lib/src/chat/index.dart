import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ia/src/utils/elevenLabs.dart';
import 'package:typewritertext/typewritertext.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late OpenAI openAI;
  String respuesta = "";
  final TextEditingController _controller = TextEditingController();
  bool cargando = false;
  @override
  void initState() {
    openAI = OpenAI.instance.build(
        token: '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',
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20)),
        enableLog: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            )),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FadeOut(
                delay: const Duration(milliseconds: 3000),
                child: const Text(
                  'Comencemos...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
                ),
              ),
              cargando
                  ? const Center(child: CupertinoActivityIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.deepPurple, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: respuesta != ""
                              ? Text(respuesta)
                              : const Text(''),
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Escribe algo...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () async {
                    cargando = true;
                    setState(() {});
                    //http request to api ElevenLabs

                    // Play the audio file
                    // final player = AudioPlayer();
                    // await player.play(DeviceFileSource(file.path));
                    final request = CompleteText(
                        prompt: _controller.text != ""
                            ? "${_controller.text}. Dame una respuesta que no sea de mas de 200 caracteres"
                            : " 'Hola, mi nombre es Martín, presentate como mi asistente virtual llamada Snow",
                        model: TextDavinci3Model(),
                        maxTokens: 200);

                    final response =
                        await openAI.onCompletion(request: request);
                    log(response!.choices[0].text);

                    await ElevenLabs.speak(response.choices[0].text);
                    respuesta = response.choices[0].text;
                    cargando = false;
                    setState(() {});
                  },
                  child: const Text('Enviar')),
              Stack(
                children: [
                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: SizedBox(
                  //     height: 80,
                  //     width: size.width,
                  //     child: WaveHalfOval(
                  //         width: size.width + 100,
                  //         height: 80,
                  //         color: Colors.deepPurple),
                  //   ),
                  // ),
                  SizedBox(
                    height: size.height * 0.2,
                    child: Hero(
                        tag: 'ia',
                        child: Image.asset('assets/img/ia.gif',
                            fit: BoxFit.cover)),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

//CustomPainter para dibujar el circulo

class WaveHalfOval extends StatefulWidget {
  final double width;
  final double height;
  final Color color;

  const WaveHalfOval({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
  }) : super(key: key);

  @override
  _WaveHalfOvalState createState() => _WaveHalfOvalState();
}

class _WaveHalfOvalState extends State<WaveHalfOval>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _WaveHalfOvalPainter(
            color: widget.color,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}

class _WaveHalfOvalPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  _WaveHalfOvalPainter({
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final waveHeight = size.height * 0.2;
    final waveWidth = size.width * 0.8;
    final waveOffset = waveWidth * 0.4;
    final waveMidpoint = rect.bottomCenter - Offset(0, waveHeight);
    final controlPointOffset = Offset(waveOffset, waveHeight * animationValue);

    final path = Path()
      ..moveTo(rect.left, rect.bottom)
      ..lineTo(rect.left, waveMidpoint.dy)
      ..quadraticBezierTo(
        waveMidpoint.dx - controlPointOffset.dx,
        waveMidpoint.dy - controlPointOffset.dy,
        waveMidpoint.dx,
        waveMidpoint.dy,
      )
      ..quadraticBezierTo(
        waveMidpoint.dx + controlPointOffset.dx,
        waveMidpoint.dy + controlPointOffset.dy,
        rect.right,
        waveMidpoint.dy,
      )
      ..lineTo(rect.right, rect.bottom)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WaveHalfOvalPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.animationValue != animationValue;
  }
}
