import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<SearchScreen> {
  final List<Course> courses = [
    Course(
      title: 'YOLO for Defect Detection',
      description: 'Enhancing Quality Control in Manufacturing',
      price: '\$12,000',
      type: 'FREE CONTENT FILES',
    ),
    Course(
      title: 'Food Quality Inspection Using AI',
      description: 'Ensure Safety Standards',
      price: '\$12,000',
      type: 'FREE CONTENT FILES',
    ),
    Course(
      title: 'Mental Health Support App',
      description: '',
      price: '\$15,020',
      type: 'FREE CONTENT VIDEOS',
    ),
    Course(
      title: 'Autonomous Drone Surveillance Software',
      description: 'Using AI for Border Security',
      price: '\$12,000',
      type: 'FREE CONTENT FILES',
    ),
    Course(
      title: 'Smart Waste Sorting System',
      description: 'Using AI for Efficient Recycling',
      price: '\$12,000',
      type: 'FREE CONTENT FILES',
    ),
  ];

  List<Course> filteredCourses = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    filteredCourses = courses;
    super.initState();
  }

  void filterCourses(String query) {
    setState(() {
      filteredCourses = courses
          .where((course) =>
              course.title.toLowerCase().contains(query.toLowerCase()) ||
              course.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses for Computer/IT'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: filterCourses,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                return CourseCard(course: filteredCourses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Course {
  final String title;
  final String description;
  final String price;
  final String type;

  Course({
    required this.title,
    required this.description,
    required this.price,
    required this.type,
  });
}

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.type,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              course.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              course.description,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              course.price,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
