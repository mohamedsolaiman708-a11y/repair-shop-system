import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../repairs/presentation/providers/repair_provider.dart';
import '../../../repairs/domain/entities/repair_order.dart';
import '../../../technicians/presentation/providers/technician_provider.dart';
import '../../../branches/presentation/providers/branch_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repairsState = ref.watch(repairOrdersListProvider((status: null, query: null)));
    final branchesState = ref.watch(branchesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Operations & Financial Reports'),
      ),
      body: repairsState.when(
        data: (repairs) {
          // Total Revenue
          final totalRevenue = repairs
              .where((r) => r.status == RepairStatus.delivered)
              .fold<double>(0.0, (sum, item) => sum + (item.finalCost ?? 0));

          // Pending collections (ready for pickup but not delivered)
          final pendingCollections = repairs
              .where((r) => r.status == RepairStatus.readyForPickup)
              .fold<double>(0.0, (sum, item) => sum + ((item.finalCost ?? item.estimatedCost ?? 0) - item.deposit));

          // Out of Order count
          final activeRepairs = repairs
              .where((r) => r.status != RepairStatus.delivered && r.status != RepairStatus.cancelled)
              .length;

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Summary Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Total Revenue Collected',
                      value: '\$${totalRevenue.toStringAsFixed(2)}',
                      icon: Icons.payments_outlined,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Outstanding Balances',
                      value: '\$${pendingCollections.toStringAsFixed(2)}',
                      icon: Icons.account_balance_wallet_outlined,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Active Repair Pipeline',
                      value: activeRepairs.toString(),
                      icon: Icons.pending_actions_outlined,
                      color: AppTheme.kPrimaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Detail breakdowns
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  return Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Branch Performance table
                      Expanded(
                        flex: isWide ? 1 : 0,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Revenue by Branch',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                branchesState.when(
                                  data: (branches) {
                                    return Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(1.2),
                                      },
                                      children: [
                                        const TableRow(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.0),
                                              child: Text('Branch Name', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.0),
                                              child: Text('Repairs', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.0),
                                              child: Text('Revenue', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        ...branches.map((b) {
                                          final branchRepairs = repairs.where((r) => r.branchId == b.id);
                                          final branchRevenue = branchRepairs
                                              .where((r) => r.status == RepairStatus.delivered)
                                              .fold<double>(0.0, (sum, item) => sum + (item.finalCost ?? 0));

                                          return TableRow(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Text(b.name),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Text(branchRepairs.length.toString()),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Text('\$${branchRevenue.toStringAsFixed(2)}'),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    );
                                  },
                                  loading: () => const Center(child: CircularProgressIndicator()),
                                  error: (err, stack) => Text('Error loading branches: $err'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isWide) const SizedBox(width: 24),
                      if (!isWide) const SizedBox(height: 24),

                      // Repair status breakdown
                      Expanded(
                        flex: isWide ? 1 : 0,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Repairs by Status',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(1),
                                  },
                                  children: [
                                    const TableRow(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Text('Count', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    ...RepairStatus.values.map((status) {
                                      final count = repairs.where((r) => r.status == status).length;
                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Text(status.label),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Text(count.toString()),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading reports: $err')),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 12),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
              ],
            ),
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
