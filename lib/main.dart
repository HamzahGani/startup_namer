import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// Main method, runs Class MyApp
void main() {
  runApp(const MyApp());
}

// Main Class of Application (Root)
//  Has 1 widget (the application root)
//    Title, Theme (ColorScheme), HomePage
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // WHAT IS Key / super ???
  @override // WHAT IS @override ???
  Widget build(BuildContext context) { // Application Root Widget
    return MaterialApp( // WHAT IS MaterialApp ???
      title: 'Startup Name Generator1', // Tab Title
      theme: ThemeData( // Application theme
        appBarTheme: const AppBarTheme( // AppBar ColorScheme
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
        ), ),
      home: RandomWords(), // Body - RandomWords widget
    );
  }
}

// Application Home Page
//  This widget is stateful (has a State object - contains fields that affect how it looks.)
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key); // constructor
  @override
  State<RandomWords> createState() => _RandomWordsState(); // Page State
}

// This class is the configuration for the state
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // array of random word pairs
  final _saved = <WordPair>{}; // saved word pairs
  final _biggerFont = const TextStyle(fontSize: 18); // font size for word pairs
  final _biggestFont = const TextStyle(fontSize: 28); // font size for saved word pairs
  @override

  Widget build(BuildContext context) {
    return Scaffold( // WHAT IS scaffold ???
      appBar: AppBar( // App bar
        title: const Text('Startup Name Generator2'), // Page title (top left)
        actions: [
          IconButton(
            icon: const Icon(Icons.list), // burger menu top right
            onPressed: _pushSaved, // opens a new page
            tooltip: 'Saved Suggestions',
          ),
        ]
      ),
      body: ListView.builder( // list
          padding: const EdgeInsets.all(16.0), // border around the list
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider(); // divider line between wordPairs

            final index = i ~/2;

            // lazy load - if the user reaches the end of the list, add 10 more
            if (index >= _suggestions.length) _suggestions.addAll(generateWordPairs().take(10));

            // bool for each list item - has the user saved it
            final alreadySaved = _saved.contains(_suggestions[index]);

            // List item - Title & onTap()
            return ListTile(
              title: // icon & Text
                Text(
                  _suggestions[index].asPascalCase,
                  style: _biggerFont,
                ),
                trailing: Icon( // changes if item is saved
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                  semanticLabel: alreadySaved? 'Remove from saved' : 'saved',
                ),
              onTap: () {
                setState(() { // if saved remove, else add
                  alreadySaved ? _saved.remove(_suggestions[index]) : _saved.add(_suggestions[index]);
                });
              },
            );
          }
      )
    );
  }

  // new page to load when burger menu (top right) is pressed
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map( (pair) { // array with list of tiles
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggestFont,
              ),
            );
          }, );
          // if tiles are not empty set savedList, else setList is empty Widgeet array
          final savedList = tiles.isNotEmpty
            ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
            : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'), // Page title (top left)
            ),
            body: ListView(children: savedList), // List from savedList
          );
        },
      ),
    );
  }
}