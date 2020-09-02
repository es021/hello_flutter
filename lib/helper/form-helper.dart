import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class _FormHelper {
  Widget formSubmit({onPressed, icon = Icons.add, label: "Submit"}) {
    return Column(
      children: [
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: RaisedButton.icon(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            onPressed: () => {
              onPressed(),
            },
            textColor: Colors.white,
            color: Colors.green,
            icon: Icon(icon),
            label: Text(label),
          ),
        )
      ],
    );
  }

  setText(controller, value) {
    controller.text = value;
  }

  Widget formItem({
    List<String> dataset,
    String selectVal = "",
    TextEditingController controller,
    String label = "",
    String type,
    Function onChanged,
    bool disabled = false
  }) {
    var field;

    // ###### TEXT / NUMBER #############################
    if (type == "text" || type == "number") {
      field = TextField(
        enabled: !disabled,
        onChanged: (val) {
          onChanged(val);
        },
        controller: controller,
        keyboardType: type == "number" ? TextInputType.number : null,
      );
    }

    // ###### SELECT #############################
    if (type == "select") {
      if (dataset.indexOf(selectVal) <= -1) {
        selectVal = "";
      }

      field = DropdownButton<String>(
        value: selectVal == "" ? dataset[0] : selectVal,
        // icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String val) {
          onChanged(val);
        },
        items: dataset.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
      );
    }

    return new Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          field,
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

final FormHelper = _FormHelper();
