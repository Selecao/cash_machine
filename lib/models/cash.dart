class Cash {
  final String text;
  int get value => int.parse(text);
  int limit;

  Cash(this.text, {this.limit = 10});

  void setLimit(int value) {
    limit = value;
  }

  @override
  bool operator ==(Object other) => other is Cash && other.text == text;

  @override
  int get hashCode => text.hashCode;
}
