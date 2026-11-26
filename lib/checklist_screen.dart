import 'package:flutter/material.dart';
import 'mining_checklists_data.dart'; // Import the checklist data
import 'models/user_stats.dart'; // Import the stats model

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});



  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  Map<String, dynamic> _roleData = {};
  List<Map<String, dynamic>> _checklistItems = [];
  
  // Track answers: Map<checkId, bool?> where null means unanswered, true = Yes, false = No
  final Map<String, bool?> _answers = {};
  
  // Track sub-check completion: Map<checkId_subCheckIndex, bool>
  final Map<String, bool> _subCheckAnswers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      _roleData = args as Map<String, dynamic>;
      _loadChecklistForRole();
    }
  }

  void _loadChecklistForRole() {
    final roleId = _roleData['roleId'] as String?;
    if (roleId != null) {
      _checklistItems = MiningChecklistsData.getChecklistForRole(roleId);
      setState(() {});
    }
  }

  void _setMainAnswer(String checkId, bool? answer) {
    setState(() {
      // If clicking the same answer again, deselect it (toggle to null)
      if (_answers[checkId] == answer) {
        _answers[checkId] = null;
        // Clear sub-checks when deselecting
        _clearSubChecksForItem(checkId);
      } else {
        _answers[checkId] = answer;
      }
    });
  }

  void _clearSubChecksForItem(String checkId) {
    final keys = _subCheckAnswers.keys.toList();
    for (var key in keys) {
      if (key.startsWith('${checkId}_')) {
        _subCheckAnswers.remove(key);
      }
    }
  }

  void _openHazardReport() {
    Navigator.pushNamed(
      context,
      '/hazard-report',
      arguments: {
        'userId': _roleData['userId'] as String? ?? 'user',
        'userName': _roleData['userName'] as String? ?? 'Worker',
        'userRole': _roleData['roleId'] as String? ?? 'worker',
      },
    );
  }

  void _setSubCheckAnswer(String checkId, int subIndex, bool answer) {
    setState(() {
      final key = '${checkId}_$subIndex';
      // Toggle: if already checked, uncheck it
      if (_subCheckAnswers[key] == true) {
        _subCheckAnswers.remove(key);
      } else {
        _subCheckAnswers[key] = answer;
      }
    });
  }

  int get _totalChecks {
    return _checklistItems.length;
  }

  // Only count "Yes" answers as completed
  int get _completedChecks {
    return _answers.values.where((answer) => answer == true).length;
  }

  int get _totalSubChecks {
    int total = 0;
    for (var item in _checklistItems) {
      final subChecks = item['subChecks'] as List?;
      if (subChecks != null) {
        total += subChecks.length;
      }
    }
    return total;
  }

  int get _completedSubChecks {
    return _subCheckAnswers.length;
  }

  double get _overallProgress {
    final total = _totalChecks + _totalSubChecks;
    if (total == 0) return 0.0;
    return (_completedChecks + _completedSubChecks) / total;
  }

  bool get _isChecklistComplete {
    // Checklist is complete when all main checks are answered with "Yes"
    if (_totalChecks == 0) return false;
    return _answers.values.every((answer) => answer == true);
  }

  // Check if all sub-checks for a specific item are completed
  int _getSubCheckCountForItem(String checkId) {
    int count = 0;
    for (var key in _subCheckAnswers.keys) {
      if (key.startsWith('${checkId}_')) {
        count++;
      }
    }
    return count;
  }

  int _getTotalSubCheckCountForItem(String checkId, List<String> subChecks) {
    return subChecks.length;
  }

  @override
  Widget build(BuildContext context) {
    final String roleName = _roleData['roleName'] ?? 'Safety Checklist';
    final IconData roleIcon = _roleData['roleIcon'] ?? Icons.shield;
    final Color roleColor = _roleData['roleColor'] ?? Colors.grey;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openHazardReport(),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.warning_rounded),
        label: const Text('Report Hazard'),
        tooltip: 'Report safety hazard immediately',
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1730),
        elevation: 0,
        title: Row(
          children: [
            Icon(roleIcon, color: roleColor, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roleName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_totalChecks} checks to complete',
                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: _overallProgress,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(roleColor),
            minHeight: 6,
          ),

          // Progress Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1730),
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Main Checks', '$_completedChecks / $_totalChecks'),
                _buildStatItem('Sub-Checks', '$_completedSubChecks / $_totalSubChecks'),
                _buildStatItem('Overall', '${(_overallProgress * 100).toStringAsFixed(0)}%'),
              ],
            ),
          ),

          // Checklist Items
          Expanded(
            child: _checklistItems.isEmpty
                ? Center(
                    child: Text(
                      'No checklists available',
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _checklistItems.length,
                    itemBuilder: (context, index) {
                      final item = _checklistItems[index];
                      return _buildCheckItem(item, roleColor);
                    },
                  ),
          ),

          // Submit Button
          _buildSubmitButton(roleColor),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(Map<String, dynamic> item, Color roleColor) {
    final checkId = item['id'] as String;
    final category = item['category'] as String;
    final question = item['question'] as String;
    final subChecks = (item['subChecks'] as List?)?.cast<String>() ?? [];
    final mainAnswer = _answers[checkId];
    final isAnswered = mainAnswer != null;
    final isYes = mainAnswer == true;
    
    // Count completed sub-checks for this item
    final completedSubChecksForItem = _getSubCheckCountForItem(checkId);
    final totalSubChecksForItem = _getTotalSubCheckCountForItem(checkId, subChecks);
    final allSubChecksCompleted = completedSubChecksForItem == totalSubChecksForItem && totalSubChecksForItem > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111A33).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAnswered 
              ? (isYes ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5))
              : Colors.white.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with category and status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: roleColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: roleColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: roleColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (isAnswered && isYes)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.green,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Pass',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (isAnswered && !isYes)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.cancel,
                              size: 14,
                              color: Colors.red,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Fail',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  question,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Sub-checks (always show)
          if (subChecks.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Verify:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '$completedSubChecksForItem / $totalSubChecksForItem',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...subChecks.asMap().entries.map((entry) {
                    final subIndex = entry.key;
                    final subCheck = entry.value;
                    final subCheckKey = '${checkId}_$subIndex';
                    final isSubCompleted = _subCheckAnswers[subCheckKey] == true;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () => _setSubCheckAnswer(checkId, subIndex, !isSubCompleted),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSubCompleted
                                ? Colors.green.withOpacity(0.1)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSubCompleted
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSubCompleted
                                        ? Colors.green
                                        : Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                  color: isSubCompleted
                                      ? Colors.green
                                      : Colors.transparent,
                                ),
                                child: isSubCompleted
                                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  subCheck,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isSubCompleted
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.7),
                                    decoration: isSubCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

          // Main Question Answer Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Is this check complete and safe?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildAnswerButton(
                      checkId: checkId,
                      text: 'No',
                      isSelected: mainAnswer == false,
                      isPositive: false,
                      // Disable "No" if all sub-checks are completed
                      isDisabled: allSubChecksCompleted,
                    ),
                    const SizedBox(width: 12),
                    _buildAnswerButton(
                      checkId: checkId,
                      text: 'Yes',
                      isSelected: mainAnswer == true,
                      isPositive: true,
                      // Disable "Yes" until all sub-checks are completed (if there are sub-checks)
                      isDisabled: subChecks.isNotEmpty && !allSubChecksCompleted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton({
    required String checkId,
    required String text,
    required bool isSelected,
    required bool isPositive,
    required bool isDisabled,
  }) {
    final Color selectedColor = isPositive ? Colors.green : Colors.red;

    return Expanded(
      child: OutlinedButton(
        onPressed: isDisabled ? null : () => _setMainAnswer(checkId, isPositive),
        style: OutlinedButton.styleFrom(
          foregroundColor: isDisabled 
              ? Colors.white30 
              : (isSelected ? Colors.white : Colors.white70),
          backgroundColor: isDisabled 
              ? Colors.transparent
              : (isSelected ? selectedColor.withOpacity(0.2) : Colors.transparent),
          side: BorderSide(
            color: isDisabled 
                ? Colors.white.withOpacity(0.1)
                : (isSelected ? selectedColor : Colors.white.withOpacity(0.3)),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(Color roleColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1730),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            if (!_isChecklistComplete)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Mark all checks as "Yes" to submit',
                  style: TextStyle(
                    fontSize: 12,
                    color: roleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isChecklistComplete
                    ? () {
                        // Record the completion
                        final completion = ChecklistCompletion(
                          roleId: _roleData['roleId'] as String,
                          roleName: _roleData['roleName'] as String,
                          completedAt: DateTime.now(),
                          totalChecks: _totalChecks,
                          passedChecks: _completedChecks,
                          failedChecks: _totalChecks - _completedChecks,
                        );

                        UserStatsManager().recordChecklistCompletion(completion);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${_roleData['roleName']} checklist submitted successfully!'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.of(context).pop(true); // Pass result back
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: roleColor,
                  disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Checklist',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}