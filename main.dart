import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text('Focus: The Concetration App'),
          ),
        ),
        body: FirstPage(),
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with TickerProviderStateMixin {
  var image = 'LightRain';
  AnimationController playPauseController;
  bool isSongPlaying = false;
  bool istimerPaused= false;
  AudioCache audioCache = new AudioCache();
  AudioCache audioCache1 = new AudioCache();
  AudioPlayer advancedPlayer = new AudioPlayer();
  AudioPlayer advancedPlayer1 = new AudioPlayer();
  Timer _timer;
  int _start = 0;
  bool isButtonPressed = false;
  List<bool> _listColor = [false, false, false, false];
  int _minutes=0, _seconds=0;

  int count = 0;
  var imageList = [
    'LightRain',
    'Nature',
    'Waterstream',
    'Waves',
    'Lake',
    'Airplane'
  ];

  String localFilePath;
  Duration _duration = new Duration();
  Duration _position = new Duration();

  @override
  void initState() {
    super.initState();
    initPlayer();
    playPauseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  void startTimer() {
    istimerPaused=false;
    const oneMin = const Duration(minutes: 1);
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
              _minutes=_start~/60;
              _seconds = _start%60;
          if (_start < 1) {
            playSong();
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void timerStart() {

    audioCache.loop('music/$image' '_Part1.mp3');
    audioCache1.loop('music/$image' '_Part2.mp3');
    playPauseController.forward();
    isSongPlaying = !isSongPlaying;
    startTimer();
  }

  void timerCancel() {
    if (_start > 1) {
      _timer.cancel();
      istimerPaused=true;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  playSong() {
    if (isSongPlaying) {
      advancedPlayer.pause();
      advancedPlayer1.pause();
      playPauseController.reverse();
      timerCancel();

    } else {
      audioCache.loop('music/$image' '_Part1.mp3');
      audioCache1.loop('music/$image' '_Part2.mp3');
      playPauseController.forward();
      if (istimerPaused){
        startTimer();
      }
      //startTimer();

    }
    isSongPlaying = !isSongPlaying;
  }

  change() {
    setState(() {
      // count = count+1;
      image = imageList[count];
      audioCache.loop('music/$image' '_Part1.mp3');
      audioCache1.loop('music/$image' '_Part2.mp3');
      playPauseController.forward();
      isSongPlaying = !isSongPlaying;
    });
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    advancedPlayer1 = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    audioCache1 = new AudioCache(fixedPlayer: advancedPlayer1);

    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            Expanded(
              //Stretches to column to use all the available space
              //First Block
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, //positions to column at the start of the row
                children: [
                  //2nd block
                  Container(
                    padding: const EdgeInsets.only(left: 18),
                    child: Center(
                      child: Text(
                        '$image',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Third block
          ],
        ));

    Color color = Theme.of(context).primaryColor;

    void seekToSecond(int second) {
      Duration newDuration = Duration(seconds: second);
      advancedPlayer.seek(newDuration);
    }

    Widget slider() {
      return Slider(
          value: _position.inSeconds.toDouble(),
          min: 0.0,
          max: _duration.inSeconds.toDouble(),
          onChanged: (double value) {
            setState(() {
              seekToSecond(value.toInt());
              value = value;
            });
          });
    }

    Expanded timerButtons({String timerText, int timerTime, int btnNumber}){
      return Expanded(
        child: RaisedButton(
          splashColor:  Colors.orange,
          color: _listColor[btnNumber] ? Colors.green : Colors.red,
          onPressed:(){
            timerCancel();
            _start = timerTime;
            _listColor = [false, false, false, false];

            timerStart();
            setState(() {
              //isButtonPressed = !isButtonPressed;
              _listColor[btnNumber]= !_listColor[btnNumber];
            });
          },
          child: Text(timerText),
        ),
      );

    }

    Widget timerSection = Container(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.max,

          children: <Widget>[
            const SizedBox(width: 1),
            timerButtons(timerText: "10", timerTime: 600, btnNumber: 0),

            SizedBox(width: 05,),
            timerButtons(timerText: "20", timerTime: 1200, btnNumber: 1),

            SizedBox(width: 05,),

            timerButtons(timerText: "30", timerTime: 1800, btnNumber: 2),
            SizedBox(width: 05,),

            timerButtons(timerText: "45", timerTime: 2700, btnNumber: 3),
            SizedBox(width: 05,),

         Expanded(
              flex: 1,
              child: RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {
                //  _timer.cancel();
                  playSong();
                },
                child: Text("$_minutes:$_seconds"),
              ),
            ),


          ],
        ),
      ),
    ));

    Widget buttonSection = Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: _buildButtonColumn(
                  color,
                  Icons.skip_previous,
                  'Previous',
                ),
                onTap: () {
                  if (count == 0) {
                    count = 5;
                  }
                  count = count - 1;
                  change();
                },
              ),

              Center(
                child: InkWell(
                  onTap: () {
                    playSong();

                    //  playSongAgain();
                  },
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: playPauseController,
                    color: Colors.black,
                    size: 60,
                  ),
                ),
              ),

              InkWell(
                child: _buildButtonColumn(color, Icons.skip_next, 'Next'),
                onTap: () {
                  if (count == 5) {
                    count = -1;
                  }
                  count = count + 1;
                  change();
                },
              ),
              // slider(),
            ],
          ),
        ),
      ),
    );

    return Container(
      child: ListView(
        children: <Widget>[
          Image.asset(
            'assets/images/$image.jpeg',
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.height / 1.51,
            fit: BoxFit.cover,
          ),
          Center(child: titleSection),
          Center(child: buttonSection),
          Center(child: timerSection),
          // Center(child: slider()),
          // Text('Testing Text : $image'),
          //textSection,
        ],
      ),
    );
  }
}

Column _buildButtonColumn(Color color, IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        icon,
        color: Colors.black,
        size: 30,
      ),
      Container(
        margin: const EdgeInsets.only(top: 2),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}

