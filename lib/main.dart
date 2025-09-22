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

  final ScrollController _scrollController = ScrollController(); // For scroll control
  final GlobalKey _pageViewKey = GlobalKey();//Global

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
            controller: _scrollController, // Attach scroll controller
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75, // 3/4th of screen
                    child: Column(
                      children: [
                        // App name centered
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
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
                        ),
                        Spacer(), // Pushes button to bottom inside 3/4th box
                        // Swipe down button with scroll action
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final context = _pageViewKey.currentContext;
                              if (context != null) {
                                Scrollable.ensureVisible(
                                  context,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            icon: Icon(Icons.arrow_downward, color: Colors.teal[700]),
                            label: Text("Swipe Down to Explore"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Horizontal PageView with navigation
                  Container(
                    key: _pageViewKey,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,          // Background color of outer container

                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SwipableContainer(
                      controller: _pageController,
                      currentIndex: _currentIndex,
                      pages: _pages,
                    ),
                  ),

                  // Add padding to ensure scrollable space
                  SizedBox(height: 100), // Buffer to allow scrolling back up
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
                            title: Text('Login'),
                            onTap: () => _toggleMenu(),
                          ),
                          ListTile(
                            title: Text('Download Dataset'),
                            onTap: () => _toggleMenu(),
                          ),
                          ListTile(
                            title: Text('User Guide'),
                            onTap: () => _toggleMenu(),
                          ),
                          ListTile(
                            title: Text('About'),
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

class SwipableContainer extends StatelessWidget {
  final PageController controller;
  final double currentIndex;
  final List<Widget> pages;

  const SwipableContainer({
    Key? key,
    required this.controller,
    required this.currentIndex,
    required this.pages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: EdgeInsets.symmetric(
        horizontal: 4.0, // left & right
        vertical: 8.0,    // top & bottom
      ),
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(12),
      ),
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
              icon: Icon(Icons.arrow_left, size: 32),
              onPressed: () {
                if (controller.hasClients) {
                  controller.previousPage(
                    duration: Duration(milliseconds: 300),
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
              icon: Icon(Icons.arrow_right, size: 32),
              onPressed: () {
                if (controller.hasClients) {
                  controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          // Page dots
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex.round() == index
                        ? Colors.blue
                        : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
