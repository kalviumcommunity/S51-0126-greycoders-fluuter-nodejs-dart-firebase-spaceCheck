import 'package:flutter/material.dart';
import '../../models/space_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/space_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../spaces/space_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  final bool isAdmin;

  const DashboardScreen({super.key, this.isAdmin = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Simulate stream
  late Stream<List<SpaceModel>> _spacesStream;

  @override
  void initState() {
    super.initState();
    _spacesStream = _getMockSpaces();
  }

  Stream<List<SpaceModel>> _getMockSpaces() async* {
    while (true) {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Initial loading
      yield [
        const SpaceModel(
          id: '1',
          name: 'Community Gym',
          description:
              'State of the art gym equipment available for all residents.',
          imageUrl: '',
          status: SpaceStatus.available,
          currentOccupancy: 5,
          maxCapacity: 20,
          amenities: ['AC', 'Water', 'Trainer'],
          openTime: '06:00 AM',
          closeTime: '10:00 PM',
        ),
        const SpaceModel(
          id: '2',
          name: 'Swimming Pool',
          description: 'Olympic size swimming pool.',
          imageUrl: '',
          status: SpaceStatus.occupied,
          currentOccupancy: 18,
          maxCapacity: 20,
          amenities: ['Showers', 'Lockers'],
          openTime: '07:00 AM',
          closeTime: '08:00 PM',
        ),
        const SpaceModel(
          id: '3',
          name: 'Conference Room',
          description: 'Quiet space for meetings and work.',
          imageUrl: '',
          status: SpaceStatus.available,
          currentOccupancy: 0,
          maxCapacity: 8,
          amenities: ['Wifi', 'Projector'],
          openTime: '09:00 AM',
          closeTime: '06:00 PM',
        ),
        const SpaceModel(
          id: '4',
          name: 'Party Hall',
          description: 'Large hall for celebrations.',
          imageUrl: '',
          status: SpaceStatus.closed,
          currentOccupancy: 0,
          maxCapacity: 100,
          amenities: ['Sound System', 'Kitchen'],
          openTime: '10:00 AM',
          closeTime: '11:00 PM',
        ),
      ];
      await Future.delayed(const Duration(seconds: 10)); // Updates every 10s
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading:
            false, // Don't show back button if coming from login
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(
              context,
            ).pop(), // Go back to login or handle logout
          ),
        ],
      ),
      body: StreamBuilder<List<SpaceModel>>(
        stream: _spacesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading spaces',
                style: TextStyle(color: AppColors.occupied),
              ),
            );
          }

          final spaces = snapshot.data ?? [];

          if (spaces.isEmpty) {
            return const EmptyStateWidget(
              title: 'No Spaces Found',
              message: 'Check back later for available community spaces.',
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns for card look
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final space = spaces[index];
              return SpaceCard(
                space: space,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpaceDetailScreen(
                        space: space,
                        isAdmin: widget.isAdmin,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
