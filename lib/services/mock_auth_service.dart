import '../models/mock_user.dart';

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