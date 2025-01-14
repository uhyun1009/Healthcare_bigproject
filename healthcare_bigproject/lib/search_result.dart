import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class SearchResult extends StatefulWidget {
  SearchResult({Key? key, this.text}) : super(key: key);
  final text;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final firebase = FirebaseFirestore.instance;
  dynamic data = 0;
  var search_bool = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResult(widget.text);
  }

  getResult(text) async{
    try {
      data = await firebase.collection('hospital_marker').doc(text).get();
      print(data['name']);
      setState((){
        search_bool = true;
      });

    } catch (e) {
      print(e);
      setState((){
        search_bool = false;
      });
    }
  }
  final controller = PageController(viewportFraction: 0.8, keepPage: true);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Result'), centerTitle: true, ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: controller,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Search Result!', style: TextStyle(fontSize: 25),),
              Container(
                margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ResultText(data:data, searchBool: search_bool, searchText:widget.text,)),
            ],),
        ),
      )
    );
    // 221222!!  Null is not a subtype of type 'bool' 문제 해결해야함!!
  }
}

class ResultText extends StatelessWidget {
  const ResultText({Key? key, this.data, this.searchBool, this.searchText}) : super(key: key);
  final data;
  final searchBool;
  final searchText;
  @override
  Widget build(BuildContext context) {
    if(searchBool) {
      return Column(children: [
        Text(data['name']),
        Text(data['n_list'].toString()),
      ],);
    } else {
      return Column(children: [
        Text('There is no result for ${searchText}'),
      ],);
    }
  }
}
