import 'dart:async';

import 'package:meta/meta.dart';

import 'firestore_path.dart';
import 'firestore_service.dart';

import '../models/conversation.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid})
      : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> addOrUpdateConversation(Conversation conversation) =>
      _service.setData(
        path: FirestorePath.conversation(uid, conversation.sender.number),
        data: conversation.toMap(),
      );

  Future<void> readConversation(Conversation conversation) => _service.documentAction(
    path: FirestorePath.conversation(uid, conversation.sender.number),
    changes: {'isRead': conversation.isRead},
  );

  Future<void> readGroup(Conversation conversation) => _service.documentAction(
    path: FirestorePath.group(uid, conversation.groupID),
    changes: {'isRead': conversation.isRead},
  );

  Future<void> addMessages(Conversation conversation) => _service.documentAction(
    path: FirestorePath.conversation(uid, conversation.sender.number),
    changes: {'messages': conversation.serializeMessages()},
  );

  void archiveSelectedConversations(List<Conversation> _archivedConvos) =>
      _archivedConvos.forEach(addOrUpdateConversation);

  Future<void> spamSelectedConversation(Conversation _spammedConvo) =>
      _service.documentAction(
        path: FirestorePath.conversation(uid, _spammedConvo.sender.number),
        changes: {'isSpam': _spammedConvo.isSpam},
      );

  Future<void> markAllConversationsRead() => _service.batchActon(
        path: FirestorePath.conversations(uid),
        changes: {'isRead': true},
        queryBuilder: (query) => query
            .where('isSpam', isEqualTo: false)
            .where('isArchived', isEqualTo: false),
      );

  Future<void> deleteConversation(Conversation conversation) =>
      _service.deleteData(
        path: FirestorePath.conversation(uid, conversation.sender.number),
      );

  Future<void> addOrUpdateGroup(Conversation conversation) => _service.setData(
        path: FirestorePath.group(uid, conversation.groupID),
        data: conversation.toMap(),
      );

  Future<void> deleteGroup(Conversation conversation) => _service.deleteData(
        path: FirestorePath.group(uid, conversation.groupID),
      );

  Stream<Conversation> conversationStream({@required String number}) =>
      _service.documentStream(
        path: FirestorePath.conversation(uid, number),
        builder: (data, documentId) => Conversation.fromMap(data),
      );

  Stream<Conversation> groupStream({@required String groupID}) =>
      _service.documentStream(
        path: FirestorePath.group(uid, groupID),
        builder: (data, documentId) => Conversation.fromMap(data),
      );

  /// This method fetches all conversations including spammed and archived
  /// in one list.
  ///
  /// Stream<List<Conversation>> allConversationsStream() =>
  ///     _service.collectionStream(
  ///       path: FirestorePath.conversations(uid),
  ///       builder: (data, _) => Conversation.fromMap(data),
  ///     );

  Stream<List<Conversation>> normalStream() =>
      _service.collectionStream<Conversation>(
        path: FirestorePath.conversations(uid),
        queryBuilder: (query) => query
            .where('isSpam', isEqualTo: false)
            .where('isArchived', isEqualTo: false),
        builder: (data, _) => Conversation.fromMap(data),
        sort: (lhs, rhs) => rhs.sender.name.compareTo(lhs.sender.name),
      );

  Stream<List<Conversation>> spammedStream() =>
      _service.collectionStream<Conversation>(
        path: FirestorePath.conversations(uid),
        queryBuilder: (query) => query.where('isSpam', isEqualTo: true),
        builder: (data, _) => Conversation.fromMap(data),
        sort: (lhs, rhs) => rhs.sender.name.compareTo(lhs.sender.name),
      );

  Stream<List<Conversation>> archivedStream({Conversation conversation}) =>
      _service.collectionStream<Conversation>(
        path: FirestorePath.conversations(uid),
        queryBuilder: (query) => query.where('isArchived', isEqualTo: true),
        builder: (data, _) => Conversation.fromMap(data),
        sort: (lhs, rhs) => rhs.sender.name.compareTo(lhs.sender.name),
      );

  Stream<List<Conversation>> groupsStream({Conversation conversation}) =>
      _service.collectionStream<Conversation>(
        path: FirestorePath.groups(uid),
        queryBuilder: (query) => query.where('isGroup', isEqualTo: true),
        builder: (data, _) => Conversation.fromMap(data),
        sort: (lhs, rhs) => rhs.groupName.compareTo(lhs.groupName),
      );
}
