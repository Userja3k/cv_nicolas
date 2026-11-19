import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  final String email = 'nicolas.iragi@gmail.com';
  final String adresse = 'Kyeshero 2 - Goma';
  final String telephone = '+243 899 966 453'; // Fictif, à compléter

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Impossible d\'ouvrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        children: [
          _buildContactCard(
            icon: Icons.email,
            title: 'Email',
            subtitle: email,
            color: Colors.blue,
            onTap: () => _launchUrl('mailto:$email'),
          ),
          _buildContactCard(
            icon: Icons.location_on,
            title: 'Adresse',
            subtitle: adresse,
            color: AppColors.primaryRed,
            onTap: () => _launchUrl('https://maps.google.com/?q=$adresse'),
          ),
          _buildContactCard(
            icon: Icons.phone,
            title: 'Téléphone',
            subtitle: telephone,
            color: Colors.green,
            onTap: () => _launchUrl('tel:$telephone'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textGrey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}