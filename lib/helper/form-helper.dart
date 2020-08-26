import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class _FormHelper {
  Widget formSubmit({onPressed, icon = Icons.add, label: "Submit"}) {
    return SizedBox(
      width: double.infinity, // match_parent
      child: RaisedButton.icon(
        onPressed: () => {
          onPressed(),
        },
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  Widget formItem({
    dataset,
    String currentVal = "",
    TextEditingController controller,
    String label = "",
    String type,
    Function onChanged,
  }) {
    var field;
    if (type == "text" || type == "number") {
      // controller.text = currentVal;
      // controller.selection = TextSelection.fromPosition(
      //     TextPosition(offset: controller.text.length));

      // int currentOffset = controller.selection.base.offset;
      // controller.value = TextEditingValue(
      //   text: currentVal,
      //   selection: TextSelection.fromPosition(
      //     TextPosition(offset: currentOffset),
      //   ),
      // );

      field = TextField(
        onChanged: (val) {
          onChanged(val);
        },
        controller: controller,
        keyboardType: type == "number" ? TextInputType.number : null,
      );
    }

    if (type == "select") {
      field = DropdownButton<String>(
        value: currentVal == "" ? dataset[0] : currentVal,
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
