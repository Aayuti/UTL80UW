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
        backgroundColor: Color.fromARGB(255, 218, 239, 219),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...options.keys.map((String option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        options[option] = !options[option]!;
                      });
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(
                            255, 203, 202, 202), // Set white background color
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 10),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.white,
                              child: Container(
                                height: 50,
                                width: 250,
                                decoration: BoxDecoration(),
                                child: Center(
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: options[option]!
                                          ? const Color.fromARGB(
                                              255, 92, 165, 95)
                                          : Color.fromARGB(255, 203, 202, 202),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(option,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
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
