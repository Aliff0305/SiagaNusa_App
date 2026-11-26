import 'package:flutter/material.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/models/campaign_model.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/models/donation_model.dart';
import 'package:siaganusa/models/notification_model.dart';
import 'package:siaganusa/screens/auth/login_screen.dart';
import 'package:siaganusa/screens/auth/register_screen.dart';
import 'package:siaganusa/screens/dashboard/main_shell.dart';
import 'package:siaganusa/screens/disaster/disaster_detail_screen.dart';
import 'package:siaganusa/screens/disaster/impact_analysis_screen.dart';
import 'package:siaganusa/screens/disaster/risk_analysis_screen.dart';
import 'package:siaganusa/screens/donation/campaign_detail_screen.dart';
import 'package:siaganusa/screens/donation/create_campaign_screen.dart';
import 'package:siaganusa/screens/donation/donation_history_screen.dart';
import 'package:siaganusa/screens/donation/donation_payment_screen.dart';
import 'package:siaganusa/screens/donation/donation_success_screen.dart';
import 'package:siaganusa/screens/emergency/emergency_contact_screen.dart';
import 'package:siaganusa/screens/emergency/evacuation_screen.dart';
import 'package:siaganusa/screens/mitigation/mitigation_detail_screen.dart';
import 'package:siaganusa/screens/mitigation/mitigation_screen.dart';
import 'package:siaganusa/screens/mitigation/preparedness_screen.dart';
import 'package:siaganusa/screens/notification/notification_detail_screen.dart';
import 'package:siaganusa/screens/notification/notification_screen.dart';
import 'package:siaganusa/screens/profile/edit_profile_screen.dart';
import 'package:siaganusa/screens/profile/settings_screen.dart';
import 'package:siaganusa/screens/report/create_report_screen.dart';
import 'package:siaganusa/screens/report/report_history_screen.dart';
import 'package:siaganusa/screens/report/report_screen.dart';
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
        page = DisasterDetailScreen(disaster: args as DisasterModel);
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
      case RouteNames.preparedness:
        page = const PreparednessScreen();
      case RouteNames.emergencyContacts:
        page = const EmergencyContactScreen();
      case RouteNames.evacuation:
        page = const EvacuationScreen();
      case RouteNames.report:
        page = const ReportScreen();
      case RouteNames.createReport:
        page = CreateReportScreen(related: args is DisasterModel ? args : null);
      case RouteNames.reportHistory:
        page = const ReportHistoryScreen();
      case RouteNames.campaignDetail:
        page = CampaignDetailScreen(campaign: args as CampaignModel);
      case RouteNames.payment:
        page = DonationPaymentScreen(campaign: args as CampaignModel);
      case RouteNames.donationSuccess:
        page = DonationSuccessScreen(donation: args as DonationModel);
      case RouteNames.donationHistory:
        page = const DonationHistoryScreen();
      case RouteNames.createCampaign:
        page = const CreateCampaignScreen();
      case RouteNames.editProfile:
        page = const EditProfileScreen();
      case RouteNames.settings:
        page = const SettingsScreen();
      default:
        page = const Scaffold(
          body: Center(child: Text('Halaman tidak ditemukan')),
        );
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
