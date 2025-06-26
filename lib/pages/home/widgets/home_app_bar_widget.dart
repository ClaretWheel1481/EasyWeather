import 'package:flutter/material.dart';
import 'dart:ui';
import 'animated_title_switcher.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? currentCityName;
  final int citiesLength;
  final int pageIndex;
  final VoidCallback onAddCity;
  final VoidCallback onOpenSettings;
  final VoidCallback onLocate;

  const HomeAppBarWidget({
    super.key,
    required this.currentCityName,
    required this.citiesLength,
    required this.pageIndex,
    required this.onAddCity,
    required this.onOpenSettings,
    required this.onLocate,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedTextSwitcher(
                  text: currentCityName ?? 'EasyWeather',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (citiesLength > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(citiesLength, (i) {
                        final isActive = i == pageIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: isActive ? 10 : 6,
                          height: isActive ? 10 : 6,
                          decoration: BoxDecoration(
                            color: isActive
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
            actions: [
              IconButton(icon: const Icon(Icons.search), onPressed: onAddCity),
              IconButton(
                  icon: const Icon(Icons.location_on), onPressed: onLocate),
              IconButton(
                  icon: const Icon(Icons.settings), onPressed: onOpenSettings),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
