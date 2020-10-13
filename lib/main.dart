import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DarkLightTheme();
  }
}

class DarkLightTheme extends StatefulWidget {
  const DarkLightTheme({
    Key key,
  }) : super(key: key);

  @override
  _DarkLightThemeState createState() => _DarkLightThemeState();
}

ThemeData _lightTheme = ThemeData(
  accentColor: Colors.purple,
  brightness: Brightness.light,
  primaryColor: Colors.green,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.green,
    textTheme: ButtonTextTheme.primary,
  ),
);

ThemeData _darkTheme = ThemeData(
  accentColor: Colors.tealAccent,
  brightness: Brightness.dark,
  primaryColor: Colors.tealAccent,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.tealAccent,
    textTheme: ButtonTextTheme.primary,
  ),
);

bool _light = true;
Future<bool> _lightF;

class _DarkLightThemeState extends State<DarkLightTheme> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _saveTheme() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('theme', _light);
  }

  _getTheme() async {
    _lightF = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('theme') != null ? prefs.getBool('theme') : true;
    });
    _light = await _lightF;
  }

  @override
  void initState() {
    super.initState();
    _getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _lightF,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Text('Loading...'),
                ),
              ),
            );
          }
          return MaterialApp(
            title: 'Dynamic Theme Switcher',
            debugShowCheckedModeBanner: false,
            theme: _light ? _lightTheme : _darkTheme,
            darkTheme: _darkTheme,
            home: Scaffold(
              appBar: AppBar(
                title: Text('Dynamic Theme Switcher'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 250,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Enter Name",
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text('Click Me'),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text('Switch Theme'),
                    Switch(
                      inactiveThumbColor: _light
                          ? _lightTheme.accentColor
                          : _darkTheme.accentColor,
                      inactiveTrackColor: _light
                          ? _lightTheme.accentColor
                          : _darkTheme.primaryColor,
                      value: _light,
                      onChanged: (state) {
                        setState(() {
                          _light = state;
                        });
                        _saveTheme();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
