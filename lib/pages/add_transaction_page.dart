// lib/pages/add_transaction_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaction_model.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  // GlobalKey untuk validasi Form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil data dari text field
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();

  // State untuk melacak tipe transaksi yang dipilih
  String _selectedType = 'expense'; // Default-nya 'expense'

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submitData() {
    // 1. Validasi form
    if (_formKey.currentState!.validate()) {
      // 2. Ambil data dari controller
      final description = _descriptionController.text;
      final category = _categoryController.text;
      // Konversi amount dari String ke double
      final amount = double.tryParse(_amountController.text) ?? 0.0;

      // 3. Buat objek TransactionModel baru
      final newTransaction = TransactionModel(
        description: description,
        amount: amount,
        category: category.isEmpty ? 'Lain-lain' : category,
        date: DateTime.now(),
        type: _selectedType, // <-- PERUBAHAN DI SINI
      );

      // 4. Kirim data kembali ke halaman sebelumnya (HomePage)
      //    Navigator.pop akan "menutup" halaman ini
      Navigator.of(context).pop(newTransaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi Baru'),
      ),
      // Layout utama menggunakan Column dan Padding
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Widget Form untuk validasi
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Widget Pilihan Tipe Transaksi
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'expense',
                    label: Text('Pengeluaran'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment<String>(
                    value: 'income',
                    label: Text('Pemasukan'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedType = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: _selectedType == 'expense'
                      ? Colors.red.withAlpha(25)
                      : Colors.green.withAlpha(25),
                  selectedForegroundColor:
                  _selectedType == 'expense' ? Colors.red : Colors.green,
                ),
              ),
              const SizedBox(height: 24.0),

              // Widget Form Field untuk Deskripsi
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Widget Form Field untuk Jumlah (Amount)
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Jumlah (Rp)',
                  border: const OutlineInputBorder(),
                  // Ganti ikon berdasarkan tipe
                  prefixIcon: Icon(
                    _selectedType == 'expense'
                        ? Icons.attach_money
                        : Icons.attach_money,
                  ),
                ),
                // Tampilkan keyboard angka
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Widget Form Field untuk Kategori
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (Opsional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 32.0),

              // Widget Tombol untuk Submit
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _selectedType == 'expense'
                      ? Colors.red.shade700
                      : Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan Transaksi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}