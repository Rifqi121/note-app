import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  String formatDate(String? dateString) {
    if (dateString == null) return 'Tidak ditentukan';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy', 'id').format(date);
    } catch (_) {
      return dateString;
    }
  }

  Color priorityColor(String? prio) {
    switch (prio) {
      case 'Tinggi':
        return Colors.redAccent;
      case 'Sedang':
        return Colors.orangeAccent;
      case 'Rendah':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'selesai':
        return Icons.check_circle_rounded;
      case 'proses':
        return Icons.autorenew_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Note) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Catatan')),
        body: const Center(
          child: Text('Data catatan tidak ditemukan'),
        ),
      );
    }

    final Note note = args;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text('Detail Catatan', style: TextStyle(color: Colors.blue)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            tooltip: 'Edit Catatan',
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit',
                arguments: note,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul dan tanggal/prioritas
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Date & priority row
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, color: Colors.blue[300], size: 18),
                        const SizedBox(width: 6),
                        Text(
                          formatDate(note.deadline),
                          style: TextStyle(fontSize: 14, color: Colors.blue[700], fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: priorityColor(note.priority).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.flag, color: priorityColor(note.priority), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                note.priority ?? 'Tanpa prioritas',
                                style: TextStyle(
                                  color: priorityColor(note.priority),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Status di bawah tanggal
                    Row(
                      children: [
                        Icon(
                          statusIcon(note.status),
                          color: Colors.blue[400],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          note.status ?? 'Belum ada status',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: SingleChildScrollView(
                    child: Text(
                      note.description,
                      style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}