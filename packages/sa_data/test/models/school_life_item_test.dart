import 'package:flutter_test/flutter_test.dart';
import 'package:sa_data/sa_data.dart';

void main() {
  final postJson = {
    'id': 'abc',
    'type': 'post',
    'datetime': DateTime(2000).toIso8601String(),
    'headline': 'Article Headline',
    'content': 'Article Content',
    'imageUrl': 'https://example.com/image.png',
    'hyperlink': 'https://example.com',
    'article': null,
  };

  final referencePost = SSchoolLifeItem.post(
    id: 'abc',
    datetime: DateTime(2000),
    headline: 'Article Headline',
    content: 'Article Content',
    imageUrl: 'https://example.com/image.png',
    hyperlink: 'https://example.com',
    darkHeadline: true,
    article: null,
  );

  final eventJson = {
    'id': 'abc',
    'type': 'event',
    'datetime': DateTime(2000).toIso8601String(),
    'headline': 'Event Header',
    'content': 'Event Content',
    'eventTime': DateTime(2000).toIso8601String(),
    'hyperlink': 'https://example.com',
    'article': null,
  };

  final referenceEvent = SSchoolLifeItem.event(
    id: 'abc',
    datetime: DateTime(2000),
    headline: 'Event Headline',
    content: 'Event Content',
    eventDate: DateTime(2000),
    hyperlink: 'https://example.com',
    article: null,
  );

  final announcementJson = {
    'id': 'abc',
    'type': 'announcement',
    'datetime': DateTime(2000).toIso8601String(),
    'headline': 'Announcement Headline',
    'content': 'Announcement Content',
    'hyperlink': 'https://example.com',
    'article': null,
  };

  final referenceAnnouncement = SSchoolLifeItem.announcement(
    id: 'abc',
    datetime: DateTime(2000),
    headline: 'Announcement Headline',
    content: 'Announcement Content',
    hyperlink: 'https://example.com',
    article: null,
  );

  test('Post Serialization and Deserialization', () {
    final parsedPost = SSchoolLifeItem.fromJson(postJson);

    expect(parsedPost, referencePost);
    expect(parsedPost.toJson(), postJson);
    expect(parsedPost.toJson(), referencePost.toJson());
    expect(referencePost.toJson(), postJson);
  });

  test('Event Serialization and Deserialization', () {
    final parsedEvent = SSchoolLifeItem.fromJson(eventJson);

    expect(parsedEvent, referenceEvent);
    expect(parsedEvent.toJson(), eventJson);
    expect(parsedEvent.toJson(), referenceEvent.toJson());
    expect(referenceEvent.toJson(), eventJson);
  });

  test('Announcement Serialization and Deserialization', () {
    final parsedAnnouncement = SSchoolLifeItem.fromJson(announcementJson);

    expect(parsedAnnouncement, referenceAnnouncement);
    expect(parsedAnnouncement.toJson(), announcementJson);
    expect(parsedAnnouncement.toJson(), referenceAnnouncement.toJson());
    expect(referenceAnnouncement.toJson(), announcementJson);
  });
}
