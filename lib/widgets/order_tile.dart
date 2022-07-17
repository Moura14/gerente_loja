import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/order_hader.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;
  OrderTile(this.order);
  final states = [
    '',
    'Em preparação',
    'Em transporte',
    'Aguardando Entrega',
    'Entregue'
  ];

  //const OrderTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: order.data["status"] != 4,
          title: Text(
              '#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)}- "${states[order.data['status']]}',
              style: TextStyle(
                  color: order.data["status"] != 4
                      ? Colors.grey[850]
                      : Colors.green)),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OrderHader(order),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: order.data['products'].map<Widget>((p) {
                          return ListTile(
                            title:
                                Text(p['product']['title'] + '-' + p['size']),
                            subtitle: Text(p['category'] + '/' + p['pid']),
                            trailing: Text(
                              p['quantity'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList()),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                              onPressed: () {
                                Firestore.instance
                                    .collection("users")
                                    .document(order['clientId'])
                                    .collection('orders')
                                    .document(order.documentID)
                                    .delete();
                                order.reference.delete();
                              },
                              child: Text(
                                "Excluir",
                                style: TextStyle(color: Colors.red),
                              )),
                          FlatButton(
                              onPressed: order.data['status'] < 4
                                  ? () {
                                      order.reference.updateData(
                                          {"status": order.data['status'] - 1});
                                    }
                                  : null,
                              child: Text(
                                "Regridir",
                                style: TextStyle(color: Colors.grey[850]),
                              )),
                          FlatButton(
                              onPressed: order.data["status"] < 4
                                  ? () {
                                      order.reference.updateData(
                                          {"users": order.data['status'] + 1});
                                      child:
                                      Text("Avançar ",
                                          style:
                                              TextStyle(color: Colors.green));
                                    }
                                  : null)
                        ])
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
