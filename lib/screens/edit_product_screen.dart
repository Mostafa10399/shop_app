import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../provider/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFoucusNode = FocusNode();
  final _descriptionFoucusNode = FocusNode();
  final _imageUrlFoucusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _imageController = TextEditingController();
  var _isInit = true;
  var _isLoading = false;
  String productID;
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var _editedProduct =
      Product(id: null, description: '', imageUrl: '', price: 0, title: '');
  @override
  void dispose() {
    _imageUrlFoucusNode.removeListener(_updateImageUrl);
    _priceFoucusNode.dispose();
    _descriptionFoucusNode.dispose();
    _imageController.dispose();
    _imageUrlFoucusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFoucusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context).settings.arguments as String;
      if (productID != null) {
        _editedProduct = Provider.of<ProductProvider>(context, listen: false)
            .findByID(productID);
        initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl
        };
        _imageController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFoucusNode.hasFocus) {
      if ((!_imageController.text.startsWith('http') &&
              !_imageController.text.startsWith('https')) ||
          (!_imageController.text.endsWith('.jpeg') &&
              !_imageController.text.endsWith('.png') &&
              !_imageController.text.endsWith('.jpg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    if (_editedProduct.id != null) {
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong!'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Okey'))
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save))
        ],
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: initValues['title'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a title';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFoucusNode);
                      },
                      onSaved: (value) => _editedProduct = Product(
                          id: _editedProduct.id,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          title: value,
                          isFavorite: _editedProduct.isFavorite),
                    ),
                    TextFormField(
                      initialValue: initValues['price'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a Price';
                        }
                        if (double.parse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) < 0) {
                          return 'Please enter a number greater than 0';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFoucusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFoucusNode);
                      },
                      onSaved: (value) => _editedProduct = Product(
                          id: _editedProduct.id,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(value),
                          title: _editedProduct.title,
                          isFavorite: _editedProduct.isFavorite),
                    ),
                    TextFormField(
                      initialValue: initValues['description'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a Description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 charchters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionFoucusNode,
                      onSaved: (value) => _editedProduct = Product(
                          id: _editedProduct.id,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          title: _editedProduct.title,
                          isFavorite: _editedProduct.isFavorite),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: _imageController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                        Expanded(
                          child: TextFormField(
                            // initialValue: initValues['imageUrl'],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a Image URL';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL';
                              }
                              if (!value.endsWith('.jpeg') &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('.jpg')) {
                                return 'Please enter a valid image URL';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageController,
                            focusNode: _imageUrlFoucusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (value) => _editedProduct = Product(
                                id: _editedProduct.id,
                                description: _editedProduct.description,
                                imageUrl: value,
                                price: _editedProduct.price,
                                title: _editedProduct.title,
                                isFavorite: _editedProduct.isFavorite),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
