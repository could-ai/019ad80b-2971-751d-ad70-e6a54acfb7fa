import 'dart:async';
import 'package:flutter/material.dart';
import '../models/signal.dart';
import '../data/mock_data.dart';
import '../widgets/signal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late List<TradingSignal> signals;
  late TabController _tabController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    signals = MockData.getSignals();
    _tabController = TabController(length: 2, vsync: this);
    
    // Refresh UI every second to update countdowns
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSignals = signals.where((s) => s.status == 'Active').toList();
    final historySignals = signals.where((s) => s.status != 'Active').toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_graph, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text(
              'BINOMO SURESHOT',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'ACTIVE SIGNALS'),
            Tab(text: 'HISTORY'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSignalList(activeSignals, isActive: true),
          _buildSignalList(historySignals, isActive: false),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Searching for new Sure Shot signals...')),
          );
        },
        icon: const Icon(Icons.radar),
        label: const Text('SCAN MARKET'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
      ),
    );
  }

  Widget _buildSignalList(List<TradingSignal> list, {required bool isActive}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.signal_wifi_off, size: 64, color: Colors.grey[800]),
            const SizedBox(height: 16),
            Text(
              'No signals available',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return SignalCard(signal: list[index]);
      },
    );
  }
}
