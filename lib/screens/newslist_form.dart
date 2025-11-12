import 'package:flutter/material.dart';
// TODO: Impor drawer yang sudah dibuat sebelumnya
import 'package:football_news/widgets/left_drawer.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:football_news/screens/menu.dart';

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
       final request = context.watch<CookieRequest>();
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
                                        onPressed: () async {
                                              if (_formKey.currentState!.validate()) {
                                                // Ganti URL sesuai backend kamu
                                                // Jika kamu run di Chrome → gunakan localhost
                                                // Jika kamu run di Android Emulator → gunakan 10.0.2.2
                                                final response = await request.postJson(
                                                  "http://localhost:8000/create-flutter/", // ⚠️ ubah ke endpoint kamu
                                                  jsonEncode({
                                                    "title": _title,
                                                    "content": _content,
                                                    "thumbnail": _thumbnail,
                                                    "category": _category,
                                                    "is_featured": _isFeatured,
                                                  }),
                                                );

                                                if (context.mounted) {
                                                  if (response['status'] == 'success') {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text("News successfully saved!"),
                                                      ),
                                                    );
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(builder: (context) =>  MyHomePage()),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text("Something went wrong, please try again."),
                                                      ),
                                                    );
                                                  }
                                                }
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