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
  ));
}


class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  TextEditingController moedaBRL = TextEditingController();
  TextEditingController moedaURS = TextEditingController();
  TextEditingController moedaEUR = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de moedas', style: TextStyle(color: Colors.deepPurple[300]),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Form(
          child: Column(
            key: _formKey,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                TextFormField(keyboardType: TextInputType.number,
                inputFormatters: [TextInputMask(mask: '\R!\$! !9+,99',placeholder: '0', maxPlaceHolders: 3, reverse: true)],
                decoration: InputDecoration(
                  labelText: 'Valor em BRL',
                  labelStyle: TextStyle(color: Colors.deepPurple[300])
                ),
                style: TextStyle(color: Colors.deepPurple[300], fontSize: 25.0),
              )
            ],
          ) 
        )
      ),
    );
  }
}

Future<Map> getData() async{
  http.Response response = await http.get(requestURL);
  return json.decode(response.body);
}

