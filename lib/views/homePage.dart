import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_app/views/register.dart';
import 'package:first_app/widgets/widgets.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  void _gotoRegistrationPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage()));
  }

  Future<void> _login() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Widgets.showCustomDialog(
        context,
        title: "Sucesso",
          content:"Login efetuado com sucesso!"
      );

      _emailController.clear();
      _passwordController.clear();

    }on FirebaseAuthException catch (e) {
      Widgets.showCustomDialog(
        context,
        title: "Erro de login",
        content: e.message ?? "Erro de login"
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              Image.asset('assets/images/sono-logo.png', height:120),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height:16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: _gotoRegistrationPage,
                child: const Text('Registo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}