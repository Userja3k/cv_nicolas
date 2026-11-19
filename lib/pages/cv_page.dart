import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          children: [
            // --- EN-TÊTE ---
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: const AssetImage('assets/images/profil.jpg'),
                // Remplacer par une icône si pas de photo
                onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 60),
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text('NICOLAS IRAGI', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const Center(
              child: Text('Photographe & Développeur', style: TextStyle(fontSize: 16, color: AppColors.textGrey)),
            ),
            const SizedBox(height: 20),

            // --- PROFIL ---
            _buildSectionTitle('PROFIL'),
            _buildSectionCard(
              child: const Text(
                "Photographe artistique à Goma, je façonne des images sensibles qui révèlent l'émotion, la lumière et la singularité de chaque instant. Attentif aux détails et aux ambiances, je conçois des séries visuelles cohérentes, de la recherche créative à la retouche finale.",
                style: TextStyle(height: 1.5),
              ),
            ),

            // --- COMPÉTENCES ---
            _buildSectionTitle('COMPÉTENCES'),
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkillBar('Photographie artistique', 0.95),
                  _buildSkillBar('Direction artistique', 0.85),
                  _buildSkillBar('Retouche photo', 0.90),
                  _buildSkillBar('Développeur full stack', 0.75),
                ],
              ),
            ),

            // --- FORMATION ---
            _buildSectionTitle('FORMATION'),
            _buildSectionCard(
              child: Column(
                children: [
                  _buildTimelineItem('Programmation mobile', 'Leokongo, Goma', 'déc. 2025 - juil. 2026'),
                  _buildTimelineItem('Formation en photographie', 'Full LEVEL production, Goma', 'juin 2019 - juil. 2020'),
                  _buildTimelineItem('Formation en leadership', 'Un jour nouveau, Goma', 'sept. 2014 - sept. 2018'),
                ],
              ),
            ),

            // --- EXPÉRIENCE ---
            _buildSectionTitle('EXPÉRIENCE'),
            _buildSectionCard(
              child: Column(
                children: [
                  _buildTimelineItem('Photographe & Directeur Général', 'FULL LEVEL production, Goma', 'juil. 2020 - ce jour'),
                  _buildTimelineItem('Directeur communication & développeur', 'Leokongo society, Goma', 'janv. 2024 - juil. 2025'),
                ],
              ),
            ),

            // --- LANGUES & INTÉRÊTS ---
            _buildSectionTitle('LANGUES'),
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkillBar('Français', 1.0),
                  _buildSkillBar('Anglais', 0.7),
                  _buildSkillBar('Swahili', 1.0),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            _buildSectionTitle('CENTRES D\'INTÉRÊT'),
            _buildSectionCard(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChip('Portrait artistique'),
                  _buildChip('Programmation'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14, 
          fontWeight: FontWeight.bold, 
          color: AppColors.primaryRed,
          letterSpacing: 1.2
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSkillBar(String name, double level) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: level,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
              Text(date, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
            ],
          ),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.primaryRed, fontSize: 13)),
    );
  }
}