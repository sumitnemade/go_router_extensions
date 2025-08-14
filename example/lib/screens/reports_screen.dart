import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          const Text(
            'This is the reports screen loaded with deferred shell routing.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _ReportCard(
                  title: 'Monthly Sales Report',
                  description: 'Comprehensive analysis of sales performance',
                  date: 'March 2024',
                  status: 'Completed',
                  isCompleted: true,
                ),
                const SizedBox(height: 12),
                _ReportCard(
                  title: 'User Engagement Report',
                  description:
                      'Analysis of user behavior and engagement metrics',
                  date: 'March 2024',
                  status: 'In Progress',
                  isCompleted: false,
                ),
                const SizedBox(height: 12),
                _ReportCard(
                  title: 'Financial Summary',
                  description: 'Quarterly financial performance overview',
                  date: 'Q1 2024',
                  status: 'Scheduled',
                  isCompleted: false,
                ),
                const SizedBox(height: 12),
                _ReportCard(
                  title: 'Marketing Campaign Report',
                  description: 'ROI analysis of recent marketing campaigns',
                  date: 'February 2024',
                  status: 'Completed',
                  isCompleted: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String status;
  final bool isCompleted;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isCompleted
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
