class Todo {
  Todo({required this.title}) {
    ok = false;
  }

  String title;
  late bool ok;

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        ok = json['ok'] ?? false;

  Map<String, dynamic> toJson() {
    return {'title': title, 'ok': ok};
  }
}
