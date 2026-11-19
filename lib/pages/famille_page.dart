import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

  final List<Map<String, String>> membres = const [
    {
      'nom': 'Donatien BADESIRE',
      'lien': 'Père',
      'prof': "Agent de l'État",
      'image': 'assets/images/pere.jpg',
    },
    {
      'nom': 'Pascaline NZIGIRE',
      'lien': 'Mère',
      'prof': 'Commerçante',
      'image': 'assets/images/mere.jpg',
    },
    {
      'nom': 'Nicole Ansima',
      'lien': 'Soeur',
      'prof': 'Élève finaliste',
      'image': 'assets/images/soeur.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ma Famille')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
        itemCount: membres.length,
        itemBuilder: (context, index) {
          final m = membres[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(m['image']!),
                ),
                const SizedBox(height: 10),
                Text(m['nom']!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(m['lien']!,
                    style: const TextStyle(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 20),
                // Partie grise basée sur l'image 3
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
                      const Text('Profession',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(m['prof']!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
