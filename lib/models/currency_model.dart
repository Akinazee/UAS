class CurrencyRate {
  final String code; // Kode mata uang (misal: USD, EUR)
  final double rate; // Nilai tukar terhadap IDR

  CurrencyRate({required this.code, required this.rate});

  // Factory method untuk parsing dari JSON (Syarat UAS: JSON Serialization)
  factory CurrencyRate.fromJson(String code, num rate) {
    return CurrencyRate(
      code: code,
      rate: rate.toDouble(),
    );
  }
}