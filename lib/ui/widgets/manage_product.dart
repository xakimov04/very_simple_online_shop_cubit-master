import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_simple_online_shop_cubit/data/models/product.dart';
import 'package:very_simple_online_shop_cubit/logic/blocs/product/product_bloc.dart';

class ManageProduct extends StatefulWidget {
  final bool isEdit;
  final Product? product;

  const ManageProduct({super.key, required this.isEdit, this.product});

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.product != null) {
      _productNameController.text = widget.product!.title;
      _imageUrlController.text = widget.product!.imageUrl;
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'Edit Product' : 'Add Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextFormField(
                controller: _productNameController,
                labelText: 'Product Name',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a product name'
                    : null,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _imageUrlController,
                labelText: 'Image URL',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter an image URL'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _handleSubmit(context);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }

  void _handleSubmit(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    if (widget.isEdit && widget.product != null) {
      productBloc.add(
        EditProductEvent(
          id: widget.product!.id,
          title: _productNameController.text,
          imageUrl: _imageUrlController.text,
        ),
      );
    } else {
      productBloc.add(
        AddProductEvent(
          title: _productNameController.text,
          imageUrl: _imageUrlController.text,
        ),
      );
    }
    Navigator.of(context).pop();
  }
}
