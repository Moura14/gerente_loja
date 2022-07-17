import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/field_screen.dart';
import 'package:gerente_loja/screens/home_log.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key key}) : super(key: key);

  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeLog()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Erro"),
                    content: Text("Você não possui os privilégios necessários"),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.LOADING,
          builder: (context, snapshot) {
            print(snapshot.data);
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                ));
              case LoginState.FAIL:
              case LoginState.SUCCESS:
              case LoginState.IDLE:
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(),
                    SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.store_mall_directory,
                            size: 180.0,
                            color: Colors.pinkAccent,
                          ),
                          FieldScreen("Usuário", Icons.person_outline, false,
                              _loginBloc.outEmail, _loginBloc.changeEmail),
                          FieldScreen(
                              "Senha",
                              Icons.lock,
                              true,
                              _loginBloc.outPassword,
                              _loginBloc.changePassword),
                          SizedBox(
                            height: 32.0,
                          ),
                          StreamBuilder<bool>(
                            stream: _loginBloc.outSubmittValid,
                            builder: (context, snapshot) {
                              return SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                      child: Text(
                                        "Entrar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.pinkAccent,
                                      onPressed: snapshot.hasData
                                          ? _loginBloc.submit
                                          : null,
                                      disabledColor:
                                          Colors.pinkAccent.withAlpha(140)));
                            },
                          )
                        ],
                      ),
                    ))
                  ],
                );
            }
          },
        ));
  }
}
