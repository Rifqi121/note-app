import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note/state/bloc/note/note_bloc.dart';
import '../models/note.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  Note? note;
  bool _isInit = false; 

  DateTime? _selectedDeadline;
  String? _selectedStatus;
  String? _selectedPriority;

  final List<String> statusList = ['Belum Dikerjakan', 'Sedang Dikerjakan', 'Selesai'];
  final List<String> priorityList = ['Rendah', 'Sedang', 'Tinggi'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) { 
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Note) {
        note = args;
        _titleController.text = note!.title;
        _bodyController.text = note!.description;
        _selectedStatus = note!.status ?? statusList[0];
        _selectedPriority = note!.priority ?? priorityList[1];
        _selectedDeadline = note!.deadline != null ? DateTime.tryParse(note!.deadline!) : null;
      }
      _isInit = true;
    }
  }

  void _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  void _saveNote() {
  final title = _titleController.text.trim();
  final description = _bodyController.text.trim();
  final status = _selectedStatus ?? 'Belum Dikerjakan';
  final priority = _selectedPriority ?? 'Sedang';
  final deadline = _selectedDeadline != null ? DateFormat('yyyy-MM-dd').format(_selectedDeadline!): null;

  if (title.isEmpty || description.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Judul dan isi catatan tidak boleh kosong!')),
    );
    return;
  }

  final noteBloc = context.read<NoteBloc>();

  if (note != null) {
    final updatedNote = note!.copyWith(
      title: title,
      description: description,
      status: status,
      priority: priority,
      deadline: deadline,
    );
    noteBloc.add(UpdateNoteEvent(updatedNote));
  } else {
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      status: status,
      priority: priority,
      deadline: deadline,
    );
    noteBloc.add(AddNoteEvent(newNote));
  }

  Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
}


  @override
  Widget build(BuildContext context) {
  final isEdit = note != null;
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue,
      title: Text(
        isEdit ? 'Edit Catatan' : 'Tambah Catatan',
        style: const TextStyle(color: Colors.blue),
      ),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      decoration: InputDecoration(
                        labelText: 'Judul',
                        prefixIcon: const Icon(Icons.title, color: Colors.blue),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        filled: true,
                        fillColor: Colors.blue[50],
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Isi Catatan
                    TextField(
                      controller: _bodyController,
                      maxLines: 15,
                      minLines: 10,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                      decoration: InputDecoration(
                        labelText: 'Isi Catatan',
                        alignLabelWithHint: true,
                        prefixIcon: const Icon(Icons.notes, color: Colors.blue),
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Deadline picker
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue[300], size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _selectedDeadline == null
                                ? 'Batas Waktu: Belum dipilih'
                                : 'Batas Waktu: ${DateFormat('dd MMM yyyy', 'id').format(_selectedDeadline!)}',
                            style: const TextStyle(fontSize: 15, color: Colors.black87),
                          ),
                        ),
                        TextButton(
                          onPressed: _pickDeadline,
                          child: const Text('Pilih Tanggal'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            textStyle: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Status dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      items: statusList
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Status',
                        prefixIcon: const Icon(Icons.assignment_turned_in, color: Colors.blue),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        filled: true,
                        fillColor: Colors.blue[50],
                        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Prioritas dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      items: priorityList
                          .map((prio) => DropdownMenuItem(
                                value: prio,
                                child: Text(prio),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Prioritas',
                        prefixIcon: const Icon(Icons.flag, color: Colors.blue),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        filled: true,
                        fillColor: Colors.blue[50],
                        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Tombol simpan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _saveNote,
                        icon: const Icon(Icons.save, size: 22),
                        label: Text(isEdit ? 'Update Catatan' : 'Simpan Catatan'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
