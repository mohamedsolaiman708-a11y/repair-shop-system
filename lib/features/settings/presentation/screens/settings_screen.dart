import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person_outline), text: 'Profile Settings'),
            Tab(icon: Icon(Icons.print_outlined), text: 'Print Settings'),
            Tab(icon: Icon(Icons.notifications_none_outlined), text: 'WhatsApp Templates'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Profile Settings
          _buildProfileSettings(user),

          // 2. Print Settings
          _buildPrintSettings(),

          // 3. WhatsApp Templates (Only Admin can manage edit mode, Operator is view-only)
          _buildWhatsAppSettings(user?.isAdmin ?? false),
        ],
      ),
    );
  }

  Widget _buildProfileSettings(dynamic user) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Profile',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: const Text('Full Name'),
                  subtitle: Text(user?.fullName ?? 'Operator Name'),
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.email)),
                  title: const Text('Email Address'),
                  subtitle: Text(user?.email ?? 'email@domain.com'),
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.shield_outlined)),
                  title: const Text('Role'),
                  subtitle: Text(user?.role.label ?? 'Operator'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrintSettings() {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receipt & Barcode Formatting',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: '80mm',
                  decoration: const InputDecoration(labelText: 'Receipt Width Size'),
                  items: const [
                    DropdownMenuItem(value: '58mm', child: Text('Thermal Paper 58mm')),
                    DropdownMenuItem(value: '80mm', child: Text('Thermal Paper 80mm')),
                    DropdownMenuItem(value: 'A4', child: Text('Standard Document A4')),
                  ],
                  onChanged: (val) {},
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: 'top',
                  decoration: const InputDecoration(labelText: 'Barcode Location on Receipt'),
                  items: const [
                    DropdownMenuItem(value: 'top', child: Text('Header Position')),
                    DropdownMenuItem(value: 'bottom', child: Text('Footer Position')),
                    DropdownMenuItem(value: 'none', child: Text('Do not display')),
                  ],
                  onChanged: (val) {},
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save Print Settings'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsAppSettings(bool isAdmin) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WhatsApp Event Notifications',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  isAdmin
                      ? 'Configure automatic template triggers sent to customers.'
                      : 'View default system template notification actions.',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildTemplateTile('Device Received', 'Sent when repair request is registered.'),
                _buildTemplateTile('Inspection Finished', 'Sent when diagnosis completes.'),
                _buildTemplateTile('Waiting Customer Approval', 'Sent when quotation is requested.'),
                _buildTemplateTile('Repair Completed', 'Sent when order becomes Ready For Pickup.'),
                _buildTemplateTile('Device Delivered', 'Sent when device collection is recorded.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateTile(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.edit_note_outlined, color: AppTheme.kPrimaryLight),
      onTap: () {},
    );
  }
}
