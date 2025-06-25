import 'package:easyweather/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class EmptyCityTip extends StatelessWidget {
  const EmptyCityTip({super.key});

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
        ],
      ),
    );
  }
}
