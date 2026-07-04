import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repair_center_syste/features/auth/presentation/providers/auth_provider.dart';
import 'package:repair_center_syste/features/auth/presentation/screens/login_screen.dart';
import 'package:repair_center_syste/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:repair_center_syste/features/repairs/presentation/screens/new_repair_screen.dart';
import 'package:repair_center_syste/features/repairs/presentation/screens/repair_details_screen.dart';
import 'package:repair_center_syste/features/repairs/presentation/screens/repairs_list_screen.dart';
import 'package:repair_center_syste/features/customers/presentation/screens/customers_list_screen.dart';
import 'package:repair_center_syste/features/technicians/presentation/screens/technicians_screen.dart';
import 'package:repair_center_syste/features/reports/presentation/screens/reports_screen.dart';
import 'package:repair_center_syste/features/settings/presentation/screens/settings_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/';
  static const String repairs = '/repairs';
  static const String newRepair = '/repairs/new';
  static const String repairDetails = '/repairs/:id';
  static const String customers = '/customers';
  static const String technicians = '/technicians';
  static const String reports = '/reports';
  static const String settings = '/settings';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // قراءة حالة تسجيل الدخول بأمان
      final authState = ref.read(authProvider);
      
      // إذا كان النظام لا يزال في مرحلة التهيئة، لا تفعل شيئاً
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn) {
        return isLoggingIn ? null : AppRoutes.login;
      }

      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.repairs,
        builder: (context, state) => const RepairsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.newRepair,
        builder: (context, state) => const NewRepairScreen(),
      ),
      GoRoute(
        path: AppRoutes.repairDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return RepairDetailsScreen(repairId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.customers,
        builder: (context, state) => const CustomersListScreen(),
      ),
      GoRoute(
        path: AppRoutes.technicians,
        builder: (context, state) => const TechniciansScreen(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Error: ${state.error}')),
    ),
  );
});
