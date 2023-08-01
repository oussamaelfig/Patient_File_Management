class User {
  final int id;
  final String nom;
  final String prenom;
  final String date_naissance;
  final String session;

  const User(
      {required this.id,
      required this.nom,
      required this.prenom,
      required this.date_naissance,
      required this.session});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      id: json["id"],
      nom: json["nom"],
      prenom: json["prenom"],
      date_naissance: json["date_naissance"],
      session: json["session"],
    );
  }
}
