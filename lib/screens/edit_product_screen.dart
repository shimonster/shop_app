import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/EditProductsScreen';

  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _urlFocusNode = FocusNode();
  final _urlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageURL: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
  };
  var didInit = false;

  @override
  void initState() {
    _urlFocusNode.addListener(_updateImage);
    super.initState();
  }

  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (!didInit) {
      final _editingId = ModalRoute.of(context).settings.arguments as String;
      if (_editingId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .filterForId(_editingId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _urlController.text = _editedProduct.imageURL;
      }
    }
    didInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _urlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _urlFocusNode.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_urlController.text.endsWith('.jpg') &&
        !_urlController.text.endsWith('.jpeg') &&
        !_urlController.text.endsWith('.png')) {
      return;
    }
    setState(() {});
  }

  Future<void> _submitData() async {
    print('data submited');
    final isValid = _form.currentState.validate();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      final products = Provider.of<Products>(context, listen: false);
      _form.currentState.save();
      if (_editedProduct.id != null) {
        products.editProduct(_editedProduct.id, _editedProduct);
        setState(() {
          isLoading = true;
        });
        Navigator.of(context).pop();
      } else {
        try {
          await products.addProduct(_editedProduct);
        } catch (error) {
          await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('An Error Has Occured'),
                content: Text(
                    'There seems to be an issue. How would you like to hadle it?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Go back to your products'),
                    onPressed: () {
                      isLoading = false;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } finally {
          setState(() {
            isLoading = false;
            Navigator.of(context).pop();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submitData,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a Title';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value,
                          id: _editedProduct.id,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageURL: _editedProduct.imageURL,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a Price';
                        } else if (double.tryParse(value) == null) {
                          return 'Please Enter a Valid Number';
                        } else if (double.parse(value) < 0) {
                          return 'Please Enter a Value Greater Than or Equal to 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          imageURL: _editedProduct.imageURL,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a Description';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          description: value,
                          price: _editedProduct.price,
                          imageURL: _editedProduct.imageURL,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context).primaryColor),
                          ),
                          child: _urlController.text == ''
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      'Enter a valid URL',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Image.network(
                                  _urlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _urlController,
                            focusNode: _urlFocusNode,
                            onFieldSubmitted: (_) {
                              _submitData();
                            },
                            onChanged: (_) => _updateImage(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter an Image URL';
                              } else if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg') &&
                                  !value.endsWith('.png')) {
                                return 'Please Enter a Valid Image URL';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                id: _editedProduct.id,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageURL: value,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
