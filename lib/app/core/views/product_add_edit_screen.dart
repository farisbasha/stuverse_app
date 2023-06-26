import 'dart:io';

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/auth/models/user.dart';
import 'package:stuverse_app/app/core/cubit/main_page_cubit.dart';
import 'package:stuverse_app/app/core/models/product_category.dart';
import 'package:stuverse_app/app/core/views/main_page.dart';
import 'package:stuverse_app/app/core/widgets/svg_asset_image.dart';
import 'package:stuverse_app/app/home/cubit/home_cubit.dart';
import 'package:stuverse_app/utils/app_images.dart';

import 'package:stuverse_app/utils/common_utils.dart';

import '../cubit/product_add_edit/product_add_edit_cubit.dart';
import '../models/product.dart';
import '../widgets/ai_description_dialogue.dart';

class ProductAddEditScreen extends StatefulWidget {
  const ProductAddEditScreen({super.key, this.product});
  final Product? product;

  @override
  State<ProductAddEditScreen> createState() => _ProductAddEditScreenState();
}

class _ProductAddEditScreenState extends State<ProductAddEditScreen> {
  late User _user;

  late final List<ProductCategory> categoryList;
  List<ProductCategory> _selectedCategoryList = [];
  @override
  void initState() {
    super.initState();
    _user = (context.read<AuthCubit>().state as AuthSuccess).user;
    categoryList = (context.read<HomeCubit>().state as HomeLoaded).categoryList;

    if (widget.product != null) {
      _titleController.text = widget.product!.title;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _selectedCategoryList = widget.product!.categories;
      _isActive = widget.product!.isActive;
    }
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isActive = false;

  File? _image;
  final _picker = ImagePicker();

  Future getImage({
    required ImageSource source,
  }) async {
    final pickedFile = await _picker.pickImage(
        source: source, imageQuality: 80, maxHeight: 400, maxWidth: 400);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? "Add Product" : "Edit Product"),
      ),
      body: BlocConsumer<ProductAddEditCubit, ProductAddEditState>(
        listener: (context, state) {
          if (state is ProductAddEditError) {
            CommonUtils.showSnackbar(context,
                message: state.message, isError: true);
          }
          if (state is ProductAddEditSuccess) {
            CommonUtils.showSnackbar(
              context,
              message: widget.product == null
                  ? "Product added successfully"
                  : "Product updated successfully",
            );

            context.read<MainPageCubit>().updateSelectedIndex(0);
            CommonUtils.navigatePushReplacementAll(context, const MainPage());
          }
        },
        builder: (context, state) {
          return IgnorePointer(
            ignoring: state is ProductAddEditLoading,
            child: Form(
              key: _formKey,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text("Camera"),
                                        onTap: () {
                                          getImage(source: ImageSource.camera);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.photo),
                                        title: const Text("Gallery"),
                                        onTap: () {
                                          getImage(source: ImageSource.gallery);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : widget.product != null
                                      ? NetworkImage(widget.product!.image)
                                          as ImageProvider
                                      : null,
                              child: ClipOval(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _image == null &&
                                                widget.product == null
                                            ? theme.colorScheme.primaryContainer
                                            : theme.colorScheme.background
                                                .withOpacity(0.7),
                                      ),
                                      height: _image == null &&
                                              widget.product == null
                                          ? double.infinity
                                          : 30,
                                      width: double.infinity,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: _image == null &&
                                                widget.product == null
                                            ? 25
                                            : 15,
                                        color: theme.colorScheme.onBackground,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Title is required';
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.book),
                            labelText: 'Name',
                            hintText: 'Product Name',
                          ),
                        ),
                        const SizedBox(height: 14),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            TextFormField(
                              controller: _descriptionController,
                              validator: (value) {
                                if (value!.length < 20) {
                                  return 'Atleast 20 characters';
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.description),
                                labelText: 'Description',
                                hintText: 'Description',
                              ),
                              maxLines: 5,
                              maxLength: 1500,
                            ),
                            Positioned(
                                top: -10,
                                right: -10,
                                child: InkWell(
                                  onTap: () {
                                    if (_titleController.text.isEmpty) {
                                      CommonUtils.showSnackbar(context,
                                          message:
                                              "Please enter title to use AI",
                                          isError: true);
                                      return;
                                    }
                                    showAdaptiveDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AIDescriptionDialogue(
                                            title: _titleController.text,
                                            descriptionController:
                                                _descriptionController,
                                          );
                                        });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.colorScheme.primary,
                                            theme.colorScheme.tertiary,
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                              FontAwesomeIcons
                                                  .wandMagicSparkles,
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              size: 15),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Use AI",
                                            style:
                                                textTheme.titleMedium!.copyWith(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                          ),
                                        ],
                                      )),
                                ))
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _priceController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Price is required';
                            }
                            try {
                              final price = double.parse(value);
                              if (price < 0) {
                                return 'Price must be greater than 0';
                              }
                              if (price > 100000) {
                                return 'Price must be less than 100000';
                              }
                            } catch (e) {
                              return 'Price must be a number';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.monetization_on),
                            labelText: 'Price',
                            hintText: 'Enter Desired Price',
                          ),
                        ),
                        const SizedBox(height: 14),
                        //Text Category
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Categories",
                                    style: textTheme.titleMedium,
                                  ),
                                  Spacer(),
                                  TextButton.icon(
                                    onPressed: () {
                                      openSelectCategoryDialogue();
                                    },
                                    icon: const Icon(Icons.add),
                                    label: Text("Add Category"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final category in _selectedCategoryList)
                                    Chip(
                                      label: Text(category.name),
                                      onDeleted: () {
                                        setState(() {
                                          _selectedCategoryList
                                              .remove(category);
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        //A tick box to whether to show contact details or not
                        StatefulBuilder(builder: (context, setShowContact) {
                          return Row(
                            children: [
                              Checkbox(
                                value: _isActive,
                                onChanged: (value) {
                                  setShowContact(() {
                                    _isActive = value!;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text(
                                    "Tick this box to make your product visible to others"),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 14),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 50,
                            child: FilledButton(
                              onPressed: () {
                                if (_selectedCategoryList.isEmpty) {
                                  CommonUtils.showSnackbar(context,
                                      message:
                                          "Please select atleast one category",
                                      isError: true);
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  if (widget.product == null) {
                                    if (_image == null) {
                                      CommonUtils.showSnackbar(context,
                                          message: "Please select an  image",
                                          isError: true);
                                      return;
                                    }

                                    context
                                        .read<ProductAddEditCubit>()
                                        .addProduct(
                                            title: _titleController.text,
                                            description:
                                                _descriptionController.text,
                                            price: double.parse(
                                                    _priceController.text)
                                                .toStringAsFixed(2),
                                            isActive: _isActive,
                                            categoryIds: _selectedCategoryList
                                                .map((e) => e.id)
                                                .toList(),
                                            image: _image!,
                                            sellerId: _user.id);
                                  } else {
                                    context
                                        .read<ProductAddEditCubit>()
                                        .editProduct(
                                            title: _titleController.text,
                                            description: _descriptionController
                                                .text,
                                            price:
                                                double.parse(
                                                        _priceController.text)
                                                    .toStringAsFixed(2),
                                            isActive: _isActive,
                                            categoryIds: _selectedCategoryList
                                                .map((e) => e.id)
                                                .toList(),
                                            image: _image,
                                            sellerId: _user.id,
                                            id: widget.product!.id);
                                  }
                                }
                              },
                              child: state is ProductAddEditLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    )
                                  : Text(
                                      widget.product != null ? "Update" : "Add",
                                      style: textTheme.titleMedium!.copyWith(
                                          color: theme.colorScheme.onPrimary),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openSelectCategoryDialogue() async {
    await FilterListDialog.display<ProductCategory>(
      context,
      listData: categoryList,
      selectedListData: _selectedCategoryList,
      choiceChipLabel: (category) => category!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (categry, query) {
        return categry.name.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          _selectedCategoryList = List.from(list!);
        });

        Navigator.pop(context);
      },
      themeData: FilterListThemeData(context,
          backgroundColor: Theme.of(context).colorScheme.surface,
          headerTheme: const HeaderThemeData(),
          controlButtonBarTheme: ControlButtonBarThemeData(
            context,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            controlButtonTheme: ControlButtonThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              primaryButtonBackgroundColor:
                  Theme.of(context).colorScheme.primary,
              primaryButtonTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          choiceChipTheme: ChoiceChipThemeData(
            selectedBackgroundColor:
                Theme.of(context).colorScheme.secondaryContainer,
            backgroundColor: Theme.of(context).colorScheme.background,
            selectedTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          )),
    );
  }
}
