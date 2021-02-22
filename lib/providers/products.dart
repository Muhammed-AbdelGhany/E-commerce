import 'package:e_commerce/providers/product.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Book',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://images.unsplash.com/photo-1509021436665-8f07dbf5bf1d?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MjF8fHxlbnwwfHx8&w=1000&q=80',
    ),
    Product(
      id: 'p3',
      title: 'cannon Camera',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://in.canon/media/image/2018/05/03/642e7bbeae5741e3b872e082626c0151_eos6d-mkii-ef-24-70m-l.png',
    ),
    Product(
      id: 'p4',
      title: 'Rexona Spray',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGBtLJIqRmg-OJ9z518cS01l4-1Gv9iFQnUQ&usqp=CAU',
    ),
    Product(
      id: 'p5',
      title: 'CBDDistillery',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://post.healthline.com/wp-content/uploads/2020/06/442070-CBD-Prod-Rev-CBDistillery-CBD-Products_732x549-thumbnail-732x549.jpg',
    ),
    Product(
      id: 'p6',
      title: 'Skin Care',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.shopify.com/s/files/1/0250/9661/8038/products/vital-c-intense-moisturizer-with-box_600x.jpg?v=1585843221',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  void addItem(Product product) {
    final newProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    _items.add(newProduct);

    notifyListeners();
  }

  Product getProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void updateProduct(String id, Product editedProduct) {
    var productIndex = _items.indexWhere((element) => element.id == id);
    _items[productIndex] = editedProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
