import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/repair_order.dart';
import '../providers/repair_provider.dart';

class RepairsListScreen extends ConsumerStatefulWidget {
  const RepairsListScreen({super.key});

  @override
  ConsumerState<RepairsListScreen> createState() => _RepairsListScreenState();
}

class _RepairsListScreenState extends ConsumerState<RepairsListScreen> {
  final _searchController = TextEditingController();
  RepairStatus? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    
    // Fetch repair orders matching query and status
    final repairsState = ref.watch(repairOrdersListProvider((
      status: _selectedStatus?.name,
      query: query.isEmpty ? null : query,
    )));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Orders'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.newRepair),
        icon: const Icon(Icons.add),
        label: const Text('New Repair'),
      ),
      body: Column(
        children: [
          // Filter Panel
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search by Number, Barcode...',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (_) {
                          setState(() {}); // Trigger rebuild to watch updated query provider
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<RepairStatus>(
                      value: _selectedStatus,
                      hint: const Text('Filter by Status'),
                      underline: const SizedBox(),
                      items: [
                        const DropdownMenuItem<RepairStatus>(
                          value: null,
                          child: Text('All Statuses'),
                        ),
                        ...RepairStatus.values.map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.label),
                            )),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _selectedStatus = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Repairs List
          Expanded(
            child: repairsState.when(
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.playlist_remove, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No repair orders found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          'Order #${item.repairNumber}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.problemDescription),
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${item.createdAt.toLocal().toString().substring(0, 16)}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Chip(
                              label: Text(item.status.label),
                              backgroundColor: _getStatusColor(item.status).withOpacity(0.1),
                              side: BorderSide(color: _getStatusColor(item.status)),
                            ),
                          ],
                        ),
                        onTap: () => context.push('/repairs/${item.id}'),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading repairs: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(RepairStatus status) {
    switch (status) {
      case RepairStatus.registered:
        return Colors.blue;
      case RepairStatus.underInspection:
        return Colors.orange;
      case RepairStatus.waitingCustomerApproval:
        return Colors.amber.shade700;
      case RepairStatus.repairInProgress:
        return AppTheme.kSecondaryLight;
      case RepairStatus.waitingParts:
        return Colors.purple;
      case RepairStatus.readyForPickup:
        return Colors.green;
      case RepairStatus.delivered:
        return Colors.teal;
      case RepairStatus.cancelled:
      case RepairStatus.notRepairable:
        return AppTheme.kError;
    }
  }
}
