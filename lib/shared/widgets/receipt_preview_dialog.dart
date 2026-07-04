import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../features/repairs/domain/entities/repair_order.dart';

class ReceiptPreviewDialog extends StatelessWidget {
  final RepairOrderEntity order;
  final String customerName;
  final String customerPhone;
  final String deviceLabel;

  const ReceiptPreviewDialog({
    super.key,
    required this.order,
    required this.customerName,
    required this.customerPhone,
    required this.deviceLabel,
  });

  Future<void> _printReceipt() async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('TV REPAIR CENTER', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
              ),
              pw.Center(child: pw.Text('Order Receipt')),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Text('Order No: ${order.repairNumber}'),
              pw.Text('Date: ${order.createdAt.toString().substring(0, 16)}'),
              pw.SizedBox(height: 12),
              pw.Text('CUSTOMER DETAILS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Name: $customerName'),
              pw.Text('Phone: $customerPhone'),
              pw.SizedBox(height: 12),
              pw.Text('DEVICE DETAILS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Device: $deviceLabel'),
              pw.Text('Issue: ${order.problemDescription}'),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Est. Cost:'),
                  pw.Text('\$${(order.estimatedCost ?? 0).toStringAsFixed(2)}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Deposit paid:'),
                  pw.Text('\$${order.deposit.toStringAsFixed(2)}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Balance:'),
                  pw.Text('\$${((order.estimatedCost ?? 0) - order.deposit).toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 12),
              pw.Center(
                child: pw.Text('Thank you for choosing us!', style: pw.TextStyle(fontSize: 10)),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = (order.estimatedCost ?? 0.0) - order.deposit;

    return AlertDialog(
      title: const Text('Receipt Preview'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'TV REPAIR CENTER',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text('Order No: ${order.repairNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Date: ${order.createdAt.toLocal().toString().substring(0, 16)}'),
            const SizedBox(height: 16),
            const Text('Customer Details', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            Text('Name: $customerName'),
            Text('Phone: $customerPhone'),
            const SizedBox(height: 16),
            const Text('Device Details', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            Text('Device: $deviceLabel'),
            Text('Problem: ${order.problemDescription}'),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Estimated Cost:'),
                Text('\$${(order.estimatedCost ?? 0.0).toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Deposit:'),
                Text('\$${order.deposit.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Balance:'),
                Text(
                  '\$${remaining.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          onPressed: _printReceipt,
          icon: const Icon(Icons.print),
          label: const Text('Print Receipt'),
        ),
      ],
    );
  }
}
