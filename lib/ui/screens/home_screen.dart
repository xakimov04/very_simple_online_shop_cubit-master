import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_simple_online_shop_cubit/cubit/theme/theme_cubit.dart';
import 'package:very_simple_online_shop_cubit/data/models/product.dart';
import 'package:very_simple_online_shop_cubit/logic/blocs/product/product_bloc.dart';
import 'package:very_simple_online_shop_cubit/ui/screens/cart_screen.dart';
import 'package:very_simple_online_shop_cubit/ui/screens/favorite_screen.dart';
import 'package:very_simple_online_shop_cubit/ui/screens/order_screen.dart';
import 'package:very_simple_online_shop_cubit/ui/widgets/manage_product.dart';
import 'package:very_simple_online_shop_cubit/ui/widgets/product_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final productBloc = context.read<ProductBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const FavoriteScreen(),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context, themeCubit),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is InitialProductState) {
            productBloc.add(GetProductEvent());
            return const Center(child: Text('Loading products...'));
          } else if (state is LoadingProductState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorProductState) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state is LoadedProductState) {
            return _buildProductList(state.products);
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const ManageProduct(isEdit: false),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, ThemeCubit themeCubit) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildSwitchTile(
            title: 'Dark Mode',
            value: themeCubit.state,
            onChanged: (value) => themeCubit.toggleTheme(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.shopping_cart,
            text: 'Cart',
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const CartScreen(),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.list_alt,
            text: 'Orders',
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const OrderScreen(),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.notifications,
            text: 'Notifications',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
      ),
      accountName: Text(
        'John Doe',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text('johndoe@example.com'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          'JD',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      secondary: Icon(value ? Icons.dark_mode : Icons.light_mode),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  Widget _buildProductList(List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => ProductContainer(
        isFavoriteScreen: false,
        product: products[index],
      ),
    );
  }
}
