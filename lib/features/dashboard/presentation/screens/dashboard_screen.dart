import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../repairs/domain/entities/repair_order.dart';
import '../../../repairs/presentation/providers/repair_provider.dart';
import '../../../branches/presentation/providers/branch_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String? _selectedBranchId;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final branchesState = ref.watch(branchesListProvider);

    // Filter repairs by branch
    final branchId = user?.isAdmin == true ? _selectedBranchId : user?.branchId;
    final repairsState = ref.watch(repairOrdersListProvider((status: null, query: null)));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.settings_suggest, color: AppTheme.kPrimaryLight, size: 28),
            const SizedBox(width: 8),
            Text(
              'Repair Center Console',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          if (user?.isAdmin == true) ...[
            branchesState.when(
              data: (list) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: _selectedBranchId,
                  hint: const Text('All Branches'),
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Global Overview'),
                    ),
                    ...list.map((b) => DropdownMenuItem(
                          value: b.id,
                          child: Text(b.name),
                        )),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedBranchId = val;
                    });
                  },
                ),
              ),
              loading: () => const SizedBox(),
              error: (e, s) => const SizedBox(),
            ),
          ],
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: repairsState.when(
        data: (repairs) {
          // Filter list by selected branch if set
          final filteredRepairs = branchId != null
              ? repairs.where((r) => r.branchId == branchId).toList()
              : repairs;

          // Calculate metrics
          final today = DateTime.now();
          final todayRepairs = filteredRepairs.where((r) {
            return r.createdAt.year == today.year &&
                r.createdAt.month == today.month &&
                r.createdAt.day == today.day;
          }).length;

          final waitingInspection = filteredRepairs
              .where((r) => r.status == RepairStatus.registered)
              .length;

          final waitingApproval = filteredRepairs
              .where((r) => r.status == RepairStatus.waitingCustomerApproval)
              .length;

          final inProgress = filteredRepairs
              .where((r) => r.status == RepairStatus.repairInProgress)
              .length;

          final waitingParts = filteredRepairs
              .where((r) => r.status == RepairStatus.waitingParts)
              .length;

          final readyForPickup = filteredRepairs
              .where((r) => r.status == RepairStatus.readyForPickup)
              .length;

          final deliveredToday = filteredRepairs.where((r) {
            if (r.deliveredAt == null) return false;
            return r.deliveredAt!.year == today.year &&
                r.deliveredAt!.month == today.month &&
                r.deliveredAt!.day == today.day;
          }).length;

          final todayRevenue = filteredRepairs
              .where((r) => r.status == RepairStatus.delivered)
              .fold<double>(0.0, (sum, item) => sum + (item.finalCost ?? 0));

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // User greetings
              Text(
                'Welcome back, ${user?.fullName ?? "Operator"}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              Text(
                user?.isAdmin == true
                    ? 'System Administrator'
                    : 'Branch Operator Console',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Metrics Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200
                      ? 4
                      : constraints.maxWidth > 800
                          ? 3
                          : 2;

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.5,
                    children: [
                      _buildMetricCard(
                        context,
                        title: "Today's Repairs",
                        value: todayRepairs.toString(),
                        icon: Icons.calendar_today_outlined,
                        color: AppTheme.kPrimaryLight,
                      ),
                      _buildMetricCard(
                        context,
                        title: 'Waiting Inspection',
                        value: waitingInspection.toString(),
                        icon: Icons.search_outlined,
                        color: Colors.orange,
                      ),
                      _buildMetricCard(
                        context,
                        title: 'Waiting Approval',
                        value: waitingApproval.toString(),
                        icon: Icons.hourglass_empty_outlined,
                        color: Colors.amber.shade700,
                      ),
                      _buildMetricCard(
                        context,
                        title: 'Repairs In Progress',
                        value: inProgress.toString(),
                        icon: Icons.build_circle_outlined,
                        color: AppTheme.kSecondaryLight,
                      ),
                      _buildMetricCard(
                        context,
                        title: 'Waiting Parts',
                        value: waitingParts.toString(),
                        icon: Icons.extension_outlined,
                        color: Colors.purple,
                      ),
                      _buildMetricCard(
                        context,
                        title: 'Ready for Pickup',
                        value: readyForPickup.toString(),
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      _buildMetricCard(
                        context,
                        title: 'Delivered Today',
                        value: deliveredToday.toString(),
                        icon: Icons.local_shipping_outlined,
                        color: Colors.blue,
                      ),
                      _buildMetricCard(
                        context,
                        title: "Today's Revenue",
                        value: '\$${todayRevenue.toStringAsFixed(2)}',
                        icon: Icons.attach_money_outlined,
                        color: Colors.green,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.push(AppRoutes.newRepair),
                    icon: const Icon(Icons.add),
                    label: const Text('New Repair'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.push(AppRoutes.repairs),
                    icon: const Icon(Icons.list),
                    label: const Text('All Repairs'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.push(AppRoutes.customers),
                    icon: const Icon(Icons.people_outline),
                    label: const Text('Customers'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.push(AppRoutes.technicians),
                    icon: const Icon(Icons.engineering_outlined),
                    label: const Text('Technicians'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Repairs
              Text(
                'Recent Repairs',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (filteredRepairs.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'No repair orders registered yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredRepairs.length > 5 ? 5 : filteredRepairs.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = filteredRepairs[index];
                    return ListTile(
                      tileColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      title: Text(
                        'Repair #${item.repairNumber}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item.problemDescription),
                      trailing: Chip(
                        label: Text(item.status.label),
                        backgroundColor: _getStatusColor(item.status).withOpacity(0.1),
                        side: BorderSide(color: _getStatusColor(item.status)),
                      ),
                      onTap: () => context.push('/repairs/${item.id}'),
                    );
                  },
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading dashboard: $err'),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
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
      default:
        return Colors.grey;
    }
  }
}
