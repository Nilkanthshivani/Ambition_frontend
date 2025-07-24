import 'package:ambition_delivery/presentation/bloc/auth_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/profile_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/ride_request_bloc.dart';
import 'package:ambition_delivery/presentation/pages/passenger/passenger_history_page.dart';
import 'package:ambition_delivery/presentation/pages/passenger/passenger_main_page.dart';
import 'package:ambition_delivery/presentation/pages/passenger/passenger_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PassengerHomePage extends StatefulWidget {
  const PassengerHomePage({super.key});

  @override
  State<PassengerHomePage> createState() => _PassengerHomePageState();
}

class _PassengerHomePageState extends State<PassengerHomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Titles corresponding to each page
  final List<String> _titles = [
    'Passenger Home',
    'Passenger History',
    'Passenger Profile',
  ];

  late Future<Map<String, dynamic>?> userFuture;

  Future<Map<String, dynamic>?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final decoded = jsonDecode(userJson);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    }
    return null;
  }

  void refreshUser() {
    setState(() {
      userFuture = loadUser();
    });
  }

  @override
  void initState() {
    // Fetch user location
    BlocProvider.of<RideRequestBloc>(context).add(UpdateUserLocationEvent());
    // Fetch user profile
    BlocProvider.of<ProfileBloc>(context).add(GetProfile());
    userFuture = loadUser();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshUser(); // Refresh user info after navigation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.only(
                  top: 40, left: 16, right: 16, bottom: 16),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    final user = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (user['profile'] == null || user['profile'].isEmpty)
                            ? const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              )
                            : CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(user['profile']),
                              ),
                        const SizedBox(height: 10),
                        Text(
                          "Welcome, ${user['name'] ?? 'User'}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          user['email'] ?? 'user@example.com',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }
                  // fallback UI
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome, User",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const Text(
                        'user@example.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.house),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                _pageController.jumpToPage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.clockRotateLeft),
              title: const Text('History'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                _pageController.jumpToPage(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.user),
              title: const Text('Profile'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                _pageController.jumpToPage(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.comment),
              title: const Text('Chat'),
              onTap: () {
                Navigator.of(context).pushNamed('/chat_list');
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.clock),
              title: const Text('Scheduled Rides'),
              onTap: () {
                Navigator.of(context).pushNamed('/scheduled_rides');
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.rightFromBracket),
              title: const Text('Logout'),
              onTap: () {
                //show dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text(
                        "Are you sure you want to logout from the app?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<AuthBloc>(context)
                              .add(SignOutEvent());

                          // Navigate to the login page
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          PassengerMainPage(),
          PassengerHistoryPage(),
          PassengerProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
