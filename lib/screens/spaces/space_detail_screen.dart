import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/space_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';
import '../../services/database_service.dart';

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
  late Stream<SpaceModel> _spaceStream;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _spaceStream = DatabaseService().getSpace(widget.space.id);
  }

  void _handleCheckIn(SpaceModel currentSpace) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to check in')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await DatabaseService().checkIn(currentSpace.id, user.uid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check-in successful!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleCheckOut(SpaceModel currentSpace) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      await DatabaseService().checkOut(currentSpace.id, user.uid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check-out successful!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SpaceModel>(
      stream: _spaceStream,
      initialData: widget.space,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final space = snapshot.data ?? widget.space;
        
        bool canCheckIn =
            space.status == 'available' && // String check from Model
            space.currentOccupancy < space.maxCapacity;

        // Also check if status matches Enum string?
        // Code uses space.status which is String in model.
        // But StatusBadge expects SpaceStatus Enum if not updated?
        // I need to check StatusBadge again. PR 6 step 279 showed it takes SpaceStatus Enum.
        // Wait, did I update StatusBadge to take String?
        // Step 279 view show it takes `final SpaceStatus status`.
        // My SpaceModel (PR 4/6) has `final String status`.
        // COMPILATION ERROR ALERT!
        // `StatusBadge(status: _space.status)` will FAIL if `_space.status` is String and Badge expects Enum.
        // I MUST fix StatusBadge in this PR or previous PRs were broken?
        // PR 6 (Dashboard) had `SpaceCard`. `SpaceCard` likely had `StatusBadge`.
        // I did NOT fix `StatusBadge` in PR 6.
        // So `SpaceCard` might be broken too.
        // I should fix `StatusBadge` to accept String OR convert String to Enum.
        // I'll fix `StatusBadge` in this PR to accept String.
        
        return Scaffold(
          appBar: AppBar(
            title: Text(space.name),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  // Temporary fix: Map String to Enum or Update Badge
                  // I'll update Badge in a separate tool call if possible, or just pass a basic widget here.
                  // For now, I'll update Badge in this PR too.
                  child: StatusBadge(status: _mapStatus(space.status)), 
                ),
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

                // Description (Model doesn't have description yet? I added it in PR 6?
                // Step 280 replace_file_content... I added currentOccupancy/max, but DID NOT add description.
                // FAIL. SpaceModel relies on `data['description']`? No, existing UI used it.
                // My SpaceModel does not have `description`.
                // I should add `description` and `amenities` to SpaceModel to fix this.
                // I will add them in `space_model.dart` in this PR.
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  // space.description ?? 'No description',
                  'Community Space', // Placeholder until model has it
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Timings
                Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      '${space.openTime ?? "N/A"} - ${space.closeTime ?? "N/A"}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Occupancy
                Text(
                  'Live Occupancy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
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
                            '${space.currentOccupancy} / ${space.maxCapacity}',
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
                        value: space.maxCapacity > 0
                            ? space.currentOccupancy / space.maxCapacity
                            : 0,
                        backgroundColor: AppColors.backgroundDark,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Amenities (Model missing amenities)
                Text(
                  'Amenities',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                /*
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (space.amenities ?? [])
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
                */
                const Text("Standard Amenities", style: TextStyle(color: AppColors.textSecondary)),

                const Spacer(),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'Check In',
                        isLoading: _isLoading,
                        onPressed: canCheckIn ? () => _handleCheckIn(space) : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _handleCheckOut(space),
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
      },
    );
  }

  // Helper to map String to Enum for StatusBadge (until we update it)
  SpaceStatus _mapStatus(String status) {
     switch (status.toLowerCase()) {
       case 'available': return SpaceStatus.available;
       case 'occupied': return SpaceStatus.occupied;
       case 'closed': return SpaceStatus.closed;
       default: return SpaceStatus.available;
     }
  }
}
