import 'dart:convert';

import 'package:belajar_api/main.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

final nameInput = TextEditingController();
final emailInput = TextEditingController();
final genderInput = TextEditingController();

Future<http.Response> getData() async {
  var result =
      await http.get(Uri.parse('http://192.168.22.249:8082/api/user/getAll'));
  print(result.body);
  return result;
}

Future<http.Response> postData(Map<String, dynamic> data) async {
  // Map<String, dynamic> data = {
  //   'nama': nameInput.text,
  //   'email': emailInput.text,
  //   'gender': genderInput.text
  // };
  var response =
      await http.post(Uri.parse('http://192.168.22.249:8082/api/user/insert'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
  print(response.statusCode);
  return response;
}

Future<http.Response> updateData(int id) async {
  Map<String, dynamic> data = {
    'nama': nameInput.text,
    'email': emailInput.text,
    'gender': genderInput.text
  };

  var result = await http.put(
      Uri.parse('http://192.168.22.249:8082/api/user/update/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(data));
  print(result.statusCode);
  return result;
}

Future<http.Response> deleteData(int id) async {
  var result = await http.delete(
    Uri.parse('http://192.168.22.249:8082/api/user/delete/${id}'),
  );
  print(result.statusCode);
  return result;
}

class NetworkingHtpp extends StatefulWidget {
  NetworkingHtpp({super.key});

  @override
  State<NetworkingHtpp> createState() => _NetworkingHtppState();
}

class _NetworkingHtppState extends State<NetworkingHtpp> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var data = getData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // postData();
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Tambah Data"),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: nameInput,
                            decoration: InputDecoration(
                                hintText: "name", labelText: "name"),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input your Email';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            controller: emailInput,
                            decoration: InputDecoration(
                                hintText: "Email", labelText: "email"),
                          ),
                          TextFormField(
                            controller: genderInput,
                            decoration: InputDecoration(
                                hintText: "Gender", labelText: "Gender"),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    postData({
                                      'nama': nameInput.text,
                                      'email': emailInput.text,
                                      'gender': genderInput.text
                                    });
                                    nameInput.clear();
                                    emailInput.clear();
                                    Navigator.of(context).pop();
                                  });
                                }
                                // setState(() {
                                //   Navigator.pop(context);
                                // });
                              },
                              child: Text("Kirim"))
                        ],
                      ),
                    ),
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<http.Response>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return Text("${snapshot.data!.body}");
              List<dynamic> json = jsonDecode(snapshot.data!.body);
              return ListView.builder(
                itemCount: json.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // leading: CircleAvatar(
                    //     child: Text("${decoded[index]["nama"][0] ?? ""}")),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                    ),
                    title: Text(json[index]['nama'] ?? ""),
                    subtitle: Text(json[index]['email'] ?? ""),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // updateData(json[index]["id"]);
                            nameInput.text = json[index]['nama'];
                            emailInput.text = json[index]['email'];
                            genderInput.text = json[index]['gender'];

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Update Data"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: nameInput,
                                          decoration: InputDecoration(
                                              hintText: "name",
                                              labelText: "name"),
                                        ),
                                        TextFormField(
                                          controller: emailInput,
                                          decoration: InputDecoration(
                                              hintText: "Email",
                                              labelText: "email"),
                                        ),
                                        TextFormField(
                                          controller: genderInput,
                                          decoration: InputDecoration(
                                              hintText: "Gender",
                                              labelText: "Gender"),
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              await updateData(
                                                  json[index]["id"]);
                                              // postData();
                                              // updateData();

                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("SEND"))
                                      ],
                                    ),
                                  );
                                });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await deleteData(json[index]["id"]);
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
