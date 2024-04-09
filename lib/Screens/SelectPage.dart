import 'package:flutter/material.dart';
import 'package:ubixstar_app/Screens/DisplayWidgetPage.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  Map<String, bool> options = {
    'Text Widget': false,
    'Image Widget': false,
    'Button Widget': false,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 210, 237, 211),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...options.keys.map((String option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white, // Set white background color
                      borderRadius: BorderRadius.circular(
                          8), // Optional: Add border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: options[option],
                          onChanged: (bool? value) {
                            setState(() {
                              options[option] = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(option,
                              style: const TextStyle(
                                fontSize: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 10),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayWidget(
                                options: options,
                              ),
                            ));
                      },
                      backgroundColor: const Color.fromARGB(255, 177, 224, 179),
                      foregroundColor: Colors.black,
                      child: const Text(
                        'Import Widgets',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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
