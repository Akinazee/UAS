import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency_model.dart'; // Jangan lupa import modelnya

class CurrencyService {
  final String _baseUrl = 'https://api.frankfurter.app';

  // Fungsi lama (tetap dipertahankan agar fitur konversi tidak rusak)
  Future<double> convert(double amountInIdr, String toCurrency) async {
    try {
      final url = Uri.parse('$_baseUrl/latest?amount=$amountInIdr&from=IDR&to=$toCurrency');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['rates'][toCurrency] as num).toDouble();
      } else {
        throw Exception('Gagal konversi');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // --- FUNGSI BARU UNTUK UAS ---
  // Mengambil daftar semua kurs terhadap IDR
  Future<List<CurrencyRate>> getAllRates() async {
    try {
      // Endpoint ini mengambil 1 IDR = sekian mata uang asing
      final url = Uri.parse('$_baseUrl/latest?from=IDR');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> ratesMap = data['rates'];

        // Mengubah Map JSON menjadi List<CurrencyRate>
        List<CurrencyRate> ratesList = [];
        ratesMap.forEach((key, value) {
          ratesList.add(CurrencyRate.fromJson(key, value));
        });

        return ratesList;
      } else {
        throw Exception('Gagal mengambil data kurs');
      }
    } catch (e) {
      throw Exception('Gagal koneksi: $e');
    }
  }
}