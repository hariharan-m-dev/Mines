// lib/models/user_stats.dart

class UserStats {
  int completedChecklists;
  int streak; // Days of consecutive checklist completion
  double safetyScore; // Percentage: (perfect checklists / total checklists) * 100
  DateTime? lastCompletionDate;
  List<ChecklistCompletion> completionHistory;

  UserStats({
    this.completedChecklists = 0,
    this.streak = 0,
    this.safetyScore = 0.0,
    this.lastCompletionDate,
    this.completionHistory = const [],
  });

  /// Update stats after a checklist is completed
  void recordCompletion(ChecklistCompletion completion) {
    completedChecklists++;
    completionHistory.add(completion);
    
    // Update streak
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (lastCompletionDate == null) {
      streak = 1;
    } else {
      final lastDate = DateTime(
        lastCompletionDate!.year,
        lastCompletionDate!.month,
        lastCompletionDate!.day,
      );
      
      final difference = today.difference(lastDate).inDays;
      
      if (difference == 0) {
        // Same day, no change to streak
      } else if (difference == 1) {
        // Consecutive day, increment streak
        streak++;
      } else {
        // Gap in streak, reset to 1
        streak = 1;
      }
    }
    
    lastCompletionDate = now;
    
    // Calculate safety score
    _calculateSafetyScore();
  }

  /// Calculate safety score based on completion history
  void _calculateSafetyScore() {
    if (completionHistory.isEmpty) {
      safetyScore = 0.0;
      return;
    }
    
    final perfectCount = completionHistory
        .where((c) => c.isPerfect)
        .length;
    
    safetyScore = (perfectCount / completionHistory.length) * 100;
  }

  /// Reset daily stats (call this when starting a new day)
  void resetDailyStats() {
    // Optionally clear some data or reset for a new day
    // This depends on your app's logic
  }

  /// Get level based on completed checklists (gamification badge)
  String getLevel() {
    if (completedChecklists >= 100) return 'Safety Master';
    if (completedChecklists >= 50) return 'Safety Expert';
    if (completedChecklists >= 25) return 'Safety Champion';
    if (completedChecklists >= 10) return 'Safety Guardian';
    if (completedChecklists >= 5) return 'Safety Ally';
    return 'Safety Novice';
  }

  /// Get achievement badges
  List<String> getAchievements() {
    final achievements = <String>[];
    
    if (streak >= 7) achievements.add('Week Warrior - 7 day streak');
    if (streak >= 30) achievements.add('Monthly Master - 30 day streak');
    if (safetyScore >= 95) achievements.add('Perfect Guardian - 95%+ safety score');
    if (completedChecklists >= 50) achievements.add('Golden Guardian - 50 checklists');
    if (completedChecklists >= 100) achievements.add('Platinum Guardian - 100 checklists');
    
    return achievements;
  }

  @override
  String toString() =>
      'UserStats(completed: $completedChecklists, streak: $streak, score: ${safetyScore.toStringAsFixed(1)}%)';
}

/// Model for individual checklist completion record
class ChecklistCompletion {
  String roleId;
  String roleName;
  DateTime completedAt;
  int totalChecks;
  int passedChecks;
  int failedChecks;
  List<String> failedCheckIds; // IDs of checks marked as "No"

  ChecklistCompletion({
    required this.roleId,
    required this.roleName,
    required this.completedAt,
    required this.totalChecks,
    required this.passedChecks,
    required this.failedChecks,
    this.failedCheckIds = const [],
  });

  /// A checklist is "perfect" if all checks passed (no "No" answers)
  bool get isPerfect => failedChecks == 0;

  /// Get completion percentage
  double get completionPercentage =>
      (passedChecks / totalChecks) * 100;
}

/// Global user stats manager (for session-based storage)
class UserStatsManager {
  static final UserStatsManager _instance = UserStatsManager._internal();

  factory UserStatsManager() {
    return _instance;
  }

  UserStatsManager._internal();

  late UserStats _stats = UserStats();

  UserStats get stats => _stats;

  void recordChecklistCompletion(ChecklistCompletion completion) {
    _stats.recordCompletion(completion);
  }

  void resetStats() {
    _stats = UserStats();
  }

  /// Get stats as a readable summary
  String getStatsSummary() {
    return 'Completed: ${_stats.completedChecklists} | '
        'Streak: ${_stats.streak} days | '
        'Safety Score: ${_stats.safetyScore.toStringAsFixed(1)}%';
  }
}