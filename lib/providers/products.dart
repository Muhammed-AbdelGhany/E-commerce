import 'dart:convert';
import 'package:e_commerce/models/http_exception.dart';
import 'package:e_commerce/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Book',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1509021436665-8f07dbf5bf1d?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MjF8fHxlbnwwfHx8&w=1000&q=80',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'cannon Camera',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://in.canon/media/image/2018/05/03/642e7bbeae5741e3b872e082626c0151_eos6d-mkii-ef-24-70m-l.png',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Rexona Spray',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGBtLJIqRmg-OJ9z518cS01l4-1Gv9iFQnUQ&usqp=CAU',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'CBDDistillery',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://post.healthline.com/wp-content/uploads/2020/06/442070-CBD-Prod-Rev-CBDistillery-CBD-Products_732x549-thumbnail-732x549.jpg',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Skin Care',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.shopify.com/s/files/1/0250/9661/8038/products/vital-c-intense-moisturizer-with-box_600x.jpg?v=1585843221',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchData() async {
    const baseUrl =
        'https://flutter-ecommerce-1-2d485-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(baseUrl);
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      loadedData.forEach((productId, product) {
        loadedProducts.add(Product(
            id: productId,
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl'],
            isFavorite: product['isFavorite']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(Product product) async {
    const baseUrl =
        'https://flutter-ecommerce-1-2d485-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(baseUrl,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product getProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product editedProduct) async {
    final baseUrl =
        'https://flutter-ecommerce-1-2d485-default-rtdb.firebaseio.com/products/$id.json';
    await http.patch(baseUrl,
        body: json.encode({
          'title': editedProduct.title,
          'price': editedProduct.price,
          'description': editedProduct.description,
          'imageUrl': editedProduct.imageUrl
        }));
    var productIndex = _items.indexWhere((element) => element.id == id);
    _items[productIndex] = editedProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final baseUrl =
        'https://flutter-ecommerce-1-2d485-default-rtdb.firebaseio.com/products/$id.json';
    final response = await http.delete(baseUrl);
    if (response.statusCode == 200 || response.statusCode == 201) {
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
    } else {
      throw HttpException('Cant delete item.');
    }
  }
}
