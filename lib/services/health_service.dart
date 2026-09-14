import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// Health data state
class HealthData {
  final int? steps;
  final double? weight;
  final double? activeCalories;
  final int? workoutMinutes;
  final DateTime? lastSynced;
  final bool isConnected;
  final String? error;

  const HealthData({
    this.steps,
    this.weight,
    this.activeCalories,
    this.workoutMinutes,
    this.lastSynced,
    this.isConnected = false,
    this.error,
  });

  HealthData copyWith({
    int? steps,
    double? weight,
    double? activeCalories,
    int? workoutMinutes,
    DateTime? lastSynced,
    bool? isConnected,
    String? error,
  }) {
    return HealthData(
      steps: steps ?? this.steps,
      weight: weight ?? this.weight,
      activeCalories: activeCalories ?? this.activeCalories,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
      lastSynced: lastSynced ?? this.lastSynced,
      isConnected: isConnected ?? this.isConnected,
      error: error,
    );
  }
}

/// Health service for Apple Health / Google Fit integration
class HealthService {
  final Health _health = Health();

  /// Data types we want to read
  List<HealthDataType> get _readTypes => [
        HealthDataType.STEPS,
        HealthDataType.WEIGHT,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.WORKOUT,
      ];

  /// Data types we want to write
  List<HealthDataType> get _writeTypes => [
        HealthDataType.WEIGHT,
        HealthDataType.WORKOUT,
      ];

  /// Check if health data is available on this platform
  bool get isAvailable => Platform.isIOS || Platform.isAndroid;

  /// Request authorization to access health data
  Future<bool> requestAuthorization() async {
    if (!isAvailable) return false;

    try {
      // Request activity recognition permission on Android
      if (Platform.isAndroid) {
        final status = await Permission.activityRecognition.request();
        if (!status.isGranted) {
          debugPrint('Activity recognition permission denied');
          return false;
        }
      }

      // Configure health
      await _health.configure();

      // Request permissions for each type
      final permissions = _readTypes.map((type) => HealthDataAccess.READ).toList();
      final writePermissions = _writeTypes.map((type) => HealthDataAccess.READ_WRITE).toList();

      final granted = await _health.requestAuthorization(
        [..._readTypes, ..._writeTypes],
        permissions: [...permissions, ...writePermissions],
      );

      return granted;
    } catch (e) {
      debugPrint('Health authorization error: $e');
      return false;
    }
  }

  /// Check if we have authorization
  Future<bool> hasAuthorization() async {
    if (!isAvailable) return false;

    try {
      await _health.configure();
      return await _health.hasPermissions(_readTypes) ?? false;
    } catch (e) {
      debugPrint('Health permission check error: $e');
      return false;
    }
  }

  /// Get steps for today
  Future<int?> getTodaySteps() async {
    if (!isAvailable) return null;

    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      final steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps;
    } catch (e) {
      debugPrint('Error getting steps: $e');
      return null;
    }
  }

  /// Get weight (most recent)
  Future<double?> getLatestWeight() async {
    if (!isAvailable) return null;

    try {
      final now = DateTime.now();
      final oneMonthAgo = now.subtract(const Duration(days: 30));

      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: oneMonthAgo,
        endTime: now,
      );

      if (data.isNotEmpty) {
        // Get the most recent weight
        data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
        final weightValue = data.first.value;
        if (weightValue is NumericHealthValue) {
          return weightValue.numericValue.toDouble();
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting weight: $e');
      return null;
    }
  }

  /// Get active calories burned today
  Future<double?> getTodayActiveCalories() async {
    if (!isAvailable) return null;

    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: midnight,
        endTime: now,
      );

      double totalCalories = 0;
      for (final point in data) {
        if (point.value is NumericHealthValue) {
          totalCalories += (point.value as NumericHealthValue).numericValue.toDouble();
        }
      }
      return totalCalories > 0 ? totalCalories : null;
    } catch (e) {
      debugPrint('Error getting calories: $e');
      return null;
    }
  }

  /// Get workout minutes for today
  Future<int?> getTodayWorkoutMinutes() async {
    if (!isAvailable) return null;

    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: midnight,
        endTime: now,
      );

      int totalMinutes = 0;
      for (final point in data) {
        final duration = point.dateTo.difference(point.dateFrom).inMinutes;
        totalMinutes += duration;
      }
      return totalMinutes > 0 ? totalMinutes : null;
    } catch (e) {
      debugPrint('Error getting workout minutes: $e');
      return null;
    }
  }

  /// Write weight to health app
  Future<bool> writeWeight(double weightKg) async {
    if (!isAvailable) return false;

    try {
      final now = DateTime.now();
      return await _health.writeHealthData(
        value: weightKg,
        type: HealthDataType.WEIGHT,
        startTime: now,
        endTime: now,
        unit: HealthDataUnit.KILOGRAM,
      );
    } catch (e) {
      debugPrint('Error writing weight: $e');
      return false;
    }
  }

  /// Write workout to health app
  Future<bool> writeWorkout({
    required DateTime startTime,
    required DateTime endTime,
    required int caloriesBurned,
  }) async {
    if (!isAvailable) return false;

    try {
      return await _health.writeWorkoutData(
        activityType: HealthWorkoutActivityType.FUNCTIONAL_STRENGTH_TRAINING,
        start: startTime,
        end: endTime,
        totalEnergyBurned: caloriesBurned,
        totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
      );
    } catch (e) {
      debugPrint('Error writing workout: $e');
      return false;
    }
  }

  /// Fetch all health data
  Future<HealthData> fetchAllData() async {
    if (!isAvailable) {
      return const HealthData(error: 'Health data not available on this platform');
    }

    final hasAuth = await hasAuthorization();
    if (!hasAuth) {
      return const HealthData(error: 'Not connected to health app');
    }

    final steps = await getTodaySteps();
    final weight = await getLatestWeight();
    final calories = await getTodayActiveCalories();
    final workoutMins = await getTodayWorkoutMinutes();

    return HealthData(
      steps: steps,
      weight: weight,
      activeCalories: calories,
      workoutMinutes: workoutMins,
      lastSynced: DateTime.now(),
      isConnected: true,
    );
  }
}

/// Health service provider
final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService();
});

/// Health data state provider
final healthDataProvider = StateNotifierProvider<HealthDataNotifier, HealthData>((ref) {
  final service = ref.watch(healthServiceProvider);
  return HealthDataNotifier(service);
});

class HealthDataNotifier extends StateNotifier<HealthData> {
  final HealthService _service;

  HealthDataNotifier(this._service) : super(const HealthData());

  /// Connect to health app
  Future<bool> connect() async {
    final granted = await _service.requestAuthorization();
    if (granted) {
      await refresh();
      return true;
    } else {
      state = state.copyWith(error: 'Permission denied');
      return false;
    }
  }

  /// Disconnect (just clears local state)
  void disconnect() {
    state = const HealthData();
  }

  /// Refresh health data
  Future<void> refresh() async {
    final data = await _service.fetchAllData();
    state = data;
  }

  /// Write weight and refresh
  Future<bool> writeWeight(double kg) async {
    final success = await _service.writeWeight(kg);
    if (success) {
      await refresh();
    }
    return success;
  }

  /// Write workout and refresh
  Future<bool> writeWorkout({
    required DateTime startTime,
    required DateTime endTime,
    required int caloriesBurned,
  }) async {
    final success = await _service.writeWorkout(
      startTime: startTime,
      endTime: endTime,
      caloriesBurned: caloriesBurned,
    );
    if (success) {
      await refresh();
    }
    return success;
  }
}
