import 'package:flutter/material.dart';
import 'video_player_screen.dart';
import 'models/user_stats.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? userEmail;
  String? userRole;
  bool isOnline = true;
  int pendingSync = 0;

  late UserStats userStats;

  @override
  void initState() {
    super.initState();
    userStats = UserStatsManager().stats;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      userEmail = args['email'] as String?;
      userRole = args['role'] as String?;
    }
  }

  final List<Map<String, dynamic>> roles = [
    {
      'id': 'truck_driver',
      'name': 'Haul Truck Driver',
      'icon': Icons.local_shipping,
      'color': const Color(0xFFEF4444),
      'gradient': const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
      ),
      'checks': 10,
      'description': 'Vehicle safety inspection',
    },
    {
      'id': 'underground_miner',
      'name': 'Underground Miner',
      'icon': Icons.construction,
      'color': const Color(0xFFF59E0B),
      'gradient': const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
      ),
      'checks': 10,
      'description': 'Roof support & gas detection',
    },
    {
      'id': 'blaster',
      'name': 'Blaster / Explosives Handler',
      'icon': Icons.warning_amber,
      'color': const Color(0xFFDC2626),
      'gradient': const LinearGradient(
        colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
      ),
      'checks': 11,
      'description': 'Detonator & blast area safety',
    },
    {
      'id': 'electrician',
      'name': 'Electrician / Maintenance',
      'icon': Icons.flash_on,
      'color': const Color(0xFF3B82F6),
      'gradient': const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
      ),
      'checks': 10,
      'description': 'Electrical & equipment safety',
    },
    {
      'id': 'supervisor',
      'name': 'Supervisor / Safety Officer',
      'icon': Icons.shield,
      'color': const Color(0xFF8B5CF6),
      'gradient': const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      ),
      'checks': 11,
      'description': 'Team safety monitoring',
    },
  ];

  void _startChecklist(Map<String, dynamic> role) async {
    final result = await Navigator.pushNamed(
      context,
      '/checklist',
      arguments: {
        'roleId': role['id'],
        'roleName': role['name'],
        'roleIcon': role['icon'],
        'roleColor': role['color'],
        'checks': role['checks'],
        'userId': userEmail?.split('@')[0] ?? 'user',
        'userName': userEmail?.split('@')[0]?.toUpperCase() ?? 'Worker',
      },
    );

    if (result != null) {
      setState(() {
        userStats = UserStatsManager().stats;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRoleCard = roles.firstWhere(
      (role) => role['id'] == userRole,
      orElse: () => roles[0],
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1020),
              Color(0xFF0F1730),
              Color(0xFF0B1020),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),
              SliverToBoxAdapter(
                child: _buildStatusBanner(),
              ),
              SliverToBoxAdapter(
                child: _buildQuickStats(),
              ),
              SliverToBoxAdapter(
                child: _buildVideoOfTheDayCard(),
              ),
              SliverToBoxAdapter(
                child: _buildLevelAndAchievements(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Row(
                    children: [
                      const Text(
                        'Your Role Today',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: userRoleCard['color'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '< 2 min',
                          style: TextStyle(
                            fontSize: 12,
                            color: userRoleCard['color'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: _buildPrimaryRoleCard(userRoleCard),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openHazardReport(),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.warning_rounded),
        label: const Text('Report Hazard'),
        tooltip: 'Report safety hazard immediately',
      ),
    );
  }

  void _openHazardReport() {
    Navigator.pushNamed(
      context,
      '/hazard-report',
      arguments: {
        'userId': userEmail?.split('@')[0] ?? 'user',
        'userName': userEmail?.split('@')[0]?.toUpperCase() ?? 'Worker',
        'userRole': userRole ?? 'Worker',
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shield,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suraksha Saathi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Mine Safety Companion',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white54),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome back,',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail?.split('@')[0].toUpperCase() ?? 'Worker',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOnline
            ? const Color(0xFF10B981).withOpacity(0.15)
            : const Color(0xFFF59E0B).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOnline
              ? const Color(0xFF10B981).withOpacity(0.3)
              : const Color(0xFFF59E0B).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.wifi : Icons.wifi_off,
            color: isOnline ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isOnline
                  ? 'Online • All systems synced'
                  : 'Offline Mode • $pendingSync pending sync',
              style: TextStyle(
                color: isOnline ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.check_circle,
              label: 'Completed',
              value: userStats.completedChecklists.toString(),
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.local_fire_department,
              label: 'Streak',
              value: '${userStats.streak} days',
              color: const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.star,
              label: 'Safety Score',
              value: '${userStats.safetyScore.toStringAsFixed(0)}%',
              color: const Color(0xFFF59E0B),
            ),
          ),
        ],
      ),
    );
  }

  // lib/dashboard_screen.dart

// ... (inside _RoleSelectionScreenState class)

  Widget _buildVideoOfTheDayCard() {
    // Define your YouTube video URL here
    const String myYouTubeVideoUrl = 'https://youtu.be/ERVmTWFuaAo?si=QK4hiQyZ2EHaLmFJ'; // <--- REPLACE THIS WITH YOUR YOUTUBE LINK

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Card(
        color: const Color(0xFF111A33).withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to the video player screen and pass the URL
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(youtubeUrl: myYouTubeVideoUrl),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Video of the Day',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Watch a short safety tip',
                        style: TextStyle(fontSize: 13, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111A33).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelAndAchievements() {
    final level = userStats.getLevel();
    final achievements = userStats.getAchievements();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8B5CF6).withOpacity(0.15),
            const Color(0xFFF59E0B).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.whatshot, color: Color(0xFF8B5CF6), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Level',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      level,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (achievements.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Achievements',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            ...achievements.map((achievement) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        achievement,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildPrimaryRoleCard(Map<String, dynamic> role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: role['gradient'],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: role['color'].withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _startChecklist(role),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        role['icon'],
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Primary Role',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            role['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  role['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${role['checks']} safety checks',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start Daily Check',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}