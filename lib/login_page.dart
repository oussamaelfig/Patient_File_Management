import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:patient_file_management/profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:patient_file_management/user.dart';

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
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Entrer'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    try {
                      User user = await validerInformationsBD(
                          _fbKey.currentState!.value['insuranceNumber'],
                          _fbKey.currentState!
                              .value['code']); //pass code as String
                      print(user);

                      // Ici, on passe à la ProfilePage et on lui donne l'objet 'user'
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(user: user),
                        ),
                      );
                    } catch (e) {
                      print('Echec de validation du user: $e');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<User> validerInformationsBD(String num_ass_medic, String code) async {
    // Convertir 'code' en integer
    int codeAsInt;
    try {
      codeAsInt = int.parse(code);
    } catch (e) {
      print('Erreur lors de la conversion du code en nombre: $e');
      throw Exception('Le code doit être un nombre.');
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Envoyer 'code' en tant que integer
      body: jsonEncode(<String, dynamic>{
        'num_assurance_maladie': num_ass_medic,
        'code': codeAsInt,
      }),
    );

    print("Statut de réponse: ${response.statusCode}"); // Ajout de debug
    print("Corps de réponse: ${response.body}"); // Ajout de debug

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Le numéro d\'assurance maladie/code invalide(s).');
    }
  }
}
