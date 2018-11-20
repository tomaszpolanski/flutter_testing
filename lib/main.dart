import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_testing/equality.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: ProfilePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetch(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(snapshot.data.avatar),
                ),
                title: Text(snapshot.data.name),
              ),
              body: Row());
        }
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future<User> fetch() async {
    final result =
        await http.get('https://api.github.com/users/tomaszpolanski');

    final user = User.fromJson(json.decode(result.body));

    final List<dynamic> rep =
        json.decode((await http.get(user.repository)).body);
    print(user.repository);

    final reppp = rep.map((it) => Repository.fromJson(it)).toList();

    print(reppp);

    return user;
  }

  Future<List<Repository>> fetchRepo(String url) async {
    final List<dynamic> rep = json.decode((await http.get(url)).body);
    return rep.map((it) => Repository.fromJson(it)).toList(growable: false);
  }
}

class User extends Equatable {
  const User({
    @required this.name,
    @required this.avatar,
    @required this.repository,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      avatar: json['avatar_url'],
      repository: json['repos_url'],
    );
  }

  final String name;
  final String avatar;
  final String repository;

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'avatar': avatar,
        'repository': repository,
      };
}

class Repository extends Equatable {
  const Repository({
    @required this.name,
    @required this.description,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    print(json.keys.toList());
    return Repository(
      name: json['name'],
      description: json['avatar_url'],
    );
  }

  final String name;
  final String description;

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };
}
