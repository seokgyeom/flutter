import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final bool isLoggedIn;

  const LoginScreen({super.key, required this.isLoggedIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleFirebaseLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('이메일과 비밀번호를 빠짐없이 입력해 주세요.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _showSnackBar('🛡️ 멤버십 보안 세션 수립 성공! 개인화 서비스가 동기화됩니다.', isError: false);
    } on FirebaseAuthException catch (e) {
      String errorMessage = '로그인 인증에 실패했습니다.';
      if (e.code == 'user-not-found') {
        errorMessage = '등록되지 않은 이메일 계정입니다.';
      } else if (e.code == 'wrong-password') {
        errorMessage = '비밀번호가 일치하지 않습니다.';
      } else if (e.code == 'invalid-email') {
        errorMessage = '이메일 주소 형식이 올바르지 않습니다.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = '인증 정보가 만료되었거나 일치하지 않습니다.';
      }
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      _showSnackBar('네트워크 통신 중 에러가 발생했습니다.', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleFirebaseLogout() async {
    await FirebaseAuth.instance.signOut();
    _showSnackBar('안전하게 로그아웃되었습니다.', isError: false);
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF171F33),
        content: Text(
          message,
          style: TextStyle(
            color: isError ? const Color(0xFFFFB4AB) : const Color(0xFF6FFF92),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: const Color(0xFF171F33),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: widget.isLoggedIn
                ? _buildAuthenticatedView()
                : _buildLoginFormView(),
          ),
        ),
      ),
    );
  }

  // 🔓 일반 로그인 폼 디자인 뷰 (출제 권한 멘트 전면 제거)
  Widget _buildLoginFormView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.account_circle_rounded,
          size: 48,
          color: Color(0xFF6FFF92),
        ),
        const SizedBox(height: 16),
        const Text(
          'MEMBER SIGN IN',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'CODE_FLOW 계정으로 로그인하여 나만의 맞춤형 학습 트랙을 기록해 보세요.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: '이메일 주소',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email_outlined),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: '비밀번호',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleFirebaseLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6FFF92),
            foregroundColor: const Color(0xFF003915),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF003915),
                  ),
                )
              : const Text(
                  '로그인 및 클라우드 동기화',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }

  // 🔒 로그인 성공 후 대시보드 뷰 (통제 문구 전면 제거)
  Widget _buildAuthenticatedView() {
    final user = FirebaseAuth.instance.currentUser;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.cloud_done_rounded,
          size: 48,
          color: Color(0xFF6FFF92),
        ),
        const SizedBox(height: 16),
        const Text(
          '프로필 허브 수립됨',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '${user?.email ?? "알 수 없는 사용자"} 계정 정보 연결 중',
          style: const TextStyle(fontSize: 13, color: Color(0xFFBCCBB9)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        const Text(
          '✨ 실시간 클라우드 동기화가 활성화되었습니다. 모든 퀴즈 진행 상황과 카드뉴스 학습 데이터가 안전하게 저장됩니다.',
          style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: _handleFirebaseLogout,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFFFB4AB)),
            foregroundColor: const Color(0xFFFFB4AB),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            '보안 세션 종료 (로그아웃)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
