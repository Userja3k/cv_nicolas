class MembreFamille {
  final int? id;
  final String nom;
  final String lien;
  final String prof;
  final String? image;

  MembreFamille({
    this.id,
    required this.nom,
    this.lien = 'Famille',
    required this.prof,
    this.image,
  });

  factory MembreFamille.fromMap(Map<String, dynamic> map) {
    return MembreFamille(
      id: map['id'] as int?,
      nom: map['nom'] as String? ?? '',
      lien: map['lien'] as String? ?? 'Famille',
      prof: map['prof'] as String? ?? '',
      image: map['image'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nom': nom,
      'lien': lien,
      'prof': prof,
      'image': image,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  MembreFamille copyWith({
    int? id,
    String? nom,
    String? lien,
    String? prof,
    String? image,
  }) {
    return MembreFamille(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      lien: lien ?? this.lien,
      prof: prof ?? this.prof,
      image: image ?? this.image,
    );
  }
}
