import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Yes or No App',
      home: MyHomePage(title: 'Flutter Yes or No App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _url = "https://yesno.wtf/api";
  StreamController _streamController;
  Stream _stream;
  Response response;

  getYesorNo() async {
    _streamController.add("waiting");
    response = await get(_url);
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    getYesorNo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return getYesorNo();
          },
          child: Center(
            child: StreamBuilder(
              stream: _stream,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.data == "waiting") {
                  return Center(child: Text("Waiting of the result....."));
                }
                return Center(
                  child: ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int i) {
                        return Center(
                          child: ListBody(
                            children: [
                              Center(
                                child: Card(
                                  elevation: 8.0,
                                  child: Column(
                                    children: [
                                      Center(
                                        child:FadeInImage.assetNetwork(
                                          placeholder: 'assets/loading.gif',
                                          image:  snapshot.data['image'],
                                        ),),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: (snapshot.data['answer'].toString().toUpperCase() == 'NO')? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(snapshot.data['answer'].toString().toUpperCase(),style: TextStyle(letterSpacing: 1.0,fontSize: 18.0),),
                                            SizedBox(width: 10.0,),
                                            CircleAvatar( backgroundColor: Colors.redAccent,child: Icon(Icons.close,color: Colors.white,))
                                          ],
                                        ): Row(
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: [
                                            Text(snapshot.data['answer'].toString().toUpperCase(),style: TextStyle(letterSpacing: 1.0,fontSize: 18.0),),
                                            SizedBox(width: 10.0,),
                                            CircleAvatar( backgroundColor: Colors.green,child: Icon(Icons.check,color: Colors.white,))
                                          ],
                                        ),
                                          
                                      )

                                    ],
                                  ),),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
    child: Icon(Icons.refresh),
    onPressed:(){
    getYesorNo();
    },),);
  }
}
