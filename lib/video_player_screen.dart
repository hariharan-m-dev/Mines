// lib/video_player_screen.dart

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? youtubeUrl; // This will receive the YouTube URL

  const VideoPlayerScreen({super.key, this.youtubeUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    // Validate the incoming URL and extract the video ID
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl ?? '');

    // Initialize the YouTube player controller
    _ytController = YoutubePlayerController(
      initialVideoId: videoId ?? '', // Use the extracted ID, or empty if invalid
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
        isLive: false,
        forceHD: false, // Set to true for HD playback
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _ytController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.youtubeUrl == null || YoutubePlayer.convertUrlToId(widget.youtubeUrl!) == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Invalid YouTube video URL.', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _ytController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber, // Customize progress bar color
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () {
          // You can add logic here when the player is ready
          _ytController.play();
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('Video of the Day'),
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: player, // This displays the YouTube player
          ),
        );
      },
    );
  }
}