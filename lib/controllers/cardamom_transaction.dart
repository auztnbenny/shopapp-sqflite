import 'package:get/get.dart';
import 'package:shopapp/model/cardamom_transaction.dart';
import '../services/api_service.dart';

class TransactionController extends GetxController {
  final ApiService _apiService = ApiService();
  var transactions = <Transaction>[].obs;
  var isLoading = false.obs;
  var dateFrom = ''.obs;
  var dateUpto = ''.obs;
  var partyName = ''.obs;
  var refNo = ''.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initial load with current date
    final today = DateTime.now();
    dateFrom.value = '${today.day.toString().padLeft(2, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.year}';
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Format date if needed (assuming API expects dd-MM-yyyy format)
      final formattedDate = dateFrom.value;

      final result = await _apiService.getCardamomData(formattedDate);

      if (result.isEmpty) {
        errorMessage.value = 'No data found for the selected date';
      }

      transactions.value = result;
    } catch (e) {
      errorMessage.value = 'Error loading data: $e';
      print('Error in loadTransactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterTransactions({
    String? fromDate,
    String? uptoDate,
    String? party,
    String? reference,
  }) {
    dateFrom.value = fromDate ?? dateFrom.value;
    dateUpto.value = uptoDate ?? dateUpto.value;
    partyName.value = party ?? '';
    refNo.value = reference ?? '';
    loadTransactions();
  }
}
