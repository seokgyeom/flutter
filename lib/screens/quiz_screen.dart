import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // 사용자가 현재 선택한 연산자 상태를 저장할 변수 (null이면 아직 미선택)
  String? _selectedOperator;

  // 4개의 인터랙티브 연산자 선택지 리스트
  final List<String> _operators = ['==', '<=', '&&', '!='];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: Colors.transparent, // main.dart의 다크 배경 공유
      body: SafeArea(
        child: Flex(
          direction: isDesktop ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 💻 왼쪽 영역: 코드 에디터 전광판 (가로 스케일 최적화)
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 제목부
                        const Text('선형 탐색 알고리즘 구현', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6FFF92), letterSpacing: 1.5)),
                        const SizedBox(height: 8),
                        const Text('Linear Search Implementation', style: TextStyle(fontFamily: 'Montserrat', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 6),
                        const Text('배열 내부에서 타겟 데이터를 찾기 위한 올바른 비교 연산자를 완성하세요.', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFFBCCBB9))),
                        const SizedBox(height: 24),

                        // IDE 에디터 스타일 맥북 패널 박스
                        _buildCodeEditorWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ⚡ 오른쪽 영역: 상호작용 카드 조립 패널 (유리블러 효과 레이아웃)
            Container(
              width: isDesktop ? 360 : double.infinity,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1326).withOpacity(0.5),
                border: Border(
                  left: isDesktop ? const BorderSide(color: Colors.white10, width: 1) : BorderSide.none,
                  top: !isDesktop ? const BorderSide(color: Colors.white10, width: 1) : BorderSide.none,
                ),
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('연산자 선택', style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFBCCBB9), letterSpacing: 2.0), textAlign: TextAlign.center),
                      const SizedBox(height: 24),

                      // 2x2 버튼 그리드 배치
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2.0,
                        ),
                        itemCount: _operators.length,
                        itemBuilder: (context, index) {
                          String op = _operators[index];
                          bool isSelected = _selectedOperator == op;
                          return _buildOperatorCard(op, isSelected);
                        },
                      ),
                      const SizedBox(height: 40),

                      // 코드 실행 하단 액션 버튼
                      _buildRunCodeButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🛠️ 에디터 목업 위젯 빌더 (자바 문법 테크니컬 컬러링 이식)
  Widget _buildCodeEditorWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF171F33), // 에디터 깊은 네이비 배경
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 크롬 컨트롤 바 (빨/노/초 신호등 버튼)
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF222A3E),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFFB4AB), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFFB690), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF6FFF92), shape: BoxShape.circle)),
                const SizedBox(width: 16),
                const Text('Search.java', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: Color(0xFFBCCBB9))),
              ],
            ),
          ),
          
          // 소스코드 텍스트 도화지 (RichText 활용 분할 문법 하이라이팅)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCodeLine([
                    _span('public ', const Color(0xFFFFB690)),
                    _span('int ', const Color(0xFF6FFF92)),
                    _span('findTarget(', Colors.white),
                    _span('int', const Color(0xFF6FFF92)),
                    _span('[] arr, ', Colors.white),
                    _span('int ', const Color(0xFF6FFF92)),
                    _span('target) {', Colors.white),
                  ]),
                  _buildCodeLine([
                    _span('    for ', const Color(0xFFFFB690)),
                    _span('(int i = 0; i < arr.length; i++) {', Colors.white),
                  ]),
                  
                  // 🔥 핵심: 빈칸 채우기 조립 상자 결합 구간
                  Row(
                    children: [
                      Text('        if (arr[i] ', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14, color: Colors.white)),
                      
                      // 드롭인 연산자 슬롯 박스
                      Container(
                        width: 64,
                        height: 32,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _selectedOperator != null ? const Color(0x336FFF92) : const Color(0x1A6FFF92),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _selectedOperator != null ? const Color(0xFF6FFF92) : const Color(0xFF6FFF92).withOpacity(0.4),
                            width: 2,
                            style: _selectedOperator != null ? BorderStyle.solid : BorderStyle.none,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _selectedOperator ?? '?',
                            style: TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6FFF92),
                            ),
                          ),
                        ),
                      ),
                      
                      Text(' target) {', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14, color: Colors.white)),
                    ],
                  ),
                  
                  _buildCodeLine([
                    _span('            return ', const Color(0xFFFFB690)),
                    _span('i;', Colors.white),
                  ]),
                  _buildCodeLine([
                    _span('        }', Colors.white),
                  ]),
                  _buildCodeLine([
                    _span('    }', Colors.white),
                  ]),
                  _buildCodeLine([
                    _span('    return -1;', const Color(0xFFFFB690)),
                  ]),
                  _buildCodeLine([
                    _span('}', Colors.white),
                  ]),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 코드 한 줄 컴포넌트 편의 매퍼
  Widget _buildCodeLine(List<TextSpan> fragments) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14, height: 1.5),
          children: fragments,
        ),
      ),
    );
  }

  TextSpan _span(String text, Color color) {
    return TextSpan(text: text, style: TextStyle(color: color));
  }

  // 🔘 우측 연산자 카드 위젯 매커니즘
  Widget _buildOperatorCard(String operator, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedOperator = operator; // 연산자 상태 변환 및 화면 리빌드 트리거
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF222A3E) : const Color(0xFF171F33),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF6FFF92) : Colors.white10,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFF6FFF92).withOpacity(0.2), blurRadius: 10, spreadRadius: 1)]
              : null,
        ),
        child: Center(
          child: Text(
            operator,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF6FFF92) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ▶️ 하단 [코드 실행] 활성화 액션 버튼 위젯
  Widget _buildRunCodeButton() {
    bool isReady = _selectedOperator != null; // 연산자를 골라야 비로소 가동 상태 진입

    return ElevatedButton(
      onPressed: isReady
          ? () {
              bool isCorrect = _selectedOperator == '=='; // 자바 선형 탐색의 정답 조건 판단
              _showFeedbackDialog(isCorrect);
            }
          : null, // 미선택 시 버튼 원천 비활성화
      style: ElevatedButton.styleFrom(
        backgroundColor: isReady ? const Color(0xFF6FFF92) : const Color(0xFF222A3E),
        foregroundColor: const Color(0xFF003915),
        disabledBackgroundColor: const Color(0xFF171F33),
        disabledForegroundColor: Colors.white24,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
        elevation: isReady ? 8 : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('코드 실행하기', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Icon(Icons.play_arrow_rounded, size: 20, color: isReady ? const Color(0xFF003915) : Colors.white24),
        ],
      ),
    );
  }

  // 📝 정답 여부에 따른 실시간 피드백 얼럿창 팝업
  void _showFeedbackDialog(bool isCorrect) {
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
              isCorrect ? '정답입니다! (+10 XP)' : '다시 한번 생각해볼까요?',
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
              ? '배열의 인덱스 순서대로 값을 비교하여 target과 완전히 일치하는(==) 순간 해당 원소의 방 번호(i)를 리턴하는 정석 선형탐색 구조입니다.'
              : '현재 기호는 배열의 인덱스 값과 타겟 값이 서로 다를 때나 크기를 판별할 때 작동하므로, 일치하는 요소를 찾아내는 조건식에 맞지 않습니다.',
          style: const TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isCorrect ? '다음 문제로' : '다시 풀기',
              style: const TextStyle(color: Color(0xFF6FFF92), fontFamily: 'Inter', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}