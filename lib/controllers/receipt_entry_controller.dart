// controllers/receipt_entry_controller.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class ReceiptEntryController extends GetxController {
  final ApiService _apiService = ApiService();

  // Form fields with default values
  final gcrid = RxInt(0);
  final compRefNo = RxString('');
  final date = RxString('');
  final refNo = RxString('');
  final party = RxString('');
  final partyId = RxInt(0);
  final qty = RxString('0.00');
  final rate = RxString('0.00');
  final processingCharges = RxString('0.00');
  final numberOfBags = RxString('1');
  final remark = RxString('');
  final isLoading = RxBool(false);

  // Additional fields
  final stkDate = RxString('');
  final stkQty = RxString('0.00');
  final delDate = RxString('');
  final delQty = RxString('0.00');
  final stockLocation = RxString('');
  final paidYn = RxBool(false);
  final driedYn = RxBool(false);

  get formData => null;

  @override
  void onInit() {
    super.onInit();
    // Set default date for new entries
    final today = DateTime.now();
    date.value = _formatDate(today);

    // Check for edit mode
    if (Get.arguments != null && Get.arguments['GCRID'] != null) {
      loadReceiptDetails(Get.arguments['GCRID']);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Future<void> loadReceiptDetails(int receiptId) async {
    try {
      isLoading.value = true;

      // final formData = FormData.fromMap({
      //   'title': 'GetGreenCardamomReceiptByCode',
      //   'ReqGCRID': receiptId,
      // });

      final response = await _apiService.getFormattedResponse(formData);

      if (response != null && response['JSONData1'] != null) {
        final receiptData = json.decode(response['JSONData1'])[0];

        // Update all form fields
        gcrid.value = receiptData['GCRID'] ?? 0;
        compRefNo.value = (receiptData['CompRefNo'] ?? '').toString();
        date.value = receiptData['CdateStr'] ?? '';
        refNo.value = receiptData['RefNo'] ?? '';
        party.value = receiptData['PartyName'] ?? '';
        partyId.value = receiptData['PartyID'] ?? 0;
        qty.value = (receiptData['GCRecQty'] ?? 0).toStringAsFixed(2);
        rate.value = (receiptData['Rate'] ?? 0).toStringAsFixed(2);
        processingCharges.value =
            (receiptData['ProcAmount'] ?? 0).toStringAsFixed(2);
        remark.value = receiptData['GCRecRemarks'] ?? '';

        // Additional fields
        stkDate.value = receiptData['StkDateStr'] ?? '';
        stkQty.value = (receiptData['StkQty'] ?? 0).toStringAsFixed(2);
        delDate.value = receiptData['DelDateStr'] ?? '';
        delQty.value = (receiptData['DelQty'] ?? 0).toStringAsFixed(2);
        stockLocation.value = receiptData['StockLocation'] ?? '';
        paidYn.value = receiptData['PaidYn'] ?? false;
        driedYn.value = receiptData['DriedYN'] ?? false;
      } else {
        Get.snackbar(
          'Error',
          'Receipt details not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error loading receipt details: $e');
      Get.snackbar(
        'Error',
        'Failed to load receipt details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void calculateProcessingCharges() {
    if (qty.value.isNotEmpty && rate.value.isNotEmpty) {
      final qtyValue = double.tryParse(qty.value) ?? 0;
      final rateValue = double.tryParse(rate.value) ?? 0;
      processingCharges.value = (qtyValue * rateValue).toStringAsFixed(2);
    }
  }

  Future<void> handleSubmit() async {
    try {
      isLoading.value = true;

      final data = {
        'GCRID': gcrid.value,
        'CompRefNo': int.tryParse(compRefNo.value) ?? 0,
        'Cdate': date.value,
        'RefNo': refNo.value,
        'PartyID': partyId.value,
        'PartyName': party.value,
        'GCRecQty': double.tryParse(qty.value) ?? 0,
        'Rate': double.tryParse(rate.value) ?? 0,
        'ProcAmount': double.tryParse(processingCharges.value) ?? 0,
        'GCRecRemarks': remark.value,
        'DriedYN': true,
      };

      // final formData = FormData.fromMap({
      //   'title': 'UpdateGreenCardamomReceipt',
      //   ...data,
      // });

      final response = await _apiService.getFormattedResponse(formData);

      if (response != null && response['ActionType'] != -1) {
        Get.back(result: true);
        Get.snackbar(
          'Success',
          'Receipt updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response?['ErrorMessage'] ?? 'Failed to update receipt',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating receipt: $e');
      Get.snackbar(
        'Error',
        'An error occurred while saving',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
