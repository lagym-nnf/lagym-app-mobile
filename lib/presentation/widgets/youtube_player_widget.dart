import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/youtube_utils.dart';

/// A widget that plays YouTube videos with full-screen support
class YouTubePlayerWidget extends StatefulWidget {
  final String youtubeUrl;
  final bool autoPlay;
  final bool showControls;
  final VoidCallback? onEnded;

  const YouTubePlayerWidget({
    super.key,
    required this.youtubeUrl,
    this.autoPlay = false,
    this.showControls = true,
    this.onEnded,
  });

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;
  late String? _videoId;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _videoId = YouTubeUtils.extractVideoId(widget.youtubeUrl);

    if (_videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: _videoId!,
        flags: YoutubePlayerFlags(
          autoPlay: widget.autoPlay,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
          hideControls: !widget.showControls,
          controlsVisibleAtStart: true,
        ),
      )..addListener(_listener);
    }
  }

  void _listener() {
    if (_isPlayerReady && mounted) {
      if (_controller.value.playerState == PlayerState.ended) {
        widget.onEnded?.call();
      }
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null) {
      return Container(
        color: AppColors.gray900,
        child: const Center(
          child: Text(
            'Invalid YouTube URL',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // Reset orientation when exiting fullscreen
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      onEnterFullScreen: () {
        // Allow landscape in fullscreen
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
        progressColors: ProgressBarColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          backgroundColor: Colors.grey.shade800,
          bufferedColor: Colors.grey.shade600,
        ),
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          widget.onEnded?.call();
        },
        topActions: [
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        bottomActions: [
          CurrentPosition(),
          const SizedBox(width: 8.0),
          ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
              playedColor: AppColors.primary,
              handleColor: AppColors.primary,
              backgroundColor: Colors.grey.shade800,
              bufferedColor: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 8.0),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) {
        return player;
      },
    );
  }
}

/// Full screen YouTube player page
class YouTubeFullScreenPlayer extends StatefulWidget {
  final String youtubeUrl;
  final String? title;

  const YouTubeFullScreenPlayer({
    super.key,
    required this.youtubeUrl,
    this.title,
  });

  @override
  State<YouTubeFullScreenPlayer> createState() => _YouTubeFullScreenPlayerState();
}

class _YouTubeFullScreenPlayerState extends State<YouTubeFullScreenPlayer> {
  late YoutubePlayerController _controller;
  late String? _videoId;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _videoId = YouTubeUtils.extractVideoId(widget.youtubeUrl);

    if (_videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: _videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      )..addListener(_listener);
    }

    // Force landscape for full screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      // Reset when exiting fullscreen
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    // Reset orientation
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Invalid YouTube URL',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: YoutubePlayerBuilder(
        onExitFullScreen: () {
          Navigator.pop(context);
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: AppColors.primary,
          progressColors: ProgressBarColors(
            playedColor: AppColors.primary,
            handleColor: AppColors.primary,
            backgroundColor: Colors.grey.shade800,
            bufferedColor: Colors.grey.shade600,
          ),
          onReady: () {
            _isPlayerReady = true;
          },
          topActions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                widget.title ?? _controller.metadata.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        builder: (context, player) {
          return SafeArea(
            child: player,
          );
        },
      ),
    );
  }
}
