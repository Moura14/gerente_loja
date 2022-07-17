import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';
import 'package:gerente_loja/widgets/user_tile.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class UsersTab extends StatelessWidget {
  //const UsersTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _usersBloc = BlocProvider.getBloc<UserBLoc>();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Pesquisar",
              hintStyle: TextStyle(color: Colors.white),
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: InputBorder.none),
          onChanged: _usersBloc.onChengedSearch,
        ),
      ),
      Expanded(
          child: StreamBuilder<List>(
              stream: _usersBloc.outUsers,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                    ),
                  );
                else if (snapshot.data.length == 0)
                  return Center(
                      child: Text(
                    "Nenhum usuário encontrado!",
                    style: TextStyle(
                      color: Colors.pinkAccent,
                    ),
                  ));
                else
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return UserTile(snapshot.data[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: snapshot.data.length);
              })),
    ]);
  }
}
