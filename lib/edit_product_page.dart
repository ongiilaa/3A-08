import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'database_helper.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameController;

  late TextEditingController priceController;

  late TextEditingController descController;

  File? imageFile;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product['name']);

    priceController = TextEditingController(
      text: widget.product['price'].toString(),
    );

    descController = TextEditingController(text: widget.product['description']);

    imageFile = File(widget.product['image']);
  }

  // ======================
  // PICK IMAGE
  // ======================
  Future pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  // ======================
  // UPDATE PRODUCT
  // ======================
  Future updateProduct() async {
    await DatabaseHelper.instance.updateProduct(widget.product['id'], {
      "name": nameController.text,

      "price": int.parse(priceController.text),

      "description": descController.text,

      "image": imageFile!.path,
    });

    Navigator.pop(context);
  }

  Widget buildInput(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextField(
        controller: controller,

        decoration: InputDecoration(
          hintText: hint,

          filled: true,

          fillColor: const Color(0xFFE5D8C5),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            children: [
              buildInput("Nama", nameController),

              buildInput("Harga", priceController),

              buildInput("Deskripsi", descController),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: pickImage,

                child: Container(
                  height: 200,

                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: const Color(0xFFE5D8C5),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: Image.file(imageFile!, fit: BoxFit.cover),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: updateProduct,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,

                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),

                  child: const Text("Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
