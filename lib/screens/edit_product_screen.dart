import 'package:e_commerce/providers/product.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFoucsnode.dispose();
    _descriptionFoucsNode.dispose();
    _imageUrlcontroller.dispose();
    super.dispose();
  }

  void _saveProduct() {
    _form.currentState.validate();
    _form.currentState.save();
    print(_editedProduct.title);
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
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
                        imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return ' enter a Title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFoucsnode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFoucsNode);
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(newValue),
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                TextFormField(
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
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
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
                        decoration: InputDecoration(labelText: 'Image URL'),
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
                              imageUrl: newValue);
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
