import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/creator_screen.dart'; // ⚡ 카드뉴스형 문제 풀기 클래스 (기존 파일명 유지)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

  // 🛠️ 개선: 권한 체크 가드를 완전히 제거하여 어떤 탭이든 자유롭게 즉시 이동합니다.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 768;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final bool isLoggedIn = snapshot.hasData && snapshot.data != null;

        // 🛠️ 개선: 과거 로그아웃 시 홈으로 강제 튕겨내던 감시 루프(addPostFrameCallback)를 제거했습니다.
        final List<Widget> screens = [
          const HomeScreen(),
          LoginScreen(isLoggedIn: isLoggedIn),
          const QuizScreen(),
          const CreatorScreen(),
        ];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF060D20),
            elevation: 0,
            shape: const Border(
              bottom: BorderSide(color: Colors.white10, width: 1),
            ),
            title: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6FFF92),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'CODE_FLOW',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6FFF92),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isLoggedIn ? Icons.lock_open_rounded : Icons.lock_rounded,
                ),
                color: isLoggedIn
                    ? const Color(0xFF6FFF92)
                    : const Color(0xFFFFB4AB),
                onPressed: () async {
                  if (isLoggedIn) {
                    await FirebaseAuth.instance.signOut();
                  }
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
                  selectedLabelTextStyle: const TextStyle(
                    color: Color(0xFF6FFF92),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelTextStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                  selectedIconTheme: const IconThemeData(
                    color: Color(0xFF060D20),
                  ),
                  unselectedIconTheme: const IconThemeData(color: Colors.grey),
                  indicatorColor: const Color(0xFF6FFF92),
                  // 🛠️ 이름 및 아이콘 쇄신: 4번째 목적지를 '카드뉴스 풀기'와 전용 그래픽 아이콘으로 개편
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_filled),
                      label: Text('홈'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_pin_rounded),
                      label: Text('로그인'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.extension_rounded),
                      label: Text('퀴즈풀기'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.view_carousel_rounded),
                      label: Text('카드뉴스 풀기'),
                    ),
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
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white10, width: 1),
                    ),
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: const Color(0xFF060D20),
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    selectedItemColor: const Color(0xFF6FFF92),
                    unselectedItemColor: Colors.grey,
                    // 🛠️ 모바일 하단바도 동일하게 카드뉴스 인프라 명세 적용
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_filled),
                        label: '홈',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_pin_rounded),
                        label: '로그인',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.extension_rounded),
                        label: '퀴즈풀기',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.view_carousel_rounded),
                        label: '카드뉴스 풀기',
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }
}
