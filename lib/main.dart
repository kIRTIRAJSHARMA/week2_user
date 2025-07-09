import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); // Entry point of the app
}

// Model class to store user information
class UserData {
  String name;
  String email;
  String gender;
  bool isAgreed;
  double age;

  UserData({
    required this.name,
    required this.email,
    required this.gender,
    required this.isAgreed,
    required this.age,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UserFormApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegistrationScreen(), // Loads the registration form
    );
  }
}

// Registration screen to take user input
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  String gender = 'Male';
  bool isAgreed = false;
  double age = 18;

  // Called when submit button is pressed
  void _submit() {
    if (!isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please agree to terms')),
      );
      return;
    }

    // Store all input into UserData object
    final user = UserData(
      name: nameController.text,
      email: emailController.text,
      gender: gender,
      isAgreed: isAgreed,
      age: age,
    );

    // Navigate to home screen and pass user data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Name input
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 8),
            // Email input
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),

            // Gender selection using radio buttons
            Text("Gender:"),
            Row(
              children: [
                Radio(
                  value: 'Male',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
                Text('Male'),
                Radio(
                  value: 'Female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
                Text('Female'),
              ],
            ),

            // Checkbox to accept terms
            CheckboxListTile(
              title: Text("I agree to terms and conditions"),
              value: isAgreed,
              onChanged: (value) {
                setState(() {
                  isAgreed = value!;
                });
              },
            ),

            // Age selection using slider
            Text("Select Age: ${age.toInt()}"),
            Slider(
              value: age,
              min: 10,
              max: 100,
              divisions: 90,
              label: age.round().toString(),
              onChanged: (value) {
                setState(() {
                  age = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Submit form button
            ElevatedButton(onPressed: _submit, child: Text('Submit')),
          ],
        ),
      ),
    );
  }
}

// Home screen that displays user info and includes drawer & bottom nav
class HomeScreen extends StatefulWidget {
  final UserData user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();

    // Define tabs
    _screens = [
      _userDataPage(), // Tab 0: show user info
      Center(child: Text('Profile Page')), // Tab 1: dummy profile
    ];
  }

  // Widget to show all user details
  Widget _userDataPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome, ${widget.user.name}", style: TextStyle(fontSize: 20)),
          Text("Email: ${widget.user.email}"),
          Text("Gender: ${widget.user.gender}"),
          Text("Age: ${widget.user.age.toInt()}"),
          Text("Terms Agreed: ${widget.user.isAgreed ? 'Yes' : 'No'}"),
        ],
      ),
    );
  }

  // Handle tab selection
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),

      // Side drawer menu
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Menu", style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () {
                _onTabTapped(1); // Navigate to profile tab
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
          ],
        ),
      ),

      // Content changes based on selected tab
      body: _screens[_selectedIndex],

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
