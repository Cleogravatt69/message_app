import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:message_app/helper/utils.dart';
import 'package:provider/provider.dart';

import 'package:message_app/providers/messages_provider.dart';

enum ConversationActions { DELETE, DETAILS, ARCHIVE, HELP }

extension ConversationActionExtension on ConversationActions {
  String get name => describeEnum(this);

  void actionOnConversation(BuildContext context, convo) {
    switch (this) {
      case ConversationActions.DELETE:
        {
          final msgManger = context.read<MessageManager>();
          msgManger.deleteConversation(convo);
          Navigator.of(context).pop();
          Future.delayed(Duration(milliseconds: 300)).then(
            (value) => Utils.showFlushBar(
              context,
              "Conversation with ${convo.sender.name} deleted",
              Icons.delete,
            ),
          );
          return;
        }
      case ConversationActions.ARCHIVE:
        {
          final msgManger = context.read<MessageManager>();
          msgManger.toggleArchiveConvo(convo);
          Navigator.of(context).pop();
          Future.delayed(Duration(milliseconds: 300)).then(
                (value) => Utils.showFlushBar(
              context,
              "Conversation with ${convo.sender.name} archived",
              Icons.delete,
            ),
          );
          return;
        }
      case ConversationActions.HELP:
        {
          //go to help page
          return;
        }
      case ConversationActions.DETAILS:
        {
          //pass convo to details page
          return;
        }
    }
  }
}
