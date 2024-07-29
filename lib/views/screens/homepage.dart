import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:shimmer/shimmer.dart';
import 'package:guess_meaning_game/bloc/word_bloc.dart';
import 'package:guess_meaning_game/utils/app_color.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.info,
        title: Text(
          "Guess the Word",
          style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.network(
                  fit: BoxFit.cover,
                  'https://st2.depositphotos.com/4187197/6383/v/600/depositphotos_63835503-stock-illustration-glowing-effect-horizontal-stripes-background.jpg')),
          BlocConsumer<WordBloc, WordState>(
            listener: (context, state) {
              if (state.words.isNotEmpty &&
                  state.userWord.join() == state.words[0].word) {
                Future.delayed(Duration.zero, () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Correct!"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("You guessed the word!"),
                            Text("Description: ${state.words[0].description}"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.read<WordBloc>().add(NextWord());
                              Navigator.of(context).pop();
                            },
                            child: const Text("Next Word"),
                          ),
                        ],
                      );
                    },
                  );
                });
              }
            },
            builder: (context, state) {
              if (state.completed) {
                return Center(
                  child: Text(
                    "Congratulations!\nYou've completed the game.",
                    style: GoogleFonts.lato(
                        fontSize: 24, color: AppColors.secondary),
                  ),
                );
              }

              if (state.words.isEmpty) {
                return const Center(
                  child: SpinKitCircle(
                    color: Colors.white,
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.words.length,
                            itemBuilder: (context, index) {
                              return AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 500),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      Image.network(
                                        state.words[index].image,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        loadingBuilder:
                                            (context, child, progress) {
                                          if (progress == null) return child;
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.grey[300],
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 60,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (index < state.userWord.length) {
                                context
                                    .read<WordBloc>()
                                    .add(RemoveCharacter(index));
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  state.userWord.isNotEmpty
                                      ? state.userWord[index]
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: state.userWord.length,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 60,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return InkWell(
                            onTap: () {
                              context.read<WordBloc>().add(
                                  AddCharacter(state.shuffledLetters[index]));
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: AnimatedContainer(
                              height: 180,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.info,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  state.shuffledLetters[index],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: state.shuffledLetters.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
