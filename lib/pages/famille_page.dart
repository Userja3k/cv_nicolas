import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../models/membre_famille.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  List<MembreFamille> _membres = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerMembres();
  }

  Future<void> _chargerMembres() async {
    setState(() => _isLoading = true);
    try {
      final list = await DatabaseService.instance.getMembres();
      setState(() {
        _membres = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement : $e')),
        );
      }
    }
  }

  // --- Image provider helper ---
  ImageProvider? _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    }
    final file = File(imagePath);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return null;
  }

  // --- Dialogue Ajout ou Modification ---
  void _ouvrirDialogue({MembreFamille? membre}) {
    final estModif = membre != null;
    final nomController = TextEditingController(text: membre?.nom ?? '');
    final profController = TextEditingController(text: membre?.prof ?? '');
    final lienController = TextEditingController(text: membre?.lien ?? '');
    String? photoPath = membre?.image;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final imageProvider = _getImageProvider(photoPath);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(
                    estModif ? Icons.edit : Icons.person_add,
                    color: AppColors.primaryRed,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    estModif ? 'Modifier le membre' : 'Ajouter un membre',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sélection / Prévisualisation de la photo
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: imageProvider,
                            child: imageProvider == null
                                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () async {
                                final result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'bmp'],
                                );
                                if (result != null && result.files.single.path != null) {
                                  setDialogState(() {
                                    photoPath = result.files.single.path;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryRed,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'bmp'],
                        );
                        if (result != null && result.files.single.path != null) {
                          setDialogState(() {
                            photoPath = result.files.single.path;
                          });
                        }
                      },
                      icon: const Icon(Icons.folder_open, size: 18),
                      label: const Text('Choisir dans l\'explorateur'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nomController,
                      decoration: InputDecoration(
                        labelText: 'Nom du membre *',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: lienController,
                      decoration: InputDecoration(
                        labelText: 'Lien de parenté (ex: Père, Mère...)',
                        prefixIcon: const Icon(Icons.favorite_border),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: profController,
                      decoration: InputDecoration(
                        labelText: 'Travail / Profession *',
                        prefixIcon: const Icon(Icons.work_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final nom = nomController.text.trim();
                    final prof = profController.text.trim();
                    final lien = lienController.text.trim().isEmpty
                        ? 'Famille'
                        : lienController.text.trim();

                    if (nom.isEmpty || prof.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez remplir le nom et le travail'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    if (estModif) {
                      final updated = membre.copyWith(
                        nom: nom,
                        lien: lien,
                        prof: prof,
                        image: photoPath,
                      );
                      await DatabaseService.instance.modifierMembre(updated);
                    } else {
                      final nouveau = MembreFamille(
                        nom: nom,
                        lien: lien,
                        prof: prof,
                        image: photoPath,
                      );
                      await DatabaseService.instance.ajouterMembre(nouveau);
                    }

                    if (dialogCtx.mounted) {
                      Navigator.pop(dialogCtx);
                    }
                    _chargerMembres();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            estModif ? 'Membre modifié avec succès !' : 'Membre ajouté avec succès !',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text(estModif ? 'Enregistrer' : 'Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- Dialogue de confirmation de suppression ---
  void _confirmerSuppression(MembreFamille membre) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer "${membre.nom}" de la famille ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              if (membre.id != null) {
                await DatabaseService.instance.supprimerMembre(membre.id!);
                if (ctx.mounted) Navigator.pop(ctx);
                _chargerMembres();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${membre.nom}" a été supprimé.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Famille'),
        actions: [
          // Bouton plus au coin supérieur droit
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            tooltip: 'Ajouter un membre',
            onPressed: () => _ouvrirDialogue(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            )
          : _membres.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 70, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        'Aucun membre dans la famille.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _ouvrirDialogue(),
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter un membre'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.primaryRed,
                  onRefresh: _chargerMembres,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                    itemCount: _membres.length,
                    itemBuilder: (context, index) {
                      final m = _membres[index];
                      final imgProvider = _getImageProvider(m.image);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // En-tête de la carte avec les trois points au coin supérieur droit
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, right: 10),
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    onSelected: (value) {
                                      if (value == 'modifier') {
                                        _ouvrirDialogue(membre: m);
                                      } else if (value == 'supprimer') {
                                        _confirmerSuppression(m);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'modifier',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, color: Colors.blue, size: 20),
                                            SizedBox(width: 10),
                                            Text('Modifier'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'supprimer',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, color: Colors.red, size: 20),
                                            SizedBox(width: 10),
                                            Text('Supprimer'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Photo de profil
                            CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: imgProvider,
                              child: imgProvider == null
                                  ? const Icon(Icons.person, size: 45, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              m.nom,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              m.lien,
                              style: const TextStyle(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Partie inférieure sombre affichant le travail / profession
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: AppColors.darkBg,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Travail / Profession',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    m.prof,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
