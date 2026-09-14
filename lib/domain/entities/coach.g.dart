// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachImpl _$$CoachImplFromJson(Map<String, dynamic> json) => _$CoachImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble(),
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
      pricePerSession: (json['pricePerSession'] as num?)?.toInt(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      isPrivateCoach: json['isPrivateCoach'] as bool? ?? false,
      acceptsNewClients: json['acceptsNewClients'] as bool? ?? true,
      privateSessionPrice: (json['privateSessionPrice'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      role: json['role'] as String?,
      experienceYears: (json['experienceYears'] as num?)?.toInt(),
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      socialInstagram: json['socialInstagram'] as String?,
      socialLinkedin: json['socialLinkedin'] as String?,
    );

Map<String, dynamic> _$$CoachImplToJson(_$CoachImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'bio': instance.bio,
      'avatarUrl': instance.avatarUrl,
      'specialties': instance.specialties,
      'rating': instance.rating,
      'totalSessions': instance.totalSessions,
      'pricePerSession': instance.pricePerSession,
      'isAvailable': instance.isAvailable,
      'isPrivateCoach': instance.isPrivateCoach,
      'acceptsNewClients': instance.acceptsNewClients,
      'privateSessionPrice': instance.privateSessionPrice,
      'createdAt': instance.createdAt?.toIso8601String(),
      'role': instance.role,
      'experienceYears': instance.experienceYears,
      'certifications': instance.certifications,
      'email': instance.email,
      'phone': instance.phone,
      'socialInstagram': instance.socialInstagram,
      'socialLinkedin': instance.socialLinkedin,
    };

_$CoachingRequestImpl _$$CoachingRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CoachingRequestImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      coachId: json['coachId'] as String,
      message: json['message'] as String?,
      status: $enumDecode(_$CoachingRequestStatusEnumMap, json['status']),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      responseMessage: json['responseMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CoachingRequestImplToJson(
        _$CoachingRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'coachId': instance.coachId,
      'message': instance.message,
      'status': _$CoachingRequestStatusEnumMap[instance.status]!,
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'responseMessage': instance.responseMessage,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$CoachingRequestStatusEnumMap = {
  CoachingRequestStatus.pending: 'pending',
  CoachingRequestStatus.accepted: 'accepted',
  CoachingRequestStatus.declined: 'declined',
};

_$PrivateCoachingClientImpl _$$PrivateCoachingClientImplFromJson(
        Map<String, dynamic> json) =>
    _$PrivateCoachingClientImpl(
      id: json['id'] as String,
      coachId: json['coachId'] as String,
      clientUserId: json['clientUserId'] as String,
      status: $enumDecode(_$CoachingClientStatusEnumMap, json['status']),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PrivateCoachingClientImplToJson(
        _$PrivateCoachingClientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coachId': instance.coachId,
      'clientUserId': instance.clientUserId,
      'status': _$CoachingClientStatusEnumMap[instance.status]!,
      'startedAt': instance.startedAt?.toIso8601String(),
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$CoachingClientStatusEnumMap = {
  CoachingClientStatus.pending: 'pending',
  CoachingClientStatus.active: 'active',
  CoachingClientStatus.paused: 'paused',
  CoachingClientStatus.cancelled: 'cancelled',
};
