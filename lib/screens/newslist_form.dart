import 'package:flutter/material.dart';
// TODO: Impor drawer yang sudah dibuat sebelumnya
import 'package:football_news/widgets/left_drawer.dart';

class NewsFormPage extends StatefulWidget {
    const NewsFormPage({super.key});

    @override
    State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
    // 1. Buat _formKey dan variabel state
    final _formKey = GlobalKey<FormState>();
    String _title = "";
    String _content = "";
    String _category = "update"; // default
    String _thumbnail = "";
    bool _isFeatured = false; // default

    final List<String> _categories = [
        'transfer',
        'update',
        'exclusive',
        'match',
        'rumor',
        'analysis',
    ];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Center(
                    child: Text(
                        'Form Tambah Berita',
                    ),
                ),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
            ),
            drawer: const LeftDrawer(),
            body: Form(
                key: _formKey, // 2. Tambahkan _formKey ke widget Form
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Atur alignment
                        children: [
                            // === Title (Judul Berita) ===
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Judul Berita",
                                        labelText: "Judul Berita",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                        ),
                                    ),
                                    onChanged: (String? value) {
                                        setState(() {
                                            _title = value!;
                                        });
                                    },
                                    validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                            return "Judul tidak boleh kosong!";
                                        }
                                        return null;
                                    },
                                ),
                            ),

                            // === Content (Isi Berita) ===
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                        hintText: "Isi Berita",
                                        labelText: "Isi Berita",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                        ),
                                    ),
                                    onChanged: (String? value) {
                                        setState(() {
                                            _content = value!;
                                        });
                                    },
                                    validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                            return "Isi berita tidak boleh kosong!";
                                        }
                                        return null;
                                    },
                                ),
                            ),

                            // === Category (Kategori) ===
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                        labelText: "Kategori",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                        ),
                                    ),
                                    value: _category,
                                    items: _categories
                                        .map((cat) => DropdownMenuItem(
                                                value: cat,
                                                child: Text(
                                                    // Kapitalisasi huruf pertama
                                                    cat[0].toUpperCase() + cat.substring(1)),
                                            ))
                                        .toList(),
                                    onChanged: (String? newValue) {
                                        setState(() {
                                            _category = newValue!;
                                        });
                                    },
                                ),
                            ),

                            // === Thumbnail URL (URL Thumbnail) ===
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "URL Thumbnail (opsional)",
                                        labelText: "URL Thumbnail",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                        ),
                                    ),
                                    onChanged: (String? value) {
                                        setState(() {
                                            _thumbnail = value!;
                                        });
                                    },
                                ),
                            ),

                            // === Is Featured (Berita Unggulan) ===
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SwitchListTile(
                                    title: const Text("Tandai sebagai Berita Unggulan"),
                                    value: _isFeatured,
                                    onChanged: (bool value) {
                                        setState(() {
                                            _isFeatured = value;
                                        });
                                    },
                                ),
                            ),

                            // === Tombol Simpan ===
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(Colors.indigo),
                                        ),
                                        onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                        return AlertDialog(
                                                            title: const Text('Berita berhasil disimpan!'),
                                                            content: SingleChildScrollView(
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment.start,
                                                                    children: [
                                                                        Text('Judul: $_title'),
                                                                        const SizedBox(height: 8.0),
                                                                        Text('Isi: $_content'),
                                                                        const SizedBox(height: 8.0),
                                                                        Text('Kategori: $_category'),
                                                                        const SizedBox(height: 8.0),
                                                                        Text('Thumbnail: $_thumbnail'),
                                                                        const SizedBox(height: 8.0),
                                                                        Text(
                                                                            'Unggulan: ${_isFeatured ? "Ya" : "Tidak"}'),
                                                                    ],
                                                                ),
                                                            ),
                                                            actions: [
                                                                TextButton(
                                                                    child: const Text('OK'),
                                                                    onPressed: () {
                                                                        Navigator.pop(context);
                                                                    },
                                                                ),
                                                            ],
                                                        );
                                                    },
                                                );
                                                _formKey.currentState!.reset();
                                            }
                                        },
                                        child: const Text(
                                            "Simpan",
                                            style: TextStyle(color: Colors.white),
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