import 'package:flutter/material.dart';
import 'package:wedo_flutter/presentation/home/widgets/add_project_buttom_sheet.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/project_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> projects = [
      {
        'title': 'Groceries',
        'completed': 5,
        'total': 10,
        'icon': Icons.shopping_cart_outlined,
        'collaborators': ['https://i.pravatar.cc/100?img=1'],
      },
      {
        'title': 'Flutter Project',
        'completed': 18,
        'total': 24,
        'icon': Icons.code_rounded,
        'collaborators': [
          'https://i.pravatar.cc/100?img=2',
          'https://i.pravatar.cc/100?img=3',
          'https://i.pravatar.cc/100?img=4',
        ],
      },
      {
        'title': 'Trip to Dahab',
        'completed': 1,
        'total': 5,
        'icon': Icons.flight_takeoff_rounded,
        'collaborators': ['https://i.pravatar.cc/100?img=5'],
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textLight),
          onPressed: () {},
        ),
        title: const Text(
          'WeDo',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=9'),
            ),
          ),
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            const Text(
              'My Lists',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You have ${projects.length} active projects',
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(), 
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return ProjectCard(
                    title: project['title'],
                    completedTasks: project['completed'],
                    totalTasks: project['total'],
                    icon: project['icon'],
                    collaboratorsImages: List<String>.from(project['collaborators']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, 
            backgroundColor: Colors.transparent, 
            builder: (context) => const AddProjectBottomSheet(),
          );
        },
        backgroundColor: AppColors.accent,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Text(
          'add',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}