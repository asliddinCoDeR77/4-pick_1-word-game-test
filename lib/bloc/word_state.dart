part of 'word_bloc.dart';

class WordState {
  final List<Word> words;
  final List<String> userWord;
  final List<String> shuffledLetters;
  final bool completed;

  const WordState({
    this.words = const [],
    this.userWord = const [],
    this.shuffledLetters = const [],
    this.completed = false,
  });

  WordState copyWith({
    List<Word>? words,
    List<String>? userWord,
    List<String>? shuffledLetters,
    bool? completed,
  }) {
    return WordState(
      words: words ?? this.words,
      userWord: userWord ?? this.userWord,
      shuffledLetters: shuffledLetters ?? this.shuffledLetters,
      completed: completed ?? this.completed,
    );
  }
}
