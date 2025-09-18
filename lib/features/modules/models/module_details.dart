import 'package:flutter/material.dart';

// A simple class to hold the information for a syllabus area card.
class SyllabusAreaInfo {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  SyllabusAreaInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

// This helper function returns the correct list of syllabus areas based on the module ID.
List<SyllabusAreaInfo> getSyllabusAreasForModule(String moduleId) {
  switch (moduleId) {
    case 'BA4':
      return [
        SyllabusAreaInfo(
          id: 'A',
          title: 'Syllabus Area A',
          subtitle: 'Business Ethics & Ethical Conflict',
          icon: Icons.shield_outlined,
        ),
        SyllabusAreaInfo(
          id: 'B',
          title: 'Syllabus Area B',
          subtitle: 'Corporate Governance & Controls',
          icon: Icons.account_balance_outlined,
        ),
        SyllabusAreaInfo(
          id: 'C',
          title: 'Syllabus Area C',
          subtitle: 'Business & Employment Law',
          icon: Icons.gavel_outlined,
        ),
      ];
    case 'BA1':
      return [
        SyllabusAreaInfo(
          id: 'A',
          title: 'Syllabus Area A',
          subtitle: 'Microeconomics',
          icon: Icons.show_chart_outlined,
        ),
        SyllabusAreaInfo(
          id: 'B',
          title: 'Syllabus Area B',
          subtitle: 'Macroeconomics',
          icon: Icons.public_outlined,
        ),
        SyllabusAreaInfo(
          id: 'C',
          title: 'Syllabus Area C',
          subtitle: 'Financial Context of Business',
          icon: Icons.monetization_on_outlined,
        ),
        SyllabusAreaInfo(
          id: 'D',
          title: 'Syllabus Area D',
          subtitle: 'Data and Forecasting',
          icon: Icons.bar_chart_outlined,
        ),
      ];

    case 'P1':
      return [
        SyllabusAreaInfo(
          id: 'A',
          title: 'Syllabus Area A',
          subtitle: 'Cost Accounting Systems',
          icon: Icons.receipt_long_outlined,
        ),
        SyllabusAreaInfo(
          id: 'B',
          title: 'Syllabus Area B',
          subtitle: 'Budgeting',
          icon: Icons.inventory_2_outlined,
        ),
        SyllabusAreaInfo(
          id: 'C',
          title: 'Syllabus Area C',
          subtitle: 'Short-term Decision Making',
          icon: Icons.lightbulb_outline,
        ),
        SyllabusAreaInfo(
          id: 'D',
          title: 'Syllabus Area D',
          subtitle: 'Dealing with Risk and Uncertainty',
          icon: Icons.gpp_good_outlined,
        ),
      ];
    // This is the newly updated section for P2
    case 'P2':
      return [
        SyllabusAreaInfo(
          id: 'A',
          title: 'Syllabus Area A',
          subtitle: 'Managing Costs for Value Creation',
          icon: Icons.price_check_outlined,
        ),
        SyllabusAreaInfo(
          id: 'B',
          title: 'Syllabus Area B',
          subtitle: 'Capital Investment Decision Making',
          icon: Icons.analytics_outlined,
        ),
        SyllabusAreaInfo(
          id: 'C',
          title: 'Syllabus Area C',
          subtitle: 'Managing Performance of Organisational Units',
          icon: Icons.hub_outlined,
        ),
        SyllabusAreaInfo(
          id: 'D',
          title: 'Syllabus Area D',
          subtitle: 'Risk and Control',
          icon: Icons.shield_outlined,
        ),
      ];
    default:
      // Return an empty list if the module ID is unknown.
      return [];
  }
}
