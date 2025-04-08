import 'package:flutter/material.dart';

class GovService {
  final String name;
  final String serviceType; // Instead of @StringRes, we directly store the string
  final IconData serviceIcon; // Instead of @DrawableRes, we use Flutter's IconData

  const GovService({
    required this.name,
    required this.serviceType,
    required this.serviceIcon,
  });

  static const GovService adminService = GovService(
    name: "admin",
    serviceType: "Admin Service", // Replace with localized string if needed
    serviceIcon: Icons.admin_panel_settings, // Replace with a custom asset if necessary
  );

  static const GovService lawEnfService = GovService(
    name: "lawenf",
    serviceType: "Law Enforcement Service",
    serviceIcon: Icons.gavel, // Replace with a relevant icon
  );

  static List<GovService> get allServices => [adminService, lawEnfService];
}
