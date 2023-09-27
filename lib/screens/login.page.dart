import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_whm_2/_api/apiService.dart';
import 'package:mobile_whm_2/_api/authService.dart';
import 'package:mobile_whm_2/_api/tokenStorageService.dart';
import 'package:mobile_whm_2/di/service_locator.dart';
import 'package:mobile_whm_2/models/agent.dart';
import 'package:mobile_whm_2/screens/Members/attendanceBisBis.dart';
import 'package:mobile_whm_2/screens/home.page.dart';
import 'package:mobile_whm_2/widgets/error.dialog.dart';
import 'package:mobile_whm_2/widgets/loading.indicator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final authService = locator<AuthService>();
  // final apiService = locator<ApiService>();
  // final storage = locator<TokenStorageService>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool notvisible = true;
  // Agent? agentConnected;
  // bool isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(2, 108, 104, 1),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                child: Center(
                  child: Container(
                    child: Image.asset(
                      'images/logo_vhm_blanc.png',
                    ),
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.only(top: 3, left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un nom utilisateur';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter votre nom utilisateur'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.only(top: 3, left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un mot de passe';
                      }
                      return null;
                    },
                    obscureText: notvisible,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(notvisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                notvisible = !notvisible;
                              });
                            }),
                        border: InputBorder.none,
                        hintText: 'Entrer votre mot de passe'),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  child: Container(
                    height: 50,
                    width: 500,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('Connexion',
                          style: TextStyle(
                              color: Color.fromRGBO(2, 108, 104, 1),
                              fontSize: 25)),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                        // _submitLogin();
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _submitLogin() async {
  //   if (_formKey.currentState!.validate()) {
  //     LoadingIndicatorDialog().show(context);
  //     try {
  //       var statusCode = await authService.authenticateUser(_usernameController.text.trim(),
  //           _passwordController.text.trim());
  //       if (statusCode == 200) {
  //         // agentConnected =
  //         // await apiService.getUserConnected(_usernameController.text.trim());
  //         // log(agentConnected.toString());
  //         // storage.saveAgentConnected(agentConnected!);
  //         // save secteurs in local database
  //         LoadingIndicatorDialog().dismiss();
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (_) => const attendanceBisBis()));
  //       }
  //     } on DioError catch (e) {
  //       LoadingIndicatorDialog().dismiss();
  //       ErrorDialog().show(e);
  //     }
  //   }
//   }
}
