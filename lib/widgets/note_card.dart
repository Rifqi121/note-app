import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final Widget title;
  final Widget content;
  final String date;
  final String owner;
  final String priority; // 'high', 'medium', 'low'
  final VoidCallback? onInfo;

  const NoteCard({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    required this.owner,
    required this.priority,
    this.onInfo,
  });

  // Mendapatkan warna background sesuai prioritas
  Color _getBackgroundColor() {
    switch (priority) {
      case 'high':
        return Colors.red[100]!;
      case 'medium':
        return Colors.yellow[100]!;
      case 'low':
        return Colors.green[100]!;
      default:
        return Colors.white;
    }
  }

  // Mendapatkan warna teks utama sesuai background
  Color _getMainTextColor() {
    switch (priority) {
      case 'high':
        return Colors.red[900]!;
      case 'medium':
        return Colors.brown[800]!;
      case 'low':
        return Colors.green[900]!;
      default:
        return Colors.black;
    }
  }

  // Mendapatkan warna ikon
  Color _getIconColor() {
    switch (priority) {
      case 'high':
        return Colors.red[900]!;
      case 'medium':
        return Colors.brown[800]!;
      case 'low':
        return Colors.green[900]!;
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
            // Baris atas: Judul + Icon sejajar tengah
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, // <-- Perubahan utama di sini
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
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.info_outline, size: 20, color: iconColor),
                  tooltip: 'Info',
                  onPressed: onInfo,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
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
            // Baris bawah: Date + Owner dengan Icon
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
