import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final Widget title;
  final Widget content;
  final String date;
  final String owner;
  final String priority;
  final VoidCallback? onInfo;

  const SearchCard({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    required this.owner,
    required this.priority,
    this.onInfo,
  });

  Color _getBackgroundColor() {
    switch (priority) {
      case 'Tinggi':
        return Colors.red[100]!;
      case 'Sedang':
        return Colors.yellow[100]!;
      default:
        return Colors.white;
    }
  }

  Color _getMainTextColor() {
    switch (priority) {
      case 'Tinggi':
        return Colors.red[900]!;
      case 'Sedang':
        return Colors.brown[800]!;
      default:
        return Colors.black;
    }
  }

  Color _getIconColor() {
    switch (priority) {
      case 'Tinggi':
        return Colors.red[900]!;
      case 'Sedang':
        return Colors.brown[800]!;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainTextColor = _getMainTextColor();
    final iconColor = _getIconColor();

    return Card(
      color: _getBackgroundColor(),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: mainTextColor,
                    ),
                    child: title,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: mainTextColor.withValues(),
              ),
              child: content,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: iconColor),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12, color: mainTextColor.withValues()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: iconColor),
                    const SizedBox(width: 4),
                    Text(
                      owner,
                      style: TextStyle(fontSize: 12, color: mainTextColor.withValues()),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
