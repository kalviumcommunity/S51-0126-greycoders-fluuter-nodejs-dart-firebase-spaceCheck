import 'package:flutter/material.dart';
import '../models/space_model.dart';
import '../utils/app_colors.dart';
import 'status_badge.dart';

class SpaceCard extends StatelessWidget {
  final SpaceModel space;
  final VoidCallback onTap;
  final VoidCallback? onActionPressed;

  const SpaceCard({
    super.key,
    required this.space,
    required this.onTap,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image / Header
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.surfaceDark, // Fallback
                    child: Center(
                      child: Icon(
                        _getIconForSpace(space.name),
                        size: 40,
                        color: AppColors.textCaption,
                      ),
                    ),
                  ),
                  // In a real app, use Image.network(space.imageUrl) here
                  Positioned(
                    top: 12,
                    right: 12,
                    child: StatusBadge(status: space.status),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          space.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${space.currentOccupancy} / ${space.maxCapacity} Occupied',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),

                    // Linear Progress for occupancy
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: space.maxCapacity > 0
                            ? space.currentOccupancy / space.maxCapacity
                            : 0,
                        backgroundColor: AppColors.backgroundDark,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getOccupancyColor(
                            space.currentOccupancy,
                            space.maxCapacity,
                          ),
                        ),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForSpace(String name) {
    // Helper to return icon based on name
    name = name.toLowerCase();
    if (name.contains('gym')) return Icons.fitness_center;
    if (name.contains('pool')) return Icons.pool;
    if (name.contains('park')) return Icons.local_parking;
    if (name.contains('hall')) return Icons.celebration;
    if (name.contains('meet')) return Icons.meeting_room;
    return Icons.place;
  }

  Color _getOccupancyColor(int current, int max) {
    if (max == 0) return AppColors.closed;
    final double ratio = current / max;
    if (ratio >= 0.9) return AppColors.occupied;
    if (ratio >= 0.6) return AppColors.booked;
    return AppColors.available;
  }
}
