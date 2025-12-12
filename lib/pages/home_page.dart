// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import yang sudah diperbaiki
import '../models/transaction_model.dart';
import 'add_transaction_page.dart'; // Impor halaman tambah
import 'conversion_page.dart'; // Impor halaman konversi
import 'currency_list_page.dart'; // Impor halaman API Kurs (Syarat UAS)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- DATABASE TRANSAKSI (DUMMY AWAL) ---
  final List<TransactionModel> _transactions = [
    TransactionModel(
      description: 'Gaji Bulanan',
      amount: 5000000,
      category: 'Gaji',
      date: DateTime.now(),
      type: 'income', // Tipe Pemasukan
    ),
    TransactionModel(
      description: 'Nasi Padang',
      amount: 25000,
      category: 'Makanan',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: 'expense', // Tipe Pengeluaran
    ),
    TransactionModel(
      description: 'Bensin Motor',
      amount: 30000,
      category: 'Transportasi',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: 'expense',
    ),
    TransactionModel(
      description: 'Bonus Proyek',
      amount: 1500000,
      category: 'Hadiah',
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: 'income',
    ),
  ];
  // --- AKHIR DATABASE ---

  // Variabel state untuk saldo
  double _totalIncome = 0;
  double _totalExpense = 0;
  double _mainBalance = 0;

  @override
  void initState() {
    super.initState();
    _calculateBalance(); // Hitung saldo saat aplikasi dibuka
  }

  // Fungsi menghitung Total Pemasukan, Pengeluaran, dan Saldo
  void _calculateBalance() {
    double totalIncome = 0;
    double totalExpense = 0;

    for (var tx in _transactions) {
      if (tx.type == 'income') {
        totalIncome += tx.amount;
      } else if (tx.type == 'expense') {
        totalExpense += tx.amount;
      }
    }

    setState(() {
      _totalIncome = totalIncome;
      _totalExpense = totalExpense;
      _mainBalance = totalIncome - totalExpense;
    });
  }

  // Navigasi ke Halaman Konversi (Membawa data Saldo)
  void _goToConversionPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConversionPage(
          totalExpenseInIdr: _mainBalance,
        ),
      ),
    );
  }

  // Navigasi ke Halaman Tambah Transaksi
  void _navigateToAddTransaction() async {
    final newTransaction = await Navigator.of(context).push<TransactionModel>(
      MaterialPageRoute(builder: (context) => const AddTransactionPage()),
    );

    if (newTransaction != null) {
      setState(() {
        _transactions.insert(0, newTransaction); // Masukkan ke urutan teratas
        _calculateBalance(); // Hitung ulang saldo
      });
    }
  }

  // Navigasi ke Halaman API Kurs (Syarat UAS)
  void _goToCurrencyListPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CurrencyListPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final idrFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Keuangan'),
        actions: [
          // Tombol untuk fitur UAS (API List Data)
          IconButton(
            icon: const Icon(Icons.currency_exchange),
            tooltip: 'Cek Kurs Dunia',
            onPressed: _goToCurrencyListPage,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. KARTU RINGKASAN SALDO
          _buildSummaryCard(idrFormatter),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Riwayat Transaksi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // 2. LIST TRANSAKSI
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                final bool isIncome = tx.type == 'income';
                
                // Warna & Format berdasarkan tipe
                final Color color = isIncome ? Colors.green : Colors.red;
                final String prefix = isIncome ? '+ ' : '- ';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withAlpha(25), // Pengganti withOpacity
                      child: Icon(
                        _getIconForCategory(tx.category, isIncome),
                        color: color,
                      ),
                    ),
                    title: Text(tx.description),
                    subtitle: Text(tx.category),
                    trailing: Text(
                      '$prefix${idrFormatter.format(tx.amount)}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTransaction,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget Kartu Saldo Utama
  Widget _buildSummaryCard(NumberFormat formatter) {
    return InkWell(
      onTap: _goToConversionPage,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Saldo Utama', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                formatter.format(_mainBalance),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bagian Pemasukan
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                          SizedBox(width: 4),
                          Text('Pemasukan', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Text(
                        formatter.format(_totalIncome),
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // Bagian Pengeluaran
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Row(
                        children: [
                          Text('Pengeluaran', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_downward, color: Colors.red, size: 16),
                        ],
                      ),
                      Text(
                        formatter.format(_totalExpense),
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Ikon Kategori
  IconData _getIconForCategory(String category, bool isIncome) {
    if (isIncome) {
      switch (category) {
        case 'Gaji': return Icons.account_balance_wallet;
        case 'Hadiah': return Icons.card_giftcard;
        default: return Icons.attach_money;
      }
    } else {
      switch (category) {
        case 'Makanan': return Icons.fastfood;
        case 'Transportasi': return Icons.directions_bus;
        case 'Tagihan': return Icons.receipt_long;
        case 'Hiburan': return Icons.movie;
        default: return Icons.shopping_bag;
      }
    }
  }
}