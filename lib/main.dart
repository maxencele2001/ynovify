import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:project/music.dart';
import 'page_manager.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  late PageManager _pageManager;
  bool _isShuffle = false; 
  static List<Music> _musicsOriginals = <Music> [
    Music(1,'Cringe','./assets/fin-frerot-tu-es-cringe.mp3',AssetImage('../assets/victor_tollemer.jpg'),'author'),
    Music(2,'Tellement de choses a te dire','./assets/conference-de-presse-masterclass-de-thierry-henry-3-memes-en-moins-dune-minute.mp3',AssetImage('../assets/poupou.PNG'),'Maxence'),
    Music(3,'Filon','./assets/filon.mp3',AssetImage('../assets/filon.png'),'Ninho'),
    Music(3,'Jefe','./assets/jefe.mp3',AssetImage('../assets/jefe.jpg'),'Ninho'),
  ];
  static List<Music> _musics = _musicsOriginals;

  _shuffle(){
    if(_isShuffle){
      _musics == _musicsOriginals;
      _isShuffle = false;
    }else{
      _musics.shuffle();
      _isShuffle = true;
    }
  }

  _previous() {
    setState(() {
      _pageManager.pause();
      if(_selectedIndex > 0){
        _selectedIndex--;
      }else{
        _selectedIndex = _musics.length - 1;
      }
      _pageManager = PageManager(_musics.elementAt(_selectedIndex).soundLink);
      _pageManager.play();
    });
  }
  _next() {
    setState(() {
      _pageManager.pause();
      if(_selectedIndex < _musics.length - 1){
        _selectedIndex++;
      }else{
        _selectedIndex = 0;
      }
      _pageManager = PageManager(_musics.elementAt(_selectedIndex).soundLink);
      _pageManager.play();
    });
  }

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager(_musics.elementAt(0).soundLink);
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              
                  Image(
                  image: _musics.elementAt(_selectedIndex).picture,
                  ),
                
            
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(
                    _musics.elementAt(_selectedIndex).name
                  ),
                ]
              ),
              
              
              
                ValueListenableBuilder<ProgressBarState>(
                  valueListenable: _pageManager.progressNotifier,
                  builder: (_, value, __) {
                    return ProgressBar(
                      progress: value.current,
                      buffered: value.buffered,
                      total: value.total,
                      onSeek: _pageManager.seek,
                    );
                  },
                ),
              
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  IconButton(
                  icon : const Icon(Icons.skip_previous_rounded),
                  onPressed: _previous,
                  ),
                  ValueListenableBuilder<ButtonState>(
                valueListenable: _pageManager.buttonNotifier,
                builder: (_, value, __) {
                  switch (value) {
                    case ButtonState.loading:
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 32.0,
                        height: 32.0,
                        child: const CircularProgressIndicator(),
                      );
                    case ButtonState.paused:
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 32.0,
                        onPressed: _pageManager.play,
                      );
                    case ButtonState.playing:
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        iconSize: 32.0,
                        onPressed: _pageManager.pause,
                      );
                  }
                },
                
              ),
              IconButton(
                  icon : const Icon(Icons.skip_next_rounded),
                  onPressed: _next,
                ),
                IconButton(
                  icon : const Icon(Icons.shuffle),
                  onPressed: _shuffle,
                ),
              ] 
                
              )
              
            ],
          ),
        ),
      ),
    );
  }
}