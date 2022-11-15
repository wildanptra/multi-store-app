class Product {
  String name;
  double price;
  int qty = 1;
  int qntty;
  List imagesUrl;
  String documentId;
  String supplierId;
  
  Product({
    required this.name,
    required this.price,
    required this.qty,
    required this.qntty,
    required this.imagesUrl,
    required this.documentId,
    required this.supplierId,
  });

  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }

}