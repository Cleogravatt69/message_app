import 'package:flutter/material.dart';

import '../../enums/filters_enum.dart';

class ArchivedMessagesScreen extends StatelessWidget {
  static const routeName="ArchivedMessagesScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          splashRadius: 21,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
        iconTheme: IconThemeData(color: Colors.grey[800]),
        title: Text(
          "Archived",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)
            ),
            onSelected: (Filters filter) => filter.actionOnFilter(context),
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey[600],
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Help & feedback"),
                value: Filters.HelpAndFeedback,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
