import 'package:flutter/material.dart';

import '../services/drop_box_service.dart';
import '../services/parcel_store.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'parcel_overview_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.service,
    required this.parcelStore,
  });

  final DropBoxService service;
  final ParcelStore parcelStore;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(service: widget.service),
          ParcelOverviewScreen(parcelStore: widget.parcelStore),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accentBlue.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Parcel',
          ),
        ],
      ),
    );
  }
}
