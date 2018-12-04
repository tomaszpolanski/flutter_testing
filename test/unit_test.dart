import 'package:flutter_testing/http.dart';
import 'package:http/http.dart' show Response, get;
import 'package:test_api/test_api.dart';

const userResponse = '''
{
  "name": "John",
  "avatar_url": "http://some.image",
  "repos_url": "http://some.repo"
}
''';

void main() {
  group('Http client', () {
    test('fetches users', () async {
      final get = (String url) => Future.value(Response(userResponse, 200));

      final User tested = await Http(get).fetchUser('John');

      expect(tested.name, 'John');
    });

    test('fetches real users', () async {
      final User tested = await Http(get).fetchUser('tomaszpolanski');

      expect(tested.name, 'Tomek Polański');
    });
  });

  group('BONUS: parameterized tests', () {
    const gdprCompliantParameters = const <String, String>{
      'bob': 'Vadim K',
      'john': 'John M',
      'tom': 'Tom M',
      'tomaszpolanski': 'Tomek Polański',
    };

    gdprCompliantParameters.forEach((user, name) {
      test('fetches $user users', () async {
        final User tested = await Http(get).fetchUser(user);

        expect(tested.name, startsWith(name));
      });
    });
  });
}
