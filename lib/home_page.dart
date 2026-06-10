import 'package:flutter/material.dart';

import 'favorite_model.dart';
import 'non_pop_coffee.dart';
import 'pop_coffe.dart';
import 'product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> allProducts = [
    {
      "img": "assets/images/coffee1.png",
      "name": "Kopi Sruput 1",
      "price": "6000",
    },
    {
      "img": "assets/images/coffee2.png",
      "name": "Kopi Sruput 2",
      "price": "8000",
    },
    {
      "img": "assets/images/coffee3.png",
      "name": "Kopi Sruput 3",
      "price": "10000",
    },
    {"img": "assets/images/matcha1.png", "name": "Green Tea", "price": "6000"},
    {
      "img": "assets/images/coklat1.png",
      "name": "Choco Latte",
      "price": "6000",
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(allProducts);
    searchController.addListener(() {
      filterSearch(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(allProducts);
      } else {
        filteredProducts = allProducts
            .where(
              (item) => item["name"].toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/home"),
              child: const Icon(Icons.home, size: 28),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/favorite"),
              child: const Icon(Icons.favorite_border, size: 28),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/cart"),
              child: const Icon(Icons.shopping_cart_outlined, size: 28),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/profile"),
              child: const Icon(Icons.person_outline, size: 28),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFFC7BA9D),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Grab",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your Kopi Sruput",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4DCC4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Popular Coffee",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            if (searchController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: filteredProducts.map((item) {
                    return ListTile(
                      leading: Image.asset(item["img"], width: 45),
                      title: Text(item["name"]),
                      trailing: Text("Rp ${item["price"]}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductPage(
                              img: item["img"],
                              name: item["name"],
                              price: int.tryParse(item["price"]) ?? 0,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            if (searchController.text.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _categoryButton("Coffee", true),
                    const SizedBox(width: 10),
                    _categoryButton("Non Coffee", false),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _sectionTitle(
                title: "Popular Coffee",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PopularCoffeePage()),
                ),
              ),
              const SizedBox(height: 15),
              _horizontalList([allProducts[0], allProducts[1], allProducts[2]], context),
              const SizedBox(height: 25),
              _sectionTitle(
                title: "Popular Non Coffee",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PopularNonCoffeePage()),
                ),
              ),
              const SizedBox(height: 15),
              _horizontalList([allProducts[3], allProducts[4]], context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: onTap,
            child: const Text(
              "See All",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _horizontalList(List<Map<String, dynamic>> items, BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          return _productCard(
            context: context,
            img: item["img"],
            name: item["name"],
            price: item["price"],
          );
        },
      ),
    );
  }

  Widget _categoryButton(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFC7BA9D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC7BA9D)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _productCard({
    required BuildContext context,
    required String img,
    required String name,
    required String price,
  }) {
    final isFavorite = FavoriteData.isFavorite(name);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductPage(
              img: img,
              name: name,
              price: int.tryParse(price) ?? 0,
            ),
          ),
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
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        img,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text("Rp $price"),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    final item = FavoriteItem(
                      img: img,
                      name: name,
                      price: int.tryParse(price) ?? 0,
                    );
                    FavoriteData.toggle(item);
                  });
                },
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isFavorite ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ),
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
