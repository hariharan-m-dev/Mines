// lib/widgets/hazard_report_button.dart

import 'package:flutter/material.dart';

/// Floating Action Button for reporting hazards
/// Use this in both Dashboard and Checklist screens
class HazardReportFAB extends StatelessWidget {
  final String userId;
  final String userName;
  final String userRole;
  final VoidCallback? onReportSubmitted;

  const HazardReportFAB({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.onReportSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openHazardReport(context),
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.warning_rounded),
      label: const Text('Report Hazard'),
      tooltip: 'Report safety hazard immediately',
    );
  }

  void _openHazardReport(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/hazard-report',
      arguments: {
        'userId': userId,
        'userName': userName,
        'userRole': userRole,
      },
    ).then((result) {
      if (result == true) {
        onReportSubmitted?.call();
      }
    });
  }
}

/// Alternative: Compact button for adding to AppBar or other locations
class HazardReportButton extends StatelessWidget {
  final String userId;
  final String userName;
  final String userRole;
  final VoidCallback? onReportSubmitted;
  final bool compact;

  const HazardReportButton({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.onReportSubmitted,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return IconButton(
        icon: const Icon(Icons.warning_rounded, color: Colors.red),
        onPressed: () => _openHazardReport(context),
        tooltip: 'Report hazard',
      );
    }

    return ElevatedButton.icon(
      onPressed: () => _openHazardReport(context),
      icon: const Icon(Icons.warning_rounded),
      label: const Text('Report Hazard'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _openHazardReport(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/hazard-report',
      arguments: {
        'userId': userId,
        'userName': userName,
        'userRole': userRole,
      },
    ).then((result) {
      if (result == true) {
        onReportSubmitted?.call();
      }
    });
  }
}

// ============================================
// INTEGRATION GUIDE FOR YOUR SCREENS
// ============================================

/*
1. ADD TO DASHBOARD (dashboard_screen.dart):
   
   In the Scaffold, add:
   
   floatingActionButton: HazardReportFAB(
     userId: 'user123', // Get from your auth
     userName: userEmail?.split('@')[0] ?? 'Worker',
     userRole: userRole ?? 'Worker',
     onReportSubmitted: () {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Hazard report recorded')),
       );
     },
   ),

2. ADD TO CHECKLIST (checklist_screen.dart):
   
   In the Scaffold, add:
   
   floatingActionButton: HazardReportFAB(
     userId: 'user123', // Get from your auth
     userName: _roleData['userName'] ?? 'Worker',
     userRole: _roleData['userRole'] ?? 'Worker',
     onReportSubmitted: () {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Hazard report recorded')),
       );
     },
   ),

3. ADD ROUTE TO main.dart:
   
   Add this import:
   import 'hazard_reporting_screen.dart';
   
   In MaterialApp routes:
   routes: {
     '/dashboard': (context) => const RoleSelectionScreen(),
     '/checklist': (context) => const ChecklistScreen(),
     '/hazard-report': (context) {
       final args = ModalRoute.of(context)!.settings.arguments 
           as Map<String, dynamic>;
       return HazardReportingScreen(
         userId: args['userId'] as String,
         userName: args['userName'] as String,
         userRole: args['userRole'] as String,
       );
     },
   },

4. EXAMPLE: Updated dashboard_screen.dart with FAB
   
   In _RoleSelectionScreenState:
   
   @override
   Widget build(BuildContext context) {
     // ... existing code ...
     
     return Scaffold(
       backgroundColor: const Color(0xFF0B1020),
       body: Container(
         // ... existing container code ...
       ),
       floatingActionButton: HazardReportFAB(
         userId: userEmail?.split('@')[0] ?? 'user',
         userName: userEmail?.split('@')[0]?.toUpperCase() ?? 'Worker',
         userRole: userRole ?? 'Worker',
         onReportSubmitted: () {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
               content: Text('✓ Hazard report submitted'),
               backgroundColor: Colors.green,
             ),
           );
         },
       ),
     );
   }

5. EXAMPLE: Updated checklist_screen.dart with FAB
   
   In _ChecklistScreenState:
   
   @override
   Widget build(BuildContext context) {
     // ... existing code ...
     
     return Scaffold(
       backgroundColor: const Color(0xFF0B1020),
       appBar: AppBar(
         // ... existing appbar code ...
       ),
       body: Column(
         // ... existing body code ...
       ),
       floatingActionButton: HazardReportFAB(
         userId: _roleData['userId'] as String? ?? 'user',
         userName: _roleData['userName'] as String? ?? 'Worker',
         userRole: _roleData['roleId'] as String? ?? 'worker',
         onReportSubmitted: () {
           // Optionally refresh or show notification
         },
       ),
     );
   }

6. FEATURES OF THE HAZARD REPORTING SYSTEM:

   ✓ Hazard Types: Equipment, Structural, Environmental, 
     Unsafe Behavior, PPE, Communication, Other
   
   ✓ Severity Levels: Low, Medium, High, Critical
     (Each with color coding for quick visual reference)
   
   ✓ Required Fields:
     - Hazard Type
     - Severity Level
     - Location
     - At least one: Image OR Voice Message OR Description
   
   ✓ Optional Fields:
     - Text Description
     - Additional Notes
   
   ✓ Media Support:
     - Image capture via phone camera
     - Voice recording with timer
     - Duration display for voice messages
   
   ✓ Data Persistence:
     - All reports stored in HazardReportManager
     - Accessible from anywhere in the app
     - Timestamp tracking
     - Reporter info captured automatically

7. FUTURE ENHANCEMENTS (when adding real integrations):

   - Replace image capture simulation with:
     * image_picker package for gallery/camera
     * image compression before upload
   
   - Replace voice recording simulation with:
     * record package for audio recording
     * audio compression and upload to backend
   
   - Backend integration:
     * Send reports to server
     * Real-time notifications to supervisors
     * Report tracking dashboard
   
   - Multilingual support:
     * Translate hazard types and descriptions
     * Voice-to-text in multiple languages
   
   - Analytics:
     * Track most common hazards
     * Identify high-risk areas
     * Monitor response times

8. ACCESSING REPORTS:

   Get all reports:
   final allReports = HazardReportManager().allReports;
   
   Get pending reports:
   final pending = HazardReportManager().pendingReports;
   
   Get critical reports:
   final critical = HazardReportManager().criticalReports;
   
   Get report counts by severity:
   final counts = HazardReportManager().getReportCountBySeverity();
   
   Update report status:
   HazardReportManager().updateReportStatus('report_id', 'Resolved');
*/