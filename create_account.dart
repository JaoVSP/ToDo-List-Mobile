import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  State<CreateAccountPage> createState() => _CreateAccountePage();
}

class _CreateAccountePage extends State<CreateAccountPage> {
  String email = "";
  String senha = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "To-Do List",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 50.0),

              TextField(
                onChanged: (text) {
                  email = text;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1.75,
                    ),
                  ),

                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black45),
                ),
              ),

              SizedBox(height: 12),

              TextField(
                onChanged: (text) {
                  senha = text;
                },
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,

                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1.75,
                    ),
                  ),
                  labelText: "Senha",
                  labelStyle: TextStyle(color: Colors.black45),
                ),
              ),
              SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  if (email.isNotEmpty && senha.length >= 6) {
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Create account error"),
                          content: Text(
                            "A senha deve ter no mínimo 6 caracteres e o campo de email deve ser preenchido.",
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Fechar",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  "Cadastrar",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
