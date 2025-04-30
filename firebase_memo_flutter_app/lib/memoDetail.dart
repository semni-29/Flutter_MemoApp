import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';

class MemoDetailPage extends StatefulWidget {
  final DatabaseReference reference;
  final Memo memo;

  const MemoDetailPage({
    super.key,
    required this.reference,
    required this.memo,
  });

  @override
  State<MemoDetailPage> createState() => _MemoDetailPage();
}

class _MemoDetailPage extends State<MemoDetailPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    // 기존 메모 내용을 불러와 텍스트 필드에 초기값으로 설정
    titleController = TextEditingController(text: widget.memo.title);
    contentController = TextEditingController(text: widget.memo.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        // 화면이 작을 경우 스크롤이 가능하도록 SingleChildScrollView 사용
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // 제목 입력 필드: 입력 내용과 라벨이 겹치지 않도록 OutlineInputBorder 사용
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20), // 제목과 내용 사이 간격 추가

              // 내용 입력 필드: 여러 줄 입력 가능, 높이를 300으로 고정
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4, // 화면 비율로 높이 설정 (40% 크기)
                child: TextField(
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // 줄 수 제한 없음
                  expands: true,   // 부모 위젯 크기에 맞춰 확장
                  decoration: const InputDecoration(
                    labelText: '내용',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true, // 라벨이 입력 상단에 정렬되도록 설정
                  ),
                ),
              ),
              const SizedBox(height: 20), // 버튼과 텍스트 필드 간격

              // 수정 버튼: 메모를 수정하고 이전 화면으로 돌아감
              ElevatedButton(
                onPressed: () {
                  final updatedMemo = Memo(
                    titleController.text,
                    contentController.text,
                    widget.memo.createTime,
                  );

                  // 수정된 내용을 데이터베이스에 저장
                  widget.reference
                      .child(widget.memo.key!)
                      .set(updatedMemo.toJson())
                      .then((_) {
                    // 수정 후 이전 화면으로 돌아감
                    Navigator.of(context).pop(updatedMemo);
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('수정하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';

class MemoDetailPage extends StatefulWidget {
  final DatabaseReference reference;
  final Memo memo;

  const MemoDetailPage({
    super.key,
    required this.reference,
    required this.memo,
  });

  @override
  State<MemoDetailPage> createState() => _MemoDetailPage();
}

class _MemoDetailPage extends State<MemoDetailPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.memo.title);
    contentController = TextEditingController(text: widget.memo.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: '제목',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: '내용',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final updatedMemo = Memo(
                  titleController.text,
                  contentController.text,
                  widget.memo.createTime,
                );

                widget.reference
                    .child(widget.memo.key!)
                    .set(updatedMemo.toJson())
                    .then((_) {
                  Navigator.of(context).pop(updatedMemo);
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('수정하기'),
            ),
          ],
        ),
      ),
    );
  }
}

 */

/*
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';

class MemoDetailPage extends StatefulWidget {
  final DatabaseReference reference;
  final Memo memo;

  const MemoDetailPage({
    super.key,
    required this.reference,
    required this.memo,
  });

  @override
  State<MemoDetailPage> createState() => _MemoDetailPage();
}

class _MemoDetailPage extends State<MemoDetailPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.memo.title);
    contentController = TextEditingController(text: widget.memo.content);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // 스크롤 가능하도록 처리
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 10,
                decoration: InputDecoration(
                  labelText: '내용',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Memo memo = Memo(
                      titleController.text,
                      contentController.text,
                      widget.memo.createTime,
                    );
                    widget.reference
                        .child(widget.memo.key!)
                        .set(memo.toJson())
                        .then((_) => Navigator.of(context).pop(memo));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('수정하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/