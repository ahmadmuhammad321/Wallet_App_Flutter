import 'package:flutter/material.dart';

class tile extends StatelessWidget {
  final String expensename;
  final int amount;

  const tile({
    super.key,
    required this.expensename,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("assets/expenses.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        expensename,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 23, 183, 189),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text(
                  "- Rs." + amount.toString(),
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
