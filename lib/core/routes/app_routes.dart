import 'package:flutter/material.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/models/campaign_model.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/models/notification_model.dart';
import 'package:siaganusa/screens/auth/login_screen.dart';
import 'package:siaganusa/screens/auth/register_screen.dart';
import 'package:siaganusa/screens/dashboard/main_shell.dart';
import 'package:siaganusa/screens/disaster/earthquake_detail_screen.dart';
import 'package:siaganusa/screens/disaster/hotspot_detail_screen.dart';
import 'package:siaganusa/screens/disaster/impact_analysis_screen.dart';
import 'package:siaganusa/screens/disaster/risk_analysis_screen.dart';
import 'package:siaganusa/screens/disaster/tsunami_detail_screen.dart';
import 'package:siaganusa/screens/donation/campaign_detail_screen.dart';
import 'package:siaganusa/screens/donation/create_campaign_screen.dart';
import 'package:siaganusa/screens/donation/donation_history_screen.dart';
import 'package:siaganusa/screens/donation/payment_screen.dart';
import 'package:siaganusa/screens/emergency/emergency_contacts_screen.dart';
import 'package:siaganusa/screens/emergency/go_bag_screen.dart';
import 'package:siaganusa/screens/mitigation/mitigation_data.dart';
import 'package:siaganusa/screens/mitigation/mitigation_detail_screen.dart';
import 'package:siaganusa/screens/notification/notification_detail_screen.dart';
import 'package:siaganusa/screens/notification/notification_screen.dart';
import 'package:siaganusa/screens/report/report_form_screen.dart';
import 'package:siaganusa/screens/report/report_status_screen.dart';
import 'package:siaganusa/screens/splash/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generate(RouteSettings settings) {
    final args = settings.arguments;

    Widget page;
    switch (settings.name) {
      case RouteNames.splash:
        page = const SplashScreen();
      case RouteNames.login:
        page = const LoginScreen();
      case RouteNames.register:
        page = const RegisterScreen();
      case RouteNames.main:
        page = const MainShell();
      case RouteNames.disasterDetail:
        final d = args as DisasterModel;
        page = switch (d.type) {
          DisasterType.earthquake => EarthquakeDetailScreen(disaster: d),
          DisasterType.tsunami => TsunamiDetailScreen(disaster: d),
          DisasterType.wildfire => HotspotDetailScreen(disaster: d),
        };
      case RouteNames.impactAnalysis:
        page = ImpactAnalysisScreen(disaster: args as DisasterModel);
      case RouteNames.riskAnalysis:
        page = RiskAnalysisScreen(disaster: args as DisasterModel);
      case RouteNames.notifications:
        page = const NotificationScreen();
      case RouteNames.notificationDetail:
        page = NotificationDetailScreen(item: args as NotificationModel);
      case RouteNames.mitigationDetail:
        page = MitigationDetailScreen(guide: args as MitigationGuide);
      case RouteNames.emergencyContacts:
        page = const EmergencyContactsScreen();
      case RouteNames.goBag:
        page = const GoBagScreen();
      case RouteNames.reportForm:
        page = ReportFormScreen(related: args is DisasterModel ? args : null);
      case RouteNames.reportStatus:
        page = const ReportStatusScreen();
      case RouteNames.campaignDetail:
        page = CampaignDetailScreen(campaign: args as CampaignModel);
      case RouteNames.payment:
        page = PaymentScreen(campaign: args as CampaignModel);
      case RouteNames.donationHistory:
        page = const DonationHistoryScreen();
      case RouteNames.createCampaign:
        page = const CreateCampaignScreen();
      default:
        page = const Scaffold(
          body: Center(child: Text('Halaman tidak ditemukan')),
        );
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
