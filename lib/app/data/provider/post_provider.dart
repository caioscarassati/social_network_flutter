import 'package:faker/faker.dart';
import 'package:social_network/app/data/models/post_model.dart';
import 'package:uuid/uuid.dart';

class PostProvider {
  final Faker _faker = Faker();
  final Uuid _uuid = const Uuid();

  // Simula a busca de uma lista de posts de uma API
  Future<List<PostModel>> getPosts() async {
    // Simula um atraso de rede
    await Future.delayed(const Duration(milliseconds: 800));

    // Gera uma lista de 15 posts falsos
    return List.generate(15, (index) {
      return PostModel(
        id: _uuid.v4(),
        authorName: _faker.person.name(),
        // Usaremos um serviço de imagens aleatórias para os avatares e posts
        authorAvatarUrl: 'https://i.pravatar.cc/150?u=${_faker.internet.userName()}',
        text: _faker.lorem.sentences(3).join(' '),
        imageUrl: 'https://picsum.photos/seed/${_faker.randomGenerator.integer(999)}/600/400',
        createdAt: _faker.date.dateTime(minYear: 2023, maxYear: 2024),
      );
    });
  }
}
