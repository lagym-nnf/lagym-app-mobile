import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/program.dart';
import '../../../providers/programs_provider.dart';

class ProgramsScreen extends ConsumerStatefulWidget {
  const ProgramsScreen({super.key});

  @override
  ConsumerState<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends ConsumerState<ProgramsScreen> {
  int _selectedFilterIndex = 0;
  final _filters = ['All', 'Fixed', 'Infinity', 'Free'];

  List<Program> _filteredPrograms(List<Program> programs) {
    switch (_selectedFilterIndex) {
      case 1:
        return programs.where((p) => p.type == ProgramType.fixed).toList();
      case 2:
        return programs.where((p) => p.type == ProgramType.infinity).toList();
      case 3:
        return programs.where((p) => !p.isPremium).toList();
      default:
        return programs;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text('Programs', style: AppTypography.greetingLarge),
                ],
              ),
            ),

            // Filter tabs
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedFilterIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.gray900 : AppColors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        _filters[index],
                        style: AppTypography.buttonSmall.copyWith(
                          color: isSelected ? AppColors.white : AppColors.gray600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Programs list
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidate(programsProvider),
                child: ref.watch(programsProvider).when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) => ListView(
                        children: [
                          const SizedBox(height: 80),
                          Icon(PhosphorIcons.wifiSlash(),
                              size: 48, color: AppColors.gray300),
                          const SizedBox(height: 16),
                          Text(
                            'Could not load programs.\nPull down to try again.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.gray500),
                          ),
                        ],
                      ),
                      data: (programs) {
                        final filtered = _filteredPrograms(programs);
                        if (filtered.isEmpty) {
                          return ListView(
                            children: [
                              const SizedBox(height: 80),
                              Icon(PhosphorIcons.barbell(),
                                  size: 48, color: AppColors.gray300),
                              const SizedBox(height: 16),
                              Text(
                                'No programs here yet.\nCheck back soon!',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium
                                    .copyWith(color: AppColors.gray500),
                              ),
                            ],
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final program = filtered[index];
                            return _ProgramCard(
                              program: program,
                              onTap: () =>
                                  context.push('/programs/${program.id}'),
                            );
                          },
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback onTap;

  const _ProgramCard({
    required this.program,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: AppShadows.md,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: program.thumbnailUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.gray100),
              errorWidget: (context, url, error) => Container(color: AppColors.gray200),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags row
                  Row(
                    children: [
                      // Program type badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: program.isInfinity ? AppColors.coral : AppColors.pinkDark,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text(
                          program.isInfinity ? 'INFINITY' : '${program.durationWeeks} WEEKS',
                          style: AppTypography.captionSmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (program.tags.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          child: Text(
                            program.tags.first,
                            style: AppTypography.captionSmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const Spacer(),
                      if (program.isPremium)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(PhosphorIcons.crown(PhosphorIconsStyle.fill), size: 14, color: Colors.white),
                        ),
                    ],
                  ),
                  const Spacer(),
                  // Title
                  Text(
                    program.title,
                    style: AppTypography.h2.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Stats row
                  Row(
                    children: [
                      // Coach
                      if (program.coachImageUrl != null) ...[
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: program.coachImageUrl!,
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          program.coachName ?? '',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.white),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Icon(PhosphorIcons.barbell(), size: 16, color: AppColors.white.withValues(alpha: 0.8)),
                      const SizedBox(width: 4),
                      Text(
                        '${program.totalWorkouts} workouts',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.white.withValues(alpha: 0.9)),
                      ),
                      const SizedBox(width: 16),
                      Icon(PhosphorIcons.chartBar(), size: 16, color: AppColors.white.withValues(alpha: 0.8)),
                      const SizedBox(width: 4),
                      Text(
                        program.difficulty.name[0].toUpperCase() + program.difficulty.name.substring(1),
                        style: AppTypography.bodySmall.copyWith(color: AppColors.white.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
