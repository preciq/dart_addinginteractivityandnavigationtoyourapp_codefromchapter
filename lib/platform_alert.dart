import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlert {
  final String title;
  final String message;
  //the alert title and message that will be displayed when the alert appears
  //set in the constructor

  const PlatformAlert({required this.title, required this.message});

  void show(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      _buildCupertinoAlert(context);
      //executes if this is run on an iPhone
    } else {
      _buildMaterialAlert(context);
      //executes on all other platforms
    }
  }

  void _buildMaterialAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                    child: const Text('Close'),
                    onPressed: () => Navigator.of(context).pop())
              ]);
        });
  }
  //creates a material style alert dialog

  void _buildCupertinoAlert(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoButton(
                    child: const Text('Close'),
                    onPressed: () => Navigator.of(context).pop())
              ]);
        });
  }
  //creates a cupertino (apple) style alert dialog

}
