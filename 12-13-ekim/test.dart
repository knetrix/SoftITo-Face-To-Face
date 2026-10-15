abstract class Identifiable {
  String get id;
}

class User implements Identifiable {
  @override
  final String id;

  final String name;

  User({
    required this.id,
    required this.name,
  });
}

class GenericCache<T extends Identifiable> {
  final Map<String, T> _storage = {};

  void save(T item) {
    // item'ın id Özelliği Olduğu Kesin Oldığı için Kullanılabilir.
    _storage[item.id] = item;
  }

  T? getById(String id) {
    // id varsa Nesneyi, Yoksa null Döndürür.
    return _storage[id];
  }
}

void main() {
  final userCache = GenericCache<User>();

  final user = User(
    id: 'user-1',
    name: 'Mustafa',
  );

  userCache.save(user);

  final foundUser = userCache.getById('user-1');

  print(foundUser?.name); // Mustafa
}
