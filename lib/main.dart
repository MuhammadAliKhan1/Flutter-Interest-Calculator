import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Removes the debug label
    title: "Simple Interest Calculator",
    home: SIForm(),
    theme: ThemeData(
        //Application theme
        primaryColor: Colors.blueGrey,
        accentColor: Colors.blueGrey,
        brightness: Brightness.dark),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SIFormState();
  }
}

class SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();
  var _currencies = [
    "Rupees",
    "Dollars",
    "Pounds",
    "Others"
  ]; // Dropdown list items
  var _minPadding = 5.0;
  var _currencySelected = "Rupees"; //Default value of rupees set
  TextEditingController principalControl = TextEditingController();
  TextEditingController roiControl = TextEditingController();
  TextEditingController termControl = TextEditingController();
  var dispResult = '';
  @override
  void initState() {
    super.initState();
    _currencySelected = _currencies[0];
  }

  Widget build(BuildContext context) {
    TextStyle textStyle =
        Theme.of(context).textTheme.subhead; // Variable for TextStyle
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"), // Appbar title
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(_minPadding * 2.0),
            child: ListView(
              children: <Widget>[
                getImageAsset(), // Image asset function call
                Padding(
                    //Principal amount text field
                    //Start TextFormfield
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                      controller: principalControl, //Fetches input
                      style: textStyle,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Principal",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          errorStyle: TextStyle(
                              color: Colors.yellowAccent, fontSize: 15.0),
                          labelStyle: textStyle,
                          hintText: "Enter Principal e.g. 12000"),
                      validator: (String val) {
                        if (val.isEmpty)
                          return 'Please input a principal amount';
                        else if (double.tryParse(val) == null)
                          return 'Input a number';
                      },
                    ) //end
                    ),
                Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                      //Rate of interest text field
                      //Start
                      controller: roiControl,
                      style: textStyle,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.yellowAccent, fontSize: 15.0),
                          labelText: "Rate of Interest",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "In Percent (%)"),
                      validator: (String val) {
                        if (val.isEmpty)
                          return 'Please input rate of interest.';
                        else if (double.tryParse(val) == null)
                          return 'Input a number';
                      },
                    ) //end
                    ),
                Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          //Term text field
                          //start
                          keyboardType: TextInputType.number,
                          style: textStyle,
                          controller: termControl,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                  color: Colors.yellowAccent, fontSize: 15.0),
                              labelText: "Term",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "In Years"),
                          validator: (String val) {
                            if (val.isEmpty)
                              return 'Please input term.';
                            else if (double.tryParse(val) == null)
                              return 'Input a number';
                          },
                        ) //end
                            ),
                        Container(
                          width: _minPadding * 5.0,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                          //dropdown menu created from _currencies array
                          //start
                          style: textStyle,
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _currencySelected,
                          onChanged: (String newValSelect) {
                            _onDropDownItemSelected(newValSelect);
                          },
                        ) //end
                            )
                      ],
                    )),
                Padding(
                  padding:
                      EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          //Calculate Button
                          //start
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColorDark,
                          child: Text(
                            'Calculate',
                            textScaleFactor: 1.2,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_formKey.currentState.validate())
                                this.dispResult = _calcTotalReturn();
                            });
                          },
                        ), //end
                      ),
                      Expanded(
                        child: RaisedButton(
                          //Reset raised button
                          //start
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Reset',
                            textScaleFactor: 1.2,
                          ),
                          onPressed: () {
                            setState(() {
                              _reset();
                            });
                          },
                        ), //end
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                  child: Text(
                    this.dispResult,
                    style: textStyle,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget getImageAsset() {
    //Returns a container having a image
    //Image location images/money.png
    //Image width 125x125
    AssetImage moneyImageAsset = AssetImage("images/money.png");
    Image moneyImage = Image(
      image: moneyImageAsset,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: moneyImage,
      margin: EdgeInsets.all(_minPadding * 10.0),
    );
  }

  void _onDropDownItemSelected(String newValSelected) {
    setState(() {
      this._currencySelected = newValSelected;
    });
  }

  String _calcTotalReturn() {
    double principal = double.parse(principalControl.text);
    double roi = double.parse(roiControl.text);
    double term = double.parse(termControl.text);

    double totalAmt = principal + (principal * roi * term) / 100;
    return 'After $term years, your investment will be worth $totalAmt $_currencySelected';
  }

  void _reset() {
    principalControl.text =
        roiControl.text = termControl.text = dispResult = '';
    _currencySelected = _currencies[0];
  }
}
