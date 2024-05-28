import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethiopia Salary Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Ethiopia Salary Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool submitted = false;
  bool isVisible = false;
  String grossSalary = "0";
  String netSalary = "0";
  String pension = "0";
  String incomeTax = "0";

  final List<Map<String, dynamic>> taxInfo = [
    {'id': 1, 'min': 0, 'max': 600, 'tax': 0, 'desc': 0},
    {'id': 2, 'min': 601, 'max': 1650, 'tax': 10, 'desc': 60},
    {'id': 3, 'min': 1651, 'max': 3200, 'tax': 15, 'desc': 142.50},
    {'id': 4, 'min': 3201, 'max': 5250, 'tax': 20, 'desc': 302.50},
    {'id': 5, 'min': 5251, 'max': 7800, 'tax': 25, 'desc': 565},
    {'id': 6, 'min': 7801, 'max': 10900, 'tax': 30, 'desc': 955},
    {'id': 7, 'min': 10900, 'max': 10900, 'tax': 35, 'desc': 1500},
  ];

  final TextEditingController _salaryController = TextEditingController();

  String? get salaryerror {
    final text = _salaryController.text;
    if (text.isEmpty) {
      return 'Please enter your salary';
    }

    bool numberValid = RegExp(r'^\d+$').hasMatch(text);

    if (!numberValid) {
      return 'Please enter a valid number';
    }

    return null;
  }

  String addCommaNumbers(String data) {
    double number = double.tryParse(data) ?? 0;
    final formatter = NumberFormat("#,##0.00", "en_US");
    String formattedNumber = formatter.format(number);
    return formattedNumber;
  }

  void _submit() {
    setState(() {
      submitted = true;
    });
    if (salaryerror == null) {
      int tpension = 7;
      var tax = 0;
      double nSalary = 0;
      double tMoney = 0;
      double pMoney = 0;
      var desc = 0;

      // Find the tax rate
      for (var i = 0; i < taxInfo.length; i++) {
        if (int.parse(_salaryController.text) >= taxInfo[i]['min'] &&
            int.parse(_salaryController.text) <= taxInfo[i]['max']) {
          tax = taxInfo[i]['tax'];
          desc = taxInfo[i]['desc'];
          break;
        } else if (int.parse(_salaryController.text) >
            taxInfo[taxInfo.length - 1]['max']) {
          tax = taxInfo[taxInfo.length - 1]['tax'];
        }
      }

      tMoney = int.parse(_salaryController.text) * (tax / 100) - desc;
      pMoney = int.parse(_salaryController.text) * (tpension / 100);

      nSalary = int.parse(_salaryController.text) - (tMoney + pMoney);

      setState(() {
        grossSalary = _salaryController.text;
        netSalary = nSalary.toStringAsFixed(2);
        pension = pMoney.toStringAsFixed(2);
        incomeTax = tMoney.toStringAsFixed(2);
        isVisible = true;
      });
    }
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double? height = MediaQuery.of(context).size.height;
    double? width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A5D4D),
        title: Text(
          widget.title,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            width: double.infinity,
            height: isVisible ? null : height,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: const Color.fromRGBO(75, 85, 99, 0.8),
            child: Column(
              children: [
                // Main Container
                SizedBox(
                    height: 450,
                    width: width > 500 ? 500 : width,
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        children: [
                          // Size
                          const SizedBox(height: 20),
                          // Image
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  Image.asset("assets/images/logo/logo.jpeg"),
                            ),
                          ),
                          // Size
                          const SizedBox(height: 50),
                          // Form
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                // Salary
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Salary:",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Salary Input
                                    TextFormField(
                                      controller: _salaryController,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        errorText:
                                            submitted ? salaryerror : null,
                                        hintText: "Enter your Gross Salary",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Size
                                const SizedBox(height: 20),

                                // Calculate Button
                                TextButton(
                                  onPressed: _submit,
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A5D4D),
                                    foregroundColor: Colors.white,
                                    fixedSize: const Size(400, 50),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                  child: Text(
                                    "Calculate",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),

                // Size
                const SizedBox(height: 30),

                // Result
                Visibility(
                  visible: isVisible,
                  child: SizedBox(
                      height: 350,
                      width: width > 500 ? 500 : width,
                      child: Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),

                              // Ttitle
                              Text(
                                "Result",
                                style: GoogleFonts.montserrat(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),

                              // Divider
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color: Colors.grey[300],
                                ),
                              ),

                              // Size
                              const SizedBox(height: 20),

                              // Result
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Column(children: [
                                  // Gross Salary
                                  Row(
                                    children: [
                                      Text(
                                        "Gross Salary:",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        " ${addCommaNumbers(grossSalary)} Birr",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // Net Salary
                                  Row(
                                    children: [
                                      Text(
                                        "Net Salary:",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        " ${addCommaNumbers(netSalary)} Birr",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // Pension
                                  Row(
                                    children: [
                                      Text(
                                        "Pension:",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        " ${addCommaNumbers(pension)} Birr",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // Icncome Tax
                                  Row(
                                    children: [
                                      Text(
                                        "Income Tax:",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        " ${addCommaNumbers(incomeTax)} Birr",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ],
                          ))),
                ),
              ],
            )),
      ),
    );
  }
}
