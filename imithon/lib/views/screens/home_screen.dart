import 'package:flutter/material.dart';
import 'package:imithon/services/auth_http_services.dart';
import 'package:imithon/services/products_http_services.dart';
import 'package:imithon/views/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final productController = TextEditingController();
  final productsHttpServices = ProductsHttpServices();

  void addProduct() async {
    await productsHttpServices.addProduct(productController.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bosh Sahifa"),
        actions: [
          IconButton(
            onPressed: () {
              AuthHttpServices.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (ctx) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: productController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Mahsulot nomi",
                suffixIcon: IconButton(
                  onPressed: addProduct,
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Mahsulotlar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: productsHttpServices.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final products = snapshot.data;
                  return products == null || products.isEmpty
                      ? const Center(
                          child: Text("Mavjud emas"),
                        )
                      : ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (ctx, index) {
                            return Card(
                              color: Colors.amber,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                  // title: Text(products[index].title),
                                  ),
                            );
                          },
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
