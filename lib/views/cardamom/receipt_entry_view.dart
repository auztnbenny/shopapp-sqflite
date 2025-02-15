// views/receipt_entry_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/receipt_entry_controller.dart';

class ReceiptEntryView extends StatelessWidget {
  final ReceiptEntryController controller = Get.put(ReceiptEntryController());

  // Custom color scheme
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color secondaryGray = Color(0xFF4A4A4A);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color borderGray = Color(0xFFE0E0E0);

  ReceiptEntryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryBlack,
        title: const Text(
          'Edit Cardamom Receipt',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeaderSection(),
                  Expanded(child: _buildFormSection()),
                ],
              );
      }),
    );
  }

  Widget _buildHeaderSection() {
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
                      child: _buildTextField(
                        'Comp Ref. No.',
                        controller.compRefNo.value,
                        readOnly: true,
                        backgroundColor: Colors.green.shade50,
                        onChanged: (val) => controller.compRefNo.value = val,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        'Date',
                        controller.date.value,
                        readOnly: true,
                        onChanged: (val) => controller.date.value = val,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        'Party',
                        controller.party.value,
                        onChanged: (val) => controller.party.value = val,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        'Ref No.',
                        controller.refNo.value,
                        onChanged: (val) => controller.refNo.value = val,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: borderGray),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Qty',
                      controller.qty.value,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        controller.qty.value = val;
                        controller.calculateProcessingCharges();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Rate',
                      controller.rate.value,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        controller.rate.value = val;
                        controller.calculateProcessingCharges();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => _buildTextField(
                          'Processing Charges',
                          controller.processingCharges.value,
                          readOnly: true,
                          backgroundColor: Colors.green.shade50,
                          onChanged: null,
                        )),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'No. of Bags',
                      controller.numberOfBags.value,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => controller.numberOfBags.value = val,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Obx(() => Column(
                    children: [
                      _buildInfoRow(
                          'Stock Entry Date', controller.stkDate.value),
                      _buildInfoRow(
                          'Stock Qty', '${controller.stkQty.value} kg'),
                      _buildInfoRow('Del Date', controller.delDate.value),
                      _buildInfoRow('Del Qty', '${controller.delQty.value} kg'),
                    ],
                  )),
              const SizedBox(height: 24),
              _buildTextField(
                'Remarks',
                controller.remark.value,
                maxLines: 3,
                onChanged: (val) => controller.remark.value = val,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlack,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: controller.handleSubmit,
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String value, {
    bool readOnly = false,
    Color? backgroundColor,
    TextInputType? keyboardType,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: secondaryGray,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: backgroundColor ?? Colors.white,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
      ],
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
