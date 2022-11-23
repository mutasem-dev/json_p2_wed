import 'product.dart';

class Invoice {
  int invoiceNo;
  String cName;
  List<Product> products;

  Invoice({required this.invoiceNo, required this.cName,required this.products});

  factory Invoice.fromJson(dynamic jsonObject) {
    var jsonArray = jsonObject['products'] as List;
    List<Product> products = jsonArray.map((e) => Product.fromJson(e)).toList();
    return Invoice(
        invoiceNo: jsonObject['invoiceNo'],
        cName: jsonObject['customerName'],
        products: products);
  }
}