class Student {
    final int id;
    final String name;

    const Student({
        required this.id,
        required this.name,
    });

    factory Student.fromMap(Map<String, dynamic> map) {
        return Student(
            id: map['id'] as int,
            name: (map['name'] ?? '') as String,
        );
    }

    Map<String, dynamic> toMap() {
        return {'id': id, 'name': name};
    }
}