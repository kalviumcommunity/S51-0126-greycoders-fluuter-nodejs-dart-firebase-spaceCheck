import 'package:flutter/material.dart';
import '../../models/space_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/space_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../spaces/space_detail_screen.dart';
import '../../services/database_service.dart';

class DashboardScreen extends StatefulWidget {
  final bool isAdmin;

  const DashboardScreen({super.key, this.isAdmin = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Stream<List<SpaceModel>> _spacesStream;

  @override
  void initState() {
    super.initState();
    // Connect to real Firestore stream
    _spacesStream = DatabaseService().getSpaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pop(), 
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
                'Error loading spaces: ${snapshot.error}',
                style: const TextStyle(color: AppColors.occupied),
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
              crossAxisCount: 2, 
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
