import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // Uncomment when map added

class RequestConfigurationScreen extends StatefulWidget {
  const RequestConfigurationScreen({super.key});

  @override
  State<RequestConfigurationScreen> createState() =>
      _RequestConfigurationScreenState();
}

class _RequestConfigurationScreenState
    extends State<RequestConfigurationScreen> {
  int _selectedUrgencyIndex = 0;

  final List<Map<String, dynamic>> _urgencyOptions = [
    {
      'title': 'Emergency',
      'subtitle': '30-45 mins',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.red,
    },
    {
      'title': 'Same Day',
      'subtitle': 'Within 24hrs',
      'icon': Icons.calendar_today,
      'color': Colors.orange,
    },
    {
      'title': 'Scheduled',
      'subtitle': 'Pick a date',
      'icon': Icons.event_available,
      'color': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Help')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How urgent is it?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // Urgency Selector
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _urgencyOptions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final option = _urgencyOptions[index];
                      final isSelected = _selectedUrgencyIndex == index;

                      return InkWell(
                        onTap: () =>
                            setState(() => _selectedUrgencyIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? option['color'].withOpacity(0.1)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? option['color']
                                  : Colors.grey.shade200,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: option['color'].withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(option['icon'],
                                    color: option['color']),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      option['subtitle'],
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_circle,
                                    color: option['color']),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  Text(
                    'Confirm Location',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // Map Placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.map,
                              size: 60, color: Colors.grey.shade300),
                          const Positioned(
                            child: Icon(Icons.location_on,
                                color: AppTheme.primary, size: 40),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('Estimated Cost:')),
                    Text(
                      '~ \$50',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Submit Request
                    },
                    child: const Text('Find Providers'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
