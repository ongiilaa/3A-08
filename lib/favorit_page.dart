import 'package:flutter/material.dart';
import 'favorite_model.dart';
import 'cart_model.dart';
import 'check_out_page.dart';
import 'bottom_nav.dart';

String rupiah(int v) => v.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite")),
      body: FavoriteData.items.isEmpty
          ? const Center(child: Text("Favorite kosong"))
          : ListView.builder(
              itemCount: FavoriteData.items.length,
              itemBuilder: (_, i) {
                final item = FavoriteData.items[i];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.asset(item.img, width: 50),
                    title: Text(item.name),
                    subtitle: Text("Rp ${item.price}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        // ADD TO CART
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () {
                            CartData.add(
                              CartItem(
                                img: item.img,
                                name: item.name,
                                price: item.price,
                                quantity: 1,
                              ),
                            );
                          },
                        ),

                        // DELETE FAVORITE
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              FavoriteData.remove(item.name);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

     bottomNavigationBar: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Color(0xFFC7BA9D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Items (${CartData.totalItems})"),
              Text(
                "Total ${rupiah(CartData.totalPrice)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              if (CartData.items.isEmpty) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutPage(
                    items: List.from(CartData.items),
                    name: '',
                  ),
                ),
              );
            },
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE4DCC4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "Checkout",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ),
    const BottomNav(current: 2),
  ],
),
    );
  }
}
