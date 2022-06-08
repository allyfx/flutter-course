import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String _infoText = "Informe seus dados!";

  void _handleCalculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);

      if (imc < 18.5) {
        _infoText = "Abaixo do peso!! IMC: ${imc.toStringAsPrecision(4)}";
      } else if (imc >= 18.5 && imc <= 24.9) {
        _infoText = "Peso normal! IMC: ${imc.toStringAsPrecision(4)}";
      } else if (imc >= 25 && imc <= 29.9) {
        _infoText = "Sobrepeso! IMC: ${imc.toStringAsPrecision(4)}";
      } else if (imc >= 30 && imc <= 34.9) {
        _infoText = "Obesidade grau I! IMC: ${imc.toStringAsPrecision(4)}";
      } else if (imc >= 35 && imc <= 39.9) {
        _infoText = "Obesidade grau II! IMC: ${imc.toStringAsPrecision(4)}";
      } else {
        _infoText = "Obesidade grau III! IMC: ${imc.toStringAsPrecision(4)}";
      }
    });
  }

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";

    setState(() {
      _infoText = "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Calculadora de IMC'),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: [
            IconButton(
                onPressed: _resetFields,
                icon: const Icon(
                  Icons.refresh,
                )),
          ],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 120,
                    color: Colors.green,
                  ),
                  InputForm(
                      labelText: 'Peso (kg)',
                      controller: weightController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Insira seu peso!";
                        }
                      }),
                  InputForm(
                      labelText: 'Altura (cm)',
                      controller: heightController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Insira sua altura!";
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: SizedBox(
                        height: 50.0,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _handleCalculate();
                              }
                            },
                            child: const Text("Calcular",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25.0)),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ))),
                  ),
                  Text(_infoText,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.green, fontSize: 25.0))
                ],
              ),
            )));
  }
}

class InputForm extends StatelessWidget {
  const InputForm(
      {Key? key, required this.labelText, this.controller, this.validator})
      : super(key: key);

  final String labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.green,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
      ),
      textAlign: TextAlign.center,
      cursorColor: Colors.green,
      style: const TextStyle(
        color: Colors.green,
        fontSize: 25,
      ),
      controller: controller,
      validator: validator,
    );
  }
}
