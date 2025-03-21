import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_data/sa_data.dart';
import 'package:uuid/uuid.dart';

void main() {
  final fakeFirestore = FakeFirebaseFirestore();
  const uuid = Uuid();

  final teacher1 = STeacherItem(
    id: uuid.v4(),
    name: 'Max Mustermann',
    abbreviation: 'mma',
  );

  final teacher2 = STeacherItem(
    id: uuid.v4(),
    name: 'Erika Mustermann',
    abbreviation: 'mme',
  );

  final teacher3 = STeacherItem(
    id: uuid.v4(),
    name: 'John Doe',
    abbreviation: 'jdo',
  );

  setUpAll(() {
    SFirebasePersistenceRepository.instance.firestore = fakeFirestore;
  });

  test('Save Teachers', () async {
    final saveResult1 = await SPersistenceRepository.instance.saveTeacher(teacher1);

    saveResult1.fold(
      (l) => fail('Error saving teacher1: ${l.message}'),
      (r) => null,
    );

    final saveResult2 = await SPersistenceRepository.instance.saveTeacher(teacher2);

    saveResult2.fold(
      (l) => fail('Error saving teacher2: ${l.message}'),
      (r) => null,
    );

    final saveResult3 = await SPersistenceRepository.instance.saveTeacher(teacher3);

    saveResult3.fold(
      (l) => fail('Error saving teacher2: ${l.message}'),
      (r) => null,
    );

    final loadResult = await SPersistenceRepository.instance.loadTeachers();

    loadResult.fold(
      (l) => fail('Error loading teachers: ${l.message}'),
      (r) => expect(r, containsAll([teacher1, teacher2, teacher3])),
    );
  });

  test('Delete Teachers', () async {
    final deleteResult1 = await SPersistenceRepository.instance.deleteTeacher(teacher1);

    deleteResult1.fold(
      (l) => fail('Error deleting teacher1: ${l.message}'),
      (r) => null,
    );

    final deleteResult2 = await SPersistenceRepository.instance.deleteTeacher(teacher2);

    deleteResult2.fold(
      (l) => fail('Error deleting teacher2: ${l.message}'),
      (r) => null,
    );

    final loadResult = await SPersistenceRepository.instance.loadTeachers();

    loadResult.fold(
      (l) => fail('Error loading teachers: ${l.message}'),
      (r) => expect(r, containsAll([teacher3])),
    );
  });
}
