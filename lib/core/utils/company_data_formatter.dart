String formatEmployees(int count) {
  if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(0)},000+';
  }
  return '$count';
}

String formatMarketCap(int cap) {
  if (cap >= 1000000000) {
    final value = cap / 1000000000;
    return '\$${value.toStringAsFixed(1)}B';
  }
  if (cap >= 1000000) {
    final value = cap / 1000000;
    return '\$${value.toStringAsFixed(1)}M';
  }
  return '\$$cap';
}
