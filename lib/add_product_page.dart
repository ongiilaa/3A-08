import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'database_helper.dart';

class AddProductPage extends StatefulWidget {

  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() =>
      _AddProductPageState();
}

class _AddProductPageState
    extends State<AddProductPage> {

  final nameController =
      TextEditingController();

  final priceController =
      TextEditingController();

  final descController =
      TextEditingController();

  File? imageFile;

  // ======================
  // PICK IMAGE
  // ======================
  Future pickImage() async {

    final picker = ImagePicker();

    final image =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {

      setState(() {

        imageFile = File(image.path);

      });
    }
  }

  // ======================
  // SAVE PRODUCT
  // ======================
  Future saveProduct() async {

    if (imageFile == null) return;

    await DatabaseHelper.instance
        .insertProduct({

      "name": nameController.text,

      "price": int.parse(
        priceController.text,
      ),

      "description":
          descController.text,

      "image": imageFile!.path,
    });

    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget buildInput(
    String hint,
    TextEditingController controller,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(bottom: 16),

      child: TextField(

        controller: controller,

        decoration: InputDecoration(

          hintText: hint,

          filled: true,

          fillColor:
              const Color(0xFFE5D8C5),

          border: OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(16),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Tambah Product",
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(

          child: Column(

            children: [

              buildInput(
                "Nama",
                nameController,
              ),

              buildInput(
                "Harga",
                priceController,
              ),

              buildInput(
                "Deskripsi",
                descController,
              ),

              const SizedBox(height: 20),

              GestureDetector(

                onTap: pickImage,

                child: Container(

                  height: 200,

                  width: double.infinity,

                  decoration: BoxDecoration(

                    color:
                        const Color(0xFFE5D8C5),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: imageFile != null

                      ? ClipRRect(

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),

                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          ),
                        )

                      : const Icon(
                          Icons.add_a_photo,
                          size: 50,
                        ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: saveProduct,

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.black,

                    foregroundColor:
                        Colors.white,

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),

                  child: const Text(
                    "Simpan",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}