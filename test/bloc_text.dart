import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:guess_meaning_game/bloc/word_bloc.dart';

void main() {
  group('WordBloc', () {
    late WordBloc wordBloc;

    setUp(() {
      wordBloc = WordBloc();
    });

    tearDown(() {
      wordBloc.close();
    });

    test('initial state is WordState', () {
      expect(wordBloc.state, WordState());
    });

    blocTest<WordBloc, WordState>(
      'emits state with loaded words when LoadWords event is added',
      build: () => wordBloc,
      act: (bloc) => bloc.add(LoadWords()),
      expect: () => [
        isA<WordState>()
            .having((state) => state.words.isNotEmpty, 'has words', true),
      ],
    );

    blocTest<WordBloc, WordState>(
      'emits state with added character when AddCharacter event is added',
      build: () => wordBloc,
      act: (bloc) {
        bloc.add(LoadWords());
        bloc.add(AddCharacter('a'));
      },
      expect: () => [
        isA<WordState>().having((state) => state.userWord.contains('a'),
            'contains character', true),
      ],
    );

    blocTest<WordBloc, WordState>(
      'emits state with removed character when RemoveCharacter event is added',
      build: () => wordBloc,
      act: (bloc) {
        bloc.add(LoadWords());
        bloc.add(AddCharacter('a'));
        bloc.add(RemoveCharacter(0));
      },
      expect: () => [
        isA<WordState>()
            .having((state) => state.userWord.isEmpty, 'is empty', true),
      ],
    );

    blocTest<WordBloc, WordState>(
      'emits state with shuffled letters when ShuffleLetters event is added',
      build: () => wordBloc,
      act: (bloc) => bloc.add(ShuffleLetters()),
      expect: () => [
        isA<WordState>().having((state) => state.shuffledLetters.isNotEmpty,
            'has shuffled letters', true),
      ],
    );

    blocTest<WordBloc, WordState>(
      'emits state with next word when NextWord event is added',
      build: () => wordBloc,
      act: (bloc) {
        bloc.add(LoadWords());
        bloc.add(NextWord());
      },
      expect: () => [
        isA<WordState>().having(
            (state) => state.words.length == 5, 'words length is 5', true),
      ],
    );
  });
}
