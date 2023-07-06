import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallet_app/Database/database.dart';
import 'package:wallet_app/pages/tile.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  Database db = Database();
  final mybox = Hive.box('mybox');

  TextEditingController balancecontroller = TextEditingController();
  TextEditingController expensetitlecontroller = TextEditingController();
  TextEditingController expenseamountcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    if (mybox.get('list') != null) {
      db.load();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.30,
            0.20,
            0.50,
          ],
          colors: [
            Color.fromARGB(255, 23, 183, 189),
            Color.fromARGB(235, 255, 255, 255),
            Color.fromARGB(235, 255, 255, 255)
          ],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: addexpensedialog,
          backgroundColor: const Color.fromARGB(255, 23, 183, 189),
          child: const Icon(Icons.monetization_on),
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Wallet",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: const Text("About"),
                                  content: const Text(
                                      "Developed by: \n    Ahmad Muhammad\nEmail:\n    ahmadnwz32@gmail.com\n\n\n           App Version 1.0.0"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("OK"),
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 34,
                      ))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 30,
                            spreadRadius: 10,
                          )
                        ]),
                    height: 220,
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Available Balance",
                          style: TextStyle(
                            color: Color.fromARGB(255, 23, 183, 189),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Rs. ${db.balance}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 23, 183, 189),
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                child: Text('Add Balance'),
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 23, 183, 189),
                                ),
                                onPressed: () {
                                  addbalancedialog();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                child: Text('Clean Wallet'),
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 206, 61, 61),
                                ),
                                onPressed: () {
                                  setState(() {
                                    db.balance = 0;
                                    db.expenses.clear();
                                    db.update();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: db.expenses.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      // Specify the direction to swipe and delete
                      direction: DismissDirection.endToStart,
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        // Removes that item the list on swipwe
                        setState(() {
                          db.expenses.removeAt(index);
                          db.update();
                        });
                        // Shows the information on Snackbar
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Successfuly Removed"),
                          backgroundColor: Colors.red,
                        ));
                      },
                      background: Container(color: Colors.red),
                      child: tile(
                        expensename: db.expenses[index][0],
                        amount: db.expenses[index][1],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addbalancedialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              height: 200,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: balancecontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Add Balance',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: addbalance,
                          child: Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color.fromARGB(255, 23, 183, 189),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MaterialButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color.fromARGB(255, 23, 183, 189),
                        )
                      ],
                    )
                  ]),
            ),
          );
        });
  }

  void addexpensedialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              height: 200,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: expensetitlecontroller,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          hintText: 'Add Title',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                    TextField(
                      controller: expenseamountcontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Add Amount',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: addexpense,
                          child: Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color.fromARGB(255, 23, 183, 189),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MaterialButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color.fromARGB(255, 23, 183, 189),
                        )
                      ],
                    )
                  ]),
            ),
          );
        });
  }

  void addbalance() {
    if (balancecontroller.text.isNotEmpty) {
      setState(() {
        db.balance = db.balance + int.parse(balancecontroller.text);
      });
      Navigator.of(context).pop();
      balancecontroller.clear();
      db.update();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Balance Added"),
        backgroundColor: Color.fromARGB(255, 23, 183, 189),
      ));
    }
  }

  void addexpense() {
    if (expensetitlecontroller.text.isNotEmpty &
        expenseamountcontroller.text.isNotEmpty &
        (db.balance >= int.parse(expenseamountcontroller.text))) {
      setState(() {
        db.balance = db.balance - int.parse(expenseamountcontroller.text);
        db.expenses.add([
          expensetitlecontroller.text,
          int.parse(expenseamountcontroller.text),
        ]);
      });
      Navigator.of(context).pop();
      expenseamountcontroller.clear();
      expensetitlecontroller.clear();
      db.update();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Expense Added"),
        backgroundColor: Color.fromARGB(255, 23, 183, 189),
      ));
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Not Enough Balance"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
