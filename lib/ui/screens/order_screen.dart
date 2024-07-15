import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_simple_online_shop_cubit/data/models/cart.dart';
import 'package:very_simple_online_shop_cubit/logic/blocs/order/order_bloc.dart';
import 'package:very_simple_online_shop_cubit/data/models/product.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (BuildContext context, OrderState state) {
          if (state is OrderLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoadedState) {
            if (state.orders.orders.isEmpty) {
              return const Center(child: Text('No orders available.'));
            }

            return ListView.builder(
              itemCount: state.orders.orders.length,
              itemBuilder: (context, index) {
                final cart = state.orders.orders[index];
                return AnimatedOrderCard(cart: cart);
              },
            );
          } else if (state is OrderErrorState) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else {
            return const Center(child: Text('No orders available.'));
          }
        },
      ),
    );
  }
}

class AnimatedOrderCard extends StatefulWidget {
  final Cart cart;
  const AnimatedOrderCard({required this.cart, Key? key}) : super(key: key);

  @override
  _AnimatedOrderCardState createState() => _AnimatedOrderCardState();
}

class _AnimatedOrderCardState extends State<AnimatedOrderCard> with SingleTickerProviderStateMixin {
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
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 5,
        child: ExpansionTile(
          title: Text(
            'Order ID: ${widget.cart.id}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: widget.cart.products.map((Product product) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(product.title),
              subtitle: Text(product.isFavorite ? 'Favorite' : ''),
            );
          }).toList(),
        ),
      ),
    );
  }
}
