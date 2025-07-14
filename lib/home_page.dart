import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_book_page.dart';
import 'edit_book_page.dart';
import 'main.dart'; // Needed to access themeNotifier

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  void fetchBooks() async {
    try {
      final url = Uri.parse('http://192.168.193.238:3000/api/books');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          books = data;
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (error) {
      print('Error fetching books: $error');
    }
  }

  void deleteBook(String id) async {
    bool shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );


    if (shouldDelete) {
      final url = Uri.parse('http://192.168.193.238:3000/api/books/$id');
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        fetchBooks();
      } else {
        print('Error deleting book: ${response.statusCode}');
      }
    }
  }

  Widget bookCard(Map book) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListTile(
    contentPadding: const EdgeInsets.all(12),
    title: Text(
    book['title'],
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text('Author: ${book['author']}'),
    Text('Published Year: ${book['description']}'),
    ],
    ),
    trailing: Wrap(
    spacing: 8,
    children: [
    IconButton(
    icon: const Icon(Icons.edit, color: Colors.lightBlue),
    onPressed: () async {
    await Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => EditBookPage(book: book),
    ),
    );
    fetchBooks();
  },
    ),
    IconButton(
    icon: const Icon(Icons.delete, color: Colors.red),
    onPressed: () => deleteBook(book['_id']),
    ),
    ],
    ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Viewer'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              themeNotifier.value = themeNotifier.value == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: books.isEmpty
            ? const Center(child: Text('No books found.'))
            : ListView(
          children: books.map((book) => bookCard(book)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddBookPage()),
          );
          await Future.delayed(const Duration(milliseconds: 500));
          fetchBooks();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}