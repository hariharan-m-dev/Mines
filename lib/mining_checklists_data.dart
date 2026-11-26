// This file contains comprehensive, role-specific safety checklists for miners
// Each role has multiple detailed checks covering their specific responsibilities

class MiningChecklistsData {
  static final Map<String, List<Map<String, dynamic>>> checklistsByRole = {
    'truck_driver': [
      {
        'id': 'tire_inspection',
        'category': 'Vehicle Inspection',
        'question': 'Are all tires properly inflated and free of damage or cuts?',
        'subChecks': [
          'Check tire pressure matches specifications',
          'Inspect for cuts, punctures, or wear',
          'Verify wheel bolts are tight',
        ],
      },
      {
        'id': 'brake_system',
        'category': 'Vehicle Inspection',
        'question': 'Is the brake system functioning properly with adequate pressure?',
        'subChecks': [
          'Test brake responsiveness',
          'Check brake fluid level',
          'Inspect brake pads for wear',
          'Listen for unusual brake noises',
        ],
      },
      {
        'id': 'steering',
        'category': 'Vehicle Inspection',
        'question': 'Is steering smooth and responsive with no excessive play?',
        'subChecks': [
          'Check steering wheel for looseness',
          'Test steering response at rest',
          'Verify power steering fluid level',
        ],
      },
      {
        'id': 'lights_mirrors',
        'category': 'Vehicle Inspection',
        'question': 'Are all headlights, tail lights, and mirrors clean and functional?',
        'subChecks': [
          'Check all external lights work',
          'Verify mirrors are clean and adjusted',
          'Test turn signals and hazard lights',
        ],
      },
      {
        'id': 'load_securing',
        'category': 'Load Management',
        'question': 'Is the load properly balanced, secured, and within weight limits?',
        'subChecks': [
          'Verify load secured with straps or chains',
          'Check weight is within truck capacity',
          'Ensure load is properly distributed',
          'Confirm tarp is secure if needed',
        ],
      },
      {
        'id': 'visibility',
        'category': 'Safety Equipment',
        'question': 'Is visibility adequate? Are windows and mirrors clean?',
        'subChecks': [
          'Clean windshield and side windows',
          'Remove dirt or debris from mirrors',
          'Check for obstructions around vehicle',
        ],
      },
      {
        'id': 'ppe_equipment',
        'category': 'Safety Equipment',
        'question': 'Do you have required PPE and emergency equipment in the cab?',
        'subChecks': [
          'Seat belt present and functional',
          'First aid kit accessible',
          'Fire extinguisher in place',
          'Reflective vest and hard hat available',
        ],
      },
      {
        'id': 'route_planning',
        'category': 'Pre-Drive Check',
        'question': 'Have you reviewed the route for hazards or weight restrictions?',
        'subChecks': [
          'Aware of restricted areas',
          'Know bridge weight limits',
          'Identified tight turns or steep grades',
        ],
      },
      {
        'id': 'communication',
        'category': 'Pre-Drive Check',
        'question': 'Is communication equipment working (radio, phone)?',
        'subChecks': [
          'Test radio for clear transmission',
          'Ensure phone battery is charged',
          'Know dispatch contact numbers',
        ],
      },
      {
        'id': 'weather_conditions',
        'category': 'Environmental Check',
        'question': 'Have you assessed current weather and visibility conditions?',
        'subChecks': [
          'Check for rain or wet surfaces',
          'Assess visibility distance',
          'Know wind direction and speed',
          'Plan for reduced visibility if needed',
        ],
      },
    ],
    'underground_miner': [
      {
        'id': 'roof_support',
        'category': 'Structural Safety',
        'question': 'Are roof support systems (bolts, timber) intact with no visible damage?',
        'subChecks': [
          'Inspect roof bolts for tightness',
          'Check for fresh falls of rock',
          'Verify support timbers are not cracked',
          'Look for sagging or displacement',
        ],
      },
      {
        'id': 'gas_detection',
        'category': 'Environmental Hazards',
        'question': 'Is the atmosphere safe with no gas hazards detected?',
        'subChecks': [
          'Test gas detection equipment is operational',
          'Check for methane levels',
          'Monitor for carbon monoxide',
          'Verify oxygen levels are adequate',
        ],
      },
      {
        'id': 'ventilation',
        'category': 'Environmental Hazards',
        'question': 'Is ventilation adequate and airflow moving through the work area?',
        'subChecks': [
          'Feel air movement in workplace',
          'Check ventilation ducts for blockages',
          'Verify fan operation',
          'No stale air pockets detected',
        ],
      },
      {
        'id': 'ground_stability',
        'category': 'Structural Safety',
        'question': 'Is the floor stable with no subsidence, cracks, or soft spots?',
        'subChecks': [
          'Walk area to check for soft ground',
          'Look for fresh cracks or fractures',
          'Check for water seepage',
          'Verify no loose material underfoot',
        ],
      },
      {
        'id': 'ppe_inspection',
        'category': 'Personal Protection',
        'question': 'Is your helmet, lamp, and self-rescue device all functioning?',
        'subChecks': [
          'Helmet secure and no cracks',
          'Cap lamp produces bright light',
          'Battery level adequate for shift',
          'Self-rescue device sealed properly',
        ],
      },
      {
        'id': 'equipment_safety',
        'category': 'Equipment Check',
        'question': 'Are hand tools and equipment in safe working condition?',
        'subChecks': [
          'Check tools for damage or wear',
          'Ensure handles are secure',
          'Verify electrical equipment is grounded',
          'No damaged cords or cables',
        ],
      },
      {
        'id': 'escape_routes',
        'category': 'Emergency Preparedness',
        'question': 'Are escape routes clearly marked and unobstructed?',
        'subChecks': [
          'Know primary escape route',
          'Identify secondary escape route',
          'No debris blocking exits',
          'Emergency signs visible',
        ],
      },
      {
        'id': 'communication_systems',
        'category': 'Emergency Preparedness',
        'question': 'Are communication systems working for emergency contact?',
        'subChecks': [
          'Test underground phone system',
          'Verify radio reception',
          'Know procedure to call for help',
          'Emergency contact numbers known',
        ],
      },
      {
        'id': 'hazard_awareness',
        'category': 'Environmental Hazards',
        'question': 'Are there any new hazards, obstacles, or changes since last shift?',
        'subChecks': [
          'Report any new cracks or falls',
          'Note any unusual sounds',
          'Check for new water sources',
          'Alert supervisor of changes',
        ],
      },
      {
        'id': 'working_height',
        'category': 'Structural Safety',
        'question': 'Is working height adequate with clearance for safe movement?',
        'subChecks': [
          'Verify minimum headroom available',
          'No stooping hazards present',
          'Ladders or platforms stable',
          'No low-hanging hazards',
        ],
      },
    ],
    'blaster': [
      {
        'id': 'detonator_inspection',
        'category': 'Explosive Safety',
        'question': 'Are all detonators intact, properly sealed, and stored securely?',
        'subChecks': [
          'Inspect detonators for damage or corrosion',
          'Verify seals are unbroken',
          'Check expiration dates',
          'Confirm secure storage location',
        ],
      },
      {
        'id': 'explosive_storage',
        'category': 'Explosive Safety',
        'question': 'Are explosives stored in proper magazine with correct ventilation?',
        'subChecks': [
          'Magazine temperature within limits',
          'Moisture control adequate',
          'Inventory records accurate',
          'Unauthorized access prevented',
        ],
      },
      {
        'id': 'blast_area_perimeter',
        'category': 'Blast Site Safety',
        'question': 'Is the blast area properly cordoned with clear warning signs?',
        'subChecks': [
          'Perimeter marked at safe distance',
          'Warning signs visible and legible',
          'All personnel accounted for outside zone',
          'Secondary blast radius identified',
        ],
      },
      {
        'id': 'blast_design',
        'category': 'Blast Planning',
        'question': 'Has the blast design been reviewed and approved by supervisor?',
        'subChecks': [
          'Hole depth and spacing correct',
          'Explosive quantities calculated',
          'Charge configuration documented',
          'Blast timing sequences verified',
        ],
      },
      {
        'id': 'ppe_compliance',
        'category': 'Personal Protection',
        'question': 'Are you wearing all required PPE including hearing protection?',
        'subChecks': [
          'Hard hat with chin strap secure',
          'Safety glasses with side protection',
          'Ear protection properly inserted',
          'Steel-toed boots on',
          'Gloves appropriate for task',
        ],
      },
      {
        'id': 'wiring_integrity',
        'category': 'Explosive Safety',
        'question': 'Are blast wires intact with no damage, cuts, or fraying?',
        'subChecks': [
          'Inspect wiring for continuity',
          'Check connections are crimped securely',
          'Verify insulation is intact',
          'Test circuits with multimeter',
        ],
      },
      {
        'id': 'weather_conditions',
        'category': 'Environmental Factors',
        'question': 'Are weather conditions suitable for blasting (no lightning risk)?',
        'subChecks': [
          'Check weather forecast before blast',
          'Postpone if lightning possible',
          'Monitor wind direction for flyrock',
          'Assess visibility for post-blast inspection',
        ],
      },
      {
        'id': 'communication_protocol',
        'category': 'Blast Site Safety',
        'question': 'Are communication protocols established and understood?',
        'subChecks': [
          'All personnel know blast signals',
          'Radio communication clear and loud',
          'Final verbal all-clear obtained',
          'Countdown procedures confirmed',
        ],
      },
      {
        'id': 'equipment_condition',
        'category': 'Equipment Safety',
        'question': 'Is blasting equipment properly maintained and calibrated?',
        'subChecks': [
          'Detonator timer functioning correctly',
          'Blast machine battery fully charged',
          'Cables tested for continuity',
          'All connections secure',
        ],
      },
      {
        'id': 'post_blast_inspection',
        'category': 'Blast Site Safety',
        'question': 'Will blast area be safely inspected after detonation?',
        'subChecks': [
          'Plan inspection protocol',
          'Identify hazards to check for',
          'Assign personnel for inspection',
          'Schedule appropriate waiting time',
        ],
      },
      {
        'id': 'incident_plan',
        'category': 'Emergency Preparedness',
        'question': 'Is there a documented response plan for blast emergencies?',
        'subChecks': [
          'Know first aid procedures',
          'Emergency contacts accessible',
          'Evacuation routes identified',
          'Medical kit present and stocked',
        ],
      },
    ],
    'electrician': [
      {
        'id': 'electrical_hazards',
        'category': 'Electrical Safety',
        'question': 'Are electrical hazards identified and proper precautions taken?',
        'subChecks': [
          'High voltage areas marked clearly',
          'Lockout/tagout procedures followed',
          'Circuits de-energized before work',
          'No water near electrical sources',
        ],
      },
      {
        'id': 'ppe_electrical',
        'category': 'Personal Protection',
        'question': 'Are you wearing appropriate electrical safety PPE?',
        'subChecks': [
          'Insulated gloves in good condition',
          'Non-conductive shoes worn',
          'Hard hat and safety glasses on',
          'No metallic jewelry or watches',
        ],
      },
      {
        'id': 'tool_inspection',
        'category': 'Equipment Safety',
        'question': 'Are all electrical tools properly grounded and tested?',
        'subChecks': [
          'Tool cords inspected for damage',
          'Grounding pins present and intact',
          'No exposed wiring',
          'Three-prong plugs functional',
        ],
      },
      {
        'id': 'circuit_breaker',
        'category': 'Electrical Safety',
        'question': 'Are circuit breakers and panels properly labeled and accessible?',
        'subChecks': [
          'All circuits labeled clearly',
          'Breaker ratings appropriate',
          'Panel clear of obstructions',
          'Emergency shut-off accessible',
        ],
      },
      {
        'id': 'cable_management',
        'category': 'Equipment Safety',
        'question': 'Are cables properly routed with no trip hazards or damage?',
        'subChecks': [
          'Cables secured out of walkways',
          'No cables under equipment or machinery',
          'Temporary cables have proper sleeves',
          'No damaged or frayed insulation',
        ],
      },
      {
        'id': 'equipment_maintenance',
        'category': 'Equipment Safety',
        'question': 'Has electrical equipment been properly maintained and serviced?',
        'subChecks': [
          'Follow maintenance schedules',
          'Document all service performed',
          'Parts replaced with proper specifications',
          'Testing completed after repairs',
        ],
      },
      {
        'id': 'battery_safety',
        'category': 'Equipment Safety',
        'question': 'Are battery systems properly maintained with adequate ventilation?',
        'subChecks': [
          'Battery terminals clean and tight',
          'No corrosion or damage visible',
          'Ventilation prevents gas buildup',
          'Battery case intact',
        ],
      },
      {
        'id': 'fire_prevention',
        'category': 'Environmental Safety',
        'question': 'Are fire hazards minimized with proper electrical practices?',
        'subChecks': [
          'No overloaded circuits',
          'Circuits not bypassed with jumpers',
          'Combustible materials away from heat',
          'Fire extinguisher accessible',
        ],
      },
      {
        'id': 'communication_systems',
        'category': 'Equipment Safety',
        'question': 'Are emergency communication systems functional?',
        'subChecks': [
          'Phone or radio working',
          'Emergency numbers posted',
          'Alarm systems tested',
          'Know emergency procedures',
        ],
      },
      {
        'id': 'confined_space',
        'category': 'Environmental Safety',
        'question': 'If working in confined spaces, are precautions in place?',
        'subChecks': [
          'Permit obtained and on file',
          'Atmosphere tested for hazards',
          'Rescue equipment ready',
          'Standby personnel present',
        ],
      },
    ],
    'supervisor': [
      {
        'id': 'team_safety_briefing',
        'category': 'Team Management',
        'question': 'Have all team members received safety briefing for today?',
        'subChecks': [
          'Briefing covered job hazards',
          'All personnel attended',
          'Questions answered clearly',
          'Briefing documented',
        ],
      },
      {
        'id': 'hazard_assessment',
        'category': 'Site Assessment',
        'question': 'Have all workplace hazards been assessed and documented?',
        'subChecks': [
          'Conducted hazard walk-through',
          'New hazards identified',
          'Controls implemented',
          'Staff briefed on hazards',
        ],
      },
      {
        'id': 'ppe_compliance',
        'category': 'Safety Compliance',
        'question': 'Are all team members wearing required PPE correctly?',
        'subChecks': [
          'Conduct visual inspection',
          'Correct usage observed',
          'Damaged PPE replaced',
          'Personnel trained on proper use',
        ],
      },
      {
        'id': 'equipment_inspection',
        'category': 'Equipment Management',
        'question': 'Have all work equipment been inspected and found safe?',
        'subChecks': [
          'Equipment maintenance logs reviewed',
          'Recent repairs documented',
          'Defective equipment removed',
          'Replacements available',
        ],
      },
      {
        'id': 'incident_investigation',
        'category': 'Incident Management',
        'question': 'Are there any unreported incidents that need investigation?',
        'subChecks': [
          'Talk to team members',
          'Document any incidents',
          'Investigate root causes',
          'Implement corrective actions',
        ],
      },
      {
        'id': 'near_miss_tracking',
        'category': 'Safety Records',
        'question': 'Have near-misses been recorded and reviewed?',
        'subChecks': [
          'Review yesterday\'s near-miss reports',
          'Investigate trends',
          'Share findings with team',
          'Implement preventive measures',
        ],
      },
      {
        'id': 'safety_training',
        'category': 'Team Development',
        'question': 'Is ongoing safety training being conducted for team development?',
        'subChecks': [
          'Training schedule current',
          'Personnel attendance recorded',
          'New procedures explained',
          'Competency assessed',
        ],
      },
      {
        'id': 'emergency_procedures',
        'category': 'Emergency Preparedness',
        'question': 'Are emergency procedures understood and drills conducted?',
        'subChecks': [
          'Evacuation plan posted',
          'Emergency contacts available',
          'First aid station stocked',
          'Drills scheduled regularly',
        ],
      },
      {
        'id': 'communication_effectiveness',
        'category': 'Team Management',
        'question': 'Is communication with team clear and safety-focused?',
        'subChecks': [
          'Safety meetings held regularly',
          'Two-way communication encouraged',
          'Concerns addressed promptly',
          'Positive safety culture promoted',
        ],
      },
      {
        'id': 'regulatory_compliance',
        'category': 'Safety Compliance',
        'question': 'Are operations compliant with all mining safety regulations?',
        'subChecks': [
          'Regulations reviewed regularly',
          'Procedures updated as needed',
          'Compliance documentation maintained',
          'Inspections conducted',
        ],
      },
      {
        'id': 'performance_metrics',
        'category': 'Safety Records',
        'question': 'Are safety performance metrics being tracked and analyzed?',
        'subChecks': [
          'Incident statistics reviewed',
          'Safety scores calculated',
          'Trends identified',
          'Goals set and monitored',
        ],
      },
    ],
  };

  /// Get checklist questions for a specific role
  static List<Map<String, dynamic>> getChecklistForRole(String roleId) {
    return checklistsByRole[roleId] ?? checklistsByRole['underground_miner'] ?? [];
  }

  /// Get all available role IDs
  static List<String> getAvailableRoles() {
    return checklistsByRole.keys.toList();
  }

  /// Count total checks for a role
  static int getCheckCountForRole(String roleId) {
    return getChecklistForRole(roleId).length;
  }
}