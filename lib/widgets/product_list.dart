import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/product_storage.dart';
import 'product_form.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Future<List<Product>> _allProductsFuture = Future.value([]);
  Future<List<Product>> _userProductsFuture = Future.value([]);
  List<String> _userProductIds = [];
  bool _isLoading = false;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      _userProductIds = await ProductStorage.getIds();
      setState(() {
        _allProductsFuture = ApiService.getProducts().then((products) {
          return products.where((p) => !_userProductIds.contains(p.id)).toList();
        });
        _userProductsFuture = ApiService.getUserProducts(_userProductIds);
        _isInitialLoad = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar productos: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showAddProductForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProductForm(
        onSuccess: _loadProducts,
      ),
    );
  }

  void _showEditProductForm(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProductForm(
        product: product,
        onSuccess: _loadProducts,
      ),
    );
  }

  Future<void> _deleteProduct(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Estás seguro de eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        setState(() => _isLoading = true);
        final success = await ApiService.deleteProduct(id);
        if (success) {
          await ProductStorage.removeId(id);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Producto eliminado exitosamente')),
            );
          }
          await _loadProducts();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Productos'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
      body: _isInitialLoad
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProducts,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Mis Productos',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  _buildUserProductsList(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Productos de Muestra (solo lectura)',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  _buildSampleProductsList(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _showAddProductForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserProductsList() {
    return FutureBuilder<List<Product>>(
      future: _userProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !_isInitialLoad) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        
        final userProducts = snapshot.data ?? [];
        
        if (userProducts.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('No has creado productos aún')),
          );
        }
        
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildProductItem(userProducts[index]),
            childCount: userProducts.length,
          ),
        );
      },
    );
  }

  Widget _buildSampleProductsList() {
    return FutureBuilder<List<Product>>(
      future: _allProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        
        final sampleProducts = snapshot.data ?? [];
        
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildSampleProductItem(sampleProducts[index]),
            childCount: sampleProducts.length,
          ),
        );
      },
    );
  }

  Widget _buildProductItem(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${product.id}'),
            if (product.data['price'] != null)
              Text('Precio: \$${product.data['price']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditProductForm(product),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteProduct(product.id),
            ),
          ],
        ),
        onTap: () => _showProductDetails(product),
      ),
    );
  }

  Widget _buildSampleProductItem(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: ListTile(
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${product.id}'),
            if (product.data['price'] != null)
              Text('Precio: \$${product.data['price']}'),
          ],
        ),
        trailing: const Icon(Icons.lock, color: Colors.grey),
        onTap: () => _showProductDetails(product),
      ),
    );
  }

  void _showProductDetails(Product product) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text('ID: ${product.id}'),
            const SizedBox(height: 8),
            const Text('Detalles:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...product.data.entries.map((e) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('${e.key}: ${e.value}'),
              )
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}