// lib/models/hazard_report.dart

class HazardReport {
  String id;
  String reporterId;
  String reporterName;
  String reporterRole;
  DateTime reportedAt;
  
  String hazardType; // e.g., "Equipment", "Environmental", "Behavior", "Structural"
  String severity; // "Low", "Medium", "High", "Critical"
  String description;
  String? imageUrl; // Path to captured image
  String? voiceMessageUrl; // Path to voice recording
  String? textNotes;
  
  String location; // Where the hazard was found
  String status; // "Pending", "Acknowledged", "Resolved"
  
  HazardReport({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.reporterRole,
    required this.reportedAt,
    required this.hazardType,
    required this.severity,
    required this.description,
    this.imageUrl,
    this.voiceMessageUrl,
    this.textNotes,
    required this.location,
    this.status = 'Pending',
  });

  /// Check if report is ready to submit (has at least image or voice message or description)
  bool get canSubmit => 
      (imageUrl != null && imageUrl!.isNotEmpty) ||
      (voiceMessageUrl != null && voiceMessageUrl!.isNotEmpty) ||
      (description.isNotEmpty);

  @override
  String toString() => 
      'HazardReport(type: $hazardType, severity: $severity, status: $status)';
}

/// Hazard types and severity levels for the app
class HazardConstants {
  static const List<String> hazardTypes = [
    'Equipment Malfunction',
    'Structural Hazard',
    'Environmental Hazard',
    'Unsafe Behavior',
    'PPE Issue',
    'Communication Failure',
    'Other',
  ];

  static const List<String> severityLevels = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  static const Map<String, String> severityColors = {
    'Low': '0xFF3B82F6',      // Blue
    'Medium': '0xFFF59E0B',   // Yellow/Orange
    'High': '0xFFEF4444',     // Red
    'Critical': '0xFF991B1B', // Dark Red
  };

  static const Map<String, String> hazardDescriptions = {
    'Equipment Malfunction': 'Broken or malfunctioning equipment',
    'Structural Hazard': 'Roof falls, floor instability, support issues',
    'Environmental Hazard': 'Gas buildup, poor ventilation, contamination',
    'Unsafe Behavior': 'Workers not following safety protocols',
    'PPE Issue': 'Missing or damaged personal protective equipment',
    'Communication Failure': 'Lack of coordination between workers',
    'Other': 'Other safety concerns',
  };
}

/// Global hazard report manager
class HazardReportManager {
  static final HazardReportManager _instance = HazardReportManager._internal();

  factory HazardReportManager() {
    return _instance;
  }

  HazardReportManager._internal();

  final List<HazardReport> _reports = [];

  List<HazardReport> get allReports => _reports;
  
  List<HazardReport> get pendingReports => 
      _reports.where((r) => r.status == 'Pending').toList();
  
  List<HazardReport> get criticalReports =>
      _reports.where((r) => r.severity == 'Critical').toList();

  /// Submit a new hazard report
  void submitReport(HazardReport report) {
    _reports.add(report);
    // In a real app, this would send to backend
    print('Hazard Report Submitted: $report');
  }

  /// Get report by ID
  HazardReport? getReportById(String id) {
    try {
      return _reports.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update report status
  void updateReportStatus(String reportId, String newStatus) {
    try {
      final report = _reports.firstWhere((r) => r.id == reportId);
      _reports[_reports.indexOf(report)] = HazardReport(
        id: report.id,
        reporterId: report.reporterId,
        reporterName: report.reporterName,
        reporterRole: report.reporterRole,
        reportedAt: report.reportedAt,
        hazardType: report.hazardType,
        severity: report.severity,
        description: report.description,
        imageUrl: report.imageUrl,
        voiceMessageUrl: report.voiceMessageUrl,
        textNotes: report.textNotes,
        location: report.location,
        status: newStatus,
      );
    } catch (e) {
      print('Report not found: $reportId');
    }
  }

  /// Get reports count by severity
  Map<String, int> getReportCountBySeverity() {
    final counts = {
      'Low': 0,
      'Medium': 0,
      'High': 0,
      'Critical': 0,
    };
    
    for (var report in _reports) {
      counts[report.severity] = (counts[report.severity] ?? 0) + 1;
    }
    
    return counts;
  }

  void clearReports() {
    _reports.clear();
  }
}