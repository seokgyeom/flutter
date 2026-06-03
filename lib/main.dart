import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // 로그인 화면 파일 연결
import 'screens/quiz_screen.dart';  // ⚡ 방금 만든 퀴즈 화면 파일 연결!

void main() {
  runApp(const CodeLingoApp());
}

class CodeLingoApp extends StatelessWidget {
  const CodeLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CODE_FLOW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B1326), 
        primaryColor: const Color(0xFF6FFF92), 
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6FFF92),
          secondary: Color(0xFFFFB690), 
          surface: Color(0xFF171F33),
          error: Color(0xFFFFB4AB),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFFDBE2FD)),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false; // 🔒 전역 보안 세션 상태 변수

  // 로그인 성공 시 세션을 켜고 홈(0번 탭)으로 이동시키는 콜백 함수
  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
      _selectedIndex = 0; 
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF171F33),
        content: Text('🛡️ 안전한 보안 세션이 수립되었습니다. 전역 권한이 활성화됩니다.', style: TextStyle(color: Color(0xFF6FFF92))),
      ),
    );
  }

  void _onItemTapped(int index) {
    // 🔒 보안 라우트 가드: 로그인하지 않은 상태에서 4번째 탭(index 3)을 누르면 차단
    if (index == 3 && !_isLoggedIn) {
      _showSecurityAlert();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSecurityAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF171F33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Row(
          children: [
            Icon(Icons.lock, color: Color(0xFFFFB4AB), size: 20),
            SizedBox(width: 8),
            Text('접근 권한 제한', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFB4AB))),
          ],
        ),
        content: const Text('보안 위협 방지를 위해 문제 출제 기능은 로그인 및 출제자 권한 승인 후 이용 가능합니다.', style: TextStyle(fontFamily: 'Inter', fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인', style: TextStyle(color: Color(0xFF6FFF92), fontFamily: 'Inter', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 768;

    // 🔄 탭 전환 시 렌더링될 화면 매핑 교체 완료!
    final List<Widget> screens = [
      const Center(child: Text('홈 화면 (구현 준비중)', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 18))),
      LoginScreen(onLoginSuccess: _onLoginSuccess, isLoggedIn: _isLoggedIn),
      const QuizScreen(), // ⚡ 3번째 자리에 임시 텍스트 대신 진짜 퀴즈 화면 도킹!
      const Center(child: Text('새로운 코딩 문제 출제 (보안 권한 승인됨)', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 18))),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D20),
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Colors.white10, width: 1)),
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: Color(0xFF6FFF92), shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            const Text(
              'CODE_FLOW',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6FFF92), letterSpacing: 1.0),
            ),
          ],
        ),
        actions: [
          // 보안 상태 시각화 자물쇠 아이콘
          IconButton(
            icon: Icon(_isLoggedIn ? Icons.lock_open_rounded : Icons.lock_rounded),
            color: _isLoggedIn ? const Color(0xFF6FFF92) : const Color(0xFFFFB4AB),
            onPressed: () {
              setState(() {
                _isLoggedIn = !_isLoggedIn;
                if (!_isLoggedIn && _selectedIndex == 3) _selectedIndex = 0;
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              backgroundColor: const Color(0xFF060D20),
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.all,
              selectedLabelTextStyle: const TextStyle(color: Color(0xFF6FFF92), fontSize: 11, fontFamily: 'Inter', fontWeight: FontWeight.bold),
              unselectedLabelTextStyle: const TextStyle(color: Colors.grey, fontSize: 11, fontFamily: 'Inter'),
              selectedIconTheme: const IconThemeData(color: Color(0xFF060D20)),
              unselectedIconTheme: const IconThemeData(color: Colors.grey),
              indicatorColor: const Color(0xFF6FFF92),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home_filled), label: Text('홈')),
                NavigationRailDestination(icon: Icon(Icons.person_pin_rounded), label: Text('로그인')),
                NavigationRailDestination(icon: Icon(Icons.extension_rounded), label: Text('퀴즈풀기')),
                NavigationRailDestination(icon: Icon(Icons.add_moderator_rounded), label: Text('문제출제')),
              ],
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: screens[_selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? Container(
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white10, width: 1))),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF060D20),
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: const Color(0xFF6FFF92),
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 10),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
                  BottomNavigationBarItem(icon: Icon(Icons.person_pin_rounded), label: '로그인'),
                  BottomNavigationBarItem(icon: Icon(Icons.extension_rounded), label: '퀴즈풀기'),
                  BottomNavigationBarItem(icon: Icon(Icons.add_moderator_rounded), label: '문제출제'),
                ],
              ),
            )
          : null,
    );
  }
}