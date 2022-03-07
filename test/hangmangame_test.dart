import 'package:test/test.dart';
import 'package:hangman_game/models/hangmangame.dart';

void main() {
  //This test group will run several tests on the constructor of our hangmanGame class
  group('Test Hangman Constructor', () {
    test('Function word() should return the word given to constructor', () {
      //make a variable that we will use to pass to the constructor as our word
      String word = 'glorp';
      //pass word to game constructor and create object called hangmanGame
      final hangmanGame = HangmanGame(word);
      //expect that the hangmanGame objects word matches the originally passed word
      expect(hangmanGame.word(), word);

      //added for score
      expect(hangmanGame.score(), 0);
    });

    test('Function correctGuesses() should return empty string initially', () {
      //make a variable that we will use to pass to the constructor as our word
      String word = 'glorp';
      //pass word to game constructor and create object called hangmanGame
      final hangmanGame = HangmanGame(word);
      //expect that the game doesn't have any correct guesses since we have not guessed anything yet
      expect(hangmanGame.correctGuesses().isEmpty, isTrue);
    });

    test('Function wrongGuesses() should return empty string initially', () {
      //make a variable that we will use to pass to the constructor as our word
      String word = 'glorp';
      //pass word to game constructor and create object called hangmanGame
      final hangmanGame = HangmanGame(word);
      //expect that the game doesn't have any incorrect guesses since we have not guessed anything yet
      expect(hangmanGame.wrongGuesses().isEmpty, isTrue);
    });
  });

  //This test group will run several tests on the way the game should respond to certain guesses
  group('Test Hangman Guessing Behavior', () {
    test(
      'When user guesses correctly',
      () {
        //make a variable that we will use to pass to the constructor as our word
        String word = 'garply';
        //pass word to game constructor and create object called hangmanGame
        final hangmanGame = HangmanGame(word);

        //when assigning this boolean variable, the assignment also triggers a guess in our game object
        bool returnValue = hangmanGame.guess('a');
        //check to see if the correct letter was placed in the right list of guesses
        expect(hangmanGame.correctGuesses().contains('a'), isTrue);
        expect(hangmanGame.wrongGuesses().contains('a'), isFalse);
        expect(returnValue, isTrue);
      },
    );

    test(
      'When user guess incorrectly',
      () {
        //make a variable that we will use to pass to the constructor as our word
        String word = 'garply';
        //pass word to game constructor and create object called hangmanGame
        final hangmanGame = HangmanGame(word);

        //when assigning this boolean variable, the assignment also triggers a guess in our game object
        bool returnValue = hangmanGame.guess('z');

        //check to see if the incorrect letter was placed in the list of wrong guesses
        expect(hangmanGame.correctGuesses().isEmpty, isTrue);
        expect(hangmanGame.wrongGuesses(), 'z');
        expect(returnValue, isTrue);
      },
    );

    test(
      'When user guesses same letter repeatedly (case-insensitive)',
      () {
        //make a variable that we will use to pass to the constructor as our word
        String word = 'garply';
        //pass word to game constructor and create object called hangmanGame
        final hangmanGame = HangmanGame(word);

        // 'a' and 'q' are guessed for the first time
        hangmanGame.guess('a');
        hangmanGame.guess('q');

        //guess 'a' again
        bool acceptedAagain = hangmanGame.guess('a');
        expect(hangmanGame.correctGuesses(), 'a');
        expect(acceptedAagain, isFalse);

        // quess 'q' again
        bool acceptedQagain = hangmanGame.guess('q');
        expect(hangmanGame.wrongGuesses(), 'q');
        expect(acceptedQagain, isFalse);

        //guess 'A' again
        bool acceptedCapitalAagain = hangmanGame.guess('A');
        expect(hangmanGame.correctGuesses(), 'a');
        expect(acceptedCapitalAagain, isFalse);

        //guess 'Q' again
        bool acceptedCapitalQagain = hangmanGame.guess('Q');
        expect(hangmanGame.wrongGuesses(), 'q');
        expect(acceptedCapitalQagain, isFalse);
      },
    );

    //This nested group of tests will run through various invalid character guesses to see how the game responds
    group('Invalid guesses', () {
      test(
        'User tries empty string',
        () {
          String word = 'foobar';
          final hangmanGame = HangmanGame(word);

          //guess empty string
          expect(() => hangmanGame.guess(''), throwsArgumentError);
        },
      );

      test(
        'User tries non letters (a-zA-Z)',
        () {
          String word = 'foobar';
          final hangmanGame = HangmanGame(word);

          //guess nonletter
          expect(() => hangmanGame.guess('&'), throwsArgumentError);
        },
      );

      test(
        'User tries a null guess',
        () {
          String word = 'foobar';
          final hangmanGame = HangmanGame(word);

          //guess null
          expect(() => hangmanGame.guess(null), throwsArgumentError);
        },
      );

      test(
        'User guesses a string with more than one letter',
        () {
          String word = 'foobar';
          final hangmanGame = HangmanGame(word);

          //guess multiple letters at one time
          expect(() => hangmanGame.guess('oo'), throwsArgumentError);
        },
      );
    });
  });

  //This test group will run several tests on the progress we are making towards the word we are guessing
  group("Test Word Progress", () {
    test(
      'with some correct guesses',
      () {
        //Start a game with the word banana
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //Guess two correct letters
        hangmanGame.guess('b');
        hangmanGame.guess('n');
        //Guess one incorrect letter
        hangmanGame.guess('z');
        //We expect the game to return the correct word progress
        expect(hangmanGame.blanksWithCorrectGuesses(), 'b-n-n-');
      },
    );

    test(
      'with all wrong guesses',
      () {
        //Start a game with the word banana
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //Guess three incorrect letters
        hangmanGame.guess('d');
        hangmanGame.guess('e');
        hangmanGame.guess('f');
        //We expect the game to return the correct word progress
        expect(hangmanGame.blanksWithCorrectGuesses(), '------');
      },
    );

    test(
      'with all letters guessed',
      () {
        //Start a game with the word banana
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //Guess all the correct letters of the word banana
        hangmanGame.guess('b');
        hangmanGame.guess('a');
        hangmanGame.guess('n');
        //We expect the game to return the correct word progress
        expect(hangmanGame.blanksWithCorrectGuesses(), 'banana');
      },
    );
  });

  //This test group will run several tests on
  group('Test Game Status', () {
    test(
      'status returns "win" when all letters guessed',
      () {
        //Start a game with the word banana
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //Correctly guess all the letters to our word
        hangmanGame.guess('b');
        hangmanGame.guess('a');
        hangmanGame.guess('n');
        //Expect for the game to return a string of 'win' for its status
        expect(hangmanGame.status(), 'win');
      },
    );

    test(
      'status to return "lose" after 7 incorrect guesses',
      () {
        //Start a game with the word xyz
        String word = 'xyz';
        final hangmanGame = HangmanGame(word);
        // makes 7 incorrect guesses
        hangmanGame.guess('a'); // 1
        hangmanGame.guess('b'); // 2
        hangmanGame.guess('c'); // 3
        hangmanGame.guess('d'); // 4
        hangmanGame.guess('e'); // 5
        hangmanGame.guess('f'); // 6
        hangmanGame.guess('g'); // 7
        //Expect for the game to return a string of 'lose' for its status
        expect(hangmanGame.status(), 'lose');
      },
    );

    test(
      'status to return "play" if neither win nor lose',
      () {
        //Start a game with the word play
        String word = 'play';
        final hangmanGame = HangmanGame(word);
        //Expect for the game to return a string of 'play' for its status
        expect(hangmanGame.status(), 'play');
        //guess a letter correctly
        hangmanGame.guess('p');
        //Expect for the game to still return a string of 'play' for its status
        expect(hangmanGame.status(), 'play');
      },
    );
  });

  group("Starting Word", () {
    test('should be "banana" when integration test flag is on', () async {
      bool areWeInIntegrationTest = true;
      String word = await HangmanGame.getStartingWord(areWeInIntegrationTest);
      expect(word, 'banana');
    });
  });

  //score tests
  group("Test Scoring Logic not <6", () {
    test(
      "starts on 0",
      () {
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //We expect the score to be 0
        expect(hangmanGame.score(), 0);
      },
    );
    test(
      "after a single correct guess!<6",
      () {
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //Guess one correct letter
        hangmanGame.guess('b');
        //We expect the score to be 10
        expect(hangmanGame.score(), 10);
      },
    );
    test(
      "after a single incorrect guess!<6",
      () {
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //Guess one incorrect letter
        hangmanGame.guess('z');
        //We expect the score to be -5
        expect(hangmanGame.score(), -5);
      },
    );
    test(
      "after multiple correct guesses!<6",
      () {
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //Guess 2+ correct letters
        hangmanGame.guess('b');
        hangmanGame.guess('a');
        //We expect the score to be 20
        expect(hangmanGame.score(), 20);
      },
    );
    test(
      "after multiple incorrect guesses!<6",
      () {
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //Guess 2 incorrect letters
        hangmanGame.guess('z');
        hangmanGame.guess('r');
        //We expect the score to be -10
        expect(hangmanGame.score(), -10);
      },
    );
    test(
      "after some correct and some incorrect guesses!<6",
      () {
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //Guess 2 correct
        hangmanGame.guess('b');
        hangmanGame.guess('a');
        //Guess 1 incorrect letter
        hangmanGame.guess('z');
        //We expect the score to be 15
        expect(hangmanGame.score(), 15);
      },
    );
    test(
      "after all letters guessed!<6",
      () {
        String word = 'banana';
        final hangmanGame = HangmanGame(word);
        //Guess all
        hangmanGame.guess('b');
        hangmanGame.guess('a');
        hangmanGame.guess('n');
        //We expect the score to be 30
        expect(hangmanGame.score(), 30);
      },
    );
  });
  group("Test Scoring Logic<6", () {
    test(
      "starts on 5",
      () {
        String word = 'banan';
        final hangmanGame = HangmanGame(word);
        //We expect the score to be 5
        expect(hangmanGame.score(), 5);
      },
    );
    test(
      "after a single correct guess<6",
      () {
        String word = 'banan';
        final hangmanGame = HangmanGame(word);
        //Guess one correct letter
        hangmanGame.guess('b');
        //We expect the score to be 15
        expect(hangmanGame.score(), 15);
      },
    );
    test(
      "after a single incorrect guess<6",
      () {
        String word = 'banan';
        final hangmanGame = HangmanGame(word);
        //Guess one incorrect letter
        hangmanGame.guess('z');
        //We expect the score to be 0
        expect(hangmanGame.score(), 0);
      },
    );
    test(
      "after multiple correct guesses<6",
      () {
        String word = 'banan';
        final hangmanGame = HangmanGame(word);
        //Guess 2+ correct letters
        hangmanGame.guess('b');
        hangmanGame.guess('a');
        //We expect the score to be 25
        expect(hangmanGame.score(), 25);
      },
    );
    test(
      "after multiple incorrect guesses<6",
      () {
        String word = 'banan';
        final hangmanGame = HangmanGame(word);
        //Guess 2 incorrect letters
        hangmanGame.guess('z');
        hangmanGame.guess('r');
        //We expect the score to be -5
        expect(hangmanGame.score(), -5);
      },
    );
    test(
      "after some correct and some incorrect guesses<6",
      () {
        String word = 'banan';
        final hangmanGame = HangmanGame(word);
        //Guess 2 correct
        hangmanGame.guess('b');
        hangmanGame.guess('a');
        //Guess 1 incorrect letter
        hangmanGame.guess('z');
        //We expect the score to be 20
        expect(hangmanGame.score(), 20);
      },
    );
    test(
      "after all letters guessed<6",
      () {
        String word = 'banan';
        final hangmanGame = HangmanGame(word);
        //Guess all
        hangmanGame.guess('b');
        hangmanGame.guess('a');
        hangmanGame.guess('n');
        //We expect the score to be 35
        expect(hangmanGame.score(), 35);
      },
    );
  });
  //group('Widget Tests', () {
  // test(
  //    'Win screen Score',
  //    () {

  //   },
  //  );
  // });
  //also missing lose screen score
}
