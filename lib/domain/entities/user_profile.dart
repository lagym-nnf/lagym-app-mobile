/// Fitness goals
enum FitnessGoal {
  buildStrength,
  loseWeight,
  stayHealthy,
  toneUp,
  improveFlexibility,
}

/// Workout location preference
enum WorkoutLocation {
  gym,
  home,
  homeGym,
}

/// Fitness level
enum FitnessLevel {
  beginner,
  intermediate,
  advanced,
}

/// Subscription tier
enum SubscriptionTier {
  free,
  premium,
  premiumNutrition,
}

/// Subscription status
enum SubscriptionStatus {
  active,
  trial,
  expired,
  cancelled,
}

class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final double? weight;
  final double? height;
  final List<FitnessGoal> fitnessGoals;
  final WorkoutLocation workoutLocation;
  final FitnessLevel fitnessLevel;
  final SubscriptionTier subscriptionTier;
  final SubscriptionStatus subscriptionStatus;
  final DateTime? trialStartDate;
  final DateTime? trialEndDate;
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final bool onboardingCompleted;
  final bool notificationsEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.dateOfBirth,
    this.weight,
    this.height,
    this.fitnessGoals = const [],
    this.workoutLocation = WorkoutLocation.home,
    this.fitnessLevel = FitnessLevel.beginner,
    this.subscriptionTier = SubscriptionTier.free,
    this.subscriptionStatus = SubscriptionStatus.trial,
    this.trialStartDate,
    this.trialEndDate,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.onboardingCompleted = false,
    this.notificationsEnabled = true,
    this.createdAt,
    this.updatedAt,
  });

  bool get isTrialActive {
    if (subscriptionStatus != SubscriptionStatus.trial) return false;
    if (trialEndDate == null) return false;
    return DateTime.now().isBefore(trialEndDate!);
  }

  int get trialDaysRemaining {
    if (trialEndDate == null) return 0;
    final remaining = trialEndDate!.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  bool get isPremium {
    return subscriptionTier == SubscriptionTier.premium ||
        subscriptionTier == SubscriptionTier.premiumNutrition;
  }

  bool get hasNutritionAccess {
    return subscriptionTier == SubscriptionTier.premiumNutrition;
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      fitnessGoals: (json['fitness_goals'] as List<dynamic>?)
              ?.map((e) => FitnessGoal.values.firstWhere(
                    (g) => g.name == e,
                    orElse: () => FitnessGoal.stayHealthy,
                  ))
              .toList() ??
          [],
      workoutLocation: WorkoutLocation.values.firstWhere(
        (l) => l.name == json['workout_location'],
        orElse: () => WorkoutLocation.home,
      ),
      fitnessLevel: FitnessLevel.values.firstWhere(
        (l) => l.name == json['fitness_level'],
        orElse: () => FitnessLevel.beginner,
      ),
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (t) => t.name == json['subscription_tier'],
        orElse: () => SubscriptionTier.free,
      ),
      subscriptionStatus: SubscriptionStatus.values.firstWhere(
        (s) => s.name == json['subscription_status'],
        orElse: () => SubscriptionStatus.trial,
      ),
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'fitness_goals': fitnessGoals.map((g) => g.name).toList(),
      'workout_location': workoutLocation.name,
      'fitness_level': fitnessLevel.name,
      'subscription_tier': subscriptionTier.name,
      'subscription_status': subscriptionStatus.name,
      'onboarding_completed': onboardingCompleted,
      'notifications_enabled': notificationsEnabled,
    };
  }
}
