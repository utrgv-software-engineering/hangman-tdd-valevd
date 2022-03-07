import 'package:http/http.dart' as http;

class HangmanGame {
  String _word;
  String _correctGuesses = "";
  String _wrongGuesses = "";
  int _score;

  //Constructor starts off with blank strings that we will concatenate during the course of play
  HangmanGame(String word) {
    _word = word;
    _correctGuesses = "";
    _wrongGuesses = "";
    if (_word.length < 5) {
      // longer == easier
      _score = 5;
    } else if (_word.length > 4) {
      // longer == easier
      _score = 0;
    }
  }

  int score() {
    return _score;
  }

  String correctGuesses() {
    return _correctGuesses;
  }

  String wrongGuesses() {
    return _wrongGuesses;
  }

  String word() {
    return _word;
  }

  bool guess(String letter) {
    // TODO: Fill this in

    RegExp validChar = new RegExp(r'[a-zA-Z]');
    // aA-zZ char || not null || not empty string
    if (!validChar.hasMatch(letter) ||
        letter == null ||
        letter == "" ||
        letter.length > 1) {
      throw ArgumentError();
    }
    letter = letter.toLowerCase();

    if (_word.contains(letter)) {
      if (_correctGuesses.contains(letter)) {
        return false;
      }
      _correctGuesses += letter;
      _score += 10;

      return true;
    } else {
      if (_wrongGuesses.contains(letter)) {
        return false;
      }
      _wrongGuesses += letter;
      _score -= 5;
      return true;
    }
  }

  String blanksWithCorrectGuesses() {
    // TODO: Fill this in
    String hold = "";
    for (int i = 0; i < _word.length; i++) {
      if (_correctGuesses.contains(_word[i])) {
        hold += _word[i];
      } else {
        hold += "-";
      }
    }
    return hold;
  }

  String status() {
    // TODO: Fill this in
    if (_wrongGuesses.length >= 7) {
      return "lose";
    } else if (blanksWithCorrectGuesses() == _word) {
      return "win";
    } else {
      return "play";
    }
  }

  //when running integration tests always return "banana"
  static Future<String> getStartingWord(bool areWeInIntegrationTest) async {
    String word;
    Uri endpoint = Uri.parse("http://randomword.saasbook.info/RandomWord");
    if (areWeInIntegrationTest) {
      word = "banana";
    } else {
      try {
        var response = await http.post(endpoint);
        word = response.body;
      } catch (e) {
        word = "error";
      }
    }

    return word;
  }
}
