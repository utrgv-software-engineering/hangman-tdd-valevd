import 'package:flutter/material.dart';
import 'package:hangman_game/models/hangmangame.dart';
import 'package:hangman_game/config/globals.dart';

import 'gamescreen.dart';

// ignore: must_be_immutable
class WinScreen extends StatelessWidget {
  HangmanGame gamec;
  //This should be modified to take in a HangmanGame
  WinScreen(this.gamec);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Here we are giving the win game text field a key for use in our integration tests in test_driver/app_test.dart
            Text("You Win",
                style: TextStyle(fontSize: 50), key: Key('win-game-text')),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            ),
            SizedBox(
                height: 300,
                child: Image(image: AssetImage('assets/progress_8.png'))),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            ),
            ElevatedButton(
                //Here we are giving the new game button a key for use in our integration tests in test_driver/app_test.dart
                key: Key('new-game-btn'),
                child: Text("New Game", style: TextStyle(fontSize: 25)),
                onPressed: () async {
                  //This sets up a new game
                  String word =
                      await HangmanGame.getStartingWord(areWeInIntegrationTest);
                  HangmanGame game = HangmanGame(word);

                  // ignore: todo
                  //TODO: Push a GameScreen and give it the HangmanGame
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen(game)),
                  );
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
              child:
                  Text("Score: ${gamec.score()}", key: Key('win-score-text')),
            ),
          ],
        ),
      ),
    ));
  }
}
