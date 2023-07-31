import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:patient_file_management/profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FormBuilder(
          key: _fbKey,
          child: ListView(
            children: <Widget>[
              // Replace with your own image
              SizedBox(height: 20),
              FormBuilderTextField(
                name: 'insuranceNumber',
                decoration: InputDecoration(
                  labelText: 'Numero d\'assurance maladie',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer votre Numero d\'assurance maladie';
                  }
                  RegExp regExp = RegExp(r'^[a-zA-Z]{4}[0-9]{8}$');
                  if (!regExp.hasMatch(value)) {
                    return 'Enter un numero d\'assurance maladie valide. \nIl doit etre compose de 4 lettres suivis de 8 chiffres';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              FormBuilderTextField(
                name: 'code',
                decoration: InputDecoration(
                  labelText: 'Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer votre code numerique';
                  }
                  return null;
                },
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Entrer'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    print(await validerInformationsBD(_fbKey.currentState!.value['insuranceNumber'],_fbKey.currentState!.value['code']));
            
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          insuranceNumber:
                              _fbKey.currentState!.value['insuranceNumber'],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<User> validerInformationsBD(String num_ass_medic, int code) async{
    final response = await http.post(
    Uri.parse('http://localhost:5000/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'num_assurance_maladie': num_ass_medic,
      'code': code,
    }),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Le numéro d\'assurance maladie/code invalide(s).');
  }
  }
}

class User{
  final int id;
  final String nom;
  final String prenom;
  final String date_naissance;
  final String session;

  const User({required this.id, required this.nom, required this.prenom, required this.date_naissance, required this.session});

  factory User.fromJson(Map<String, dynamic> json){
    return new User(
      id: json["id"],
      nom: json["nom"],
      prenom: json["prenom"],
      date_naissance: json["date_naissance"],
      session: json["session"],
    );
  }

}