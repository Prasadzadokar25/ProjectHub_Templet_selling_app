import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () {
              // Edit Profile action
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Profile Coming Soon')));
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            WalletRow(),
            OptionList(),
          ],
        ),
      ),
    );
  }
}

// Profile Header Section
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'), // Replace with user photo URL
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Creative Designer'),
                    SizedBox(height: 8),
                    //Text('Mobile: +91 9876543210\nEmail: johndoe@gmail.com'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text('Mobile: +91 9876543210\nEmail: johndoe@gmail.com'),
        ],
      ),
    );
  }
}

// Wallet and Stats Section
class WalletRow extends StatelessWidget {
  const WalletRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWalletColumn('₹1500', 'Wallet'),
            _buildWalletColumn('12', 'Bought Creations'),
            _buildWalletColumn('8', 'Sold Creations'),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletColumn(String value, String title) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(title),
      ],
    );
  }
}

// Options List
class OptionList extends StatelessWidget {
  const OptionList({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      {'icon': Icons.favorite, 'text': 'My Favorites'},
      {'icon': Icons.history, 'text': 'Purchase History'},
      {'icon': Icons.money, 'text': 'Withdraw Money'},
      {'icon': Icons.campaign, 'text': 'Advertisement'},
      {'icon': Icons.info, 'text': 'About Us'},
      {'icon': Icons.feedback, 'text': 'Feedback'},
      {'icon': Icons.logout, 'text': 'Logout'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return ListTile(
          leading: Icon(option['icon'] as IconData),
          title: Text(option['text'] as String),
          onTap: () {
            if (option['text'] == 'Logout') {
              _showLogoutDialog(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${option['text']} clicked')));
            }
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform Logout Logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')));
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
