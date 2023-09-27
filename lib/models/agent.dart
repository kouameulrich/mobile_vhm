class Agent {
  String? nomUtilisateur;
  String? nom;
  String? prenom;
  String? telephone;
  String? email;

  @override
  String toString() {
    return 'Agent{nomUtilisateur: $nomUtilisateur, nom: $nom, prenom: $prenom, telephone: $telephone, email: $email}';
  }

  Agent(
      {
      this.nomUtilisateur,
      this.nom,
      this.prenom,
      this.telephone,
      this.email});

  Agent.fromJson(Map<String, dynamic> json) {
    nomUtilisateur = json['nomUtilisateur'];
    nom = json['nom'];
    prenom = json['prenom'];
    telephone = json['telephone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomUtilisateur'] = nomUtilisateur;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['telephone'] = telephone;
    data['email'] = email;
    return data;
  }
}
