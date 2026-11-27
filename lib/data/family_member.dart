class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  String get fullName => '$nom $postnom $prenom'.trim();

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! int && id is! String) {
      throw const FormatException('Identifiant de membre invalide.');
    }

    String requiredString(String key) {
      final value = json[key];
      if (value is! String) {
        throw FormatException('Champ "$key" manquant dans la réponse API.');
      }
      return value;
    }

    final imageUrl = json['image_url'];
    return FamilyMember(
      id: int.parse(id.toString()),
      nom: requiredString('nom'),
      postnom: requiredString('postnom'),
      prenom: requiredString('prenom'),
      lieuNaissance: requiredString('lieu_naissance'),
      dateNaissance: requiredString('date_naissance'),
      parente: requiredString('parente'),
      imageUrl: imageUrl is String ? imageUrl : null,
    );
  }

  Map<String, String> toJson() => {
    'nom': nom,
    'postnom': postnom,
    'prenom': prenom,
    'lieu_naissance': lieuNaissance,
    'date_naissance': dateNaissance,
    'parente': parente,
  };
}
