import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/signal.dart';

class SignalCard extends StatelessWidget {
  final TradingSignal signal;

  const SignalCard({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final isCall = signal.action == 'CALL';
    final color = isCall ? const Color(0xFF00C853) : const Color(0xFFD50000);
    final actionIcon = isCall ? Icons.arrow_upward : Icons.arrow_downward;
    
    // Calculate time remaining
    final now = DateTime.now();
    final difference = signal.time.difference(now);
    String timeDisplay;
    
    if (signal.status == 'Active') {
      if (difference.isNegative) {
        timeDisplay = "Processing...";
      } else {
        final minutes = difference.inMinutes;
        final seconds = difference.inSeconds % 60;
        timeDisplay = "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      }
    } else {
      timeDisplay = DateFormat('HH:mm').format(signal.time);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: signal.confidence > 0.9 ? const Color(0xFFFFD700).withOpacity(0.5) : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        signal.assetIcon,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          signal.assetName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${signal.timeframe} Candle',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (signal.confidence > 0.9)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.star, size: 12, color: Colors.black),
                        SizedBox(width: 4),
                        Text(
                          'SURE SHOT',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Action Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ACTION',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(actionIcon, color: color, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            signal.action,
                            style: TextStyle(
                              color: color,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Divider
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[800],
                ),
                
                // Timer Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        signal.status == 'Active' ? 'STARTS IN' : 'TIME',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeDisplay,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier', // Monospace for timer
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Footer (Confidence Bar)
          if (signal.status == 'Active')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AI CONFIDENCE',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      Text(
                        '${(signal.confidence * 100).toInt()}%',
                        style: TextStyle(
                          color: signal.confidence > 0.9 ? const Color(0xFFFFD700) : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: signal.confidence,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        signal.confidence > 0.9 ? const Color(0xFFFFD700) : color,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            
          // Result Footer (for History)
          if (signal.status != 'Active')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: signal.status == 'Won' 
                    ? const Color(0xFF00C853).withOpacity(0.2) 
                    : const Color(0xFFD50000).withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              alignment: Alignment.center,
              child: Text(
                signal.status.toUpperCase(),
                style: TextStyle(
                  color: signal.status == 'Won' ? const Color(0xFF00C853) : const Color(0xFFD50000),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
