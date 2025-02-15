import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart'
    as get_connect;
import 'package:shopapp/model/cardamom_transaction.dart';
import 'dart:convert';

class ApiService {
  static const String baseUrl =
      'http://nwbo1.jubilyhrm.in/api/WebServiceCardamom.aspx';
  final Dio _dio = Dio();

  Future<List<Transaction>> getCardamomData(String reqDate) async {
    try {
      // Create form data
      final formData = FormData.fromMap({
        'title': 'GetGreenCardamomReceiptList',
        'Reqdate1': reqDate,
      });

      // Make API call
      final response = await _dio.post(
        baseUrl,
        data: formData,
      );

      if (response.statusCode == 200) {
        // Extract data before "||JasonEnd"
        String jsonString = response.data.toString();
        int endIndex = jsonString.indexOf("||JasonEnd");
        if (endIndex == -1) return [];

        jsonString = jsonString.substring(0, endIndex);
        final userData = json.decode(jsonString);

        if (userData is List &&
            userData.isNotEmpty &&
            userData[0]['JSONData1'] != null) {
          // Parse the nested JSONData1
          final parsedData = json.decode(userData[0]['JSONData1']);

          // Convert to list of Transaction objects
          if (parsedData is List) {
            return parsedData
                .map((item) => Transaction.fromJson(item))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      print('Error in getCardamomData: $e');
      return [];
    }
  }
}
