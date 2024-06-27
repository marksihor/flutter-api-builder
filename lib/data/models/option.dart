class Option {
  String label;
  dynamic value;
  Map<String, dynamic> metas;

  Option({required this.label, required this.value, this.metas = const {}});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Option && other.label == label && other.value == value;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode;

  dynamic toJson() => value;
}
