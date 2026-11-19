import 'package:flutter/material.dart';
import '../widgets/floating_nav_bar.dart';
import 'cv_page.dart';
import 'famille_page.dart';
import 'contact_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _pages = const [CvPage(), FamillePage(), ContactPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Permet au corps de passer sous la navbar
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}