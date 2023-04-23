import 'dart:io';
import 'package:chatapp/Database_Connection/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  TextEditingController fullNamecontroller = TextEditingController();

  File? pickedImage;
  pickImage(source) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: source);
    //pickedImage = File(pickedFile!.path);
    print(pickedFile?.path);
    cropImage(pickedFile);
  }

  cropImage(XFile? pickedFile) async {
    ImageCropper cropper = ImageCropper();
    CroppedFile? croppedFile =
        await cropper.cropImage(sourcePath: pickedFile!.path);
    setState(() {
      pickedImage = File(croppedFile!.path);
    });
  }

  uploadtofirebaseDatabase() async {
    String fullname = fullNamecontroller.text.trim();
    if (fullname != '' && pickedImage != null) {
      print('Full Name Found');
      await UploadtoDatabase(fullname: fullname, image: pickedImage!)
          .uploadtoStorage(context);
    } else {
      print('Please Enter Full Name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                MaterialButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Upload a Pic'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {
                                  pickImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                                title: const Text('Gallery'),
                                leading: const Icon(Icons.photo_album),
                              ),
                              ListTile(
                                onTap: () {
                                  pickImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                                title: const Text('Camera'),
                                leading: const Icon(Icons.camera_alt_rounded),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        pickedImage != null ? FileImage(pickedImage!) : null,
                    radius: 50,
                    child:
                        pickedImage == null ? const Icon(Icons.person) : null,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: fullNamecontroller,
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CupertinoButton(
                  onPressed: () {
                    uploadtofirebaseDatabase();
                  },
                  color: Colors.black26,
                  child: const Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
