import 'package:flutter/material.dart';
import '../features/auth/login_screen.dart';
import '../features/request/service_selection_screen.dart';
import '../features/request/urgency_screen.dart';
import '../features/request/map_view_screen.dart';
import '../features/provider/provider_dashboard_screen.dart';

class AppRoutes {
  static const login = '/';
  static const serviceSelection = '/service';
  static const urgency = '/urgency';
  static const mapView = '/map';
  static const tracking = '/tracking';
  static const providerDashboard = '/provider';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.login: (_) => const LoginScreen(),
  AppRoutes.serviceSelection: (_) => const ServiceSelectionScreen(),
  AppRoutes.urgency: (_) => const UrgencyScreen(),
  AppRoutes.mapView: (_) => const MapViewScreen(),
  AppRoutes.providerDashboard: (_) => const ProviderDashboardScreen(),
};
