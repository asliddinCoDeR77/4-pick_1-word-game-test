part of 'word_bloc.dart';

abstract class WordEvent {}

class LoadWords extends WordEvent {}

class AddCharacter extends WordEvent {
  final String character;
  AddCharacter(this.character);
}

class RemoveCharacter extends WordEvent {
  final int index;
  RemoveCharacter(this.index);
}

class NextWord extends WordEvent {}

class ShuffleLetters extends WordEvent {}
