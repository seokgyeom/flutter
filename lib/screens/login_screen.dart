import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final bool isLoggedIn;

  const LoginScreen({super.key, required this.onLoginSuccess, required this.isLoggedIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSecureLogin() {
    // UI 단에서 유효성 검사(validator) 통과 시에만 메인 통로 활성화
    if (_formKey.currentState!.validate()) {
      widget.onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user_rounded, color: Color(0xFF6FFF92), size: 64),
            const SizedBox(height: 16),
            const Text('이미 보안 세션이 활성화되어 있습니다.', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('계정 식별자: ${_emailController.text.isNotEmpty ? _emailController.text : "user@system.local"}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400), 
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: const Color(0xFF171F33).withOpacity(0.8), 
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3D4A3D).withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1326),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF6FFF92).withOpacity(0.3), width: 1),
                  ),
                  child: const Icon(Icons.terminal_rounded, color: Color(0xFF6FFF92), size: 40),
                ),
                const SizedBox(height: 16),
                const Text('CODE_FLOW 로그인', style: TextStyle(fontFamily: 'Montserrat', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
                const SizedBox(height: 4),
                const Text('코딩 역량을 한 단계 끌어올리세요.', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFFBCCBB9))),
                const SizedBox(height: 32),
                
                // 이메일 필드
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('이메일 계정', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFBCCBB9), letterSpacing: 1.0)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14),
                      decoration: _buildInputDecoration('계정명을 입력하세요 (user@system.local)', Icons.account_circle_outlined),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return '이메일을 필수 입력해 주세요.';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) return '올바른 이메일 형식이 아닙니다.';
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // 비밀번호 필드
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('비밀번호 (ACCESS TOKEN)', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFBCCBB9), letterSpacing: 1.0)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true, 
                      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14),
                      decoration: _buildInputDecoration('비밀번호를 입력하세요', Icons.key_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) return '비밀번호를 필수 입력해 주세요.';
                        if (value.length < 4) return '비밀번호는 최소 4자 이상이어야 합니다.';
                        return null;
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('토큰 분실?', style: TextStyle(color: Color(0xFF6FFF92), fontSize: 12, fontFamily: 'Inter')),
                  ),
                ),
                const SizedBox(height: 12),
                
                // 실행 버튼
                ElevatedButton(
                  onPressed: _handleSecureLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6FFF92),
                    foregroundColor: const Color(0xFF003915),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 4,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('세션 시작하기', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.login_rounded, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // 구분선
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    const Expanded(child: Divider(color: Colors.white10)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('또는 외부 연동', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white.withOpacity(0.38))), 
                    ),
                    const Expanded(child: Divider(color: Colors.white10)),
                  ],
                ),
                const SizedBox(height: 24),
                
                // 소셜 로그인 버튼 리스트
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.code_rounded, size: 18),
                        label: const Text('GitHub'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white10),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 24),
                        label: const Text('Google'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white10),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('환경이 처음이신가요?', style: TextStyle(color: Color(0xFFBCCBB9), fontSize: 13)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('접근 권한 요청', style: TextStyle(color: Color(0xFF6FFF92), fontSize: 13, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
      prefixIcon: Icon(icon, color: Colors.white38, size: 20),
      filled: true,
      fillColor: const Color(0xFF0B1326).withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      errorStyle: const TextStyle(color: Color(0xFFFFB4AB), fontSize: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white10)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white10)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF6FFF92))),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFFFB4AB))),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFFFB4AB), width: 1.5)),
    );
  }
}