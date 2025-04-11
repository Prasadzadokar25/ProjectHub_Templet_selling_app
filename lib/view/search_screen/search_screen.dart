import 'package:flutter/material.dart';

class TemplateListScreen extends StatefulWidget {
  const TemplateListScreen({super.key});

  @override
  _TemplateListScreenState createState() => _TemplateListScreenState();
}

class _TemplateListScreenState extends State<TemplateListScreen> {
  // ... (keep the same Template list and search functionality as before)
  final List<Template> _templates = [
    Template(
      id: 1,
      name: 'Elegant Wedding Invitation',
      thumbnail: 'https://via.placeholder.com/300x200?text=Wedding+Template',
      description:
          'Beautiful floral wedding invitation template with gold accents, editable in Photoshop.',
      seller: 'CreativeDesigns',
      price: 12.99,
      date: '2023-05-15',
      category: 'Invitations',
    ),
    Template(
      id: 2,
      name: 'Modern Business Presentation',
      thumbnail: 'https://via.placeholder.com/300x200?text=Business+PPT',
      description:
          'Professional PowerPoint template with 50 unique slides, fully customizable.',
      seller: 'SlideMasters',
      price: 24.99,
      date: '2023-06-22',
      category: 'Presentations',
    ),
    Template(
      id: 3,
      name: 'Minimalist Resume Template',
      thumbnail: 'https://via.placeholder.com/300x200?text=Resume+Template',
      description:
          'Clean and professional resume template for Word and Pages, ATS-friendly design.',
      seller: 'CareerCrafters',
      price: 9.99,
      date: '2023-07-10',
      category: 'Resumes',
    ),
    Template(
      id: 4,
      name: 'Social Media Pack',
      thumbnail: 'https://via.placeholder.com/300x200?text=Social+Media',
      description:
          '100+ Instagram story templates, post designs, and highlight covers.',
      seller: 'SocialBoost',
      price: 19.99,
      date: '2023-08-05',
      category: 'Social Media',
    ),
    Template(
      id: 5,
      name: 'Restaurant Menu Template',
      thumbnail: 'https://via.placeholder.com/300x200?text=Menu+Template',
      description:
          'Elegant menu design for restaurants and cafes, easy to customize in Illustrator.',
      seller: 'FoodieDesigns',
      price: 14.99,
      date: '2023-09-18',
      category: 'Menus',
    ),
  ];

  List<Template> _filteredTemplates = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredTemplates = _templates;
    _searchController.addListener(_filterTemplates);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTemplates() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTemplates = _templates.where((template) {
        return template.name.toLowerCase().contains(query) ||
            template.description.toLowerCase().contains(query) ||
            template.seller.toLowerCase().contains(query) ||
            template.category.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Marketplace'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search templates...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: _filteredTemplates.isEmpty
                ? const Center(
                    child: Text(
                      'No templates found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    itemCount: _filteredTemplates.length,
                    itemBuilder: (context, index) {
                      return ComfortableTemplateCard(
                          template: _filteredTemplates[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ComfortableTemplateCard extends StatelessWidget {
  final Template template;
  final VoidCallback? onTap;

  const ComfortableTemplateCard({
    super.key,
    required this.template,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail - larger but still compact
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: Image.network(
                    template.thumbnail,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image,
                          size: 40, color: Colors.grey);
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Content area - more spacious
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      template.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Seller
                    Text(
                      'By ${template.seller}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description (shortened)
                    Text(
                      template.description.length > 60
                          ? '${template.description.substring(0, 60)}...'
                          : template.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Footer with price and category
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            template.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ),

                        // Price
                        Text(
                          '\$${template.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Template {
  final int id;
  final String name;
  final String thumbnail;
  final String description;
  final String seller;
  final double price;
  final String date;
  final String category;

  Template({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
    required this.seller,
    required this.price,
    required this.date,
    required this.category,
  });
}

class CompactTemplateCard extends StatelessWidget {
  final Template template;
  final VoidCallback? onTap;

  const CompactTemplateCard({
    super.key,
    required this.template,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail on the left
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  template.thumbnail,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 80,
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 30),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Content on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            template.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\$${template.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Seller
                    Text(
                      'By ${template.seller}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Category and Date
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            template.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          template.date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
