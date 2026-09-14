import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach.freezed.dart';
part 'coach.g.dart';

/// Coach/Team member profile for private coaching
@freezed
class Coach with _$Coach {
  const factory Coach({
    required String id,
    required String name,
    String? title,
    String? bio,
    String? avatarUrl,
    @Default([]) List<String> specialties,
    double? rating,
    @Default(0) int totalSessions,
    int? pricePerSession,
    @Default(true) bool isAvailable,
    @Default(false) bool isPrivateCoach,
    @Default(true) bool acceptsNewClients,
    double? privateSessionPrice,
    DateTime? createdAt,
    // New fields from team_members table
    String? role, // 'coach', 'nutritionist', 'physiotherapist'
    int? experienceYears,
    @Default([]) List<String> certifications,
    String? email,
    String? phone,
    String? socialInstagram,
    String? socialLinkedin,
  }) = _Coach;

  factory Coach.fromJson(Map<String, dynamic> json) => _$CoachFromJson(json);
}

/// Coaching request from user to coach
@freezed
class CoachingRequest with _$CoachingRequest {
  const factory CoachingRequest({
    required String id,
    required String userId,
    required String coachId,
    String? message,
    required CoachingRequestStatus status,
    DateTime? respondedAt,
    String? responseMessage,
    required DateTime createdAt,
  }) = _CoachingRequest;

  factory CoachingRequest.fromJson(Map<String, dynamic> json) =>
      _$CoachingRequestFromJson(json);
}

/// Status of a coaching request
enum CoachingRequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
}

/// Private coaching client relationship
@freezed
class PrivateCoachingClient with _$PrivateCoachingClient {
  const factory PrivateCoachingClient({
    required String id,
    required String coachId,
    required String clientUserId,
    required CoachingClientStatus status,
    DateTime? startedAt,
    String? notes,
    required DateTime createdAt,
  }) = _PrivateCoachingClient;

  factory PrivateCoachingClient.fromJson(Map<String, dynamic> json) =>
      _$PrivateCoachingClientFromJson(json);
}

/// Status of a coaching client relationship
enum CoachingClientStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('active')
  active,
  @JsonValue('paused')
  paused,
  @JsonValue('cancelled')
  cancelled,
}
