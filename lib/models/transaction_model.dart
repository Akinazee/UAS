class TransactionModel {
  final String description;
  final double amount; 
  final String category;
  final DateTime date;
  final String type; // 'income' atau 'expense'

  TransactionModel({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
  });
}
