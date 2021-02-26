import 'package:e_commerce/providers/product.dart';
import 'package:e_commerce/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFoucsnode = FocusNode();
  final _descriptionFoucsNode = FocusNode();
  final _imageUrlcontroller = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: "", description: "", price: 0, imageUrl: "");
  bool _isinit = true;
  var _initProduct = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isinit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .getProductById(productId);
        _initProduct = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageUrlcontroller.text = _editedProduct.imageUrl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFoucsnode.dispose();
    _descriptionFoucsNode.dispose();
    _imageUrlcontroller.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    setState(() {
      isLoading = true;
    });
    var _isvalid = _form.currentState.validate();
    if (!_isvalid) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);

      Navigator.pop(context);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addItem(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error happened'),
            content: Text('Some thing went wrong'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('OK'),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveProduct),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initProduct['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFoucsnode);
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: newValue,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You have to enter a title.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initProduct['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFoucsnode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFoucsNode);
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(newValue),
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) < 1) {
                            return 'Enter a price greater than zero.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                          initialValue: _initProduct['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFoucsNode,
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: newValue,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                isFavorite: _editedProduct.isFavorite);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the a Description.';
                            }
                            if (value.length < 10) {
                              return 'Number of charcters must be more than 10.';
                            }
                            return null;
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 10, right: 15),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Container(
                              child: _imageUrlcontroller.text.isEmpty
                                  ? Text('No URL')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlcontroller.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Enter Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlcontroller,
                              onFieldSubmitted: (value) {
                                setState(() {
                                  _saveProduct();
                                });
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: newValue,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Enter a Url please.";
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Enter a valid URL please.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
