/// Utility functions for handling YouTube URLs and video IDs
class YouTubeUtils {
  /// Extract video ID from various YouTube URL formats
  static String? extractVideoId(String url) {
    if (url.isEmpty) return null;

    // Already a video ID (11 characters)
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(url)) {
      return url;
    }

    // Standard YouTube URL patterns
    final patterns = [
      // youtu.be/VIDEO_ID
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
      // youtube.com/watch?v=VIDEO_ID
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]{11})'),
      // youtube.com/embed/VIDEO_ID
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})'),
      // youtube.com/v/VIDEO_ID
      RegExp(r'youtube\.com/v/([a-zA-Z0-9_-]{11})'),
      // youtube.com/shorts/VIDEO_ID
      RegExp(r'youtube\.com/shorts/([a-zA-Z0-9_-]{11})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }

    return null;
  }

  /// Check if a URL is a valid YouTube URL
  static bool isYouTubeUrl(String url) {
    return extractVideoId(url) != null;
  }

  /// Get thumbnail URL for a YouTube video
  static String getThumbnailUrl(
    String videoId, {
    YouTubeThumbnailQuality quality = YouTubeThumbnailQuality.high,
  }) {
    final qualityStr = switch (quality) {
      YouTubeThumbnailQuality.defaultQuality => 'default',
      YouTubeThumbnailQuality.medium => 'mqdefault',
      YouTubeThumbnailQuality.high => 'hqdefault',
      YouTubeThumbnailQuality.standard => 'sddefault',
      YouTubeThumbnailQuality.maxRes => 'maxresdefault',
    };
    return 'https://img.youtube.com/vi/$videoId/$qualityStr.jpg';
  }

  /// Get embed URL for a YouTube video
  static String getEmbedUrl(String videoId) {
    return 'https://www.youtube.com/embed/$videoId';
  }

  /// Get watch URL for a YouTube video
  static String getWatchUrl(String videoId) {
    return 'https://www.youtube.com/watch?v=$videoId';
  }
}

/// YouTube thumbnail quality options
enum YouTubeThumbnailQuality {
  defaultQuality, // 120x90
  medium, // 320x180
  high, // 480x360
  standard, // 640x480
  maxRes, // 1280x720 (may not exist for all videos)
}
