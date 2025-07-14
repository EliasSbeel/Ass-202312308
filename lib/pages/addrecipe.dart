import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'profile.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _dec = TextEditingController();
  final TextEditingController _cookinTime = TextEditingController();
  final TextEditingController _ingredient = TextEditingController();
  final List<String> _ingredients = [];

  void _saveRecipe() async {
    final title = _title.text.trim();
    final description = _dec.text.trim();
    final cookingTime = _cookinTime.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        cookingTime.isEmpty ||
        _ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all fields and add at least one ingredient.',
          ),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to add a recipe.')),
      );
      return;
    }

    // Save recipe to Firestore
    await FirebaseFirestore.instance.collection('recipes').add({
      'title': title,
      'description': description,
      'cookingTime': cookingTime,
      'ingredients': _ingredients,
      'createdBy': user.uid,
      'authorEmail': user.email,
      'likes': 0,
      'likedBy': [],
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Recipe saved successfully!')));

    _title.clear();
    _dec.clear();
    _cookinTime.clear();
    _ingredient.clear();
    setState(() {
      _ingredients.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth * 0.08;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFF6B35),
        title: const Text(
          'Add Recipe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _title,
                decoration: _inputDecoration('Title'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _dec,
                maxLines: 4,
                decoration: _inputDecoration('Description'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _cookinTime,
                decoration: _inputDecoration('Cooking time (minutes)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.grey, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to add photo',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredient,
                      decoration: _inputDecoration('Add ingredient'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_ingredient.text.trim().isNotEmpty) {
                        setState(() {
                          _ingredients.add(_ingredient.text.trim());
                          _ingredient.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF6B35),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _ingredients
                    .asMap()
                    .entries
                    .map(
                      (entry) => Row(
                        children: [
                          Text(
                            '• ${entry.value}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _ingredients.removeAt(entry.key);
                              });
                            },
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Save Recipe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Recipe',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 1,
        selectedItemColor: const Color(0xffFF6B35),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffFF6B35), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
    );
  }
}
