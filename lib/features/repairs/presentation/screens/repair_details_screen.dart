import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../payments/domain/entities/payment.dart';
import '../../../payments/presentation/providers/payment_provider.dart';
import '../../../whatsapp/domain/entities/whatsapp_log.dart';
import '../../../whatsapp/presentation/providers/whatsapp_provider.dart';
import '../../domain/entities/repair_order.dart';
import '../providers/repair_provider.dart';

class RepairDetailsScreen extends ConsumerStatefulWidget {
  final String repairId;
  const RepairDetailsScreen({super.key, required this.repairId});

  @override
  ConsumerState<RepairDetailsScreen> createState() => _RepairDetailsScreenState();
}

class _RepairDetailsScreenState extends ConsumerState<RepairDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _paymentAmountController = TextEditingController();
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  PaymentType _paymentType = PaymentType.partial;
  bool _savingPayment = false;
  bool _updatingStatus = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _paymentAmountController.dispose();
    super.dispose();
  }

  Future<void> _recordPayment(RepairOrderEntity order) async {
    final amount = double.tryParse(_paymentAmountController.text) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid positive payment amount.')),
      );
      return;
    }

    setState(() {
      _savingPayment = true;
    });

    try {
      final user = ref.read(authProvider).value;
      final payment = PaymentEntity(
        id: const Uuid().v4(),
        repairOrderId: order.id,
        amount: amount,
        paymentMethod: _paymentMethod,
        paymentType: _paymentType,
        notes: 'Recorded via app',
        createdBy: user?.id,
        createdAt: DateTime.now().toUtc(),
      );

      final result = await ref.read(paymentNotifierProvider.notifier).addPayment(payment);
      if (result != null) {
        _paymentAmountController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment registered successfully!')),
        );
        
        // Refresh details to update costs/deposit representation
        ref.invalidate(repairOrderDetailsProvider(order.id));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e'), backgroundColor: AppTheme.kError),
      );
    } finally {
      setState(() {
        _savingPayment = false;
      });
    }
  }

  Future<void> _changeStatus(RepairOrderEntity order, RepairStatus nextStatus) async {
    setState(() {
      _updatingStatus = true;
    });

    try {
      final updated = await ref.read(repairOrderNotifierProvider.notifier).updateStatus(
            order,
            nextStatus,
            notes: 'Status transitioned via details console',
          );

      if (updated != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to ${nextStatus.label}')),
        );
        
        // Trigger automated WhatsApp notification
        await ref.read(whatsappNotifierProvider.notifier).triggerNotification(
              repairOrderId: order.id,
              templateName: _getTemplateForStatus(nextStatus),
              phone: 'Customer Phone', // In real, fetch phone
            );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e'), backgroundColor: AppTheme.kError),
      );
    } finally {
      setState(() {
        _updatingStatus = false;
      });
    }
  }

  String _getTemplateForStatus(RepairStatus status) {
    switch (status) {
      case RepairStatus.underInspection:
        return 'Inspection Started';
      case RepairStatus.waitingCustomerApproval:
        return 'Waiting Customer Approval';
      case RepairStatus.readyForPickup:
        return 'Repair Completed';
      case RepairStatus.delivered:
        return 'Device Delivered';
      default:
        return 'Status Updated';
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(repairOrderDetailsProvider(widget.repairId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Order Details'),
      ),
      body: orderState.when(
        data: (order) {
          final totalCost = order.finalCost ?? order.estimatedCost ?? 0.0;
          final remainingBalance = totalCost - order.deposit;

          return Column(
            children: [
              // Header Details Card
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order.repairNumber}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text('Barcode: ${order.barcode}', style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        Row(
                          children: [
                            Chip(
                              label: Text(order.status.label),
                              backgroundColor: _getStatusColor(order.status).withOpacity(0.1),
                              side: BorderSide(color: _getStatusColor(order.status)),
                            ),
                            const SizedBox(width: 12),
                            if (!order.isClosed)
                              DropdownButton<RepairStatus>(
                                hint: const Text('Move to Status'),
                                underline: const SizedBox(),
                                items: RepairStatus.values
                                    .where((s) => order.status.canTransitionTo(s))
                                    .map((s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s.label),
                                        ))
                                    .toList(),
                                onChanged: _updatingStatus
                                    ? null
                                    : (val) {
                                        if (val != null) {
                                          _changeStatus(order, val);
                                        }
                                      },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // TabBar definition
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'General Info'),
                  Tab(text: 'Timeline Logs'),
                  Tab(text: 'Payments Audit'),
                  Tab(text: 'WhatsApp Alerts'),
                ],
              ),

              // Tab View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: General Info
                    _buildGeneralInfoTab(order, totalCost, remainingBalance),

                    // Tab 2: Timeline Logs
                    _buildTimelineTab(order),

                    // Tab 3: Payments Audit
                    _buildPaymentsTab(order),

                    // Tab 4: WhatsApp Alerts
                    _buildWhatsAppTab(order),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading repair order: $err')),
      ),
    );
  }

  Widget _buildGeneralInfoTab(RepairOrderEntity order, double totalCost, double remainingBalance) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Diagnostic Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(height: 24),
                ListTile(
                  title: const Text('Problem Statement'),
                  subtitle: Text(order.problemDescription),
                ),
                if (order.inspectionNotes != null)
                  ListTile(
                    title: const Text('Inspection/Diagnostic Notes'),
                    subtitle: Text(order.inspectionNotes!),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Financial Estimations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Estimated Cost:'),
                    Text(order.estimatedCost != null ? '\$${order.estimatedCost!.toStringAsFixed(2)}' : 'TBD'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Deposit Payment Received:'),
                    Text('\$${order.deposit.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Remaining Balance Due:'),
                    Text('\$${remainingBalance.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTab(RepairOrderEntity order) {
    final historyState = ref.watch(repairStatusHistoryProvider(order.id));

    return historyState.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('No historical status events recorded yet.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final log = list[index];
            final date = DateTime.parse(log['changed_at']).toLocal();
            final oldStatus = log['old_status'] ?? 'None';
            final newStatus = log['new_status'];
            final userName = log['changed_by_user']?['full_name'] ?? 'System';

            return ListTile(
              leading: const Icon(Icons.history_outlined),
              title: Text('$oldStatus ➜ $newStatus'),
              subtitle: Text('Changed by $userName - ${log['notes'] ?? ""}'),
              trailing: Text(date.toString().substring(0, 16)),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error loading timeline logs: $err')),
    );
  }

  Widget _buildPaymentsTab(RepairOrderEntity order) {
    final paymentsState = ref.watch(repairOrderPaymentsProvider(order.id));

    return Column(
      children: [
        // Add Payment form at top
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _paymentAmountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Amount (\$)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<PaymentMethod>(
                    value: _paymentMethod,
                    items: PaymentMethod.values
                        .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _paymentMethod = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _savingPayment ? null : () => _recordPayment(order),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Payment'),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Payments list
        Expanded(
          child: paymentsState.when(
            data: (list) {
              if (list.isEmpty) {
                return const Center(child: Text('No payment history found.'));
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final p = list[index];
                  return ListTile(
                    leading: const Icon(Icons.payment, color: Colors.green),
                    title: Text('\$${p.amount.toStringAsFixed(2)} - ${p.paymentMethod.label}'),
                    subtitle: Text('Type: ${p.paymentType.label} - ${p.notes ?? ""}'),
                    trailing: Text(p.createdAt.toLocal().toString().substring(0, 16)),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error loading payments: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsAppTab(RepairOrderEntity order) {
    final logsState = ref.watch(repairOrderWhatsAppLogsProvider(order.id));

    return logsState.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('No outgoing WhatsApp messages recorded.'));
        }

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final log = list[index];
            final isFailed = log.status == WhatsAppStatus.failed;

            return ListTile(
              leading: Icon(
                isFailed ? Icons.error_outline : Icons.check_circle_outline,
                color: isFailed ? AppTheme.kError : Colors.green,
              ),
              title: Text('Template: ${log.templateName}'),
              subtitle: Text('Recipient: ${log.phone}'),
              trailing: isFailed
                  ? IconButton(
                      icon: const Icon(Icons.refresh, color: AppTheme.kPrimaryLight),
                      onPressed: () {
                        ref.read(whatsappNotifierProvider.notifier).retry(log.id, order.id);
                      },
                    )
                  : Text(log.sentAt.toLocal().toString().substring(0, 16)),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error loading WhatsApp alert logs: $err')),
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
