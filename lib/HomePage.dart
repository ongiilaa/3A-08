import 'dart:io';

import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [];

  // ======================
  // LOAD PRODUCTS
  // ======================
  Future loadProducts() async {
    final data = await DatabaseHelper.instance.getProducts();

    setState(() {
      products = data;
    });
  }

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  // ======================
  // DELETE PRODUCT
  // ======================
  Future deleteProduct(int id) async {
    await DatabaseHelper.instance.deleteProduct(id);

    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ======================
      // BOTTOM NAVIGATION
      // ======================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),

        height: 70,

        decoration: const BoxDecoration(
          color: Color(0xFFC7BA9D),

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),

            topRight: Radius.circular(28),
          ),
        ),

        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Icon(Icons.home, size: 28),

            Icon(Icons.favorite_border, size: 28),

            Icon(Icons.shopping_cart_outlined, size: 28),

            Icon(Icons.person_outline, size: 28),
          ],
        ),
      ),

      // ======================
      // FLOATING BUTTON
      // ======================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,

        child: const Icon(Icons.add, color: Colors.white),

        onPressed: () async {
          final result = await Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );

          if (result == true) {
            loadProducts();
          }
        },
      ),

      // ======================
      // BODY
      // ======================
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ======================
            // HEADER
            // ======================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),

              decoration: const BoxDecoration(
                color: Color(0xFFC7BA9D),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),

                  bottomRight: Radius.circular(30),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Grab",

                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const Text(
                    "Your Kopi Sruput",

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 20),

                  // SEARCH BAR
                  Container(
                    height: 45,

                    decoration: BoxDecoration(
                      color: const Color(0xFFE4DCC4),

                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),

                        hintText: "Search",

                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ======================
            // TITLE
            // ======================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Text(
                "Popular Coffee",

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // ======================
            // PRODUCT LIST
            // ======================
            products.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),

                      child: Text("Belum ada product"),
                    ),
                  )
                : SizedBox(
                    height: 250,

                    child: ListView(
                      scrollDirection: Axis.horizontal,

                      padding: const EdgeInsets.only(left: 20),

                      children: products.map((product) {
                        return _productCard(context: context, product: product);
                      }).toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // ======================
  // PRODUCT CARD
  // ======================
  Widget _productCard({
    required BuildContext context,

    required Map<String, dynamic> product,
  }) {
    return GestureDetector(
      // ======================
      // LONG PRESS MENU
      // ======================
      onLongPress: () {
        showModalBottomSheet(
          context: context,

          builder: (_) {
            return Container(
              padding: const EdgeInsets.all(20),

              height: 180,

              child: Column(
                children: [
                  // EDIT
                  ListTile(
                    leading: const Icon(Icons.edit),

                    title: const Text("Edit"),

                    onTap: () async {
                      Navigator.pop(context);

                      final result = await Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => EditProductPage(product: product),
                        ),
                      );

                      if (result == true) {
                        loadProducts();
                      }
                    },
                  ),

                  // DELETE
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),

                    title: const Text("Delete"),

                    onTap: () async {
                      await deleteProduct(product['id']);

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },

      child: Container(
        width: 160,

        margin: const EdgeInsets.only(right: 18),

        decoration: BoxDecoration(
          color: const Color(0xFFE5D8C5),

          borderRadius: BorderRadius.circular(20),
        ),

        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // IMAGE
                  Container(
                    height: 110,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),

                      child: Image.file(
                        File(product['image']),

                        fit: BoxFit.cover,

                        width: double.infinity,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // NAME
                  Text(
                    product['name'],

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // PRICE
                  Text("Rp ${product['price']}"),
                ],
              ),
            ),

            // ADD BUTTON
            Positioned(
              bottom: 12,

              right: 12,

              child: CircleAvatar(
                radius: 14,

                backgroundColor: Colors.black,

                child: const Icon(Icons.add, size: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
