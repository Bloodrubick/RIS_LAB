class Currency {
  final String title;
  final String code;
  final String subtitle;
  final String amount;
  bool isFavorite;

  Currency({
    required this.title,
    required this.code,
    required this.subtitle,
    required this.amount,
    this.isFavorite = false,
  });
}
