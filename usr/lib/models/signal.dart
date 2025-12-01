class TradingSignal {
  final String id;
  final String assetName;
  final String assetIcon; // simple string for now, could be asset path
  final String action; // "CALL" (Buy) or "PUT" (Sell)
  final DateTime time;
  final double confidence; // 0.0 to 1.0 (1.0 = 1000% sure shot)
  final String status; // "Active", "Expired", "Won", "Lost"
  final String timeframe; // e.g., "1 Min", "5 Min"

  TradingSignal({
    required this.id,
    required this.assetName,
    required this.assetIcon,
    required this.action,
    required this.time,
    required this.confidence,
    required this.status,
    required this.timeframe,
  });
}
