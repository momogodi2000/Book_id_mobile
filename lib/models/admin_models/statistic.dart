class Statistic {
  final String category;
  final int count;

  Statistic({required this.category, required this.count});

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      category: json['category'],
      count: json['count'],
    );
  }
}
