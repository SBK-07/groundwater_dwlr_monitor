import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groundwater Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            shadowColor: Colors.blue.withOpacity(0.3),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMenuOpen = false;
  late PageController _pageController;
  double _currentIndex = 0;
  final List<Widget> _pages = [
    _buildPageContent('Current Area Visualization', Colors.blue[50]!),
    _buildPageContent('Groundwater Level Diagram', Colors.blue[100]!),
    _buildPageContent('Date vs Level Graph', Colors.blue[200]!),
    _buildPageContent('Predictions/Other Info', Colors.blue[300]!),
  ];

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _pageViewKey = GlobalKey();

  static Widget _buildPageContent(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.blue[900],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page! % _pages.length;
      });
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Groundwater Monitor',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: _toggleMenu,
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.teal[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Hero Section
                  Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[50]!, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App title
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'Groundwater Monitor\nUsing DWLR Stations',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[900],
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Spacer(),
                        // Swipe down button
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final context = _pageViewKey.currentContext;
                              if (context != null) {
                                Scrollable.ensureVisible(
                                  context,
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            icon: Icon(Icons.arrow_downward,
                                color: Colors.blue[700]),
                            label: Text(
                              "Explore Features",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue[700],
                              elevation: 8,
                              shadowColor: Colors.blue.withOpacity(0.3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // PageView Section
                  Container(
                    key: _pageViewKey,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SwipableContainer(
                      controller: _pageController,
                      currentIndex: _currentIndex,
                      pages: _pages,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ],
          ),
          // Side Menu
          if (_isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  children: [
                    Container(
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(2, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue[700]!, Colors.teal[700]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Menu',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                _buildMenuButton(
                                  context,
                                  'Sign in as Authority',
                                  Icons.security,
                                      () {
                                    _toggleMenu();
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const AuthoritySignInPage(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(-1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;
                                          var tween = Tween(
                                              begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                _buildMenuButton(
                                  context,
                                  'View Dataset',
                                  Icons.cloud_download,
                                      () {
                                    _toggleMenu();
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const DatasetPage(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(0.0, 1.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;
                                          var tween = Tween(
                                              begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                _buildMenuButton(
                                  context,
                                  'About App',
                                  Icons.info,
                                  _toggleMenu,
                                ),
                                _buildMenuButton(
                                  context,
                                  'Settings',
                                  Icons.settings,
                                  _toggleMenu,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[700]),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: Colors.blue[900],
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class SwipableContainer extends StatelessWidget {
  final PageController controller;
  final double currentIndex;
  final List<Widget> pages;

  const SwipableContainer({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return pages[index % pages.length];
              },
            ),
            // Left arrow
            Positioned(
              top: 184,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_left, size: 36, color: Colors.blue[700]),
                onPressed: () {
                  if (controller.hasClients) {
                    controller.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            // Right arrow
            Positioned(
              top: 184,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_right, size: 36, color: Colors.blue[700]),
                onPressed: () {
                  if (controller.hasClients) {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            // Page dots
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: currentIndex.round() == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: currentIndex.round() == index
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius: currentIndex.round() == index
                          ? BorderRadius.circular(4)
                          : null,
                      color: currentIndex.round() == index
                          ? Colors.blue[700]
                          : Colors.grey[400],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock User Model
class MockUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String dwlrStationId;

  MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dwlrStationId,
  });
}

// Mock Authentication Service
class MockAuthService {
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;
  MockAuthService._internal();

  // Mock user database (in real app, this would be a real database)
  final List<MockUser> _mockUsers = [
    MockUser(
      id: '1',
      name: 'Water Authority Admin',
      email: 'admin@waterauthority.com',
      phone: '+1234567890',
      dwlrStationId: 'DWLR-001',
    ),
    MockUser(
      id: '2',
      name: 'Regional Inspector',
      email: 'inspector@waterauthority.com',
      phone: '+0987654321',
      dwlrStationId: 'DWLR-002',
    ),
  ];

  MockUser? _currentUser;

  // Sign in with email and password
  Future<MockUser?> signInWithEmailPassword(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple mock validation - any non-empty password works for demo
    if (password.isNotEmpty) {
      final user = _mockUsers.firstWhere(
            (user) => user.email == email,
        orElse: () => MockUser(id: '', name: '', email: '', phone: '', dwlrStationId: ''),
      );

      if (user.id.isNotEmpty) {
        _currentUser = user;
        return user;
      }
    }
    return null;
  }

  // Sign up with email and password
  Future<MockUser?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String dwlrStationId,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Check if email already exists
    if (_mockUsers.any((user) => user.email == email)) {
      return null;
    }

    // Create new user
    final newUser = MockUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      dwlrStationId: dwlrStationId,
    );

    _mockUsers.add(newUser);
    _currentUser = newUser;
    return newUser;
  }

  // Password reset simulation
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, this would send an email
    // For demo, we just simulate success if email exists
    if (_mockUsers.any((user) => user.email == email)) {
      return;
    } else {
      throw Exception('Email not found');
    }
  }

  // Get current user
  MockUser? get currentUser => _currentUser;

  // Sign out
  Future<void> signOut() async {
    _currentUser = null;
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

// Authority Sign In Page
class AuthoritySignInPage extends StatefulWidget {
  const AuthoritySignInPage({super.key});

  @override
  State<AuthoritySignInPage> createState() => _AuthoritySignInPageState();
}

class _AuthoritySignInPageState extends State<AuthoritySignInPage> {
  final MockAuthService _authService = MockAuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        MockUser? user = await _authService.signInWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        setState(() {
          _isLoading = false;
        });

        if (user != null) {
          // Successfully signed in
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AuthorityDashboard(user: user),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid credentials. Please try again.',
                  style: GoogleFonts.poppins()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e', style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const AuthoritySignUpPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your email address first.',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await _authService.resetPassword(_emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent! Check your inbox.',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending reset email: $e',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authority Sign In', style: GoogleFonts.poppins()),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.teal[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.security, size: 64, color: Colors.blue[700]),
                      const SizedBox(height: 16),
                      Text(
                        'Authority Sign In',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Demo Credentials:\nadmin@waterauthority.com / any password',
                        style: GoogleFonts.poppins(
                          color: Colors.blue[700],
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email, color: Colors.blue[700]),
                          floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: Colors.blue[700]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue[700],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _resetPassword,
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signIn,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blue[700],
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                              : Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _navigateToSignUp,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.blue[700]!),
                          ),
                          child: Text(
                            'Sign Up as Authority',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Authority Sign Up Page
class AuthoritySignUpPage extends StatefulWidget {
  const AuthoritySignUpPage({super.key});

  @override
  State<AuthoritySignUpPage> createState() => _AuthoritySignUpPageState();
}

class _AuthoritySignUpPageState extends State<AuthoritySignUpPage> {
  final MockAuthService _authService = MockAuthService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dwlrStationIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        MockUser? user = await _authService.signUpWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          dwlrStationId: _dwlrStationIdController.text.trim(),
        );

        setState(() {
          _isLoading = false;
        });

        if (user != null) {
          // Successfully signed up
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account created successfully!',
                  style: GoogleFonts.poppins()),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AuthorityDashboard(user: user),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email already exists. Please use a different email.',
                  style: GoogleFonts.poppins()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e', style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dwlrStationIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authority Registration', style: GoogleFonts.poppins()),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.teal[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_add, size: 64, color: Colors.blue[700]),
                      const SizedBox(height: 16),
                      Text(
                        'Authority Registration',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person, color: Colors.blue[700]),
                          floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone, color: Colors.blue[700]),
                          floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email, color: Colors.blue[700]),
                          floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dwlrStationIdController,
                        decoration: InputDecoration(
                          labelText: 'DWLR Station ID',
                          prefixIcon: Icon(Icons.sensors, color: Colors.blue[700]),
                          floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your DWLR Station ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: Colors.blue[700]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue[700],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blue[700],
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                              : Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Authority Dashboard Page
class AuthorityDashboard extends StatefulWidget {
  final MockUser user;

  const AuthorityDashboard({super.key, required this.user});

  @override
  State<AuthorityDashboard> createState() => _AuthorityDashboardState();
}

class _AuthorityDashboardState extends State<AuthorityDashboard> {
  final MockAuthService _authService = MockAuthService();
  bool _isLoading = false;

  void _signOut() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _authService.signOut();
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Sign out error: $e');
    }
  }

  // Dummy data for charts and predictions
  final List<FlSpot> _waterLevelData = [
    const FlSpot(0, 45),
    const FlSpot(1, 47),
    const FlSpot(2, 43),
    const FlSpot(3, 48),
    const FlSpot(4, 42),
    const FlSpot(5, 46),
    const FlSpot(6, 44),
  ];

  final List<FlSpot> _rainfallData = [
    const FlSpot(0, 12),
    const FlSpot(1, 15),
    const FlSpot(2, 8),
    const FlSpot(3, 18),
    const FlSpot(4, 10),
    const FlSpot(5, 14),
    const FlSpot(6, 9),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authority Dashboard', style: GoogleFonts.poppins()),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.teal[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Icon(Icons.logout, color: Colors.white),
            onPressed: _isLoading ? null : _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[100]!, Colors.blue[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue[700],
                            child: Text(
                              widget.user.name.isNotEmpty
                                  ? widget.user.name[0].toUpperCase()
                                  : 'A',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome, ${widget.user.name}!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                Text(
                                  'DWLR Station: ${widget.user.dwlrStationId}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Groundwater Monitoring Analytics',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Trend Analysis Section
              Text(
                'Trend Analysis',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Water Level Trends (Last 7 Days)',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _waterLevelData,
                                isCurved: true,
                                color: Colors.blue,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Predictions Section
              Text(
                'Water Level Predictions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildPredictionCard(
                    'Next Week',
                    '45.2 m',
                    Icons.next_week,
                    Colors.green[100]!,
                  ),
                  _buildPredictionCard(
                    'Next Month',
                    '43.8 m',
                    Icons.calendar_today,
                    Colors.orange[100]!,
                  ),
                  _buildPredictionCard(
                    'Next Year',
                    '41.5 m',
                    Icons.analytics,
                    Colors.purple[100]!,
                  ),
                  _buildPredictionCard(
                    'Rainfall Forecast',
                    '12.4 mm',
                    Icons.cloud,
                    Colors.blue[100]!,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Anomaly Detection Section
              Text(
                'Anomaly Detection',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange[700], size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'System Status: Normal',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'No unusual readings detected in the last 24 hours',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Station Health Section
              Text(
                'Station Health Monitoring',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.sensors, color: Colors.green[700], size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DWLR Station Status: Active',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'Last data transmission: 2 hours ago',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(
                          'HEALTHY',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Reports Section
              Text(
                'Reports & Insights',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.assessment, color: Colors.blue[700], size: 40),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Generate Monthly Report',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Generate report functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Report generated successfully!',
                                    style: GoogleFonts.poppins()),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: Text(
                            'Download PDF Report',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue[700]),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.blue[900],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.blue[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dataset Page
class DatasetPage extends StatefulWidget {
  const DatasetPage({super.key});

  @override
  State<DatasetPage> createState() => _DatasetPageState();
}

class _DatasetPageState extends State<DatasetPage> {
  String? _selectedLocation;
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _locations = ['Chennai', 'Mumbai', 'Delhi', 'Kolkata', 'Bangalore'];
  List<GroundwaterData> _dataset = [];
  bool _isLoading = false;
  bool _filtersApplied = false;

  // Dummy data generator
  List<GroundwaterData> _generateDummyData() {
    List<GroundwaterData> data = [];
    if (_selectedLocation == null || _startDate == null || _endDate == null) {
      return data;
    }

    DateTime currentDate = _startDate!;
    int daysDifference = _endDate!.difference(_startDate!).inDays;
    int dataPoints = daysDifference > 10 ? 10 : daysDifference;

    for (int i = 0; i < dataPoints; i++) {
      data.add(GroundwaterData(
        date: currentDate.add(Duration(days: i)),
        waterLevel: 40.0 + (i * 0.5) + (DateTime.now().millisecond % 10) - 5,
        rainfall: 5.0 + (i * 0.3) + (DateTime.now().millisecond % 5),
        anomalyStatus: i % 7 == 0 ? 'Suspicious' : 'Normal',
        stationStatus: i % 5 == 0 ? 'Maintenance' : 'Active',
        location: _selectedLocation!,
      ));
    }
    return data;
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _applyFilters() {
    if (_selectedLocation == null || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select location, start date, and end date',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('End date must be after start date',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _filtersApplied = false;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _dataset = _generateDummyData();
        _isLoading = false;
        _filtersApplied = true;
      });
    });
  }

  void _downloadDataset() {
    if (_dataset.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No data available to download. Apply filters first.',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate download process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Download Successful', style: GoogleFonts.poppins()),
          content: Text(
            'Dataset for $_selectedLocation (${_startDate!.toString().split(' ')[0]} to ${_endDate!.toString().split(' ')[0]}) has been downloaded as CSV.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedLocation = null;
      _startDate = null;
      _endDate = null;
      _dataset.clear();
      _filtersApplied = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groundwater Dataset', style: GoogleFonts.poppins()),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.teal[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Filters Section
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Filter Dataset',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Location Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      decoration: InputDecoration(
                        labelText: 'Select Location',
                        prefixIcon: Icon(Icons.location_on, color: Colors.blue[700]),
                        floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLocation = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date Range Picker
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[700]),
                              floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                              hintText: _startDate == null
                                  ? 'Select start date'
                                  : _startDate!.toString().split(' ')[0],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onTap: _selectStartDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[700]),
                              floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                              hintText: _endDate == null
                                  ? 'Select end date'
                                  : _endDate!.toString().split(' ')[0],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onTap: _selectEndDate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _applyFilters,
                            icon: const Icon(Icons.filter_alt),
                            label: Text(
                              'Apply Filters',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _clearFilters,
                          icon: const Icon(Icons.clear),
                          label: Text('Clear', style: GoogleFonts.poppins()),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.blue[700]!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Dataset Display Section
            Expanded(
              child: _isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading dataset...',
                      style: GoogleFonts.poppins(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : _dataset.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.data_array,
                      size: 64,
                      color: Colors.blue[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _filtersApplied
                          ? 'No data available for selected filters'
                          : 'Apply filters to view dataset',
                      style: GoogleFonts.poppins(
                        color: Colors.blue[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Dataset Summary
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Showing ${_dataset.length} records',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[800],
                              ),
                            ),
                            Chip(
                              label: Text(
                                _selectedLocation!,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: Colors.blue[700],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Dataset Table
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Table Header
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Date',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[900],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Water Level',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[900],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Rainfall',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[900],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Status',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[900],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Table Body
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _dataset.length,
                                  itemBuilder: (context, index) {
                                    final data = _dataset[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: index.isEven
                                            ? Colors.white
                                            : Colors.grey[50],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 4),
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              '${data.date.day}/${data.date.month}/${data.date.year}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.blue[800],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data.waterLevel.toStringAsFixed(1)} m',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: _getWaterLevelColor(data.waterLevel),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data.rainfall.toStringAsFixed(1)} mm',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.blue[600],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(data.anomalyStatus),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    data.anomalyStatus,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Download Button Section
            if (_dataset.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _downloadDataset,
                    icon: _isLoading
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Icon(Icons.download),
                    label: _isLoading
                        ? Text('Downloading...', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))
                        : Text(
                      'Download CSV Dataset',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getWaterLevelColor(double level) {
    if (level < 38) return Colors.red;
    if (level < 42) return Colors.orange;
    return Colors.green;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Normal':
        return Colors.green;
      case 'Suspicious':
        return Colors.orange;
      case 'Critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Data Model for Groundwater Data
class GroundwaterData {
  final DateTime date;
  final double waterLevel;
  final double rainfall;
  final String anomalyStatus;
  final String stationStatus;
  final String location;

  GroundwaterData({
    required this.date,
    required this.waterLevel,
    required this.rainfall,
    required this.anomalyStatus,
    required this.stationStatus,
    required this.location,
  });
}