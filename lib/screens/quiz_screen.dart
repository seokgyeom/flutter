import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ⚡ Firestore 실시간 연동 모듈 임포트

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuizIndex = 0;
  String? _selectedOperator;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 768;

    // 📡 StreamBuilder: 클라우드 DB의 'quizzes' 데이터를 24시간 감시하는 파이프라인 수립
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
      builder: (context, snapshot) {
        // 로딩 중 예외 처리 (네트워크 가드)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6FFF92)),
          );
        }

        // DB가 비어있거나 통신 실패 시 비판적 크래시 예방 레이아웃
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              '🛡️ Firestore DB에 등록된 문제가 없습니다.\nFirebase 웹 콘솔에서 컬렉션을 확인해 주세요.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        // 원격 문서 목록 가져오기 및 동적 롤링 처리
        final quizDocs = snapshot.data!.docs;
        final currentDoc = quizDocs[_currentQuizIndex % quizDocs.length];

        // 맵 구조화 데이터 타입 캐스팅 파싱
        final quizData = currentDoc.data() as Map<String, dynamic>;

        // 안전하게 데이터 분해 조립 (서버 누락 데이터 방어)
        final String title = quizData['title'] ?? '문제';
        final String description = quizData['description'] ?? '';
        final String codeBody = quizData['codeBody'] ?? '';
        final List<dynamic> options = quizData['options'] ?? [];
        final String correctAnswer = quizData['correctAnswer'] ?? '';
        final String explanation = quizData['explanation'] ?? '';

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 💻 왼쪽: 소스코드 크롬 캔버스
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '문제 진행도 0${(_currentQuizIndex % quizDocs.length) + 1} / 0${quizDocs.length}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6FFF92),
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.cloud_done_rounded,
                                      color: Color(0xFF6FFF92),
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Cloud Sync Connected',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value:
                                    ((_currentQuizIndex % quizDocs.length) +
                                        1) /
                                    quizDocs.length,
                                minHeight: 6,
                                backgroundColor: Colors.white10,
                                color: const Color(0xFF6FFF92),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              title,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xFFBCCBB9),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildCodeCanvasMockup(codeBody),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ⚡ 우측: 연산자 터치 카드 조립 보드
                Container(
                  width: isDesktop ? 360 : double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1326).withOpacity(0.5),
                    border: Border(
                      left: isDesktop
                          ? const BorderSide(color: Colors.white10, width: 1)
                          : BorderSide.none,
                      top: !isDesktop
                          ? const BorderSide(color: Colors.white10, width: 1)
                          : BorderSide.none,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            '오퍼레이터 조립',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 2.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 2.0,
                                ),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              String optionText = options[index].toString();
                              bool isSelected = _selectedOperator == optionText;
                              return _buildInteractionOptionCard(
                                optionText,
                                isSelected,
                              );
                            },
                          ),
                          const SizedBox(height: 40),
                          _buildSubmitActionButton(correctAnswer, explanation),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCodeCanvasMockup(String rawCode) {
    String formattedCode = rawCode.replaceAll(r'\n', '\n');
    List<String> codeLines = formattedCode.split('\n');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF171F33),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF222A3E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.terminal_rounded,
                  color: Color(0xFF6FFF92),
                  size: 16,
                ),
                SizedBox(width: 12),
                Text(
                  'StreamContainer.java',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    color: Color(0xFFBCCBB9),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: codeLines.map((line) {
                  if (line.contains('[ ? ]')) {
                    var parts = line.split('[ ? ]');
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text(
                            parts[0],
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 30,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: _selectedOperator != null
                                  ? const Color(0x336FFF92)
                                  : const Color(0x1A6FFF92),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFF6FFF92).withOpacity(
                                  _selectedOperator != null ? 1.0 : 0.4,
                                ),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _selectedOperator ?? '?',
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6FFF92),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            parts[1],
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      line,
                      style: const TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 14,
                        color: Color(0xFFDBE2FD),
                        height: 1.4,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionOptionCard(String text, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _selectedOperator = text),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF222A3E) : const Color(0xFF171F33),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF6FFF92) : Colors.white10,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 18,
              color: isSelected ? const Color(0xFF6FFF92) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitActionButton(String correctAnswer, String explanation) {
    bool isActivated = _selectedOperator != null;

    return ElevatedButton(
      onPressed: isActivated
          ? () {
              bool isCorrect = _selectedOperator == correctAnswer;
              _showFeedbackOverlayDialog(isCorrect, explanation);
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActivated
            ? const Color(0xFF6FFF92)
            : const Color(0xFF222A3E),
        foregroundColor: const Color(0xFF003915),
        disabledBackgroundColor: const Color(0xFF171F33),
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
      ),
      child: const Text(
        '정답 제출 및 클라우드 검증',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showFeedbackOverlayDialog(bool isCorrect, String explanation) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF171F33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          isCorrect ? '정답입니다! (+10 XP) 🎉' : '틀렸습니다. 다시 고민해보세요! 🛠️',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isCorrect
                ? const Color(0xFF6FFF92)
                : const Color(0xFFFFB4AB),
          ),
        ),
        content: Text(
          explanation,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1.5,
            color: Color(0xFFDBE2FD),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isCorrect) {
                setState(() {
                  _currentQuizIndex++;
                  _selectedOperator = null;
                });
              }
            },
            child: Text(
              isCorrect ? '다음 문제' : '재도전 하기',
              style: const TextStyle(
                color: Color(0xFF6FFF92),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
