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

  const globalSettings = SGlobalSettings(
    id: 'globalSettings',
    githubUrl: 'https://www.example.com/project',
    exclusionOptions: [
      SExclusionOption(
        id: '5',
        name: '5. Klasse',
        regex: '5',
      ),
      SExclusionOption(
        id: '6',
        name: '6. Klasse',
        regex: '6',
      ),
      SExclusionOption(
        id: '7',
        name: '7. Klasse',
        regex: '7',
      ),
      SExclusionOption(
        id: '8',
        name: '8. Klasse',
        regex: '8',
      ),
      SExclusionOption(
        id: '9',
        name: '9. Klasse',
        regex: '9',
      ),
      SExclusionOption(
        id: '10',
        name: '10. Klasse',
        regex: '10',
      ),
      SExclusionOption(
        id: '11',
        name: '11. Klasse',
        regex: '11',
      ),
      SExclusionOption(
        id: '12',
        name: '12. Klasse',
        regex: '12',
      ),
      SExclusionOption(
        id: '13',
        name: '13. Klasse',
        regex: '13',
      ),
    ],
  );

  setUpAll(() {
    SFirebasePersistenceRepository.instance.firestore = fakeFirestore;
  });

  test('Save Teachers', () async {
    final saveResult1 = await SPersistenceRepository.instance.saveTeacher(teacher1);

    saveResult1.fold(
      (l) => fail('Error saving teacher1: ${l.description}'),
      (r) => null,
    );

    final saveResult2 = await SPersistenceRepository.instance.saveTeacher(teacher2);

    saveResult2.fold(
      (l) => fail('Error saving teacher2: ${l.description}'),
      (r) => null,
    );

    final saveResult3 = await SPersistenceRepository.instance.saveTeacher(teacher3);

    saveResult3.fold(
      (l) => fail('Error saving teacher2: ${l.description}'),
      (r) => null,
    );

    final loadResult = await SPersistenceRepository.instance.loadTeachers();

    loadResult.fold(
      (l) => fail('Error loading teachers: ${l.description}'),
      (r) => expect(r, containsAll([teacher1, teacher2, teacher3])),
    );
  });

  test('Delete Teachers', () async {
    final deleteResult1 = await SPersistenceRepository.instance.deleteTeacher(teacher1);

    deleteResult1.fold(
      (l) => fail('Error deleting teacher1: ${l.description}'),
      (r) => null,
    );

    final deleteResult2 = await SPersistenceRepository.instance.deleteTeacher(teacher2);

    deleteResult2.fold(
      (l) => fail('Error deleting teacher2: ${l.description}'),
      (r) => null,
    );

    final loadResult = await SPersistenceRepository.instance.loadTeachers();

    loadResult.fold(
      (l) => fail('Error loading teachers: ${l.description}'),
      (r) => expect(r, containsAll([teacher3])),
    );
  });

  test('Save Global Settings', () async {
    final saveResult = await SPersistenceRepository.instance.saveGlobalSettings(globalSettings);

    saveResult.fold(
      (l) => fail('Error saving global settings: ${l.description}'),
      (r) => null,
    );

    final loadResult = await SPersistenceRepository.instance.loadGlobalSettings();

    loadResult.fold(
      (l) => fail('Error loading global settings: ${l.description}'),
      (r) => expect(r, globalSettings),
    );
  });
}
