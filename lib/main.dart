import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ia/src/chat/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ElevenLabs

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        home: const HomeIA(),
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ));
  }
}

class HomeIA extends StatefulWidget {
  const HomeIA({Key? key}) : super(key: key);

  @override
  State<HomeIA> createState() => _HomeIAState();
}

class _HomeIAState extends State<HomeIA> {
  String _nombre = '';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeIn(
              delay: const Duration(milliseconds: 1000),
              child: SizedBox(
                height: size.height * 0.4,
                child: Hero(
                    tag: 'ia',
                    child: Image.asset('assets/img/ia.gif', fit: BoxFit.cover)),
              ),
            ),
            FadeIn(
              delay: const Duration(milliseconds: 2000),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '¡Bienvenido!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            FadeIn(
              delay: const Duration(milliseconds: 3500),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Me llamo Snow, soy tu nuevo asistente virtual.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            FadeIn(
              delay: const Duration(milliseconds: 5500),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Comencemos con mi configuración inicial.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            FadeIn(
              delay: const Duration(milliseconds: 6500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const Text(
                      '¿Cuál es tu nombre?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _nombre = value;
                          });
                        },
                        onSaved: (value) {
                          setState(() {
                            _nombre = value!;
                          });
                        },
                        cursorColor: Colors.purple,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(.5), width: 1),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide:
                                BorderSide(color: Colors.deepPurple, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            //boton
            FadeIn(
              animate: _nombre.isNotEmpty ? true : false,
              duration: const Duration(milliseconds: 2000),
              child: SizedBox(
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 2000),
                        pageBuilder: (_, __, ___) => const ChatPage(),
                        transitionsBuilder:
                            (_, Animation<double> animation, __, Widget child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Continuar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
