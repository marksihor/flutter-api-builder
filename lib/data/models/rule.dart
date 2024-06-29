enum ValidationRule { required }

class Rule {
  ValidationRule rule;
  String? message;

  Rule({required this.rule, this.message});
}
