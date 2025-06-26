import 'package:easyweather/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class EmptyCityTip extends StatelessWidget {
  final VoidCallback? onLocate;
  const EmptyCityTip({super.key, this.onLocate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noCitiesAdded,
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.add_location_alt),
            label: Text(AppLocalizations.of(context).addCity),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.my_location),
            label: Text(AppLocalizations.of(context).addByLocation),
            onPressed: onLocate,
          ),
        ],
      ),
    );
  }
}
