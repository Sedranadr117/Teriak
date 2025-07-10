import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final double size;
  final Color? color;

  const CustomIconWidget(
      {Key? key, required this.iconName, this.size = 24, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map of available icons
    final Map<String, IconData> iconMap = {
      'add': Icons.add,
      'search': Icons.search,
      'lock': Icons.lock,
      'lock_open': Icons.lock_open,
      'arrow_forward_ios': Icons.arrow_forward_ios,
      'arrow_drop_down': Icons.arrow_drop_down,
      'science': Icons.science,
      'inventory': Icons.inventory,
      'medication': Icons.medication,
      'category': Icons.category,
      'local_pharmacy': Icons.local_pharmacy,
      'arrow_back': Icons.arrow_back,
      'edit': Icons.edit,
      'fitness_center': Icons.fitness_center
    };

    // Check if the icon exists
    if (iconMap.containsKey(iconName)) {
      return Icon(
        iconMap[iconName],
        size: size,
        color: color,
        semanticLabel: iconName,
      );
    } else {
      // Return a fallback icon
      return Icon(
        Icons.help_outline,
        size: size,
        color: Colors.grey,
        semanticLabel: '$iconName',
      );
    }
  }
}
