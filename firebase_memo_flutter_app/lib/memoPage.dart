import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';
import 'memoAdd.dart';
import 'memoDetail.dart';

// 메모 페이지 화면을 만들기 위한 클래스예요
class MemoPage extends StatefulWidget {
  final FirebaseAnalytics analytics; // 앱 사용 기록을 남기기 위한 도구
  final FirebaseDatabase database;   // 메모를 저장하고 가져오는 데이터베이스

  const MemoPage({
    super.key,
    required this.analytics,
    required this.database,
  });

  @override
  State<MemoPage> createState() => _MemoPage();
}
//메모가 됩니다!@!@!@
// 실제 메모 페이지의 동작을 구현하는 클래스예요
class _MemoPage extends State<MemoPage> {
  late final DatabaseReference reference; // 메모를 저장하는 장소를 나타내요
  final List<Memo> memos = []; // 화면에 보여줄 메모들을 저장하는 리스트예요

  @override
  void initState() {
    super.initState();

    // Firebase에서 'memo'라는 곳에 저장된 데이터에 연결해요
    reference = widget.database.ref().child('memo');

    // 새로운 메모가 생기면 화면에 보여줘요
    reference.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          memos.add(Memo.fromSnapshot(event.snapshot));
        });
      }
    });

    // 메모가 삭제되면 화면에서도 지워줘요
    reference.onChildRemoved.listen((event) {
      final deletedKey = event.snapshot.key;
      setState(() {
        memos.removeWhere((memo) => memo.key == deletedKey);
      });
    });
  }

  // 메모를 삭제할 때 호출되는 함수예요
  void _deleteMemo(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(memos[index].title), // 삭제할 메모의 제목
          content: const Text('삭제하시겠습니까?'), // 물어보는 메시지
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // 예를 누르면 실제로 데이터베이스에서 메모를 지워요
                reference.child(memos[index].key!).remove().then((_) {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                });
              },
              child: const Text('예'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // 아니오 누르면 닫기만 해요
              child: const Text('아니요'),
            ),
          ],
        );
      },
    );
  }

  // 메모를 눌러서 상세 화면으로 이동할 때 사용하는 함수예요
  void _navigateToDetail(int index) async {
    final updatedMemo = await Navigator.of(context).push<Memo>(
      MaterialPageRoute(
        builder: (context) => MemoDetailPage(
          reference: reference,
          memo: memos[index],
        ),
      ),
    );

    // 수정한 메모가 있으면 화면에 반영해요
    if (updatedMemo != null) {
      setState(() {
        memos[index] = updatedMemo;
      });
    }
  }

  // 화면을 만들기 위한 부분이에요
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메모 앱'), // 앱 상단 제목
      ),
      body: Center(
        child: memos.isEmpty
            ? const CircularProgressIndicator() // 아직 메모가 없으면 로딩 표시
            : GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 한 줄에 두 개씩 보여줘요
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: memos.length, // 메모 개수만큼 보여줘요
          itemBuilder: (context, index) {
            final memo = memos[index];
            return Card(
              elevation: 3,
              child: Column(
                children: [
                  // 메모 제목 보여주는 부분
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      memo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis, // 너무 길면 ...으로 표시
                      maxLines: 1,
                    ),
                  ),
                  // 메모 내용을 보여주는 부분 (누르면 상세로, 길게 누르면 삭제)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => _navigateToDetail(index), // 눌렀을 때
                        onLongPress: () => _deleteMemo(index), // 길게 누르면 삭제
                        child: Text(
                          memo.content,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ),
                  // 메모 작성 날짜 보여주는 부분
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      memo.createTime.substring(0, 10), // 날짜만 잘라서 보여줘요
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      // 플로팅 버튼을 누르면 새로운 메모 추가 화면으로 이동해요
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MemoAddApp(reference),
            ),
          );
        },
        child: const Icon(Icons.add), // + 버튼 아이콘
      ),
    );
  }
}
