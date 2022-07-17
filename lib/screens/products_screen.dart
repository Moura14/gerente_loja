import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/products_bloc.dart';
import 'package:gerente_loja/validators/products_validators.dart';
import 'package:gerente_loja/widgets/image_widgets.dart';
import 'package:gerente_loja/widgets/products_size.dart';

class ProductsScreens extends StatelessWidget with ProducValidator {
  final String categoryId;
  final DocumentSnapshot product;

  final ProductsBloc _productsBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductsScreens({this.categoryId, this.product})
      : _productsBloc = ProductsBloc(categoryId: categoryId, product: product);

  //const ProductsScreens({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    final _fieldStyle = TextStyle(color: Colors.white, fontSize: 16);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          elevation: 0,
          title: StreamBuilder<bool>(
            stream: _productsBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? "Editar produto" : "Criar produto");
            },
          ),
          actions: [
            StreamBuilder<bool>(
                stream: _productsBloc.outCreated,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.data)
                    return StreamBuilder<bool>(
                      stream: _productsBloc.outLoading,
                      initialData: false,
                      builder: (context, snapshot) {
                        return IconButton(
                            onPressed: snapshot.data
                                ? null
                                : () {
                                    _productsBloc.deleteProduct();
                                    Navigator.of(context).pop();
                                  },
                            icon: Icon(Icons.remove));
                      },
                    );
                  else
                    return Container();
                }),
            StreamBuilder<bool>(
              stream: _productsBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                    onPressed: snapshot.data ? null : saveProduct,
                    icon: Icon(Icons.save));
              },
            )
          ],
        ),
        body: Stack(children: [
          Form(
              key: _formKey,
              child: StreamBuilder<Map>(
                stream: _productsBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Text("Imagens",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          )),
                      ImagesWidget(
                        context: context,
                        initialValue: snapshot.data['images'],
                        onSaved: _productsBloc.saveImagens,
                        validator: validateImages,
                      ),
                      TextFormField(
                        initialValue: snapshot.data['title'],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Título"),
                        onSaved: _productsBloc.saveTitle,
                        validator: validateTile,
                      ),
                      TextFormField(
                        initialValue: snapshot.data['description'],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Descrição"),
                        maxLines: 6,
                        onSaved: _productsBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                          initialValue:
                              snapshot.data['price']?.toStringAsFixed(2),
                          style: _fieldStyle,
                          decoration: _buildDecoration("Preço"),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onSaved: _productsBloc.savePrice,
                          validator: validatePrice),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Tamanhos',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      ProductsSizes(
                        context: context,
                        initialValue: snapshot.data['sizes'],
                        onSaved: _productsBloc.saveSizes,
                        validator: (s) {
                          if (s.isEmpty) return "";
                        },
                      )
                    ],
                  );
                },
              )),
          StreamBuilder<bool>(
            stream: _productsBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IgnorePointer(
                ignoring: !snapshot.data,
                child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent),
              );
            },
          )
        ]));
  }

  void saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text("Salavando produto...", style: TextStyle(color: Colors.white)),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.pinkAccent,
      ));

      bool sucess = await _productsBloc.saveProduct();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          sucess ? "Produto Salvo" : "Erro ao salvar produto",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
      ));
    }
  }
}
