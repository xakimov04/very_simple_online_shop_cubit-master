import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_simple_online_shop_cubit/data/models/product.dart';
import 'package:very_simple_online_shop_cubit/logic/blocs/cart/cart_bloc.dart';
import 'package:very_simple_online_shop_cubit/logic/blocs/product/product_bloc.dart';
import 'package:very_simple_online_shop_cubit/ui/widgets/manage_product.dart';

class ProductContainer extends StatelessWidget {
  final bool isFavoriteScreen;
  final Product product;

  const ProductContainer({
    super.key,
    required this.product,
    required this.isFavoriteScreen,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedProductCard(
      product: product,
      isFavoriteScreen: isFavoriteScreen,
    );
  }
}

class AnimatedProductCard extends StatefulWidget {
  final bool isFavoriteScreen;
  final Product product;

  const AnimatedProductCard({
    required this.product,
    required this.isFavoriteScreen,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedProductCardState createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
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
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.product.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(5),
                    const Text(
                      'Price: \$${100}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const Gap(5),
                    const Text(
                      "BMW, short for Bayerische Motoren Werke AG, is a renowned German luxury vehicle and motorcycle manufacturer with a rich history dating back to its founding in 1916. Headquartered in Munich, Bavaria, BMW has earned a global reputation for producing vehicles that combine performance, luxury, and cutting-edge technology.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => ManageProduct(
                          isEdit: true,
                          product: widget.product,
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () => context
                        .read<ProductBloc>()
                        .add(RemoveProductEvent(id: widget.product.id)),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                  IconButton(
                    onPressed: () => context
                        .read<ProductBloc>()
                        .add(ToggleFavoriteEvent(id: widget.product.id)),
                    icon: Icon(
                      widget.product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          widget.product.isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context
                        .read<CartBloc>()
                        .add(AddProductToCartEvent(product: widget.product)),
                    icon: const Icon(Icons.add_shopping_cart,
                        color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
