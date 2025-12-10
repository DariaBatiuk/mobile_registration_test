import 'package:flutter/material.dart';

class AuthorizedScreen  extends StatelessWidget{
  final String userId;

  const AuthorizedScreen({
    super.key, 
    required this.userId
  });

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authorized'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are authorized', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),),
            const SizedBox(height: 12.0,),
            Text('User ID: $userId', style: const TextStyle(fontSize: 16.0),)
          ],
        ),
      ),
    );
  }
}