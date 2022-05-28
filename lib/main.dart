import 'package:flutter/material.dart';
import 'neon_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'LAB 1'),
    );
  }
}

enum ButtonState { init, loading, done }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  bool isLoading2 = false;
  bool isAnimating = true;
  ButtonState state = ButtonState.init;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDone = state == ButtonState.done;
    bool isStretched = isAnimating || state == ButtonState.init;

    return isLoading
        ? const LoadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              centerTitle: true,
            ),
            body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const NeonButton(Colors.red),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await Future.delayed(const Duration(seconds: 3));
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: const Text('Load Data')),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 24),
                        minimumSize: const Size.fromHeight(72),
                        shape: const StadiumBorder(),
                      ),
                      child: isLoading2
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login'),
                      onPressed: () async {
                        setState(() {
                          isLoading2 = true;
                        });
                        await Future.delayed(const Duration(seconds: 3));
                        setState(() {
                          isLoading2 = false;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        width: state == ButtonState.init ? width : 70,
                        onEnd: () => setState(() => isAnimating = !isAnimating),
                        height: 70,
                        child: isStretched
                            ? buildButton()
                            : buildSmallButton(isDone)),
                  ],
                )));
  }

  Widget buildButton() => OutlinedButton(
      style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(width: 2, color: Colors.indigo)),
      child: const FittedBox(
        child: Text(
          'SUBMIT',
          style: TextStyle(
              fontSize: 24,
              color: Colors.indigo,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold),
        ),
      ),
      onPressed: () async {
        setState(() => state = ButtonState.loading);
        await Future.delayed(const Duration(seconds: 3));
        setState(() => state = ButtonState.done);
        await Future.delayed(const Duration(seconds: 3));
        setState(() => state = ButtonState.init);
      });

  Widget buildSmallButton(bool isDone) {
    final color = isDone ? Colors.green : Colors.indigo;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: isDone
            ? const Icon(Icons.done, size: 52, color: Colors.white)
            : const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitCircle(
      size: 140,
      itemBuilder: (context, index) {
        final colors = [Colors.green, Colors.red, Colors.yellow];
        final color = colors[index % colors.length];
        return DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle));
      },
    ));
  }
}
