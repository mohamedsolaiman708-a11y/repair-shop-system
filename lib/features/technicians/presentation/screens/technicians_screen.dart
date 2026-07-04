import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/technician_provider.dart';

class TechniciansScreen extends ConsumerWidget {
  const TechniciansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final branchId = user?.branchId ?? '';
    final techsState = ref.watch(branchTechniciansProvider(branchId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Branch Technicians'),
      ),
      body: techsState.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                'No technicians registered under this branch.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final tech = list[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.engineering_outlined)),
                  title: Text(tech.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Specialization: ${tech.specialization ?? "General Electronics"}'),
                  trailing: Icon(
                    Icons.circle,
                    size: 12,
                    color: tech.isActive ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading technicians: $err')),
      ),
    );
  }
}
