import 'package:attendence_system/screens/printing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PrintingAndPercentScreen extends StatefulWidget {
  const PrintingAndPercentScreen({super.key});

  @override
  State<PrintingAndPercentScreen> createState() =>
      _PrintingAndPercentScreenState();
}

class _PrintingAndPercentScreenState extends State<PrintingAndPercentScreen> {
  final studentData =
      FirebaseFirestore.instance.collection('User_Details').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peroformance Screen'),
         leading:
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                )
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: studentData,
              builder: (context, snapshot) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: ListView.builder(
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator.adaptive();
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                              child: Text('No Data'),
                            );
                          } else {
                            if (snapshot.data!.docs[index]['Present'] == null ||
                                snapshot.data!.docs[index]['name'] == null) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }
                            debugPrint(snapshot.data!.docs.toString());
                            final present = snapshot
                                    .data?.docs[index]['Present']
                                    .toString() ??
                                '';
                            final name =
                                snapshot.data?.docs[index]['name'].toString() ??
                                    '';

                            return ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PrintingScreen(
                                                name: snapshot
                                                    .data!.docs[index]['name']
                                                    .toString(),
                                                present: snapshot.data!
                                                    .docs[index]['Present'],
                                                absent: snapshot.data!
                                                    .docs[index]['Absent'],
                                                leaves: snapshot.data!
                                                    .docs[index]['Leaves'],
                                                time: snapshot.data!.docs[index]
                                                    ['Day'],
                                                createdAt: snapshot.data!
                                                    .docs[index]['createdAt'],
                                              )));
                                },
                                title: Text(name),
                                subtitle: Text('Present $present'),
                                trailing: snapshot.data!.docs[index]
                                            ['Present'] >=
                                        26
                                    ? CircularPercentIndicator(
                                        radius: 15,
                                        lineWidth: 3,
                                        animation: true,
                                        percent: 0.7,
                                        progressColor: Colors.green,
                                        backgroundColor: Colors.grey,
                                        center: const Center(
                                          child: Text(
                                            "70%",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      )
                                    : snapshot.data!.docs[index]['Present'] >=
                                            20
                                        ? CircularPercentIndicator(
                                            radius: 15,
                                            lineWidth: 3,
                                            animation: true,
                                            percent: 0.5,
                                            progressColor: Colors.green,
                                            backgroundColor: Colors.grey,
                                            center: const Center(
                                              child: Text(
                                                "80%",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          )
                                        : snapshot.data!.docs[index]
                                                    ['Present'] >=
                                                15
                                            ? CircularPercentIndicator(
                                                radius: 15,
                                                lineWidth: 3,
                                                animation: true,
                                                percent: 0.5,
                                                progressColor: Colors.yellow,
                                                backgroundColor: Colors.grey,
                                                center: const Center(
                                                  child: Text(
                                                    "50%",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ),
                                              )
                                            : snapshot.data!.docs[index]
                                                        ['Present'] >=
                                                    10
                                                ? CircularPercentIndicator(
                                                    radius: 15,
                                                    lineWidth: 3,
                                                    animation: true,
                                                    percent: 0.3,
                                                    progressColor: Colors.red,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    center: const Center(
                                                      child: Text(
                                                        "30%",
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  )
                                                : CircularPercentIndicator(
                                                    radius: 15,
                                                    lineWidth: 3,
                                                    animation: true,
                                                    percent: 0.1,
                                                    progressColor: Colors.red,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    center: const Center(
                                                      child: Text(
                                                        "10%",
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ));
                          }
                        }),
                  ),
                );
              })
        ],
      ),
    );
  }
}
