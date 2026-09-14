/// Badge type/category
enum BadgeCategory {
  workouts,
  streaks,
  challenges,
  milestones,
  special,
}

/// Badge entity representing an achievement
class Achievement {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final BadgeCategory category;
  final int requirement; // e.g., 10 workouts, 7 day streak
  final int xpReward;
  final bool isSecret;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.category,
    required this.requirement,
    this.xpReward = 50,
    this.isSecret = false,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      iconName: json['icon_name'] as String? ?? 'trophy',
      category: BadgeCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => BadgeCategory.workouts,
      ),
      requirement: json['requirement'] as int? ?? 1,
      xpReward: json['xp_reward'] as int? ?? 50,
      isSecret: json['is_secret'] as bool? ?? false,
    );
  }
}

/// User's earned badge
class UserBadge {
  final String id;
  final String oderId;
  final String badgeId;
  final DateTime earnedAt;
  final Achievement? achievement;

  const UserBadge({
    required this.id,
    required this.oderId,
    required this.badgeId,
    required this.earnedAt,
    this.achievement,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      id: json['id'] as String,
      oderId: json['user_id'] as String,
      badgeId: json['badge_id'] as String,
      earnedAt: DateTime.parse(json['earned_at'] as String),
      achievement: json['badge'] != null
          ? Achievement.fromJson(json['badge'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// User stats for tracking progress towards badges
class UserStats {
  final int totalWorkouts;
  final int currentStreak;
  final int longestStreak;
  final int challengesCompleted;
  final int totalMinutes;
  final int totalCalories;
  final int currentLevel;
  final int currentXp;
  final int xpToNextLevel;

  const UserStats({
    this.totalWorkouts = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.challengesCompleted = 0,
    this.totalMinutes = 0,
    this.totalCalories = 0,
    this.currentLevel = 1,
    this.currentXp = 0,
    this.xpToNextLevel = 100,
  });

  UserStats copyWith({
    int? totalWorkouts,
    int? currentStreak,
    int? longestStreak,
    int? challengesCompleted,
    int? totalMinutes,
    int? totalCalories,
    int? currentLevel,
    int? currentXp,
    int? xpToNextLevel,
  }) {
    return UserStats(
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      challengesCompleted: challengesCompleted ?? this.challengesCompleted,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      totalCalories: totalCalories ?? this.totalCalories,
      currentLevel: currentLevel ?? this.currentLevel,
      currentXp: currentXp ?? this.currentXp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
    );
  }

  double get levelProgress => currentXp / xpToNextLevel;
}

/// All available badges in the app
final allBadges = [
  // Workout badges
  const Achievement(
    id: 'first_workout',
    name: 'First Steps',
    description: 'Complete your first workout',
    iconName: 'star',
    category: BadgeCategory.workouts,
    requirement: 1,
    xpReward: 25,
  ),
  const Achievement(
    id: '10_workouts',
    name: 'Getting Started',
    description: 'Complete 10 workouts',
    iconName: 'barbell',
    category: BadgeCategory.workouts,
    requirement: 10,
    xpReward: 50,
  ),
  const Achievement(
    id: '25_workouts',
    name: 'Dedicated',
    description: 'Complete 25 workouts',
    iconName: 'medal',
    category: BadgeCategory.workouts,
    requirement: 25,
    xpReward: 100,
  ),
  const Achievement(
    id: '50_workouts',
    name: 'Committed',
    description: 'Complete 50 workouts',
    iconName: 'trophy',
    category: BadgeCategory.workouts,
    requirement: 50,
    xpReward: 200,
  ),
  const Achievement(
    id: '100_workouts',
    name: 'Century Club',
    description: 'Complete 100 workouts',
    iconName: 'crown',
    category: BadgeCategory.workouts,
    requirement: 100,
    xpReward: 500,
  ),

  // Streak badges
  const Achievement(
    id: '3_day_streak',
    name: 'On a Roll',
    description: 'Maintain a 3-day workout streak',
    iconName: 'flame',
    category: BadgeCategory.streaks,
    requirement: 3,
    xpReward: 30,
  ),
  const Achievement(
    id: '7_day_streak',
    name: 'Week Warrior',
    description: 'Maintain a 7-day workout streak',
    iconName: 'flame',
    category: BadgeCategory.streaks,
    requirement: 7,
    xpReward: 75,
  ),
  const Achievement(
    id: '14_day_streak',
    name: 'Fortnight Fighter',
    description: 'Maintain a 14-day workout streak',
    iconName: 'flame',
    category: BadgeCategory.streaks,
    requirement: 14,
    xpReward: 150,
  ),
  const Achievement(
    id: '30_day_streak',
    name: 'Monthly Master',
    description: 'Maintain a 30-day workout streak',
    iconName: 'flame',
    category: BadgeCategory.streaks,
    requirement: 30,
    xpReward: 300,
  ),

  // Challenge badges
  const Achievement(
    id: '5_challenges',
    name: 'Challenge Accepted',
    description: 'Complete 5 daily challenges',
    iconName: 'lightning',
    category: BadgeCategory.challenges,
    requirement: 5,
    xpReward: 50,
  ),
  const Achievement(
    id: '20_challenges',
    name: 'Challenge Champion',
    description: 'Complete 20 daily challenges',
    iconName: 'lightning',
    category: BadgeCategory.challenges,
    requirement: 20,
    xpReward: 150,
  ),

  // Milestone badges
  const Achievement(
    id: '1000_calories',
    name: 'Calorie Crusher',
    description: 'Burn 1,000 total calories',
    iconName: 'fire',
    category: BadgeCategory.milestones,
    requirement: 1000,
    xpReward: 50,
  ),
  const Achievement(
    id: '10000_calories',
    name: 'Calorie Destroyer',
    description: 'Burn 10,000 total calories',
    iconName: 'fire',
    category: BadgeCategory.milestones,
    requirement: 10000,
    xpReward: 200,
  ),
  const Achievement(
    id: '500_minutes',
    name: 'Time Investor',
    description: 'Exercise for 500 total minutes',
    iconName: 'clock',
    category: BadgeCategory.milestones,
    requirement: 500,
    xpReward: 100,
  ),

  // Special badges
  const Achievement(
    id: 'early_bird',
    name: 'Early Bird',
    description: 'Complete a workout before 7 AM',
    iconName: 'sun',
    category: BadgeCategory.special,
    requirement: 1,
    xpReward: 50,
    isSecret: true,
  ),
  const Achievement(
    id: 'night_owl',
    name: 'Night Owl',
    description: 'Complete a workout after 10 PM',
    iconName: 'moon',
    category: BadgeCategory.special,
    requirement: 1,
    xpReward: 50,
    isSecret: true,
  ),
];
