import 'package:flutter/material.dart';

class CreatorScreen extends StatefulWidget {
  const CreatorScreen({super.key});

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  // 사용자가 현재 선택한 문항 인덱스 번호 (-1은 아직 터치 안 한 상태)
  int _selectedAnswerIndex = -1;

  // 실제 네트워크 핵심 퀴즈 정보 구성
  final String _questionText = "OSI 7계층 모델 중 종단 간(End-to-End) 신뢰성 있는 통신을 보장하고, 에러 복구 및 흐름 제어를 담당하는 계층은 어디일까요?";
  
  // 4분할 격자에 매핑될 사지선다 카드 명세 (텍스트 및 대응 아이콘 매칭)
  final List<Map<String, dynamic>> _quizOptions = [
    {'name': '네트워크 계층 (Network Layer)', 'icon': Icons.router_rounded},
    {'name': '전송 계층 (Transport Layer)', 'icon': Icons.local_shipping_rounded}, // 정답 (인덱스 1)
    {'name': '데이터 링크 계층 (Data Link Layer)', 'icon': Icons.link_rounded},
    {'name': '세션 계층 (Session Layer)', 'icon': Icons.handshake_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: Colors.transparent, // main.dart의 전체 딥네이비 배경 공유
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800), // 최대 가로폭 격리
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🧠 상단 진행 정보 배치 뱃지 (듀오링고 챌린지 폰트 스타일)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF171F33).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.psychology_rounded, color: Color(0xFF6FFF92), size: 16),
                        SizedBox(width: 8),
                        Text('오늘의 챌린지 문항 04 / 10', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFBCCBB9))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ❓ 메인 질문 텍스트 섹션
                  Text(
                    _questionText,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: isDesktop ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // 🎴 4분할 카드 격자 매트릭스 레이아웃 (반응형 비율 유지)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2열 고정 구조
                      crossAxisSpacing: isDesktop ? 20 : 12,
                      mainAxisSpacing: isDesktop ? 20 : 12,
                      childAspectRatio: isDesktop ? 1.5 : 1.2, // 카드 비율 고정으로 터짐 방지
                    ),
                    itemCount: _quizOptions.length,
                    itemBuilder: (context, index) {
                      return _buildQuadrantCard(index);
                    },
                  ),
                  const SizedBox(height: 48),

                  // 🚀 하단 결과 확인 및 전진 액션 버튼
                  _buildActionContinueButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🎴 개별 사분면 터치 카드 컴포넌트 위젯 빌더
  Widget _buildQuadrantCard(int index) {
    bool isSelected = _selectedAnswerIndex == index;
    var option = _quizOptions[index];

    return InkWell(
      onTap: () {
        setState(() {
          _selectedAnswerIndex = index; // 사용자가 고른 번호로 리빌드 가동
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // 선택 시 민트색 글로우 및 반투명 배경 적용
          color: isSelected ? const Color(0x1A6FFF92) : const Color(0xFF171F33).withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6FFF92) : Colors.white10,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFF6FFF92).withOpacity(0.15), blurRadius: 15, spreadRadius: 1)]
              : null,
        ),
        child: Stack(
          children: [
            // 정답 선택 체크 마크 (상단 우측 오버레이)
            if (isSelected)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(color: Color(0x336FFF92), shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, color: Color(0xFF6FFF92), size: 14),
                ),
              ),
            
            // 중앙 아이콘 및 안내 라벨 본문
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    option['icon'],
                    size: 36,
                    color: isSelected ? const Color(0xFF6FFF92) : const Color(0xFFBCCBB9),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    option['name'],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? const Color(0xFF6FFF92) : Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ▶️ 하단 [결과 검증하기] 액션 버튼 위젯 빌더
  Widget _buildActionContinueButton() {
    bool hasSelection = _selectedAnswerIndex != -1;

    return ElevatedButton(
      onPressed: hasSelection
          ? () {
              bool isCorrect = _selectedAnswerIndex == 1; // 1번 인덱스가 전송 계층 정답
              _showQuizFeedbackResult(isCorrect);
            }
          : null, // 미선택 시 버튼 강제 잠금
      style: ElevatedButton.styleFrom(
        backgroundColor: hasSelection ? const Color(0xFF6FFF92) : const Color(0xFF222A3E),
        foregroundColor: const Color(0xFF003915),
        disabledBackgroundColor: const Color(0xFF171F33),
        disabledForegroundColor: Colors.white24,
        minimumSize: const Size(220, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
        elevation: hasSelection ? 8 : 0,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('정답 검증하기', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 18),
        ],
      ),
    );
  }

  // 📝 정답 검문 후 나타나는 세부 분석 팝업 모듈
  void _showQuizFeedbackResult(bool isCorrect) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF171F33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: isCorrect ? const Color(0xFF6FFF92) : const Color(0xFFFFB4AB),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              isCorrect ? '정답입니다! 완벽해요' : '아쉽습니다! 다시 검토해 볼까요?',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isCorrect ? const Color(0xFF6FFF92) : const Color(0xFFFFB4AB),
              ),
            ),
          ],
        ),
        content: Text(
          isCorrect
              ? '전송 계층(Transport Layer)은 상위 계층에서 보낸 데이터를 분할하고 세그먼트 단위로 만들어, 종단 간(End-to-End) 장치 간에 오류 제어 및 흐름 제어(Flow Control)를 수행하는 핵심 네트워크 허브입니다.'
              : '선택하신 계층은 데이터의 경로(라우팅)를 제어하거나 물리적 인접 노드 간의 링크 소통을 담당하므로, 전체 통신 회선의 종단 간 신뢰성 복구 임무와는 거리가 멀어 오답 처리됩니다.',
          style: const TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.5, color: Color(0xFFDBE2FD)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isCorrect ? '다음 라운드로' : '다시 도전하기',
              style: const TextStyle(color: Color(0xFF6FFF92), fontFamily: 'Inter', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}