import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'models/hazard_report.dart';
import 'dart:async';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class HazardReportingScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userRole;

  const HazardReportingScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userRole,
  }) : super(key: key);

  @override
  State<HazardReportingScreen> createState() => _HazardReportingScreenState();
}

// Replace your entire _HazardReportingScreenState class with this new version
class _HazardReportingScreenState extends State<HazardReportingScreen> {
  // --- NEW: Audio recorder instance ---
  late final AudioRecorder _audioRecorder;

  String? selectedHazardType;
  String? selectedSeverity;
  String? capturedImagePath;
  String? voiceMessagePath;
  bool isRecording = false;
  Timer? recordingTimer;
  int recordingSeconds = 0;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _textNotesController = TextEditingController();

  // --- NEW: Initialize the recorder ---
  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _textNotesController.dispose();
    recordingTimer?.cancel();
    // --- NEW: Dispose the recorder ---
    _audioRecorder.dispose();
    super.dispose();
  }
  
  // --- UPDATED: Real voice recording logic ---
  void _startVoiceRecording() async {
    // Check for microphone permission
    if (await _audioRecorder.hasPermission()) {
      setState(() {
        isRecording = true;
        recordingSeconds = 0;
      });

      // Get a temporary directory to save the file
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Start recording
      await _audioRecorder.start(const RecordConfig(), path: path);

      // Start the UI timer
      recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if(mounted) {
          setState(() {
            recordingSeconds++;
          });
        }
      });
    } else {
      // Handle permission denial
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required to record audio.')),
      );
    }
  }

  // --- UPDATED: Real stop recording logic ---
  void _stopVoiceRecording() async {
    recordingTimer?.cancel();
    final path = await _audioRecorder.stop(); // Stop recording

    if (path != null) {
      setState(() {
        isRecording = false;
        voiceMessagePath = path; // Save the REAL file path
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice message recorded: ${_formatDuration(recordingSeconds)}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }


  // --- All your other methods (_captureImage, _formatDuration, _canSubmit, _submitReport) remain the same ---
  // --- All your build methods (_build... widgets) also remain the same ---
  
  // (The rest of your code for this class goes here)

  void _captureImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        capturedImagePath = pickedFile.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image captured successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image capture canceled.')),
      );
    }
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  bool get _canSubmit {
    return (selectedHazardType != null &&
        selectedSeverity != null &&
        _locationController.text.isNotEmpty &&
        (capturedImagePath != null ||
            voiceMessagePath != null ||
            _descriptionController.text.isNotEmpty));
  }

  void _submitReport() {
    final report = HazardReport(
      id: 'hazard_${DateTime.now().millisecondsSinceEpoch}',
      reporterId: widget.userId,
      reporterName: widget.userName,
      reporterRole: widget.userRole,
      reportedAt: DateTime.now(),
      hazardType: selectedHazardType!,
      severity: selectedSeverity!,
      description: _descriptionController.text,
      imageUrl: capturedImagePath,
      voiceMessageUrl: voiceMessagePath,
      textNotes: _textNotesController.text,
      location: _locationController.text,
    );
    HazardReportManager().submitReport(report);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hazard report submitted successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if(mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1730),
        elevation: 0,
        title: const Text('Report Hazard'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_rounded, color: Colors.red, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Report any hazard immediately to keep everyone safe',
                      style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildSectionTitle('Hazard Type'),
            _buildHazardTypeSelector(),
            _buildSectionTitle('Severity Level'),
            _buildSeveritySelector(),
            _buildSectionTitle('Location'),
            _buildTextField(
              controller: _locationController,
              hintText: 'Where is the hazard? (e.g., Level 3, Section A)',
              icon: Icons.location_on,
            ),
            _buildSectionTitle('Description (Optional)'),
            _buildTextField(
              controller: _descriptionController,
              hintText: 'Describe the hazard...',
              icon: Icons.description,
              maxLines: 3,
            ),
            _buildSectionTitle('Image (Optional)'),
            _buildImageSection(),
            _buildSectionTitle('Voice Message (Recommended)'),
            _buildVoiceMessageSection(),
            _buildSectionTitle('Additional Notes (Optional)'),
            _buildTextField(
              controller: _textNotesController,
              hintText: 'Any additional details...',
              icon: Icons.note,
              maxLines: 2,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _submitReport : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Hazard Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHazardTypeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ...HazardConstants.hazardTypes.map((type) {
            final isSelected = selectedHazardType == type;
            return GestureDetector(
              onTap: () => setState(() => selectedHazardType = type),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.red : Colors.white.withOpacity(0.1),
                    width: 2,
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
                          color: isSelected ? Colors.red : Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        color: isSelected ? Colors.red : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            HazardConstants.hazardDescriptions[type] ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSeveritySelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ...HazardConstants.severityLevels.map((severity) {
            final isSelected = selectedSeverity == severity;
            final colorHex = HazardConstants.severityColors[severity] ?? '0xFF000000';
            final color = Color(int.parse(colorHex));
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedSeverity = severity),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.3) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? color : Colors.white.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.flag,
                        color: isSelected ? color : Colors.white.withOpacity(0.5),
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        severity,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.5)),
          filled: true,
          fillColor: const Color(0xFF0F1730),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: capturedImagePath != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.file(
                    File(capturedImagePath!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => capturedImagePath = null),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: _captureImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white54, size: 32),
                    SizedBox(height: 8),
                    Text('Tap to capture image', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
    );
  }
  
  Widget _buildVoiceMessageSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: voiceMessagePath != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.green),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Playing audio... (simulated)')),
                      );
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Voice message recorded',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatDuration(recordingSeconds),
                          style: TextStyle(color: Colors.green.shade300, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() {
                      voiceMessagePath = null;
                      recordingSeconds = 0;
                    }),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: isRecording ? _stopVoiceRecording : _startVoiceRecording,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isRecording ? Colors.red.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isRecording ? Colors.red : Colors.white.withOpacity(0.1), width: isRecording ? 2 : 1),
                ),
                child: Column(
                  children: [
                    Icon(
                      isRecording ? Icons.stop : Icons.mic,
                      color: isRecording ? Colors.red : Colors.white54,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isRecording ? 'Recording... ${_formatDuration(recordingSeconds)}' : 'Tap to record voice message',
                      style: TextStyle(
                        color: isRecording ? Colors.red : Colors.white70,
                        fontWeight: isRecording ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}