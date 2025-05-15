import 'package:flutter/material.dart';

class LogoGenerator extends StatelessWidget {
  final double size;
  
  const LogoGenerator({Key? key, this.size = 100}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Salva questo widget come immagine
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}