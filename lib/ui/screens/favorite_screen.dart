import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_simple_online_shop_cubit/data/models/product.dart';
import 'package:very_simple_online_shop_cubit/logic/blocs/product/product_bloc.dart';
import 'package:very_simple_online_shop_cubit/ui/widgets/product_container.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Products'),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is InitialProductState) {
            return const Center(child: Text('Add products!'));
          } else if (state is LoadedProductState) {
            final List<Product> favProducts = state.products.where((product) => product.isFavorite).toList();
            return favProducts.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: favProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Product product = favProducts[index];
                      return AnimatedFavoriteProduct(product: product);
                    },
                  )
                : const Center(
                    child: Text('You do not have favorite products!'),
                  );
          } else {
            return const Center(child: Text('Add products!'));
          }
        },
      ),
    );
  }
}

class AnimatedFavoriteProduct extends StatefulWidget {
  final Product product;
  const AnimatedFavoriteProduct({required this.product, Key? key}) : super(key: key);

  @override
  _AnimatedFavoriteProductState createState() => _AnimatedFavoriteProductState();
}

class _AnimatedFavoriteProductState extends State<AnimatedFavoriteProduct> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.product.imageUrl,
                  height: 80,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Icon(
                widget.product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.product.isFavorite ? Colors.red : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
