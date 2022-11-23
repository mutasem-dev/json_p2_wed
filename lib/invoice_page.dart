import 'package:flutter/material.dart';
import 'details_page.dart';
import 'invoice.dart';
class InvoicesPage extends StatelessWidget {
  final List<Invoice> invoices;
  const InvoicesPage(this.invoices , {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Customers'),
      ),
      body: ListView.builder(
        itemCount: invoices.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                onTap: (){
                    Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => DetailsPage(invoices[index]),));
                },
                tileColor: Colors.blueAccent,
                leading: Text(invoices[index].cName, style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              ),
            );
          },
      ),
    );
  }
}
