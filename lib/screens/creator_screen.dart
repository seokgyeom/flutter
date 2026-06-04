import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatorScreen extends StatefulWidget {
  const CreatorScreen({super.key});

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  int _currentIdx = 0;
  String? _selectedOption;

  IconData _getIconForText(String text) {
    if (text.contains('네트워크')) return Icons.router_rounded;
    if (text.contains('전송')) return Icons.local_shipping_rounded;
    if (text.contains('링크')) return Icons.link_rounded;
    if (text.contains('세션')) return Icons.handshake_rounded;
    return Icons.memory_rounded;
  }

  @override
  Widget build(BuildContext context) {
    // 📡 데이터 파이프라인 주소를 기존 'card_news' 컬렉션으로 연결합니다.
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('card_news').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6FFF92)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              '🛡️ 카드뉴스 데이터가 없습니다.\nFirestore에서 card_news 컬렉션의 필드를 확인해 주세요.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        final docs = snapshot.data!.docs;
        final currentDoc = docs[_currentIdx % docs.length];
        final data = currentDoc.data() as Map<String, dynamic>;

        final String category = data['category'] ?? 'CS 지식';
        final String question = data['question'] ?? '질문이 없습니다.';
        final List<dynamic> options = data['options'] ?? [];
        final String correctAnswer = data['correctAnswer'] ?? '';
        final String explanation = data['explanation'] ?? '';

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 40.0,
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF171F33),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(
                          '$category 테스트 (${(_currentIdx % docs.length) + 1}/${docs.length})',
                          style: const TextStyle(
                            color: Color(0xFF6FFF92),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        question,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.3,
                            ),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          String optionText = options[index].toString();
                          bool isSelected = _selectedOption == optionText;
                          return _buildOptionCard(optionText, isSelected);
                        },
                      ),
                      const SizedBox(height: 48),
                      _buildSubmitButton(correctAnswer, explanation),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(String text, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _selectedOption = text),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A3B28) : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6FFF92)
                : const Color(0xFF1F2937),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6FFF92).withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6FFF92),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: Color(0xFF003915),
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconForText(text),
                    size: 36,
                    color: isSelected ? const Color(0xFF6FFF92) : Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFF6FFF92)
                          : Colors.white70,
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

  Widget _buildSubmitButton(String correctAnswer, String explanation) {
    bool isReady = _selectedOption != null;
    return ElevatedButton(
      onPressed: isReady
          ? () {
              bool isCorrect = _selectedOption == correctAnswer;
              _showResultDialog(isCorrect, explanation);
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isReady
            ? const Color(0xFF6FFF92)
            : const Color(0xFF222A3E),
        foregroundColor: const Color(0xFF003915),
        disabledBackgroundColor: const Color(0xFF171F33),
        minimumSize: const Size(200, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
      ),
      child: const Text(
        '정답 확인',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showResultDialog(bool isCorrect, String explanation) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF171F33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: isCorrect
                  ? const Color(0xFF6FFF92)
                  : const Color(0xFFFFB4AB),
            ),
            const SizedBox(width: 8),
            Text(
              isCorrect ? '정답입니다!' : '틀렸습니다',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCorrect
                    ? const Color(0xFF6FFF92)
                    : const Color(0xFFFFB4AB),
              ),
            ),
          ],
        ),
        content: Text(
          explanation,
          style: const TextStyle(
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
                  _currentIdx++;
                  _selectedOption = null;
                });
              }
            },
            child: Text(
              isCorrect ? '다음 문제' : '다시 시도',
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
