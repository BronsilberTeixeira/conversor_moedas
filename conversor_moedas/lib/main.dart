import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:easy_mask/easy_mask.dart';

const requestURL = "https://api.hgbrasil.com/finance?format=json-cors&key=8e0b83f7";

void main() async{
  http.Response response = await http.get(requestURL);
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      primaryColor: Colors.purple,
    ),
  ));
}


class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  TextEditingController realController = TextEditingController();
  TextEditingController dolarController = TextEditingController();
  TextEditingController euroController = TextEditingController();

  double dolar;
  double euro;

  GlobalKey _formKey = GlobalKey<FormState>();  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\$ Conversor de moedas \$', style: TextStyle(color: Colors.deepPurple[300]),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[800],
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none :
            case ConnectionState.waiting:
            return Center(
              child: Text("Carregando dados...",
                style: TextStyle(color: Colors.purple[300], fontSize: 30.0),
              textAlign: TextAlign.center,
              ));
            default:
              if(snapshot.hasError){
                 return Center(
                  child: Text("Erro ao carregar os dados :'(",
                    style: TextStyle(color: Colors.red[900],
                    fontSize: 30.0),
                  textAlign: TextAlign.center,
                  ));
              }
            dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
            euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

            return 
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Form(
                child: Column(
                  key: _formKey,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      Icon(Icons.monetization_on_outlined, 
                        size: 120, 
                        color: Colors.deepPurple[900]
                      ),
                    construirCampos('Valor em Reais', '\R!\$!', realController),
                    Divider(),
                    construirCampos('Valor em Dolar', '\$!', dolarController),
                    Divider(),
                    construirCampos('Valor em Euro', '\€!', euroController)
                  ],
                ) 
              )
            );
          }
        })
    );
  }
}

Future<Map> getData() async{
  http.Response response = await http.get(requestURL);
  return json.decode(response.body);
}

Widget construirCampos(String label, String prefix, TextEditingController controlador){
  return   TextFormField(
    controller: controlador,
    keyboardType: TextInputType.number,
    inputFormatters: [TextInputMask(mask: '$prefix !9+,99',placeholder: '0', maxPlaceHolders: 3, reverse: true)],
    decoration: InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Colors.deepPurple[300], fontSize: 20.0),
    border: OutlineInputBorder(),
    ),
     style: TextStyle(
       color: Colors.deepPurple[300], fontSize: 25.0
       ),
  );
}


