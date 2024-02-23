import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)),
      home:  VideoPlayerScreen(),
    );
  }
}



class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VlcPlayerController _controller;
  bool _isFullScreen = false;
  bool _isHiddenAppBar = false;

  @override
  void initState() {
    super.initState();
    _controller = VlcPlayerController.network(
      'https:\/\/live1.acangroup.org:1929\/acas\/asfiyahitv\/playlist.m3u8?wmsAuthSign=c2VydmVyX3RpbWU9Mi8yMy8yMDI0IDQ6MTM6MjUgUE0maGFzaF92YWx1ZT1oSmdYQ2MxOU5aT0pOMGQ1R2xtbEhBPT0mdmFsaWRtaW51dGVzPTMw',
      hwAcc: HwAcc.full,
      autoInitialize: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(10000),
        ]),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log("True or False ${_isHiddenAppBar}");
    return Scaffold(
      appBar: _isHiddenAppBar ? null : AppBar(
        title: Text('Lecture vidéo'),
      ),
      body: Center(
        child: Stack(
          children: [
            VlcPlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
              placeholder: Center(child: CircularProgressIndicator()),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isFullScreen = !_isFullScreen;
                    _isHiddenAppBar = !_isHiddenAppBar;

                  });
                  _toggleFullScreen();
                },
                child: _isFullScreen ? Icon(Icons.fullscreen_exit) : Icon(Icons.fullscreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFullScreen() {
    if (_isFullScreen) {
      // Sortir du mode plein écran
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      // Définir la taille originale
      setState(() {
        // Vous pouvez régler la taille comme vous le souhaitez
        _isHiddenAppBar=false;
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      });
    } else {
      // Entrer en mode plein écran
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      // Définir la rotation en paysage
      setState(() {
        _isHiddenAppBar=true;
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}