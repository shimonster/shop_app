import 'package:flutter/material.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/EditProductsScreen';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          child: TextFormField(

          ),
        ),
      ),
    );
  }
}
