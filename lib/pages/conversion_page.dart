// lib/pages/conversion_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/currency_service.dart'; // Impor service

class ConversionPage extends StatefulWidget {
  // Menerima data dari halaman sebelumnya
  // Nama variabel masih totalExpenseInIdr, tapi isinya adalah Saldo Utama
  final double totalExpenseInIdr;

  const ConversionPage({
    super.key,
    required this.totalExpenseInIdr,
  });

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  final CurrencyService _currencyService = CurrencyService();
  final idrFormatter =
  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // State untuk UI Konverter
  String _selectedCurrency = 'USD';
  String _convertedResult = '-';
  bool _isConverting = false;

  // Fungsi yang dipanggil saat tombol "Konversi" ditekan
  void _performConversion() async {
    setState(() {
      _isConverting = true; // Tampilkan loading
      _convertedResult = 'Menghitung...';
    });

    try {
      // Panggil service (yang masih dummy)
      final result = await _currencyService.convert(
          widget.totalExpenseInIdr, _selectedCurrency);

      // Tampilkan hasil
      setState(() {
        _convertedResult = '${result.toStringAsFixed(2)} $_selectedCurrency';
      });
    } catch (e) {
      // Jika terjadi error
      setState(() {
        _convertedResult = 'Error';
      });
    } finally {
      // Selesai loading
      setState(() {
        _isConverting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Mata Uang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar card tidak full 1 halaman
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total Saldo Anda:', // <-- PERUBAHAN TEKS
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  idrFormatter.format(widget.totalExpenseInIdr),
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 32.0),

                // --- Fitur Konverter ---
                const Text(
                  'Konversi ke:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12.0),
                DropdownButton<String>(
                  value: _selectedCurrency,
                  isExpanded: true,
                  items: ['USD', 'EUR', 'JPY'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCurrency = newValue;
                        _convertedResult = '-'; // Reset hasil saat ganti
                      });
                    }
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _isConverting ? null : _performConversion,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Konversi'),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: _isConverting
                      ? const CircularProgressIndicator()
                      : Text(
                    _convertedResult,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}