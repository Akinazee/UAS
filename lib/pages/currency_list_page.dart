import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pastikan sudah 'flutter pub get'
import '../models/currency_model.dart';
import '../services/currency_service.dart';

class CurrencyListPage extends StatefulWidget {
  const CurrencyListPage({super.key});

  @override
  State<CurrencyListPage> createState() => _CurrencyListPageState();
}

class _CurrencyListPageState extends State<CurrencyListPage> {
  final CurrencyService _service = CurrencyService();

  // State Variables (Syarat UAS: Asynchronous UI)
  List<CurrencyRate> _allRates = []; // Data asli dari server
  List<CurrencyRate> _filteredRates = []; // Data hasil search
  bool _isLoading = true;
  String? _errorMessage;

  // Controller untuk search
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  // Fungsi mengambil data (HTTP GET)
  void _fetchRates() async {
    try {
      final rates = await _service.getAllRates();
      setState(() {
        _allRates = rates;
        _filteredRates = rates; // Awalnya tampilkan semua
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Logika Pencarian (Syarat UAS: Fitur Search/Filter)
  void _runFilter(String keyword) {
    List<CurrencyRate> results = [];
    if (keyword.isEmpty) {
      results = _allRates;
    } else {
      results = _allRates
          .where((item) =>
              item.code.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredRates = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kurs Mata Uang Dunia'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // --- 1. SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                labelText: 'Cari Mata Uang (cth: USD, JPY)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // --- 2. KONTEN UTAMA (Loading / Error / List) ---
          Expanded(
            child: _buildListContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildListContent() {
    // Tampilan saat Loading
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Tampilan saat Error
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Terjadi Kesalahan:\n$_errorMessage', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _fetchRates();
              },
              child: const Text('Coba Lagi'),
            )
          ],
        ),
      );
    }

    // Tampilan jika data kosong
    if (_filteredRates.isEmpty) {
      return const Center(child: Text('Mata uang tidak ditemukan.'));
    }

    // Tampilan Daftar Data (ListView)
    return ListView.separated(
      itemCount: _filteredRates.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = _filteredRates[index];
        // Kita hitung kebalikannya agar lebih mudah dipahami orang awam
        // API: 1 IDR = 0.000065 USD
        // Tampilan: 1 USD = 15,xxx IDR (Kira-kira)
        double inverseRate = 1 / item.rate; 
        
        final currencyFormatter = NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurple.shade100,
            child: Text(
              item.code.substring(0, 2),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(item.code, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('1 ${item.code} ≈ ${currencyFormatter.format(inverseRate)}'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        );
      },
    );
  }
}