// views/transaction_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/cardamom_transaction.dart';
import 'package:shopapp/views/cardamom/receipt_entry_view.dart';

class TransactionView extends StatelessWidget {
  final TransactionController controller = Get.put(TransactionController());

  // Custom color scheme
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color secondaryGray = Color(0xFF4A4A4A);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color borderGray = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryBlack,
        title: const Text(
          'Cardamom Management',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: () {
              // Implement print functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // Implement add new functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          _buildTransactionGrid(),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: lightGray,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderGray),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        'Date From',
                        controller.dateFrom.value,
                        (date) {
                          if (date != null) {
                            controller.dateFrom.value = _formatDate(date);
                            controller.loadTransactions();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateField(
                        'Date Upto',
                        controller.dateUpto.value,
                        (date) {
                          if (date != null) {
                            controller.dateUpto.value = _formatDate(date);
                            controller.loadTransactions();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        'Party Name',
                        null,
                        (value) => controller.partyName.value = value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        'Ref No.',
                        null,
                        (value) => controller.refNo.value = value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlack,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      controller.filterTransactions(
                        fromDate: controller.dateFrom.value,
                        uptoDate: controller.dateUpto.value,
                        party: controller.partyName.value,
                        reference: controller.refNo.value,
                      );
                    },
                    child: const Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    String label,
    String value,
    Function(DateTime?) onDateSelected,
  ) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: secondaryGray),
        suffixIcon: const Icon(Icons.calendar_today, color: secondaryGray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlack),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: Get.context!,
          initialDate: _parseDate(value) ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: primaryBlack,
                colorScheme: const ColorScheme.light(primary: primaryBlack),
                buttonTheme: const ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        onDateSelected(picked);
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  DateTime? _parseDate(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return null;
  }

  Widget _buildTextField(
    String label,
    IconData? icon,
    Function(String) onChanged,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: secondaryGray),
        suffixIcon: icon != null ? Icon(icon, color: secondaryGray) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlack),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildTransactionGrid() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final transaction = controller.transactions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: borderGray),
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    transaction.partyName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryBlack,
                    ),
                  ),
                  subtitle: Text(
                    'Ref: ${transaction.compRefNo} • ${transaction.receiveDate}',
                    style: const TextStyle(color: secondaryGray),
                  ),
                  // Add the trailing icon button here
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.edit, color: secondaryGray),
                      //   onPressed: () {
                      //     Get.to(() => ReceiptEntryView(), arguments: {
                      //       'GCRID': transaction.gcrid,
                      //       'compRefNo': transaction.compRefNo,
                      //       'date': transaction.receiveDate,
                      //       'party': transaction.partyName,
                      //       'partyId': transaction.partyId,
                      //       'qty': transaction.receivedQty,
                      //       'rate': transaction.processingCharges /
                      //           transaction.receivedQty,
                      //       'processingCharges': transaction.processingCharges,
                      //     })?.then((result) {
                      //       if (result == true) {
                      //         controller.loadTransactions();
                      //       }
                      //     });
                      //   },
                      // ),
                      const Icon(Icons.expand_more), // Expansion indicator
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                              'Received Qty', '${transaction.receivedQty}'),
                          _buildInfoRow('Processing Charges',
                              '₹${transaction.processingCharges}'),
                          _buildInfoRow(
                              'Stock Entry Date', transaction.stockEntryDate),
                          _buildInfoRow('Stock Qty', '${transaction.stockQty}'),
                          _buildInfoRow('Del Date', transaction.delDate),
                          _buildInfoRow('Del Qty', '${transaction.delQty}'),
                          _buildInfoRow('Receipt Amount',
                              '₹${transaction.receiptAmount}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: secondaryGray,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: primaryBlack,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// No changes needed in the model and controller files
