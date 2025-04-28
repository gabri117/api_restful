import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/product_storage.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function() onSuccess;

  const ProductForm({this.product, required this.onSuccess});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _yearController;
  late final TextEditingController _priceController;
  late final TextEditingController _cpuController;
  late final TextEditingController _diskController;

  @override
  void initState() {
    super.initState();
    final product = widget.product ?? Product.empty();
    _nameController = TextEditingController(text: product.name);
    _yearController = TextEditingController(text: product.data['year']?.toString() ?? '');
    _priceController = TextEditingController(text: product.data['price']?.toString() ?? '');
    _cpuController = TextEditingController(text: product.data['CPU model'] ?? '');
    _diskController = TextEditingController(text: product.data['Hard disk size'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _cpuController.dispose();
    _diskController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final product = Product(
      id: widget.product?.id ?? '',
      name: _nameController.text,
      data: {
        'year': int.tryParse(_yearController.text),
        'price': double.tryParse(_priceController.text),
        'CPU model': _cpuController.text,
        'Hard disk size': _diskController.text,
      },
    );

    try {
      if (widget.product == null) {
        final createdProduct = await ApiService.createProduct(product);
        await ProductStorage.addId(createdProduct.id);
      } else {
        await ApiService.updateProduct(product.id, product);
      }
      widget.onSuccess();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.product == null ? 'Nuevo Producto' : 'Editar Producto',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Año',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cpuController,
                decoration: const InputDecoration(
                  labelText: 'Modelo CPU',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _diskController,
                decoration: const InputDecoration(
                  labelText: 'Disco Duro',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(widget.product == null ? 'CREAR PRODUCTO' : 'ACTUALIZAR PRODUCTO'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}