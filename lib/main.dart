import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/video_welcome_screen.dart';
import 'screens/child_info_screen.dart';
import 'screens/parent_info_screen.dart';
import 'screens/plan_selection_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/registration_confirmation_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/book_visit_screen.dart';
import 'screens/events_screen.dart';

// Admin screens
import 'screens/admin_login_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_registrations_screen.dart';
import 'screens/admin_children_screen.dart';
import 'screens/admin_parents_screen.dart';
import 'screens/admin_visits_screen.dart';
import 'screens/admin_messages_screen.dart';

void main() {
  runApp(const SmileNurseryApp());
}

class SmileNurseryApp extends StatelessWidget {
  const SmileNurseryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smile Nursery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}

// Router configuration
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Video Welcome Screen (Main Entry Point)
    GoRoute(
      path: '/',
      builder: (context, state) => const VideoWelcomeScreen(),
    ),

    // Splash Screen (Optional)
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Registration Flow
    GoRoute(
      path: '/registration/child-info',
      builder: (context, state) => const ChildInfoScreen(),
    ),

    GoRoute(
      path: '/registration/parent-info',
      builder: (context, state) => const ParentInfoScreen(),
    ),

    GoRoute(
      path: '/registration/plan-selection',
      builder: (context, state) => const PlanSelectionScreen(),
    ),

    GoRoute(
      path: '/registration/payment',
      builder: (context, state) => const PaymentScreen(),
    ),

    GoRoute(
      path: '/registration/confirmation',
      builder: (context, state) => const RegistrationConfirmationScreen(),
    ),

    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),

    GoRoute(
      path: '/book-visit',
      builder: (context, state) => const BookVisitScreen(),
    ),

    GoRoute(
      path: '/events',
      builder: (context, state) => const EventsScreen(),
    ),

    // Admin Routes
    GoRoute(
      path: '/admin/login',
      builder: (context, state) => const AdminLoginScreen(),
    ),

    GoRoute(
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),

    GoRoute(
      path: '/admin/registrations',
      builder: (context, state) => const AdminRegistrationsScreen(),
    ),

    GoRoute(
      path: '/admin/children',
      builder: (context, state) => const AdminChildrenScreen(),
    ),

    GoRoute(
      path: '/admin/parents',
      builder: (context, state) => const AdminParentsScreen(),
    ),

    GoRoute(
      path: '/admin/visits',
      builder: (context, state) => const AdminVisitsScreen(),
    ),

    GoRoute(
      path: '/admin/messages',
      builder: (context, state) => const AdminMessagesScreen(),
    ),
  ],
);
