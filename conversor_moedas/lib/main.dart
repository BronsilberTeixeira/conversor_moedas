import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final  realController = TextEditingController();
  final  dolarController = TextEditingController();
  final  euroController = TextEditingController();

  double dolar;
  double euro;

 

  void _realChanged(String text){
    if(text.isEmpty){
      limparCampos();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
     if(text.isEmpty){
      limparCampos();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
     if(text.isEmpty){
      limparCampos();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  limparCampos(){
    realController.text = '0';
    dolarController.text = '0';
    euroController.text = '0';
  }

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
                    construirCampos('Valor em Reais', '\R!\$!', realController, _realChanged),
                    Divider(),
                    construirCampos('Valor em Dolar', '\$!', dolarController, _dolarChanged)
,                    Divider(),
                    construirCampos('Valor em Euro', '\€!', euroController, _euroChanged)
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

Widget construirCampos(String label, String prefix, TextEditingController controlador, Function funcoes){
   var maskFormatter = new MaskTextInputFormatter(
    filter: {'#': RegExp(r'[0-9]')}
  );

  return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: ([maskFormatter]),
    controller: controlador,
    decoration: InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Colors.deepPurple[300], fontSize: 20.0),
    border: OutlineInputBorder(),
    prefixText: prefix,
    ),
     style: TextStyle(
       color: Colors.deepPurple[300], fontSize: 25.0
       ),
    onChanged: funcoes,
  );
}




