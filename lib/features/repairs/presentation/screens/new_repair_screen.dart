import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../customers/domain/entities/customer.dart';
import '../../../customers/presentation/providers/customer_provider.dart';
import '../../../devices/domain/entities/device.dart';
import '../../../devices/presentation/providers/device_provider.dart';
import '../../domain/entities/repair_order.dart';
import '../providers/repair_provider.dart';
import '../../../technicians/presentation/providers/technician_provider.dart';
import '../../../whatsapp/presentation/providers/whatsapp_provider.dart';

class NewRepairScreen extends ConsumerStatefulWidget {
  const NewRepairScreen({super.key});

  @override
  ConsumerState<NewRepairScreen> createState() => _NewRepairScreenState();
}

class _NewRepairScreenState extends ConsumerState<NewRepairScreen> {
  final _formKey = GlobalKey<FormState>();

  // Customer info search and values
  final _phoneSearchController = TextEditingController();
  CustomerEntity? _selectedCustomer;
  bool _searchingCustomer = false;
  bool _newCustomerMode = false;

  // Form Fields
  final _customerNameController = TextEditingController();
  final _customerAltPhoneController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _customerNotesController = TextEditingController();

  final _deviceBrandController = TextEditingController();
  final _deviceModelController = TextEditingController();
  final _deviceSerialController = TextEditingController();
  final _deviceColorController = TextEditingController();
  final _deviceNotesController = TextEditingController();

  final _problemDescriptionController = TextEditingController();
  final _estimatedCostController = TextEditingController();
  final _depositController = TextEditingController();

  String _deviceType = 'TV';
  String? _selectedTechnicianId;
  DateTime? _deliveryDate;
  bool _submitting = false;

  @override
  void dispose() {
    _phoneSearchController.dispose();
    _customerNameController.dispose();
    _customerAltPhoneController.dispose();
    _customerAddressController.dispose();
    _customerNotesController.dispose();
    _deviceBrandController.dispose();
    _deviceModelController.dispose();
    _deviceSerialController.dispose();
    _deviceColorController.dispose();
    _deviceNotesController.dispose();
    _problemDescriptionController.dispose();
    _estimatedCostController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  Future<void> _searchCustomer() async {
    final phone = _phoneSearchController.text.trim();
    if (phone.isEmpty) return;

    setState(() {
      _searchingCustomer = true;
      _selectedCustomer = null;
      _newCustomerMode = false;
    });

    final customer = await ref.read(customerNotifierProvider.notifier).findByPhone(phone);

    setState(() {
      _searchingCustomer = false;
      if (customer != null) {
        _selectedCustomer = customer;
        _newCustomerMode = false;
      } else {
        _newCustomerMode = true;
        _customerNameController.clear();
        _customerAltPhoneController.clear();
        _customerAddressController.clear();
        _customerNotesController.clear();
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomer == null && !_newCustomerMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please look up or register a customer first.')),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      final user = ref.read(authProvider).value;
      final branchId = user?.branchId ?? '';

      // 1. Create customer if in new customer mode
      CustomerEntity customer;
      if (_newCustomerMode) {
        final newCustomer = CustomerEntity(
          id: const Uuid().v4(),
          branchId: branchId,
          name: _customerNameController.text.trim(),
          phone: _phoneSearchController.text.trim(),
          alternatePhone: _customerAltPhoneController.text.trim().isEmpty ? null : _customerAltPhoneController.text.trim(),
          address: _customerAddressController.text.trim().isEmpty ? null : _customerAddressController.text.trim(),
          notes: _customerNotesController.text.trim().isEmpty ? null : _customerNotesController.text.trim(),
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        );
        final created = await ref.read(customerNotifierProvider.notifier).create(newCustomer);
        if (created == null) throw Exception('Customer registration failed');
        customer = created;
      } else {
        customer = _selectedCustomer!;
      }

      // 2. Create device
      final deviceEntity = DeviceEntity(
        id: const Uuid().v4(),
        customerId: customer.id,
        deviceType: _deviceType,
        brand: _deviceBrandController.text.trim(),
        model: _deviceModelController.text.trim(),
        serialNumber: _deviceSerialController.text.trim().isEmpty ? null : _deviceSerialController.text.trim(),
        color: _deviceColorController.text.trim().isEmpty ? null : _deviceColorController.text.trim(),
        notes: _deviceNotesController.text.trim().isEmpty ? null : _deviceNotesController.text.trim(),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      final createdDevice = await ref.read(deviceNotifierProvider.notifier).create(deviceEntity);
      if (createdDevice == null) throw Exception('Device registration failed');

      // 3. Create Repair Order
      final repairNumber = 'REP-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
      final barcode = repairNumber; // Simple code 128 format matches repair number

      final repairOrder = RepairOrderEntity(
        id: const Uuid().v4(),
        branchId: branchId,
        deviceId: createdDevice.id,
        technicianId: _selectedTechnicianId,
        repairNumber: repairNumber,
        barcode: barcode,
        status: RepairStatus.registered,
        problemDescription: _problemDescriptionController.text.trim(),
        deposit: double.tryParse(_depositController.text) ?? 0.0,
        estimatedCost: double.tryParse(_estimatedCostController.text),
        deliveryDate: _deliveryDate,
        createdBy: user?.id,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      final createdRepair = await ref.read(repairOrderNotifierProvider.notifier).create(repairOrder);
      if (createdRepair == null) throw Exception('Repair order creation failed');

      // 4. Trigger automated WhatsApp template log entry
      await ref.read(whatsappNotifierProvider.notifier).triggerNotification(
            repairOrderId: createdRepair.id,
            templateName: 'Device Received',
            phone: customer.phone,
          );

      // Successfully processed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Repair Order #${createdRepair.repairNumber} registered successfully!')),
      );

      // Navigate to details screen
      context.replace('/repairs/${createdRepair.id}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering repair: $e'), backgroundColor: AppTheme.kError),
      );
    } finally {
      setState(() {
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final branchId = user?.branchId ?? '';

    // Fetch technicians list
    final techsState = ref.watch(branchTechniciansProvider(branchId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Repair'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // STEP 1: Customer Identification Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 1: Customer Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _phoneSearchController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Customer Phone Number',
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _searchingCustomer ? null : _searchCustomer,
                          icon: const Icon(Icons.search),
                          label: const Text('Search'),
                        ),
                      ],
                    ),
                    if (_searchingCustomer)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),

                    // Found Customer Card
                    if (_selectedCustomer != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedCustomer!.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Phone: ${_selectedCustomer!.phone}'),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedCustomer = null;
                                });
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Register New Customer Fields
                    if (_newCustomerMode) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'New Customer Registration',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.kPrimaryLight),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _customerNameController,
                        decoration: const InputDecoration(labelText: 'Customer Full Name'),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter customer name' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _customerAltPhoneController,
                        decoration: const InputDecoration(labelText: 'Alternate Phone (Optional)'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _customerAddressController,
                        decoration: const InputDecoration(labelText: 'Home Address (Optional)'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // STEP 2: Device Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 2: Device Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _deviceType,
                      decoration: const InputDecoration(labelText: 'Device Category'),
                      items: const [
                        DropdownMenuItem(value: 'TV', child: Text('Television Screen')),
                        DropdownMenuItem(value: 'Audio', child: Text('Audio Speaker System')),
                        DropdownMenuItem(value: 'Receiver', child: Text('Satellite Receiver')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _deviceType = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _deviceBrandController,
                            decoration: const InputDecoration(labelText: 'Brand (e.g. LG, Samsung)'),
                            validator: (value) => value == null || value.isEmpty ? 'Please enter brand' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _deviceModelController,
                            decoration: const InputDecoration(labelText: 'Model Name / Number'),
                            validator: (value) => value == null || value.isEmpty ? 'Please enter model' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _deviceSerialController,
                      decoration: const InputDecoration(labelText: 'Serial Number (S/N)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // STEP 3: Repair Diagnostic Assignment
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 3: Diagnoses & Assignments',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _problemDescriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Problem Description (Issue detailed by customer)'),
                      validator: (value) => value == null || value.isEmpty ? 'Please describe the problem' : null,
                    ),
                    const SizedBox(height: 12),
                    techsState.when(
                      data: (techs) => DropdownButtonFormField<String>(
                        value: _selectedTechnicianId,
                        decoration: const InputDecoration(labelText: 'Assign Responsible Technician'),
                        items: techs.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedTechnicianId = val;
                          });
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Text('Error loading technicians: $err'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _estimatedCostController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Estimated Repair Cost (Optional)'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _depositController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Upfront Deposit Payment'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const CircularProgressIndicator()
                          : const Text('Submit and Print Receipt'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
