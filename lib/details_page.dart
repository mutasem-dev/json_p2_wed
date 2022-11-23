import 'package:flutter/material.dart';
import 'product.dart';
import 'invoice_page.dart';
import 'invoice.dart';
class DetailsPage extends StatelessWidget {
  final Invoice invoice;
  const DetailsPage(this.invoice, {Key? key}) : super(key: key);
  String getProducts() {
    String prds = '';
    int i = 1;
    for (Product element in invoice.products) {
      prds += '${i++}- ${element.toString()}\n';
    }
    return prds;
  }
  String getTotal() {
    int q = 0;
    double p = 0;
    for (Product element in invoice.products) {
     q += element.quantity;
     p += element.quantity*element.price;
    }
    return 'Total Price: $p\nTotal Quantity: $q';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(invoice.cName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Invoice #: ${invoice.invoiceNo}',
            style: TextStyle(fontSize: 25), ),
          SizedBox(height: 10,),
          Text('Products: ',style: TextStyle(fontSize: 28), ),
          SizedBox(height: 5,),
          Text(getProducts(),style: TextStyle(fontSize: 22), ),
          SizedBox(height: 20,),
          Text(getTotal(),style: TextStyle(fontSize: 25), ),
        ],
      ),
    );
  }
}
