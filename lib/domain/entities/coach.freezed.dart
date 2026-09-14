// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Coach _$CoachFromJson(Map<String, dynamic> json) {
  return _Coach.fromJson(json);
}

/// @nodoc
mixin _$Coach {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  List<String> get specialties => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int get totalSessions => throw _privateConstructorUsedError;
  int? get pricePerSession => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  bool get isPrivateCoach => throw _privateConstructorUsedError;
  bool get acceptsNewClients => throw _privateConstructorUsedError;
  double? get privateSessionPrice => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // New fields from team_members table
  String? get role =>
      throw _privateConstructorUsedError; // 'coach', 'nutritionist', 'physiotherapist'
  int? get experienceYears => throw _privateConstructorUsedError;
  List<String> get certifications => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get socialInstagram => throw _privateConstructorUsedError;
  String? get socialLinkedin => throw _privateConstructorUsedError;

  /// Serializes this Coach to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Coach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachCopyWith<Coach> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachCopyWith<$Res> {
  factory $CoachCopyWith(Coach value, $Res Function(Coach) then) =
      _$CoachCopyWithImpl<$Res, Coach>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? title,
      String? bio,
      String? avatarUrl,
      List<String> specialties,
      double? rating,
      int totalSessions,
      int? pricePerSession,
      bool isAvailable,
      bool isPrivateCoach,
      bool acceptsNewClients,
      double? privateSessionPrice,
      DateTime? createdAt,
      String? role,
      int? experienceYears,
      List<String> certifications,
      String? email,
      String? phone,
      String? socialInstagram,
      String? socialLinkedin});
}

/// @nodoc
class _$CoachCopyWithImpl<$Res, $Val extends Coach>
    implements $CoachCopyWith<$Res> {
  _$CoachCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Coach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? title = freezed,
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? specialties = null,
    Object? rating = freezed,
    Object? totalSessions = null,
    Object? pricePerSession = freezed,
    Object? isAvailable = null,
    Object? isPrivateCoach = null,
    Object? acceptsNewClients = null,
    Object? privateSessionPrice = freezed,
    Object? createdAt = freezed,
    Object? role = freezed,
    Object? experienceYears = freezed,
    Object? certifications = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? socialInstagram = freezed,
    Object? socialLinkedin = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      specialties: null == specialties
          ? _value.specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerSession: freezed == pricePerSession
          ? _value.pricePerSession
          : pricePerSession // ignore: cast_nullable_to_non_nullable
              as int?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrivateCoach: null == isPrivateCoach
          ? _value.isPrivateCoach
          : isPrivateCoach // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsNewClients: null == acceptsNewClients
          ? _value.acceptsNewClients
          : acceptsNewClients // ignore: cast_nullable_to_non_nullable
              as bool,
      privateSessionPrice: freezed == privateSessionPrice
          ? _value.privateSessionPrice
          : privateSessionPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceYears: freezed == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int?,
      certifications: null == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      socialInstagram: freezed == socialInstagram
          ? _value.socialInstagram
          : socialInstagram // ignore: cast_nullable_to_non_nullable
              as String?,
      socialLinkedin: freezed == socialLinkedin
          ? _value.socialLinkedin
          : socialLinkedin // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoachImplCopyWith<$Res> implements $CoachCopyWith<$Res> {
  factory _$$CoachImplCopyWith(
          _$CoachImpl value, $Res Function(_$CoachImpl) then) =
      __$$CoachImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? title,
      String? bio,
      String? avatarUrl,
      List<String> specialties,
      double? rating,
      int totalSessions,
      int? pricePerSession,
      bool isAvailable,
      bool isPrivateCoach,
      bool acceptsNewClients,
      double? privateSessionPrice,
      DateTime? createdAt,
      String? role,
      int? experienceYears,
      List<String> certifications,
      String? email,
      String? phone,
      String? socialInstagram,
      String? socialLinkedin});
}

/// @nodoc
class __$$CoachImplCopyWithImpl<$Res>
    extends _$CoachCopyWithImpl<$Res, _$CoachImpl>
    implements _$$CoachImplCopyWith<$Res> {
  __$$CoachImplCopyWithImpl(
      _$CoachImpl _value, $Res Function(_$CoachImpl) _then)
      : super(_value, _then);

  /// Create a copy of Coach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? title = freezed,
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? specialties = null,
    Object? rating = freezed,
    Object? totalSessions = null,
    Object? pricePerSession = freezed,
    Object? isAvailable = null,
    Object? isPrivateCoach = null,
    Object? acceptsNewClients = null,
    Object? privateSessionPrice = freezed,
    Object? createdAt = freezed,
    Object? role = freezed,
    Object? experienceYears = freezed,
    Object? certifications = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? socialInstagram = freezed,
    Object? socialLinkedin = freezed,
  }) {
    return _then(_$CoachImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      specialties: null == specialties
          ? _value._specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerSession: freezed == pricePerSession
          ? _value.pricePerSession
          : pricePerSession // ignore: cast_nullable_to_non_nullable
              as int?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrivateCoach: null == isPrivateCoach
          ? _value.isPrivateCoach
          : isPrivateCoach // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsNewClients: null == acceptsNewClients
          ? _value.acceptsNewClients
          : acceptsNewClients // ignore: cast_nullable_to_non_nullable
              as bool,
      privateSessionPrice: freezed == privateSessionPrice
          ? _value.privateSessionPrice
          : privateSessionPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceYears: freezed == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int?,
      certifications: null == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      socialInstagram: freezed == socialInstagram
          ? _value.socialInstagram
          : socialInstagram // ignore: cast_nullable_to_non_nullable
              as String?,
      socialLinkedin: freezed == socialLinkedin
          ? _value.socialLinkedin
          : socialLinkedin // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachImpl implements _Coach {
  const _$CoachImpl(
      {required this.id,
      required this.name,
      this.title,
      this.bio,
      this.avatarUrl,
      final List<String> specialties = const [],
      this.rating,
      this.totalSessions = 0,
      this.pricePerSession,
      this.isAvailable = true,
      this.isPrivateCoach = false,
      this.acceptsNewClients = true,
      this.privateSessionPrice,
      this.createdAt,
      this.role,
      this.experienceYears,
      final List<String> certifications = const [],
      this.email,
      this.phone,
      this.socialInstagram,
      this.socialLinkedin})
      : _specialties = specialties,
        _certifications = certifications;

  factory _$CoachImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? title;
  @override
  final String? bio;
  @override
  final String? avatarUrl;
  final List<String> _specialties;
  @override
  @JsonKey()
  List<String> get specialties {
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialties);
  }

  @override
  final double? rating;
  @override
  @JsonKey()
  final int totalSessions;
  @override
  final int? pricePerSession;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  @JsonKey()
  final bool isPrivateCoach;
  @override
  @JsonKey()
  final bool acceptsNewClients;
  @override
  final double? privateSessionPrice;
  @override
  final DateTime? createdAt;
// New fields from team_members table
  @override
  final String? role;
// 'coach', 'nutritionist', 'physiotherapist'
  @override
  final int? experienceYears;
  final List<String> _certifications;
  @override
  @JsonKey()
  List<String> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? socialInstagram;
  @override
  final String? socialLinkedin;

  @override
  String toString() {
    return 'Coach(id: $id, name: $name, title: $title, bio: $bio, avatarUrl: $avatarUrl, specialties: $specialties, rating: $rating, totalSessions: $totalSessions, pricePerSession: $pricePerSession, isAvailable: $isAvailable, isPrivateCoach: $isPrivateCoach, acceptsNewClients: $acceptsNewClients, privateSessionPrice: $privateSessionPrice, createdAt: $createdAt, role: $role, experienceYears: $experienceYears, certifications: $certifications, email: $email, phone: $phone, socialInstagram: $socialInstagram, socialLinkedin: $socialLinkedin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            const DeepCollectionEquality()
                .equals(other._specialties, _specialties) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.pricePerSession, pricePerSession) ||
                other.pricePerSession == pricePerSession) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isPrivateCoach, isPrivateCoach) ||
                other.isPrivateCoach == isPrivateCoach) &&
            (identical(other.acceptsNewClients, acceptsNewClients) ||
                other.acceptsNewClients == acceptsNewClients) &&
            (identical(other.privateSessionPrice, privateSessionPrice) ||
                other.privateSessionPrice == privateSessionPrice) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.socialInstagram, socialInstagram) ||
                other.socialInstagram == socialInstagram) &&
            (identical(other.socialLinkedin, socialLinkedin) ||
                other.socialLinkedin == socialLinkedin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        title,
        bio,
        avatarUrl,
        const DeepCollectionEquality().hash(_specialties),
        rating,
        totalSessions,
        pricePerSession,
        isAvailable,
        isPrivateCoach,
        acceptsNewClients,
        privateSessionPrice,
        createdAt,
        role,
        experienceYears,
        const DeepCollectionEquality().hash(_certifications),
        email,
        phone,
        socialInstagram,
        socialLinkedin
      ]);

  /// Create a copy of Coach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachImplCopyWith<_$CoachImpl> get copyWith =>
      __$$CoachImplCopyWithImpl<_$CoachImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachImplToJson(
      this,
    );
  }
}

abstract class _Coach implements Coach {
  const factory _Coach(
      {required final String id,
      required final String name,
      final String? title,
      final String? bio,
      final String? avatarUrl,
      final List<String> specialties,
      final double? rating,
      final int totalSessions,
      final int? pricePerSession,
      final bool isAvailable,
      final bool isPrivateCoach,
      final bool acceptsNewClients,
      final double? privateSessionPrice,
      final DateTime? createdAt,
      final String? role,
      final int? experienceYears,
      final List<String> certifications,
      final String? email,
      final String? phone,
      final String? socialInstagram,
      final String? socialLinkedin}) = _$CoachImpl;

  factory _Coach.fromJson(Map<String, dynamic> json) = _$CoachImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get title;
  @override
  String? get bio;
  @override
  String? get avatarUrl;
  @override
  List<String> get specialties;
  @override
  double? get rating;
  @override
  int get totalSessions;
  @override
  int? get pricePerSession;
  @override
  bool get isAvailable;
  @override
  bool get isPrivateCoach;
  @override
  bool get acceptsNewClients;
  @override
  double? get privateSessionPrice;
  @override
  DateTime? get createdAt; // New fields from team_members table
  @override
  String? get role; // 'coach', 'nutritionist', 'physiotherapist'
  @override
  int? get experienceYears;
  @override
  List<String> get certifications;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get socialInstagram;
  @override
  String? get socialLinkedin;

  /// Create a copy of Coach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachImplCopyWith<_$CoachImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CoachingRequest _$CoachingRequestFromJson(Map<String, dynamic> json) {
  return _CoachingRequest.fromJson(json);
}

/// @nodoc
mixin _$CoachingRequest {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get coachId => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  CoachingRequestStatus get status => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  String? get responseMessage => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CoachingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachingRequestCopyWith<CoachingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachingRequestCopyWith<$Res> {
  factory $CoachingRequestCopyWith(
          CoachingRequest value, $Res Function(CoachingRequest) then) =
      _$CoachingRequestCopyWithImpl<$Res, CoachingRequest>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String coachId,
      String? message,
      CoachingRequestStatus status,
      DateTime? respondedAt,
      String? responseMessage,
      DateTime createdAt});
}

/// @nodoc
class _$CoachingRequestCopyWithImpl<$Res, $Val extends CoachingRequest>
    implements $CoachingRequestCopyWith<$Res> {
  _$CoachingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? coachId = null,
    Object? message = freezed,
    Object? status = null,
    Object? respondedAt = freezed,
    Object? responseMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      coachId: null == coachId
          ? _value.coachId
          : coachId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CoachingRequestStatus,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      responseMessage: freezed == responseMessage
          ? _value.responseMessage
          : responseMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoachingRequestImplCopyWith<$Res>
    implements $CoachingRequestCopyWith<$Res> {
  factory _$$CoachingRequestImplCopyWith(_$CoachingRequestImpl value,
          $Res Function(_$CoachingRequestImpl) then) =
      __$$CoachingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String coachId,
      String? message,
      CoachingRequestStatus status,
      DateTime? respondedAt,
      String? responseMessage,
      DateTime createdAt});
}

/// @nodoc
class __$$CoachingRequestImplCopyWithImpl<$Res>
    extends _$CoachingRequestCopyWithImpl<$Res, _$CoachingRequestImpl>
    implements _$$CoachingRequestImplCopyWith<$Res> {
  __$$CoachingRequestImplCopyWithImpl(
      _$CoachingRequestImpl _value, $Res Function(_$CoachingRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CoachingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? coachId = null,
    Object? message = freezed,
    Object? status = null,
    Object? respondedAt = freezed,
    Object? responseMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$CoachingRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      coachId: null == coachId
          ? _value.coachId
          : coachId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CoachingRequestStatus,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      responseMessage: freezed == responseMessage
          ? _value.responseMessage
          : responseMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachingRequestImpl implements _CoachingRequest {
  const _$CoachingRequestImpl(
      {required this.id,
      required this.userId,
      required this.coachId,
      this.message,
      required this.status,
      this.respondedAt,
      this.responseMessage,
      required this.createdAt});

  factory _$CoachingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachingRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String coachId;
  @override
  final String? message;
  @override
  final CoachingRequestStatus status;
  @override
  final DateTime? respondedAt;
  @override
  final String? responseMessage;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CoachingRequest(id: $id, userId: $userId, coachId: $coachId, message: $message, status: $status, respondedAt: $respondedAt, responseMessage: $responseMessage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachingRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.coachId, coachId) || other.coachId == coachId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.responseMessage, responseMessage) ||
                other.responseMessage == responseMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, coachId, message,
      status, respondedAt, responseMessage, createdAt);

  /// Create a copy of CoachingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachingRequestImplCopyWith<_$CoachingRequestImpl> get copyWith =>
      __$$CoachingRequestImplCopyWithImpl<_$CoachingRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachingRequestImplToJson(
      this,
    );
  }
}

abstract class _CoachingRequest implements CoachingRequest {
  const factory _CoachingRequest(
      {required final String id,
      required final String userId,
      required final String coachId,
      final String? message,
      required final CoachingRequestStatus status,
      final DateTime? respondedAt,
      final String? responseMessage,
      required final DateTime createdAt}) = _$CoachingRequestImpl;

  factory _CoachingRequest.fromJson(Map<String, dynamic> json) =
      _$CoachingRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get coachId;
  @override
  String? get message;
  @override
  CoachingRequestStatus get status;
  @override
  DateTime? get respondedAt;
  @override
  String? get responseMessage;
  @override
  DateTime get createdAt;

  /// Create a copy of CoachingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachingRequestImplCopyWith<_$CoachingRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrivateCoachingClient _$PrivateCoachingClientFromJson(
    Map<String, dynamic> json) {
  return _PrivateCoachingClient.fromJson(json);
}

/// @nodoc
mixin _$PrivateCoachingClient {
  String get id => throw _privateConstructorUsedError;
  String get coachId => throw _privateConstructorUsedError;
  String get clientUserId => throw _privateConstructorUsedError;
  CoachingClientStatus get status => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PrivateCoachingClient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrivateCoachingClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivateCoachingClientCopyWith<PrivateCoachingClient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivateCoachingClientCopyWith<$Res> {
  factory $PrivateCoachingClientCopyWith(PrivateCoachingClient value,
          $Res Function(PrivateCoachingClient) then) =
      _$PrivateCoachingClientCopyWithImpl<$Res, PrivateCoachingClient>;
  @useResult
  $Res call(
      {String id,
      String coachId,
      String clientUserId,
      CoachingClientStatus status,
      DateTime? startedAt,
      String? notes,
      DateTime createdAt});
}

/// @nodoc
class _$PrivateCoachingClientCopyWithImpl<$Res,
        $Val extends PrivateCoachingClient>
    implements $PrivateCoachingClientCopyWith<$Res> {
  _$PrivateCoachingClientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrivateCoachingClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coachId = null,
    Object? clientUserId = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      coachId: null == coachId
          ? _value.coachId
          : coachId // ignore: cast_nullable_to_non_nullable
              as String,
      clientUserId: null == clientUserId
          ? _value.clientUserId
          : clientUserId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CoachingClientStatus,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivateCoachingClientImplCopyWith<$Res>
    implements $PrivateCoachingClientCopyWith<$Res> {
  factory _$$PrivateCoachingClientImplCopyWith(
          _$PrivateCoachingClientImpl value,
          $Res Function(_$PrivateCoachingClientImpl) then) =
      __$$PrivateCoachingClientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String coachId,
      String clientUserId,
      CoachingClientStatus status,
      DateTime? startedAt,
      String? notes,
      DateTime createdAt});
}

/// @nodoc
class __$$PrivateCoachingClientImplCopyWithImpl<$Res>
    extends _$PrivateCoachingClientCopyWithImpl<$Res,
        _$PrivateCoachingClientImpl>
    implements _$$PrivateCoachingClientImplCopyWith<$Res> {
  __$$PrivateCoachingClientImplCopyWithImpl(_$PrivateCoachingClientImpl _value,
      $Res Function(_$PrivateCoachingClientImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrivateCoachingClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coachId = null,
    Object? clientUserId = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$PrivateCoachingClientImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      coachId: null == coachId
          ? _value.coachId
          : coachId // ignore: cast_nullable_to_non_nullable
              as String,
      clientUserId: null == clientUserId
          ? _value.clientUserId
          : clientUserId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CoachingClientStatus,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivateCoachingClientImpl implements _PrivateCoachingClient {
  const _$PrivateCoachingClientImpl(
      {required this.id,
      required this.coachId,
      required this.clientUserId,
      required this.status,
      this.startedAt,
      this.notes,
      required this.createdAt});

  factory _$PrivateCoachingClientImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivateCoachingClientImplFromJson(json);

  @override
  final String id;
  @override
  final String coachId;
  @override
  final String clientUserId;
  @override
  final CoachingClientStatus status;
  @override
  final DateTime? startedAt;
  @override
  final String? notes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PrivateCoachingClient(id: $id, coachId: $coachId, clientUserId: $clientUserId, status: $status, startedAt: $startedAt, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivateCoachingClientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.coachId, coachId) || other.coachId == coachId) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, coachId, clientUserId,
      status, startedAt, notes, createdAt);

  /// Create a copy of PrivateCoachingClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivateCoachingClientImplCopyWith<_$PrivateCoachingClientImpl>
      get copyWith => __$$PrivateCoachingClientImplCopyWithImpl<
          _$PrivateCoachingClientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivateCoachingClientImplToJson(
      this,
    );
  }
}

abstract class _PrivateCoachingClient implements PrivateCoachingClient {
  const factory _PrivateCoachingClient(
      {required final String id,
      required final String coachId,
      required final String clientUserId,
      required final CoachingClientStatus status,
      final DateTime? startedAt,
      final String? notes,
      required final DateTime createdAt}) = _$PrivateCoachingClientImpl;

  factory _PrivateCoachingClient.fromJson(Map<String, dynamic> json) =
      _$PrivateCoachingClientImpl.fromJson;

  @override
  String get id;
  @override
  String get coachId;
  @override
  String get clientUserId;
  @override
  CoachingClientStatus get status;
  @override
  DateTime? get startedAt;
  @override
  String? get notes;
  @override
  DateTime get createdAt;

  /// Create a copy of PrivateCoachingClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivateCoachingClientImplCopyWith<_$PrivateCoachingClientImpl>
      get copyWith => throw _privateConstructorUsedError;
}
