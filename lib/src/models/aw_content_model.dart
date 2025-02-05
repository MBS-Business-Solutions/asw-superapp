class Project {
  final int id;
  final String name;
  final String type;
  final String status;
  final String image;

  Project({required this.id, required this.name, required this.type, required this.status, required this.image});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(id: json['id'], name: json['name'], type: json['type'], status: json['status'], image: json['image']);
  }
}
