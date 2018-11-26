import 'dart:convert';

import 'package:flutter_testing/equality.dart';
import 'package:http/http.dart' show Response;
import 'package:meta/meta.dart';

class Http {
  const Http(this._get);

  final Future<Response> Function(String url) _get;

  Future<User> fetchUser(String user) async {
    final result = await _get('https://api.github.com/users/$user');
    return User.fromJson(json.decode(result.body));
  }

  Future<List<Repository>> fetchRepo(String url) async {
    final List<dynamic> rep = json.decode((await _get(url)).body);
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
    this.description,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      description: json['description'],
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
