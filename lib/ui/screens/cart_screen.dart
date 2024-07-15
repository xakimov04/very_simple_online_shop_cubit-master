import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_simple_online_shop_cubit/data/models/product.dart';
import 'package:very_simple_online_shop_cubit/logic/blocs/cart/cart_bloc.dart';
import 'package:very_simple_online_shop_cubit/logic/blocs/order/order_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = context.read<CartBloc>();
    final OrderBloc orderBloc = context.read<OrderBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart screen'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (BuildContext context, CartState state) {
          if (state is LoadedCartState) {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: state.cart.products.length,
              itemBuilder: (BuildContext context, int index) {
                final Product product = state.cart.products[index];
                return Dismissible(
                  key: ValueKey(product.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    cartBloc.add(DeleteProductFromCartEvent(id: product.id));
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: AnimatedCartProduct(
                    product: product,
                    cartBloc: cartBloc,
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Add product'));
        },
      ),
      floatingActionButton: FilledButton.icon(
        onPressed: () {
          orderBloc.add(AddOrderEvent(cart: cartBloc.cart));
          cartBloc.add(MakeOrderEvent());
        },
        label: const Text('Order'),
        icon: const Icon(Icons.shopping_cart_rounded),
      ),
    );
  }
}

class AnimatedCartProduct extends StatefulWidget {
  final Product product;
  final CartBloc cartBloc;

  const AnimatedCartProduct({
    required this.product,
    required this.cartBloc,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedCartProductState createState() => _AnimatedCartProductState();
}

class _AnimatedCartProductState extends State<AnimatedCartProduct>
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
