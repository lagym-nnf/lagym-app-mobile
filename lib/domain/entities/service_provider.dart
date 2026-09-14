/// Service provider type
enum ServiceProviderType {
  nutritionist,
  physiotherapist,
  coach,
}

/// Service provider entity (nutritionist, physiotherapist, etc.)
class ServiceProvider {
  final String id;
  final String name;
  final ServiceProviderType type;
  final String? title;
  final String? bio;
  final String? imageUrl;
  final List<String> specializations;
  final List<String> qualifications;
  final double rating;
  final int reviewCount;
  final int yearsExperience;
  final double pricePerSession;
  final int sessionDurationMinutes;
  final bool isAvailable;
  final String? email;
  final String? phone;

  const ServiceProvider({
    required this.id,
    required this.name,
    required this.type,
    this.title,
    this.bio,
    this.imageUrl,
    this.specializations = const [],
    this.qualifications = const [],
    this.rating = 5.0,
    this.reviewCount = 0,
    this.yearsExperience = 0,
    this.pricePerSession = 0,
    this.sessionDurationMinutes = 60,
    this.isAvailable = true,
    this.email,
    this.phone,
  });

  /// Maps a row from the team_members table (managed in the admin Team page)
  /// to a service provider.
  factory ServiceProvider.fromTeamMember(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ServiceProviderType.values.firstWhere(
        (t) => t.name == json['role'],
        orElse: () => ServiceProviderType.coach,
      ),
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      imageUrl: json['avatar_url'] as String?,
      specializations:
          (json['specialties'] as List<dynamic>?)?.cast<String>() ?? [],
      qualifications:
          (json['certifications'] as List<dynamic>?)?.cast<String>() ?? [],
      yearsExperience: json['experience_years'] as int? ?? 0,
      isAvailable: json['is_active'] as bool? ?? true,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ServiceProviderType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => ServiceProviderType.nutritionist,
      ),
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      imageUrl: json['image_url'] as String?,
      specializations: (json['specializations'] as List<dynamic>?)?.cast<String>() ?? [],
      qualifications: (json['qualifications'] as List<dynamic>?)?.cast<String>() ?? [],
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: json['review_count'] as int? ?? 0,
      yearsExperience: json['years_experience'] as int? ?? 0,
      pricePerSession: (json['price_per_session'] as num?)?.toDouble() ?? 0,
      sessionDurationMinutes: json['session_duration_minutes'] as int? ?? 60,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }
}

/// Availability slot for booking
class AvailabilitySlot {
  final String id;
  final String providerId;
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;

  const AvailabilitySlot({
    required this.id,
    required this.providerId,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      id: json['id'] as String,
      providerId: json['provider_id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      isBooked: json['is_booked'] as bool? ?? false,
    );
  }
}

/// Booking entity
class Booking {
  final String id;
  final String userId;
  final String providerId;
  final String slotId;
  final DateTime scheduledAt;
  final BookingStatus status;
  final String? notes;
  final double? amountPaid;

  const Booking({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.slotId,
    required this.scheduledAt,
    this.status = BookingStatus.pending,
    this.notes,
    this.amountPaid,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      providerId: json['provider_id'] as String,
      slotId: json['slot_id'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      status: BookingStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      notes: json['notes'] as String?,
      amountPaid: (json['amount_paid'] as num?)?.toDouble(),
    );
  }
}

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}
