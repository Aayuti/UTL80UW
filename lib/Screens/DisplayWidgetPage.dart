import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ubixstar_app/Screens/SelectPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DisplayWidget extends StatefulWidget {
  final Map<String, bool> options;

  const DisplayWidget({Key? key, required this.options}) : super(key: key);

  @override
  _DisplayWidgetState createState() => _DisplayWidgetState();
}

class _DisplayWidgetState extends State<DisplayWidget> {
  TextEditingController _selectedText = TextEditingController();
  late File _selectedFile;
  bool isVisible = false;

  void initState() {
    super.initState();
    _selectedFile = File('');
    _loadData();
  }

  Future<void> _selectFile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    } else {
      // User canceled image picker
    }
  }

  Future<void> _saveImage() async {
    try {
      if (_selectedFile != null) {
        print('Selected file: $_selectedFile');
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('images')
            .child('image_${DateTime.now().millisecondsSinceEpoch}.jpg');
        UploadTask uploadImage = ref.putFile(_selectedFile);

        //download link
        TaskSnapshot snapshot = await uploadImage.whenComplete(() => null);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('text data').add({
          'image url': downloadUrl,
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       'Image uploaded',
        //       style: TextStyle(color: Color.fromARGB(255, 61, 115, 63)),
        //     ),
        //     backgroundColor: const Color.fromARGB(255, 173, 255, 176),
        //   ),
        // );

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('Image uploaded'),
                  content: Text('Image url is : $downloadUrl'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ]);
            });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please select an image first.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    // bool isVisible = false;

    if (widget.options['Image Widget'] == true &&
        widget.options['Button Widget'] == true &&
        widget.options['Text Widget'] == false) {
      content = Column(
        children: [
          // Textfield
          Container(
            height: 600,
            width: 350,
            color: Color.fromARGB(255, 212, 251, 214),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 250,
                    width: 250,
                    color: const Color.fromARGB(255, 212, 204, 204),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: Text('Upload image'),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: 150,
                              width: 250,
                              color: Color.fromARGB(255, 212, 204, 204),
                              child: _selectedFile.path.isNotEmpty
                                  ? Container(
                                      height: 200, // Adjust height as needed
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: _selectedFile.path
                                                .startsWith('http')
                                            ? Image.network(_selectedFile.path)
                                            : Image.file(_selectedFile),
                                      ),
                                    )
                                  : null,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 212, 251, 214),
                          elevation: 0,
                          foregroundColor: Color.fromARGB(255, 212, 251, 214)),
                      onPressed: _selectFile,
                      child: Text('Select File'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 167, 254, 167),
                        foregroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          // Use RoundedRectangleBorder for sharp corners
                          borderRadius: BorderRadius
                              .zero, // Set borderRadius to zero for sharp edges
                        ),
                        side: const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      onPressed: _saveImage,
                      child: Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(32.0),
            child: SizedBox(
              width: 200,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectPage(),
                      ),
                    );
                  },
                  backgroundColor: const Color.fromARGB(255, 177, 224, 179),
                  foregroundColor: Colors.black,
                  child: const Text(
                    'Add widget',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (widget.options['Image Widget'] == false &&
        widget.options['Button Widget'] == true &&
        widget.options['Text Widget'] == true) {
      content = SingleChildScrollView(
        child: Column(
          children: [
            // Textfield
            Container(
              height: 600,
              width: 350,
              color: Color.fromARGB(255, 212, 251, 214),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 50,
                      width: 250,
                      color: const Color.fromARGB(255, 212, 204, 204),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 5),
                        child: TextFormField(
                          decoration:
                              const InputDecoration(hintText: 'Enter text'),
                          controller: _selectedText,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 250, bottom: 0),
                    child: SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 167, 254, 167),
                          foregroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            // Use RoundedRectangleBorder for sharp corners
                            borderRadius: BorderRadius
                                .zero, // Set borderRadius to zero for sharp edges
                          ),
                          side:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        onPressed: _saveData,
                        child: Text('Save'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(32.0),
              child: SizedBox(
                width: 200,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectPage(),
                        ),
                      );
                    },
                    backgroundColor: const Color.fromARGB(255, 177, 224, 179),
                    foregroundColor: Colors.black,
                    child: const Text(
                      'Add widget',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (widget.options['Text Widget'] == true &&
        widget.options['Image Widget'] == true &&
        widget.options['Button Widget'] == true) {
      content = Column(
        children: [
          // Textfield
          Container(
            height: 600,
            width: 350,
            color: Color.fromARGB(255, 212, 251, 214),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 50,
                    width: 250,
                    color: const Color.fromARGB(255, 212, 204, 204),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Enter text', border: InputBorder.none),
                        controller: _selectedText,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 250,
                    width: 250,
                    color: const Color.fromARGB(255, 212, 204, 204),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text('Upload image'),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: 150,
                              width: 250,
                              color: Color.fromARGB(255, 212, 204, 204),
                              child: _selectedFile.path.isNotEmpty
                                  ? Container(
                                      height: 200, // Adjust height as needed
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: _selectedFile.path
                                                .startsWith('http')
                                            ? Image.network(_selectedFile.path)
                                            : Image.file(_selectedFile),
                                      ),
                                    )
                                  : null,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 212, 251, 214),
                          elevation: 0,
                          foregroundColor: Color.fromARGB(255, 212, 251, 214)),
                      onPressed: _selectFile,
                      child: Text('Select File'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 167, 254, 167),
                        foregroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          // Use RoundedRectangleBorder for sharp corners
                          borderRadius: BorderRadius
                              .zero, // Set borderRadius to zero for sharp edges
                        ),
                        side: const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      onPressed: _saveImage,
                      child: Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 450,
              width: 350,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 222, 255, 224),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Container(
                      height: 100,
                      width: 150,
                      color: Color.fromARGB(255, 222, 255, 224),
                      child: Visibility(
                        visible: isVisible,
                        child: const Text(
                          'Add at-least a widget to save',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 167, 254, 167),
                          foregroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            // Use RoundedRectangleBorder for sharp corners
                            borderRadius: BorderRadius
                                .zero, // Set borderRadius to zero for sharp edges
                          ),
                          side:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        onPressed: () {
                          setState(() {
                            isVisible = true;
                          });
                          print('on press Working');
                          print('Value of isVisible: $isVisible');
                        },
                        child: Text('Save'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(32.0),
              child: SizedBox(
                width: 200,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectPage(),
                        ),
                      );
                    },
                    backgroundColor: const Color.fromARGB(255, 177, 224, 179),
                    foregroundColor: Colors.black,
                    child: const Text(
                      'Add widget',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment App'),
      ),
      body: Center(
        child: content,
      ),
    );
  }

  void _saveData() {
    String textValue = _selectedText.text;

    if (textValue.isNotEmpty) {
      FirebaseFirestore.instance.collection('text data').add({
        'text info': textValue,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sucessfully added',
              style: TextStyle(color: Color.fromARGB(255, 61, 115, 63)),
            ),
            backgroundColor: const Color.fromARGB(255, 173, 255, 176),
          ),
        );
      }).catchError((error) {
        print('Failed to add data: $error');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Text field is empty')),
      );
    }
  }

  void _loadData() {
    FirebaseFirestore.instance
        .collection('text data')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.exists && doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;
          if (data['text info'] != null) {
            setState(() {
              _selectedText.text = data['text info'];
            });
          }
        }
      });
    }).catchError((error) {
      print('Failed to load data : $error');
    });
  }
}
