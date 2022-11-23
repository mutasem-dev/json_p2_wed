import 'dart:convert';

import 'package:flutter/material.dart';
import 'invoice.dart';
import 'invoice_page.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
      MaterialApp(
        
        home: MainPage(),
      )
  );
}
TextEditingController cnameController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController quantityController = TextEditingController();

class MainPage extends StatefulWidget {
  List<Product> products=[];

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<Invoice>> invoices;
  int invoiceNo = 1;
  _showDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text('Product Info',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: false,
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'product name',
              ),
            ),
            TextField(
              autofocus: false,
              keyboardType: TextInputType.number,
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'price',
              ),
            ),
            TextField(
              autofocus: false,
              keyboardType: TextInputType.number,
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'quantity',
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                int q=0;
                double p = 0;
                String name='';
                if(nameController.text.isEmpty) {
                  const snackBar = SnackBar(content: Text('Enter name'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                try {
                  q = int.parse(quantityController.text);
                  p = double.parse(priceController.text);
                } catch(e) {
                  const snackBar = SnackBar(content: Text('enter valid number'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                widget.products.add(
                    Product(
                        name: nameController.text,
                        price: double.parse(priceController.text),
                        quantity: q
                    )
                );
                Navigator.of(context).pop();
                setState(() {
                  nameController.clear();
                  priceController.clear();
                  quantityController.clear();
                });
              },
              child: const Text('add'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('cancel'),
          ),
        ],
      ),
    );
  }

  Future<List<Invoice>> getInvoices() async{
    var url = Uri.https('www.jsonkeeper.com', 'b/462B');
    //http.Response response =  await http.get(Uri.parse('https://www.jsonkeeper.com/b/462B'));
    http.Response response =  await http.get(url);
    List<Invoice> invoices = [];
    if(response.statusCode == 200) {
      print(response.body);
      var jsonObject = jsonDecode(response.body);
      var jsonArray = jsonObject['invoices'] as List;
      invoices = jsonArray.map((e) => Invoice.fromJson(e)).toList();
    }
    return invoices;

  }

  @override
  void initState() {
    super.initState();
    invoices = getInvoices();
    invoices.then((value) {
      invoiceNo = value.length+1;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<Invoice>>(
          future: invoices,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return Text('Invoice# ${snapshot.data!.length+1}');

            }
            else {
              return Text('Invoice# 1');
            }
          },
        ),
      ),
      body: Column(

        children: [
          TextField(
            autofocus: false,
            controller: cnameController,
            decoration: const InputDecoration(
              labelText: 'customer name',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Products:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
              ElevatedButton(
                  onPressed: () {
                    _showDialog(context);
                  },
                  child: const Text('add product'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.blue,
                      leading: Text(widget.products[index].name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                      title: Text('price: ${widget.products[index].price}'),
                      subtitle: Text('quantity: ${widget.products[index].quantity}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                            widget.products.removeAt(index);
                            setState(() {

                            });
                        },
                      ),
                    ),
                  );
                },
            ),
          ),
          FutureBuilder<List<Invoice>>(
            future: invoices,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List<Invoice>? invs = snapshot.data;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(

                          onPressed: () {
                            if(cnameController.text.isEmpty) {
                              const snackBar = SnackBar(content: Text('Enter customer name'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              return;
                            }
                            invs?.add(
                                Invoice(invoiceNo: invoiceNo++, cName: cnameController.text, products: widget.products)
                            );
                            cnameController.clear();
                            widget.products = [];
                            setState(() {

                            });
                          },
                          child: Text('add invoice')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => InvoicesPage(invs!),));
                          },
                          child: Text('show all invoices')
                      ),
                    ],
                  );
                } else if(snapshot.hasError) {
                  return Text('Error ${snapshot.error.toString()}');
                }
                else
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
              },
          ),
        ],
      ),
    );
  }
}