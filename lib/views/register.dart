import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_app/services/database.dart';
import 'package:first_app/widgets/widgets.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();


  Future <void> _register() async{
   if (_passwordController.text == _repeatPasswordController.text) {
     try {
       await FirebaseAuth.instance.createUserWithEmailAndPassword(
         email: _emailController.text,
         password: _passwordController.text,
       );
       Widgets.showCustomDialog(
         context,
         title:"Sucesso",
         content: "Registo efetuado com sucesso!"
       );

       _emailController.clear();
       _passwordController.clear();
       _repeatPasswordController.clear();

     } on FirebaseAuthException catch (e) {
       Widgets.showCustomDialog(
         context,
         title: "Erro de autenticação",
         content: e.message ?? "Ocorreu um erro durante o registo"
       );
     }
   } else {
     Widgets.showCustomDialog(
       context,
       title: "Erro",
       content: "As passwords não coincidem!"
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
              const SizedBox(height:16),
              TextFormField(
                controller: _repeatPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Repetir Password',
                ),
              ),

              ElevatedButton(
                onPressed: _register,
                child: const Text('Sign up'),
              ),
              ElevatedButton(
                onPressed: (){Navigator.pop(context);},
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}