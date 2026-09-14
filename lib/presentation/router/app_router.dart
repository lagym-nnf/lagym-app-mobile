import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/supabase_config.dart';
import '../../domain/entities/program.dart';

import '../screens/auth/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/workouts/workouts_screen.dart';
import '../screens/workouts/workout_detail_screen.dart';
import '../screens/workouts/programs_screen.dart';
import '../screens/workouts/program_detail_screen.dart';
import '../screens/workouts/structured_workout_screen.dart';
import '../screens/services/services_screen.dart';
import '../screens/services/service_detail_screen.dart';
import '../screens/challenges/challenges_screen.dart';
import '../screens/nutrition/nutrition_screen.dart';
import '../screens/nutrition/recipe_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/progress_screen.dart';
import '../screens/profile/subscription_screen.dart';
import '../screens/profile/health_settings_screen.dart';
import '../screens/profile/badges_screen.dart';
import '../screens/shop/shop_screen.dart';
import '../screens/shop/checkout_screen.dart';
import '../screens/shop/order_success_screen.dart';
import '../screens/coaching/coaches_screen.dart';
import '../screens/coaching/coach_detail_screen.dart';
import '../widgets/bottom_nav_shell.dart';

/// Route names
class AppRoutes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const signup = '/signup';
  static const onboarding = '/onboarding';
  static const home = '/';
  static const workouts = '/workouts';
  static const workoutDetail = '/workouts/:id';
  static const challenges = '/challenges';
  static const nutrition = '/nutrition';
  static const recipeDetail = '/nutrition/:id';
  static const profile = '/profile';
  static const progress = '/profile/progress';
  static const badges = '/profile/badges';
  static const subscription = '/profile/subscription';
  static const coaches = '/coaches';
  static const coachDetail = '/coaches/:id';
  static const programs = '/programs';
  static const programDetail = '/programs/:id';
  static const programDay = '/program-day/:id';
  static const services = '/services';
  static const serviceDetail = '/services/:id';
  static const healthSettings = '/profile/health';
  static const shop = '/shop';
  static const checkout = '/checkout';
  static const orderSuccess = '/orders/:id';
}

/// Navigation keys
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Re-evaluates router redirects whenever Supabase auth state changes
/// (login, logout, OAuth deep-link return, session restore).
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier() {
    _subscription = SupabaseConfig.authStateChanges.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

const _authRoutes = {AppRoutes.welcome, AppRoutes.login, AppRoutes.signup};

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authRefresh = _AuthRefreshNotifier();
  ref.onDispose(authRefresh.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: true,
    refreshListenable: authRefresh,
    redirect: (context, state) async {
      final loggedIn = SupabaseConfig.currentSession != null;
      final onAuthRoute = _authRoutes.contains(state.matchedLocation);

      // Not logged in: everything except the auth screens goes to welcome
      if (!loggedIn) {
        return onAuthRoute ? null : AppRoutes.welcome;
      }

      // Logged in and inside the app: no redirect needed. The profile
      // query below therefore only runs when leaving the auth screens.
      if (!onAuthRoute) return null;

      // Logged in but on an auth screen (fresh login/signup/OAuth return
      // or cold start with a restored session): route by onboarding state.
      try {
        final profile = await SupabaseConfig.client
            .from('profiles')
            .select('onboarding_completed')
            .eq('id', SupabaseConfig.currentUser!.id)
            .maybeSingle();
        final onboarded = profile?['onboarding_completed'] == true;
        return onboarded ? AppRoutes.home : AppRoutes.onboarding;
      } catch (_) {
        // Profile unreadable (offline etc.) — let the user in rather than
        // trapping them on the welcome screen.
        return AppRoutes.home;
      }
    },
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main app with bottom navigation shell
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          // Home tab
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),

          // Workouts tab
          GoRoute(
            path: AppRoutes.workouts,
            name: 'workouts',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WorkoutsScreen(),
            ),
          ),

          // Challenges tab
          GoRoute(
            path: AppRoutes.challenges,
            name: 'challenges',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChallengesScreen(),
            ),
          ),

          // Nutrition tab
          GoRoute(
            path: AppRoutes.nutrition,
            name: 'nutrition',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NutritionScreen(),
            ),
          ),

          // Profile tab
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Detail screens (outside shell for full-screen experience)
      GoRoute(
        path: AppRoutes.workoutDetail,
        name: 'workout-detail',
        builder: (context, state) => WorkoutDetailScreen(
          workoutId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.recipeDetail,
        name: 'recipe-detail',
        builder: (context, state) => RecipeDetailScreen(
          recipeId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.progress,
        name: 'progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: AppRoutes.badges,
        name: 'badges',
        builder: (context, state) => const BadgesScreen(),
      ),
      GoRoute(
        path: AppRoutes.subscription,
        name: 'subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: AppRoutes.healthSettings,
        name: 'health-settings',
        builder: (context, state) => const HealthSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.shop,
        name: 'shop',
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        name: 'order-success',
        builder: (context, state) => OrderSuccessScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.programs,
        name: 'programs',
        builder: (context, state) => const ProgramsScreen(),
      ),
      GoRoute(
        path: AppRoutes.programDetail,
        name: 'program-detail',
        builder: (context, state) => ProgramDetailScreen(
          programId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.programDay,
        name: 'program-day',
        builder: (context, state) => StructuredWorkoutScreen(
          programWorkoutId: state.pathParameters['id']!,
          initial: state.extra is ProgramWorkout
              ? state.extra as ProgramWorkout
              : null,
        ),
      ),
      GoRoute(
        path: AppRoutes.services,
        name: 'services',
        builder: (context, state) => const ServicesScreen(),
      ),
      GoRoute(
        path: AppRoutes.serviceDetail,
        name: 'service-detail',
        builder: (context, state) => ServiceDetailScreen(
          providerId: state.pathParameters['id']!,
        ),
      ),
      // Coaching routes
      GoRoute(
        path: AppRoutes.coaches,
        name: 'coaches',
        builder: (context, state) => const CoachesScreen(),
      ),
      GoRoute(
        path: AppRoutes.coachDetail,
        name: 'coach-detail',
        builder: (context, state) => CoachDetailScreen(
          coachId: state.pathParameters['id']!,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
});
