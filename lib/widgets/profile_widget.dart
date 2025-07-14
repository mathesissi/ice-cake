import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF963484), size: 30),
      title: Text(text, style: const TextStyle(fontSize: 30)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF963484)),
      onTap: onTap,
    );
  }
}
