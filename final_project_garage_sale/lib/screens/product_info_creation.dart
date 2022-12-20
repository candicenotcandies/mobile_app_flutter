import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class ProductInfoCreationScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const ProductInfoCreationScreen({super.key});
  @override
  State<ProductInfoCreationScreen> createState() =>
      _ProductInfoCreationScreen();
}

class _ProductInfoCreationScreen extends State<ProductInfoCreationScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var imageUrlInput = '';
  var _editedProduct =
      Product(id: '', title: '', price: 0, description: '', imageUrl: '');

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Opps, something went wrong'),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    TextButton(
                        onPressed: (() {
                          Navigator.of(context).pop();
                        }),
                        child: const Text('Okay'))
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
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;
        if (productId.isNotEmpty) {
          final product =
              Provider.of<Products>(context, listen: false).findById(productId);
          _editedProduct = product;
          _initValues = {
            'title': _editedProduct.title,
            'description': _editedProduct.description,
            'price': _editedProduct.price.toString(),
          };
          _imageUrlController.text = _editedProduct.imageUrl;
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: <Widget>[
            IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(
                            labelText: 'Title',
                            errorStyle: TextStyle(color: Colors.amber)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          //move to the next field after hitting enter
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a valid title.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              title: newValue as String,
                              price: _editedProduct.price,
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: const InputDecoration(
                            labelText: 'Price',
                            errorStyle: TextStyle(color: Colors.amber)),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) {
                          //move to the next field after hitting enter
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Price must be larger than 0';
                          }
                          return null;
                        }),
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: double.parse(newValue as String),
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: const InputDecoration(
                            labelText: 'Description',
                            errorStyle: TextStyle(color: Colors.amber)),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Description cannot be empty';
                          }
                          if (value.length < 10) {
                            return 'Description should be longer than 10 characters';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              description: newValue as String,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.blueGrey)),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Enter an URL')
                                : FittedBox(
                                    child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'ImageUrl',
                                  errorStyle: TextStyle(color: Colors.amber)),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onChanged: (value) {
                                setState(() {
                                  imageUrlInput = value;
                                });
                              },
                              // onEditingComplete: () {
                              //   setState(() {});
                              // },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid image URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL starts with http(s)';
                                }
                                // if (!value.endsWith('.png') &&
                                //     !value.endsWith('.jpg') &&
                                //     !value.endsWith('.jpeg')) {
                                //   return 'URL should end with png/jpg/jpeg';
                                // }
                                return null;
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                    title: _editedProduct.title,
                                    price: _editedProduct.price,
                                    id: _editedProduct.id,
                                    imageUrl: newValue as String,
                                    description: _editedProduct.description,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
                ),
              ));
  }
}
