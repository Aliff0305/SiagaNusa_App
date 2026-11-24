import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/providers/dashboard_provider.dart';
import 'package:siaganusa/providers/disaster_provider.dart';
import 'package:siaganusa/providers/donation_provider.dart';
import 'package:siaganusa/providers/notification_provider.dart';
import 'package:siaganusa/screens/dashboard/dashboard_screen.dart';
import 'package:siaganusa/screens/donation/donation_screen.dart';
import 'package:siaganusa/screens/map/disaster_map_screen.dart';
import 'package:siaganusa/screens/mitigation/mitigation_screen.dart';
import 'package:siaganusa/screens/profile/profile_screen.dart';
import 'package:siaganusa/widgets/bottom_navigation.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DisasterProvider>().load();
      context.read<NotificationProvider>().load();
      context.read<DonationProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dash = context.watch<DashboardProvider>();
    return Scaffold(
      body: IndexedStack(
        index: dash.tabIndex,
        children: const [
          DashboardScreen(),
          DisasterMapScreen(),
          DonationScreen(),
          MitigationScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: dash.tabIndex,
        onTap: dash.setTab,
      ),
    );
  }
}
