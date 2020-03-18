import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_player/models/player_type.dart';
import 'package:awesome_player/pages/audio/audio_local.dart';
import 'package:awesome_player/pages/video/video_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import 'models/media_file.dart';
import 'widgets/add_media_buttons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Awesome Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // audio player initialization
  // this creates a single AudioPlayer base on uuid for audio files
  static final _audioPlayerId = Uuid().v4();
  AudioPlayer _audioPlayer = AudioPlayer(playerId: _audioPlayerId);
  StreamSubscription<Duration> _positionSubscription;
  StreamSubscription<AudioPlayerState> _audioPlayerStateSubscription;

  // video player initialization
  VideoPlayerController _videoController;
  VideoPlayer _videoPlayer;

  // current media player
  PlayerType _currentPlayer = PlayerType.none;

  // panel initialization
  PanelController _panelController;

  // current playlist
  List<MediaFile> files;

  // current item playing
  String _selectedMedia;
  bool _isPlaying = false;

  Duration duration;
  int time;
  double progress = 0.0;
  // String timeLeft = "";

  // bottom appbar visibility
  bool _isPlayerVisible = false;

  // bottom appbar Icon
  IconData _currentPlayingIcon;

  @override
  void initState() {
    super.initState();
    //_videoController = VideoPlayerController.;
    _panelController = PanelController();
    files = List<MediaFile>();

    if (_audioPlayer != null || _videoController != null) {
      _audioPlayerStateSubscription =
          _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
        if (state == AudioPlayerState.PLAYING ||
            _videoController.value.isPlaying) {
          setState(() {
            _isPlaying = true;
            _isPlayerVisible = true;
            _currentPlayingIcon = Icons.pause;
          });
        }
        if (state == AudioPlayerState.PAUSED
            //|| _videoController.value.isBuffering
            ) {
          setState(() {
            _isPlaying = false;
            _currentPlayingIcon = Icons.play_circle_outline;
          });

          if (state == AudioPlayerState.STOPPED ||
              state == AudioPlayerState.COMPLETED) {
            setState(() {
              _isPlaying = false;
              _isPlayerVisible = false;
              //_currentPlayingIcon = Icons.play_arrow;
            });
          }
        }
      });

      _positionSubscription =
          _audioPlayer.onAudioPositionChanged.listen((Duration p) async {
        time = await _audioPlayer.getDuration();
        duration = p;
        if (duration == null) {
          //timeLeft = "Time Left 0s/0s";
        } else {
          //timeLeft = "Time Left ${duration.inSeconds}s/${time / 1000}s";
        }
        if (time == null || duration == null) {
          progress = 0.0;
        } else {
          progress = (duration.inMilliseconds) / time;
        }
        setState(() {});
      });
    }
  }

  void getVideoControllerInstance(VideoPlayerController controller) {
    _videoController = controller;
    _videoPlayer = VideoPlayer(_videoController);
    isPlayerInitialized = true;
    _currentPlayer = PlayerType.videoPlayer;
  }

  @override
  void dispose() {
    //_videoController.dispose();
    _panelController.close();
    super.dispose();
  }

  void disposeAudioPlayer() async {
    _currentPlayer = PlayerType.none;

    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    if (_audioPlayer.state == AudioPlayerState.COMPLETED ||
        _audioPlayer.state == AudioPlayerState.PAUSED ||
        _audioPlayer.state == AudioPlayerState.PLAYING) {
      _audioPlayer.stop();
      // await _audioPlayer.release();
      // await _audioPlayer.dispose();
    }
  }

  void disposeVideoPlayer() async {
    //_videoController.value.
    _currentPlayer = PlayerType.audioPlayer;
    _videoController.removeListener(() {});
    _videoController.pause();
    //_isPlayerInitialized = false;
    isPlayerInitialized = false;
    _needReInstantiate = true;
    //_videoController.dispose();
    //_videoController = VideoPlayerController.file(File(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: SlidingPanel(panelController: _panelController, files: files),
      body: files == null || files.isEmpty
          ? Container(
              color: Color.fromRGBO(33, 33, 33, 1),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.playlist_add,
                      size: 70,
                      color: Colors.blueGrey,
                    ),
                    Text('Empty playlist',
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.blueGrey,
                        )),
                  ],
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.only(top: 90, left: 5, right: 5),
              child: mediaListView(),
              color: Color.fromRGBO(22, 22, 22, 1),
            ),
      floatingActionButton: AddActionButtons(
        addAudioFile: _pickAudioFileFrom,
        addVideoFile: _pickVideoFileFrom,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _isPlayerVisible
          ? bottomAppBar()
          : Container(
              height: 0,
              color: Colors.red,
            ),
    );
  }

  // Bottom App Bar
  BottomAppBar bottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Container(
        height: 80.0,
        //color: Color.fromRGBO(132, 218, 165, 1),
        color: Color.fromRGBO(75, 75, 75, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: IconButton(
                  icon: Icon(
                    _currentPlayingIcon,
                    color: Colors.white54,
                    size: 35,
                  ),
                  onPressed: () {
                    if (_audioPlayer.state == AudioPlayerState.PLAYING) {
                      _audioPlayer.pause();
                      _currentPlayingIcon = Icons.play_circle_outline;
                    }
                    if (_audioPlayer.state == AudioPlayerState.PAUSED) {
                      _audioPlayer.resume();
                      _currentPlayingIcon = Icons.pause;
                    }
                  }),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(70, 70, 70, 0.7)),
                    value: progress,
                  ),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        child: bottomPlayer(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  icon: Icon(Icons.favorite, color: Colors.white54),
                  onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomPlayer() {
    if (_currentPlayer == PlayerType.audioPlayer) {
      return Text(
        _selectedMedia,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white54),
      );
    } else if (_currentPlayer == PlayerType.videoPlayer) {
      return Container(
        height: 80,
        child: AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        ),
      );
    } else {
      return Container();
    }
  }

  _pickVideoFileFrom() async {
    File videoFile = await FilePicker.getFile(type: FileType.video);
    if (videoFile != null) {
      setState(() {
        files.add(MediaFile(
            fileName: basename(videoFile.path),
            file: videoFile,
            fileType: MediaType.video));
      });
    }
  }

  _pickAudioFileFrom() async {
    File audioFile = await FilePicker.getFile(type: FileType.audio);
    if (audioFile != null) {
      setState(() {
        files.add(MediaFile(
            fileName: basename(audioFile.path),
            file: audioFile,
            fileType: MediaType.audio));
      });
    }
  }

  bool _isPlayerInitialized = false;
  bool _needReInstantiate = false;

  bool get isPlayerInitialized => _isPlayerInitialized ?? false;
  // {
  //   var s = false;
  //   var d = false;
  //   if (_videoController != null &&
  //       _videoController.value.initialized != null) {
  //     s = _videoController.value.initialized;
  //     d = _videoController == null;
  //   }

  //   return s;
  // }

  set isPlayerInitialized(bool initialized) {
    _needReInstantiate = !initialized;
    var s = false;
    var d = false;
    if (_videoController != null &&
        _videoController.value.initialized != null) {
      s = _videoController.value.initialized;
      d = _videoController == null;
    }
    //return s;
    if (initialized) {
      _isPlayerInitialized = true;
      _isPlayerVisible = true;
    } else {
      _isPlayerInitialized = s;
    }
  }

  // ListView
  Widget mediaListView() {
    return ListView.builder(
      itemCount: files != null && files.isNotEmpty ? files.length : 1,
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          child: Card(
            color: Color.fromRGBO(36, 36, 36, 1),
            elevation: 20,
            child: ListTile(
              title: Text(
                files[index].fileName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // if (_currentPlayer == PlayerType.videoPlayer) {
                //   //disposeVideoPlayer
                // }
                // if (_currentPlayer == PlayerType.audioPlayer) {
                //   disposeAudioPlayer();
                // }

                _selectedMedia = files[index].fileName;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            files[index].fileType == MediaType.audio
                                ? AudioLocal(
                                    audioPlayer: _audioPlayer,
                                    audioPlayerId: _audioPlayerId,
                                    file: files[index].file,
                                    videoPlayerDisposable: disposeVideoPlayer)
                                : VideoFile(
                                    videoPlayer: _videoPlayer,
                                    videoPlayerController: _videoController,
                                    file: files[index].file,
                                    audioPlayerDisposable: disposeAudioPlayer,
                                    videoControllerInstance:
                                        getVideoControllerInstance,
                                    isPlayerInitialized: isPlayerInitialized,
                                    needReInstantiation: _needReInstantiate)));
              },
            ),
          ),
        );
      },
    );
  }
}
