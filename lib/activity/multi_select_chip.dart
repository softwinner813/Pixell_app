import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixell_app/utils/my_constants.dart';
import 'package:pixell_app/utils/my_utils.dart';

class MultiSelectChip extends StatefulWidget {
  List<String> getSelectedFilterDisplayList = [];
  List<String> getSelectedFilterApiList = [];
  final VoidCallback onRemoveFiltered;

  MultiSelectChip({@required this.getSelectedFilterDisplayList,this.getSelectedFilterApiList, this.onRemoveFiltered});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  String selectedChoice = "";

  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.getSelectedFilterDisplayList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(3.0),
        child: chipBuilder(
            label: item,
            onAvatarTap: () {
              setState(() {
                var index = widget.getSelectedFilterDisplayList.indexOf(item);
                widget.getSelectedFilterDisplayList.remove(item);
                widget.getSelectedFilterApiList.remove(widget.getSelectedFilterApiList[index]);
                widget.onRemoveFiltered();
              });
            }),
      ));
    });

    if (widget.getSelectedFilterDisplayList.length > 0) {
      choices.add(
        Container(
          margin: new EdgeInsets.fromLTRB(
              0.0, MyConstants.topbar_height / 2, 0.0, 0.0),
        ),
      );
    }

    return choices;
  }

  Widget chipBuilder({String label, VoidCallback onAvatarTap}) => RawChip(
        onDeleted: onAvatarTap,
        deleteIcon: Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
              color: MyUtils().getColorFromHex(MyConstants.color_theme),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(
            Icons.close,
            size: 12,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          label,
          style: MyConstants.textStyle_chipsValue,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0),
            side: BorderSide(color: Colors.white, width: 0)),
      );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
