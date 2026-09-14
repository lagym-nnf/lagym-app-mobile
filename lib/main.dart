import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent;

import 'app.dart';
import 'core/config/supabase_config.dart';
import 'core/config/stripe_config.dart';
import 'core/config/revenuecat_config.dart';
import 'services/payment_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize Stripe (shop payments)
  await StripeConfig.initialize();

  // Initialize RevenueCat (in-app subscriptions)
  await RevenueCatConfig.initialize();

  // Keep the RevenueCat customer identified as the Supabase user, so
  // subscription webhooks carry the Supabase user id. Covers email, OAuth,
  // and restored sessions.
  SupabaseConfig.authStateChanges.listen((authState) {
    final user = authState.session?.user;
    if (user != null) {
      RevenueCatConfig.logIn(user.id);
    } else if (authState.event == AuthChangeEvent.signedOut) {
      RevenueCatConfig.logOut();
    }
  });

  // Initialize Payment Service
  PaymentService.instance.initialize();

  runApp(
    const ProviderScope(
      child: LaGymApp(),
    ),
  );
}
