import 'package:flutter/material.dart';

class ServiceSelectionGrid extends StatelessWidget {
  const ServiceSelectionGrid({super.key});

  final List<Map<String, dynamic>> services = const [
    {'icon': Icons.water_drop, 'label': 'Plumber', 'color': Colors.blue},
    {
      'icon': Icons.electrical_services,
      'label': 'Electrician',
      'color': Colors.amber
    },
    {'icon': Icons.lock, 'label': 'Locksmith', 'color': Colors.grey},
    {'icon': Icons.build, 'label': 'Mechanic', 'color': Colors.orange},
    {
      'icon': Icons.cleaning_services,
      'label': 'Cleaner',
      'color': Colors.purple
    },
    {'icon': Icons.local_shipping, 'label': 'Mover', 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _ServiceCard(
          icon: service['icon'],
          label: service['label'],
          color: service['color'],
          onTap: () {
            // Navigate to Request Config
          },
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
