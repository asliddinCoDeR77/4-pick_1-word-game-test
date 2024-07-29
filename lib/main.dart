import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_meaning_game/bloc/word_bloc.dart';
import 'views/screens/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MainRunner());
}

class MainRunner extends StatelessWidget {
  const MainRunner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WordBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Homepage(),
      ),
    );
  }
}
