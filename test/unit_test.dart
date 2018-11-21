import 'package:flutter_testing/http.dart';
import 'package:http/http.dart' show Response, get;
import 'package:test_api/test_api.dart';

const userResponse = '''
{
        "name": "John",
        "avatar": "http://some.image",
        "repository": "http://some.repo"
}
''';

void main() {
  test('fetching users', () async {
    final get = (String url) => Future.value(Response(userResponse, 200));

    final tested = await Http(get).fetchUser('John');

    expect(tested.name, 'John');
  });

  test('fetching real users', () async {
    final tested = await Http(get).fetchUser('tomaszpolanski');

    expect(tested.name, 'Tomek Polański');
  });
}
