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

  // Variabel untuk tampilan lokal saja
  DateTime? _selectedDeadline;
  String? _selectedStatus;
  String? _selectedPriority;

  final List<String> statusList = ['Belum Dikerjakan', 'Sedang Dikerjakan', 'Selesai'];
  final List<String> priorityList = ['Rendah', 'Sedang', 'Tinggi'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Note) {
      note = args;
      _titleController.text = note!.title;
      _bodyController.text = note!.description;

      // Set default lokal status/prioritas jika mau, bisa juga dikosongkan
      _selectedStatus = statusList[0];
      _selectedPriority = priorityList[1];
      _selectedDeadline = null;
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

  if (title.isEmpty || description.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Judul dan isi catatan tidak boleh kosong!')),
    );
    return;
  }

  final noteBloc = context.read<NoteBloc>();

  if (note != null) {
    // Edit mode
    final updatedNote = note!.copyWith(
      title: title,
      description: description,
    );
    noteBloc.add(UpdateNoteEvent(updatedNote));
  } else {
    // Add mode
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
    );
    noteBloc.add(AddNoteEvent(newNote));
  }

  Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note != null ? 'Edit Catatan' : 'Tambah Catatan'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Judul
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Judul',
                      prefixIcon: Icon(Icons.title, color: Colors.blue),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      filled: true,
                      fillColor: Colors.blue[50],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Isi Catatan
                  TextField(
                    controller: _bodyController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: 'Isi Catatan',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Deadline (lokal saja)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDeadline == null
                              ? 'Batas Waktu: Belum dipilih'
                              : 'Batas Waktu: ${DateFormat('dd MMMM yyyy', 'id').format(_selectedDeadline!)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _pickDeadline,
                        icon: Icon(Icons.calendar_today, color: Colors.blue),
                        label: Text('Pilih', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Status (lokal)
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: statusList
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Status Pekerjaan',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      filled: true,
                      fillColor: Colors.blue[50],
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    items: priorityList
                        .map((prio) => DropdownMenuItem(
                              value: prio,
                              child: Text(prio),
                            )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Prioritas',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      filled: true,
                      fillColor: Colors.blue[50],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _saveNote,
                      icon: Icon(Icons.save),
                      label: Text(
                        'Simpan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
