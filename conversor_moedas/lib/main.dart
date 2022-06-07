import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const requestURL = "https://api.hgbrasil.com/finance?format=json-cors&key=8e0b83f7";

void main() async{

  http.Response response = await http.get(requestURL);
  print( json.decode(response.body));


  runApp(MaterialApp(
    home: Container(),
  ));
}

