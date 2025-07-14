import 'package:flutter/material.dart';

class ViewRecipePage extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const ViewRecipePage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'] ?? 'Recipe Detail'),
        backgroundColor: const Color(0xffFF6B35),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Image
              if (recipe['imageUrl'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    recipe['imageUrl'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 20),

              // Title and Author
              Text(
                recipe['title'] ?? 'No Title',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'By: ${recipe['author'] ?? 'Unknown'}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              // Cooking Time
              Row(
                children: [
                  const Icon(Icons.timer, color: Color(0xffFF6B35)),
                  const SizedBox(width: 6),
                  Text(
                    '${recipe['cookingTime'] ?? "?"} mins',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Description
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                recipe['description'] ?? 'No description available.',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              // Ingredients (optional)
              if (recipe['ingredients'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ingredients',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    for (var ing in recipe['ingredients'])
                      Text('• $ing', style: const TextStyle(fontSize: 16)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
