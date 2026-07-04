import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/customer_provider.dart';

class CustomersListScreen extends ConsumerStatefulWidget {
  const CustomersListScreen({super.key});

  @override
  ConsumerState<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends ConsumerState<CustomersListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final customersState = ref.watch(customerSearchProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers Registry'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search customer name or phone...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: customersState.when(
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      query.isEmpty
                          ? 'Enter search term above to find registered customers.'
                          : 'No customer profiles match that search term.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Primary Phone: ${item.phone}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {},
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error searching customers: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
