import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/word.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  WordBloc() : super(const WordState()) {
    on<LoadWords>(_onLoadWords);
    on<AddCharacter>(_onAddCharacter);
    on<RemoveCharacter>(_onRemoveCharacter);
    on<NextWord>(_onNextWord);
    on<ShuffleLetters>(_onShuffleLetters);

    add(LoadWords());
  }

  void _onLoadWords(LoadWords event, Emitter<WordState> emit) {
    List<Word> words = [
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/155.webp?v=1682812404",
          word: "camera"),
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/245.webp?v=1682812404",
          word: "diabet"),
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/278.webp?v=1682812404",
          word: "tourisim"),
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/303.webp?v=1682812404",
          word: "cosmos"),
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/326.webp?v=1682812404",
          word: "artist"),
      Word(
          image:
              "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/334.webp?v=1682812404",
          word: "cloud"),
    ];

    emit(state.copyWith(words: words));
    add(ShuffleLetters());
  }

  void _onAddCharacter(AddCharacter event, Emitter<WordState> emit) {
    List<String> updatedUserWord = List.from(state.userWord)
      ..add(event.character);
    emit(state.copyWith(userWord: updatedUserWord));
  }

  void _onRemoveCharacter(RemoveCharacter event, Emitter<WordState> emit) {
    if (state.userWord.isNotEmpty && event.index < state.userWord.length) {
      List<String> updatedUserWord = List.from(state.userWord)
        ..removeAt(event.index);
      emit(state.copyWith(userWord: updatedUserWord));
    }
  }

  void _onNextWord(NextWord event, Emitter<WordState> emit) {
    if (state.words.isNotEmpty) {
      List<Word> updatedWords = List.from(state.words)..removeAt(0);
      emit(state.copyWith(
          words: updatedWords, userWord: [], completed: updatedWords.isEmpty));

      if (updatedWords.isNotEmpty) {
        add(ShuffleLetters());
      }
    }
  }

  void _onShuffleLetters(ShuffleLetters event, Emitter<WordState> emit) {
    if (state.words.isNotEmpty) {
      final word = state.words[0].word;
      List<String> letters = word.split('');
      if (letters.length < 12) {
        letters.addAll(List.generate(
          12 - letters.length,
          (_) => characters[Random().nextInt(characters.length)],
        ));
      }
      letters.shuffle();
      emit(state.copyWith(shuffledLetters: letters));
    }
  }
}

List<String> characters = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z'
];
