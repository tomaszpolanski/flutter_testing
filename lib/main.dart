import 'package:flutter/material.dart';
import 'package:flutter_testing/http.dart';
import 'package:http/http.dart' show get;

void main() => runApp(TestApp());

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lighting Tests',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: ProfilePage(
        Http(get),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage(this.http, {Key key}) : super(key: key);

  final Http http;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: http.fetchUser('tomaszpolanski'),
      builder: (_, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text(snapshot.data.name)),
            body: FutureBuilder(
              future: http.fetchRepo(snapshot.data.repository),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Repository>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.separated(
                    itemCount: snapshot.data.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (_, int index) {
                      final repository = snapshot.data[index];
                      return ListTile(
                        title: Text(repository.name),
                        subtitle: repository.description != null
                            ? Text(repository.description)
                            : null,
                      );
                    },
                  );
                } else {
                  return _Loading();
                }
              },
            ),
          );
        }
        return _Loading();
      },
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
