import 'dart:io';
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
    if (widget.options['Image Widget'] == true &&
        widget.options['Button Widget'] == true &&
        widget.options['Text Widget'] == false) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration:
                  InputDecoration(labelText: 'File url will appear here'),
              readOnly: true,
              controller: TextEditingController(text: _selectedFile.path),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _selectedFile.path.isNotEmpty
                ? Container(
                    height: 200, // Adjust height as needed
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: _selectedFile.path.startsWith('http')
                          ? Image.network(_selectedFile.path)
                          : Image.file(_selectedFile),
                    ),
                  )
                : Text('No image selected'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _selectFile,
                child: Text('Select File'),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 205, 237, 205),
                  foregroundColor: Colors.black,
                ),
                onPressed: _saveImage,
                child: Text('Save'),
              ),
            ),
          ),
        ],
      );
    } else if (widget.options['Image Widget'] == false &&
        widget.options['Button Widget'] == true &&
        widget.options['Text Widget'] == true) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Enter text'),
              controller: _selectedText,
            ),
          ),
          Center(
            child: SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 205, 237, 205),
                  foregroundColor: Colors.black,
                ),
                onPressed: _saveData,
                child: Text('Save'),
              ),
            ),
          ),
        ],
      );
    } else if (widget.options['Text Widget'] == true &&
        widget.options['Image Widget'] == true &&
        widget.options['Button Widget'] == true) {
      content = Column(
        children: [
          // Textfield
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Enter text'),
              controller: _selectedText,
            ),
          ),
          // Image url textfield
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration:
                  InputDecoration(labelText: 'File url will appear here'),
              readOnly: true,
              controller: TextEditingController(text: _selectedFile.path),
            ),
          ),

          //to display image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _selectedFile.path.isNotEmpty
                ? Container(
                    height: 200, // Adjust height as needed
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: _selectedFile.path.startsWith('http')
                          ? Image.network(_selectedFile.path)
                          : Image.file(_selectedFile),
                    ),
                  )
                : Text('No image selected'),
          ),
          //select file button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _selectFile,
                child: Text('Select File'),
              ),
            ),
          ),
          //save text button
          Center(
            child: SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 205, 237, 205),
                  foregroundColor: Colors.black,
                ),
                onPressed: _saveData,
                child: Text('Save text'),
              ),
            ),
          ),
          //save image button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 205, 237, 205),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _saveImage,
                  child: Text('Save image'),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 205, 237, 205),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content:
                            Text('At least one widget needs to be selected.'),
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
                },
                child: Text('Save'),
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
                          ));
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
        title: Text('Display Widgets'),
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
          SnackBar(content: Text('Sucessfully added')),
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
