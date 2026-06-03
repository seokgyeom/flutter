import 'dart:math';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시로 84개의 잔디 데이터 강도(0~4)를 무작위로 생성 (실제 앱에서는 DB에서 학습 기록을 받아올 구간)
    final Random random = Random();
    final List<int> activityLevels = List.generate(84, (index) => random.nextInt(5));

    return Scaffold(
      backgroundColor: Colors.transparent, // main.dart의 전체 배경 사용
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📊 헤더 타이틀 섹션
            const Text('학습 분석 통계', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6FFF92), letterSpacing: 1.5)),
            const SizedBox(height: 8),
            const Text('나의 코드 흐름 로그', style: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            const Text('현재까지의 학습 궤적을 분석하고, 취약한 취약점을 파악하여 최적의 알고리즘 훈련을 실행하세요.', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFFBCCBB9))),
            const SizedBox(height: 32),

            // 🔥 1. 잔디 매트릭스 패널 (Commitment Matrix)
            _buildCommitmentMatrixPanel(activityLevels),
            const SizedBox(height: 32),

            // 🧩 하단 레이아웃 (데스크톱/모바일 반응형 분기)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildCompilationErrorsSection()),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildDiagnosticSection()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildCompilationErrorsSection(),
                      const SizedBox(height: 32),
                      _buildDiagnosticSection(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🟩 잔디 심기 가로 스크롤 매트릭스 위젯 빌더
  Widget _buildCommitmentMatrixPanel(List<int> levels) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF171F33).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3D4A3D).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: Color(0xFF6FFF92), size: 20),
                  SizedBox(width: 8),
                  Text('학습 잔디 매트릭스', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              // 범례 인디케이터
              _buildGridLegend(),
            ],
          ),
          const SizedBox(height: 20),

          // 🔄 가로 스크롤 지원 잔디밭 (7행 구조 이식)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 150, // 7행 높이 수용 공간
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // 7일(1주일) 단위 행 고정
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 1.0,
                ),
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  return _buildGridCell(levels[index]);
                },
              ),
            ),
          ),
          const Divider(color: Colors.white10, height: 32),
          
          // 하단 요약 정보
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: '현재 연속 학습 스트릭: ',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFFBCCBB9)),
                  children: [
                    TextSpan(text: '14 일째 🔥', style: TextStyle(color: Color(0xFF6FFF92), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text('총 정복한 모듈: 128개', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white70)),
            ],
          )
        ],
      ),
    );
  }

  // 🟥 오답 노트 섹션 빌더 (Compilation Errors)
  Widget _buildCompilationErrorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Color(0xFFFFB690), size: 20),
            SizedBox(width: 8),
            Text('취약 오답 로그 (컴파일 에러 리스트)', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        const SizedBox(height: 16),
        _buildErrorCard('[네트워크 인터페이스]', '2시간 전', 'OSI 7계층 전송 계층 프로토콜 특징', 'TCP와 UDP의 가장 결정적인 상태 연결 제어 메커니즘 차이 구별 실패.', const Color(0xFFFFB690)),
        const SizedBox(height: 12),
        _buildErrorCard('[자료구조]', '어제', '이진 탐색 트리(BST) 노드 삭제 알고리즘', '삭제 대상 노드가 2개의 자식 노드를 가지고 있을 때의 인오더 후속자 교체 예외 처리 오류.', const Color(0xFFFFD700)),
      ],
    );
  }

  // 💡 인공지능 진단 가이드 섹션 빌더 (Diagnostic)
  Widget _buildDiagnosticSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF171F33).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBE2FD).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0x1ADBE2FD), shape: BoxShape.circle),
                child: const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFDBE2FD), size: 20),
              ),
              const SizedBox(width: 12),
              const Text('시스템 정밀 진단', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFDBE2FD))),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '통계 알고리즘 분석 결과, 그래프 탐색 알고리즘(BFS/DFS) 부근에서 42%의 오답 패턴이 감지되었습니다. 다음 세션은 너비 우선 탐색 정복 루틴을 권장합니다.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFFBCCBB9), height: 1.5),
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('알고리즘 효율성 점수', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
              Text('58%', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: Color(0xFFDBE2FD), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          
          // 진행 게이지 바
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.58,
              minHeight: 6,
              backgroundColor: Colors.white10,
              color: Color(0xFFDBE2FD),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDBE2FD).withOpacity(0.1),
              foregroundColor: const Color(0xFFDBE2FD),
              side: const BorderSide(color: Color(0xFFDBE2FD), width: 0.5),
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('집중 훈련 루틴 실행', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 14),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 🟢 잔디 한 칸 개별 박스 정밀 빌더 (컬러 강도 이식)
  Widget _buildGridCell(int level) {
    Color cellColor;
    List<BoxShadow>? shadow;

    switch (level) {
      case 0:
        cellColor = Colors.white10;
        break;
      case 1:
        cellColor = const Color(0xFF6FFF92).withOpacity(0.2);
        break;
      case 2:
        cellColor = const Color(0xFF6FFF92).withOpacity(0.5);
        break;
      case 3:
        cellColor = const Color(0xFF6FFF92).withOpacity(0.8);
        break;
      case 4:
      default:
        cellColor = const Color(0xFF6FFF92);
        shadow = [BoxShadow(color: const Color(0xFF6FFF92).withOpacity(0.4), blurRadius: 6)];
        break;
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(2),
        boxShadow: shadow,
      ),
    );
  }

  // 범례 인디케이터 도우미
  Widget _buildGridLegend() {
    return Row(
      children: [
        const Text('Less ', style: TextStyle(fontSize: 11, color: Colors.grey)),
        _buildLegendBox(Colors.white10),
        _buildLegendBox(const Color(0xFF6FFF92).withOpacity(0.2)),
        _buildLegendBox(const Color(0xFF6FFF92).withOpacity(0.5)),
        _buildLegendBox(const Color(0xFF6FFF92).withOpacity(0.8)),
        _buildLegendBox(const Color(0xFF6FFF92)),
        const Text(' More', style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(1)),
    );
  }

  // 오답 카드 컴포넌트 위젯 빌더
  Widget _buildErrorCard(String tag, String time, String title, String desc, Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171F33).withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tag, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: accentColor)),
              Text(time, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white30)),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFFBCCBB9), height: 1.4)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_rounded, size: 14),
                SizedBox(width: 6),
                Text('해당 문항 재컴파일', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}