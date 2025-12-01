import 'package:flutter/material.dart';
import '../models/signal.dart';

class MockData {
  static List<TradingSignal> getSignals() {
    final now = DateTime.now();
    return [
      TradingSignal(
        id: '1',
        assetName: 'EUR/USD',
        assetIcon: '€/$',
        action: 'CALL',
        time: now.add(const Duration(minutes: 2)),
        confidence: 0.99, // 1000% sure shot
        status: 'Active',
        timeframe: '1 Min',
      ),
      TradingSignal(
        id: '2',
        assetName: 'CRYPTO IDX',
        assetIcon: '₿',
        action: 'PUT',
        time: now.add(const Duration(minutes: 5)),
        confidence: 0.95,
        status: 'Active',
        timeframe: '5 Min',
      ),
      TradingSignal(
        id: '3',
        assetName: 'GBP/JPY',
        assetIcon: '£/¥',
        action: 'CALL',
        time: now.add(const Duration(minutes: 12)),
        confidence: 0.85,
        status: 'Active',
        timeframe: '1 Min',
      ),
      TradingSignal(
        id: '4',
        assetName: 'USD/BRL',
        assetIcon: '$/R\$',
        action: 'PUT',
        time: now.subtract(const Duration(minutes: 10)),
        confidence: 0.98,
        status: 'Won',
        timeframe: '1 Min',
      ),
      TradingSignal(
        id: '5',
        assetName: 'GOLD',
        assetIcon: 'Au',
        action: 'CALL',
        time: now.subtract(const Duration(minutes: 30)),
        confidence: 0.92,
        status: 'Won',
        timeframe: '5 Min',
      ),
    ];
  }
}
