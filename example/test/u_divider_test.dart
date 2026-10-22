import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uview_flutter/uview_flutter.dart';

void main() {
  testWidgets('UDivider renders without assertion (no text, dashed, with text)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      UView(
        theme: UViewThemeData(),
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                UDivider(),
                UDivider(text: '中间文字'),
                UDivider(text: '居左', textAlign: MainAxisAlignment.start),
                UDivider(text: '居右', textAlign: MainAxisAlignment.end),
                UDivider(dashed: true),
                UDivider(text: '虚线带字', dashed: true),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull,
        reason: 'UDivider must not throw a ParentDataWidget assertion');
    expect(find.byType(UDivider), findsNWidgets(6));
  });
}
