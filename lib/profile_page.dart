import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_file_management/user.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Text('Nom: ${user.nom}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Prénom: ${user.prenom}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Date de naissance: ${user.date_naissance}',
                style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
