import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/constants/constants.dart';
import '../../widgets/common/app_button.dart';

/// Weight logs persisted locally on this device, per logged-in user.
class WeightLogsNotifier extends StateNotifier<List<WeightLog>> {
  WeightLogsNotifier() : super(const []) {
    _load();
  }

  static String get _key =>
      'weight_logs_${SupabaseConfig.currentUser?.id ?? 'anon'}';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || !mounted) return;
    state = (jsonDecode(raw) as List)
        .map((e) => WeightLog(
              date: DateTime.parse(e['date'] as String),
              weight: (e['weight'] as num).toDouble(),
            ))
        .toList();
  }

  Future<void> add(double weight) async {
    state = [...state, WeightLog(date: DateTime.now(), weight: weight)];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(state
          .map((l) => {'date': l.date.toIso8601String(), 'weight': l.weight})
          .toList()),
    );
  }
}

final weightLogsProvider =
    StateNotifierProvider<WeightLogsNotifier, List<WeightLog>>(
        (ref) => WeightLogsNotifier());

// Progress photos: no backend yet — starts empty, capture coming later.
final progressPhotosProvider =
    StateProvider<List<ProgressPhoto>>((ref) => const []);

// Workout history: no completion tracking backend yet — starts empty.
final workoutHistoryProvider =
    StateProvider<List<WorkoutCompletion>>((ref) => const []);

class WeightLog {
  final DateTime date;
  final double weight;
  WeightLog({required this.date, required this.weight});
}

class ProgressPhoto {
  final String id;
  final DateTime date;
  final String imageUrl;
  final PhotoType type;
  ProgressPhoto({required this.id, required this.date, required this.imageUrl, required this.type});
}

enum PhotoType { before, progress, after }

class WorkoutCompletion {
  final String id;
  final String workoutTitle;
  final DateTime date;
  final int durationMinutes;
  final int caloriesBurned;
  WorkoutCompletion({
    required this.id,
    required this.workoutTitle,
    required this.date,
    required this.durationMinutes,
    required this.caloriesBurned,
  });
}

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.sm,
                      ),
                      child: Icon(PhosphorIcons.arrowLeft(), size: 20, color: AppColors.gray900),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('My Progress', style: AppTypography.greetingLarge),
                ],
              ),
            ),

            // Stats overview, computed from the user's own data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Builder(builder: (context) {
                final history = ref.watch(workoutHistoryProvider);
                final logs = ref.watch(weightLogsProvider);
                final weightChange = logs.length >= 2
                    ? logs.last.weight - logs.first.weight
                    : null;
                return Row(
                  children: [
                    Expanded(
                        child: _StatCard(
                            value: '${history.length}',
                            label: 'Workouts',
                            icon: PhosphorIcons.barbell())),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _StatCard(
                            value: '${logs.length}',
                            label: 'Weigh-ins',
                            icon: PhosphorIcons.scales())),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _StatCard(
                            value: weightChange == null
                                ? '–'
                                : '${weightChange > 0 ? '+' : ''}${weightChange.toStringAsFixed(1)}kg',
                            label: 'Change',
                            icon: weightChange != null && weightChange > 0
                                ? PhosphorIcons.trendUp()
                                : PhosphorIcons.trendDown())),
                  ],
                );
              }),
            ),

            const SizedBox(height: 20),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.gray900,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.gray600,
                labelStyle: AppTypography.buttonSmall,
                tabs: const [
                  Tab(text: 'Weight'),
                  Tab(text: 'Photos'),
                  Tab(text: 'History'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _WeightTab(),
                  _PhotosTab(),
                  _HistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  const _StatCard({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.pinkDark, size: 24),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.statValue),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.statLabel),
        ],
      ),
    );
  }
}

class _WeightTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightLogs = ref.watch(weightLogsProvider);

    // Empty state: no weigh-ins yet
    if (weightLogs.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
        child: Column(
          children: [
            _EmptyState(
              icon: PhosphorIcons.scales(),
              title: 'No weigh-ins yet',
              message:
                  'Log your weight to start tracking your progress over time.',
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Log Weight',
              leadingIcon: PhosphorIcons.plus(),
              size: AppButtonSize.large,
              onPressed: () => _showLogWeightDialog(context, ref),
            ),
          ],
        ),
      );
    }

    final currentWeight = weightLogs.last.weight;
    final startWeight = weightLogs.first.weight;
    final weightChange = currentWeight - startWeight;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current weight display
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Weight', style: AppTypography.cardSubtitle),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${currentWeight.toStringAsFixed(1)}', style: AppTypography.h1.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text('kg', style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: weightChange <= 0 ? AppColors.mint : AppColors.pink,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        weightChange <= 0 ? PhosphorIcons.trendDown() : PhosphorIcons.trendUp(),
                        size: 16,
                        color: weightChange <= 0 ? AppColors.mintDark : AppColors.pinkDark,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${weightChange.abs().toStringAsFixed(1)} kg',
                        style: AppTypography.bodySmall.copyWith(
                          color: weightChange <= 0 ? AppColors.mintDark : AppColors.pinkDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Weight chart (needs at least two entries to draw a trend)
          if (weightLogs.length >= 2) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weight Trend', style: AppTypography.cardTitle),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: CustomPaint(
                      size: const Size(double.infinity, 150),
                      painter: _WeightChartPainter(weightLogs),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Log weight button
          AppButton(
            label: 'Log Weight',
            leadingIcon: PhosphorIcons.plus(),
            size: AppButtonSize.large,
            onPressed: () => _showLogWeightDialog(context, ref),
          ),

          const SizedBox(height: 24),

          // Weight history
          Text('Recent Logs', style: AppTypography.sectionTitle),
          const SizedBox(height: 14),

          ...weightLogs.reversed.take(5).map((log) => _WeightLogItem(log: log)),
        ],
      ),
    );
  }

  void _showLogWeightDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text('Log Your Weight', style: AppTypography.h2),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter weight in kg',
                filled: true,
                fillColor: AppColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: BorderSide.none,
                ),
                suffixText: 'kg',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Save',
              size: AppButtonSize.large,
              onPressed: () {
                final weight = double.tryParse(controller.text.replaceAll(',', '.'));
                if (weight != null && weight > 0) {
                  ref.read(weightLogsProvider.notifier).add(weight);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightLogItem extends StatelessWidget {
  final WeightLog log;
  const _WeightLogItem({required this.log});

  @override
  Widget build(BuildContext context) {
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.pink,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Center(
              child: Icon(PhosphorIcons.scales(), color: AppColors.pinkDark, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${log.weight.toStringAsFixed(1)} kg', style: AppTypography.cardTitle),
                Text(
                  '${monthNames[log.date.month - 1]} ${log.date.day}, ${log.date.year}',
                  style: AppTypography.cardSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  final List<WeightLog> logs;
  _WeightChartPainter(this.logs);

  @override
  void paint(Canvas canvas, Size size) {
    if (logs.length < 2) return;

    final minWeight = logs.map((l) => l.weight).reduce((a, b) => a < b ? a : b) - 1;
    final maxWeight = logs.map((l) => l.weight).reduce((a, b) => a > b ? a : b) + 1;
    final weightRange = maxWeight - minWeight;

    final paint = Paint()
      ..color = AppColors.pinkDark
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.pinkDark.withValues(alpha: 0.3),
          AppColors.pinkDark.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < logs.length; i++) {
      final x = (i / (logs.length - 1)) * size.width;
      final y = size.height - ((logs[i].weight - minWeight) / weightRange) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw dots
    final dotPaint = Paint()..color = AppColors.pinkDark;
    for (int i = 0; i < logs.length; i++) {
      final x = (i / (logs.length - 1)) * size.width;
      final y = size.height - ((logs[i].weight - minWeight) / weightRange) * size.height;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PhotosTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(progressPhotosProvider);

    if (photos.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
        child: _EmptyState(
          icon: PhosphorIcons.camera(),
          title: 'No progress photos yet',
          message:
              'Progress photos are coming soon — you\'ll be able to track your transformation here.',
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Before/After comparison
          if (photos.length >= 2)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Before & After', style: AppTypography.cardTitle),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              child: CachedNetworkImage(
                                imageUrl: photos.first.imageUrl,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Before', style: AppTypography.bodySmall.copyWith(color: AppColors.gray500)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              child: CachedNetworkImage(
                                imageUrl: photos.last.imageUrl,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('After', style: AppTypography.bodySmall.copyWith(color: AppColors.gray500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Add photo button
          AppButton(
            label: 'Add Progress Photo',
            leadingIcon: PhosphorIcons.camera(),
            size: AppButtonSize.large,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo capture coming soon!'),
                  backgroundColor: AppColors.pinkDark,
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // All photos grid
          Text('All Photos', style: AppTypography.sectionTitle),
          const SizedBox(height: 14),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  boxShadow: AppShadows.sm,
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: photo.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                          ),
                        ),
                        child: Text(
                          '${monthNames[photo.date.month - 1]} ${photo.date.day}',
                          style: AppTypography.captionSmall.copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.pinkLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.pinkDark, size: 30),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTypography.h3, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutHistoryProvider);

    if (workouts.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
        child: _EmptyState(
          icon: PhosphorIcons.barbell(),
          title: 'No workouts yet',
          message: 'Workouts you complete will show up here.',
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      itemCount: workouts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final workout = workouts[index];
        final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        final isToday = workout.date.day == DateTime.now().day &&
            workout.date.month == DateTime.now().month;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Center(
                  child: Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), color: AppColors.pinkDark, size: 26),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workout.workoutTitle, style: AppTypography.cardTitle),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(PhosphorIcons.clock(), size: 14, color: AppColors.gray400),
                        const SizedBox(width: 4),
                        Text('${workout.durationMinutes} min', style: AppTypography.captionSmall),
                        const SizedBox(width: 12),
                        Icon(PhosphorIcons.flame(), size: 14, color: AppColors.gray400),
                        const SizedBox(width: 4),
                        Text('${workout.caloriesBurned} cal', style: AppTypography.captionSmall),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isToday)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.pinkDark,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text('Today', style: AppTypography.captionSmall.copyWith(color: AppColors.white)),
                    )
                  else
                    Text(
                      '${monthNames[workout.date.month - 1]} ${workout.date.day}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.gray500),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
