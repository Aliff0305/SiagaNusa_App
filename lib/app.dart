import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/constants/app_strings.dart';
import 'package:siaganusa/core/routes/app_routes.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/theme/dark_theme.dart';
import 'package:siaganusa/core/theme/light_theme.dart';
import 'package:siaganusa/providers/auth_provider.dart';
import 'package:siaganusa/providers/dashboard_provider.dart';
import 'package:siaganusa/providers/disaster_provider.dart';
import 'package:siaganusa/providers/donation_provider.dart';
import 'package:siaganusa/providers/notification_provider.dart';
import 'package:siaganusa/providers/report_provider.dart';
import 'package:siaganusa/providers/theme_provider.dart';

class SiagaNusaApp extends StatelessWidget {
  const SiagaNusaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DisasterProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => DonationProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: LightTheme.theme,
          darkTheme: DarkTheme.theme,
          themeMode: theme.mode,
          initialRoute: RouteNames.splash,
          onGenerateRoute: AppRoutes.generate,
        ),
      ),
    );
  }
}
