import 'package:flutter/material.dart';
import 'package:ubixstar_app/Screens/SelectPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Assignment App'),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              children: [
                Container(
                  height: 500,
                  width: 350,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 177, 224, 179),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Center(
                      child: Text(
                    'No widget added',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
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
                                builder: (context) => const SelectPage(),
                              ));
                        },
                        backgroundColor:
                            const Color.fromARGB(255, 177, 224, 179),
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
          )),
    );
  }
}
