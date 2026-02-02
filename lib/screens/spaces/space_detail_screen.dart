import 'package:flutter/material.dart';
import '../../models/space_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

class SpaceDetailScreen extends StatefulWidget {
  final SpaceModel space;
  final bool isAdmin;

  const SpaceDetailScreen({
    super.key,
    required this.space,
    this.isAdmin = false,
  });

  @override
  State<SpaceDetailScreen> createState() => _SpaceDetailScreenState();
}

class _SpaceDetailScreenState extends State<SpaceDetailScreen> {
  late SpaceModel _space;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _space = widget.space;
  }

  void _handleCheckIn() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
        // Ideally update the state/stream here
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Check-in successful!')));
      });
    }
  }

  void _handleCheckOut() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Check-out successful!')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool canCheckIn =
        _space.status == SpaceStatus.available &&
        _space.currentOccupancy < _space.maxCapacity;

    return Scaffold(
      appBar: AppBar(
        title: Text(_space.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: StatusBadge(status: _space.status)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.image,
                size: 64,
                color: AppColors.textCaption,
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'Description',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              _space.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Timings
            Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  '${_space.openTime} - ${_space.closeTime}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Occupancy
            Text(
              'Live Occupancy',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_space.currentOccupancy} / ${_space.maxCapacity}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Text(
                        'People currently inside',
                        style: TextStyle(color: AppColors.textCaption),
                      ),
                    ],
                  ),
                  CircularProgressIndicator(
                    value: _space.maxCapacity > 0
                        ? _space.currentOccupancy / _space.maxCapacity
                        : 0,
                    backgroundColor: AppColors.backgroundDark,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Amenities
            Text(
              'Amenities',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _space.amenities
                  .map(
                    (a) => Chip(
                      label: Text(a),
                      backgroundColor: AppColors.surfaceDark,
                      labelStyle: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                  .toList(),
            ),

            const Spacer(),

            // Action Buttons
            if (widget.isAdmin)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Manage Space (Admin)',
                    isFullWidth: true,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Admin Manager opened')),
                      );
                    },
                  ),
                ),
              ),

            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'Check In',
                    isLoading: _isLoading && canCheckIn, // naive loading check
                    onPressed: canCheckIn ? _handleCheckIn : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handleCheckOut,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Check Out',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
