import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groundwater Monitor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMenuOpen = false;
  late PageController _pageController;
  double _currentIndex = 0; // Track current page for dots
  final List<Widget> _pages = [
    Container(
      color: Colors.grey[200],
      child: Center(child: Text('Current Area Visualization')),
    ),
    Container(
      color: Colors.grey[300],
      child: Center(child: Text('Groundwater Level Diagram')),
    ),
    Container(
      color: Colors.grey[400],
      child: Center(child: Text('Date vs Level Graph')),
    ),
    Container(
      color: Colors.grey[500],
      child: Center(child: Text('Predictions/Other Info')),
    ),
  ];

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''), // Empty title to keep standard height
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: _toggleMenu,
        ),
        backgroundColor: Colors.teal[700],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App name in the body
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Groundwater Monitor Using DWLR stations',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Swipe-down button in the body
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Simple scroll-down design
                        Scrollable.ensureVisible(
                          context,
                          alignment: 0.5,
                          duration: Duration(milliseconds: 500),
                        );
                      },
                      icon: Icon(Icons.arrow_downward, color: Colors.teal[700]),
                      label: Text('Swipe Down to Explore'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                      ),
                    ),
                  ),
                  // Horizontal PageView with navigation
                  Container(
                    height: 400,
                    margin: EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return _pages[index % _pages.length];
                          },
                        ),
                        // Positioned arrow buttons at side middle (encircled positions)
                        Positioned(
                          top: 184, // Middle height (400 / 2 - icon size / 2)
                          left: 10,
                          child: IconButton(
                            icon: Icon(Icons.arrow_left, size: 32),
                            onPressed: () {
                              if (_pageController.hasClients) {
                                _pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 184, // Middle height
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.arrow_right, size: 32),
                            onPressed: () {
                              if (_pageController.hasClients) {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ),
                        // Page dots indicator at bottom
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_pages.length, (index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex.round() == index
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      color: Colors.white,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text('Button 1'),
                            onTap: () => _toggleMenu(),
                          ),
                          ListTile(
                            title: Text('Button 2'),
                            onTap: () => _toggleMenu(),
                          ),
                          ListTile(
                            title: Text('Button 3'),
                            onTap: () => _toggleMenu(),
                          ),
                          ListTile(
                            title: Text('Button 4'),
                            onTap: () => _toggleMenu(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}