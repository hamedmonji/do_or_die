import 'package:do_or_die/data/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('save app data', () async {
    final data = AppData([
      BoardData(
        'Weekly topics',
        [
          PathData('week one',
              tasks: [Task('git intro'), Task('git branches')]),
          PathData.inProgress(),
          PathData.done()
        ],
      )
    ]);

    final dataJson = await data.json();
    print(dataJson);
    assert(dataJson.isNotEmpty);
  });
}
