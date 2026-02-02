import 'package:flutter/material.dart';
import '../models/space_model.dart';
import '../utils/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final SpaceStatus status;

  const StatusBadge({super.key, required this.status});

  Color _getColor() {
    switch (status) {
      case SpaceStatus.available:
        return AppColors.available;
      case SpaceStatus.occupied:
        return AppColors.occupied;
      case SpaceStatus.closed:
      case SpaceStatus.maintenance:
        return AppColors.closed;
    }
  }

  String _getText() {
    switch (status) {
      case SpaceStatus.available:
        return 'Available';
      case SpaceStatus.occupied:
        return 'Occupied';
      case SpaceStatus.closed:
        return 'Closed';
      case SpaceStatus.maintenance:
        return 'Maintenance';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            _getText().toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
