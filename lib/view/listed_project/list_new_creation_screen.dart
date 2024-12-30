import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:projecthub/config/data_file.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/model/categories_info_model.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

class ListNewCreationScreen extends StatefulWidget {
  const ListNewCreationScreen({super.key});

  @override
  State<ListNewCreationScreen> createState() => _ListNewCreationScreenState();
}

class _ListNewCreationScreenState extends State<ListNewCreationScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _filePathController = TextEditingController();
  List<CategoryModel> _categories = [];
  bool _showCategories = false;
  List<CategoryModel> _filteredCategories = [];
  List<String> _keywords = [];
  String? selectedFileName;

  @override
  void initState() {
    super.initState();
    _filePathController.text = "No file selected";
    _filteredCategories = _categories;
    _categoryController.addListener(() {
      setState(() {
        _filteredCategories = _categories
            .where((category) => category.name!
                .toLowerCase()
                .contains(_categoryController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _keywordController.dispose();
    _filePathController.dispose();
    super.dispose();
  }

  Future<void> pickZipFile() async {
    // Use file_picker to pick a ZIP file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'], // Restrict file type to ZIP
    );

    if (result != null) {
      String? filePath = result.files.single.path;

      if (filePath != null && filePath.endsWith('.zip')) {
        setState(() {
          selectedFileName = path.basename(filePath);
          _filePathController.text =
              path.basename(filePath); // Extract file name
        });
      } else {
        setState(() {
          Get.snackbar("File not selected",
              "Invalid file type. Please select a ZIP file..");

          selectedFileName = null;
          _filePathController.text = "";
        });
      }
    } else {
      // User canceled the picker
      Get.snackbar("File not selected", "File selection was canceled.");
    }
  }

  void _addKeyword(String keyword) {
    if (keyword.isNotEmpty && !_keywords.contains(keyword)) {
      setState(() {
        _keywords.add(keyword.trim());
      });
      _keywordController.clear();
    }
  }

  void _removeKeyword(String keyword) {
    setState(() {
      _keywords.remove(keyword);
    });
  }

  Future<bool> _showSaveConfirmationDialog(BuildContext context) async {
    bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Changes?'),
          content: const Text(
              'You have unsaved changes. Do you want to leave without saving?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User does not want to save
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
    return shouldSave ?? false; // Default to false if null
  }

  getData() {
    _categories = Provider.of<DataFileProvider>(context).categories;
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return WillPopScope(
      onWillPop: () async {
        // Show the save confirmation dialog
        bool shouldSave = await _showSaveConfirmationDialog(context);
        if (shouldSave) {
          // Perform save operation here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saving changes...')),
          );
        }
        return shouldSave; // Allow or block navigation
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              alignment: Alignment.center,
              onPressed: () {
                _showSaveConfirmationDialog(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              )),
          title: const Text("List new creation"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
          child: ListView(
            children: [
              SizedBox(height: Get.height * 0.02),
              getThumbnailView(),
              SizedBox(height: Get.height * 0.04),
              getInformationForm(),
              SizedBox(height: Get.height * 0.04),
              _getCategoryForm(),
              SizedBox(height: Get.height * 0.02),
              _getSubmitButton(),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeaddinfText(String str) {
    return Text(
      str,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        //fontFamily: 'Gilroy',
      ),
    );
  }

  getThumbnailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getHeaddinfText("Thumbnail"),
        SizedBox(height: Get.height * 0.01),
        DottedBorder(
          color: AppColor.primaryColor, // Border color
          strokeWidth: 2, // Border width
          dashPattern: const [6, 4], // Dash and space pattern
          borderType: BorderType.RRect,
          radius: const Radius.circular(12), // Rounded corners
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 234, 237, 250),
                borderRadius: BorderRadius.circular(12)),
            width: double.infinity, // Width of the container
            height: Get.height * 0.18, // Height of the container
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  'Add Thumbnail',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getInformationForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Listing details",
            style: AppText.bigHeddingStyle1a,
          ),
          const Text(
            "Provide all the necessary information about your iterm to create an attractive listing and reach more buyers",
            style: TextStyle(fontSize: 11, color: Colors.black87),
          ),
          SizedBox(height: Get.height * 0.028),
          getHeaddinfText("Product name"),
          SizedBox(height: Get.height * 0.01),
          _getInfoTextField(controller: _productNameController),
          SizedBox(height: Get.height * 0.028),
          getHeaddinfText("Description"),
          SizedBox(height: Get.height * 0.01),
          _getInfoTextField(controller: _descriptionController, maxLines: 4),
          SizedBox(height: Get.height * 0.028),
          getHeaddinfText("Price"),
          SizedBox(height: Get.height * 0.01),
          _getInfoTextField(
            controller: _priceController,
            isNumeric: true,
            prfixIcon: const Text("₹"),
          ),
          SizedBox(height: Get.height * 0.028),
          getHeaddinfText("Select file"),
          SizedBox(height: Get.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (Get.width - 2 * AppPadding.edgePadding) * 0.6,
                child: _getInfoTextField(
                    controller: _filePathController, readOnly: true),
              ),
              SizedBox(width: Get.width * 0.012),
              AppPrimaryButton(
                title: "Pick ZIP file",
                onTap: pickZipFile,
                icon: const Icon(
                  Icons.folder,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _getInfoTextField({
    TextEditingController? controller,
    int? maxLines,
    Widget? prfixIcon,
    bool? isNumeric,
    bool? readOnly,
  }) {
    return TextFormField(
      onTapOutside: (p) {
        setState(() {
          FocusScope.of(context).unfocus();
        });
      },
      controller: controller,
      readOnly: (readOnly != null) ? readOnly : false,
      maxLines: maxLines,
      keyboardType:
          (isNumeric != null && isNumeric) ? TextInputType.number : null,
      decoration: InputDecoration(
        //hintText: 'Password',
        prefixIcon: (prfixIcon != null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prfixIcon,
                ],
              )
            : null,
        hintStyle: AppText.textFieldHintTextStyle,
        focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
        errorBorder: AppTextfieldBorder.errorBorder,
        focusedBorder: AppTextfieldBorder.focusedBorder,
        enabledBorder: AppTextfieldBorder.enabledBorder,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.only(
          left: 20.w,
          top: 10.h,
          bottom: 10.h,
          right: 20.w,
        ),
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return "Product name should not empty";
        }
        return null;
      },
    );
  }

  _getCategoryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category details",
          style: AppText.bigHeddingStyle1a,
        ),
        const Text(
          "Provide category details that helps others to find your creation easly",
          style: TextStyle(fontSize: 11, color: Colors.black87),
        ),
        SizedBox(height: Get.height * 0.028),
        getHeaddinfText("Category"),
        SizedBox(height: Get.height * 0.01),
        TextFormField(
          onTapOutside: (p) {
            setState(() {
              //_showCategories = false;
              // FocusScope.of(context).unfocus();
            });
          },
          onTap: () {
            setState(() {
              _showCategories = true;
            });
          },
          onChanged: (value) {
            setState(() {
              _showCategories = true;
            });
          },
          //readOnly: true,
          controller: _categoryController,
          decoration: InputDecoration(
              hintText: "--- Select ---",
              focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
              errorBorder: AppTextfieldBorder.errorBorder,
              focusedBorder: AppTextfieldBorder.focusedBorder,
              enabledBorder: AppTextfieldBorder.enabledBorder,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding: EdgeInsets.only(
                left: 20.w,
                top: 10.h,
                bottom: 10.h,
                right: 20.w,
              ),
              suffixIcon: const Icon(Icons.arrow_drop_down)),
        ),
        if (_showCategories)
          Container(
            decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            height: Get.height * 0.35,
            child: ListView.builder(
              itemCount: _filteredCategories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredCategories[index].name!),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _categoryController.text =
                          _filteredCategories[index].name!;
                      _showCategories = false;
                    });
                  },
                );
              },
            ),
          ),
        SizedBox(height: Get.height * 0.03),
        getHeaddinfText("Keywords"),
        const Text(
          "Please press enter while specifying multiple skills. Skills separated by comma or space will be considered as a single entity.",
          style: TextStyle(fontSize: 11, color: Colors.black87),
        ),
        SizedBox(height: Get.height * 0.01),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onTapOutside: (p) {
                _addKeyword(_keywordController.text);
                FocusScope.of(context).unfocus();
              },
              controller: _keywordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: EdgeInsets.only(
                  left: 20.w,
                  top: 10.h,
                  bottom: 10.h,
                  right: 20.w,
                ),
                hintText: 'Enter a keyword and press Enter',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                errorBorder: AppTextfieldBorder.errorBorder,
                focusedBorder: AppTextfieldBorder.focusedBorder,
                enabledBorder: AppTextfieldBorder.enabledBorder,
              ),
              onSubmitted: _addKeyword,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0, // Space between tags horizontally
              runSpacing: 4.0, // Space between tags vertically
              children: _keywords.map((keyword) {
                return Chip(
                  label: Text(keyword),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _removeKeyword(keyword),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  _getSubmitButton() {
    return Row(
      children: [
        AppPrimaryButton(title: "Submit", onTap: () {}),
      ],
    );
  }
}
