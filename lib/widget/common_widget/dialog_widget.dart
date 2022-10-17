import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/widget/common_widget/RTE_widget.dart';

class RenameDialog extends AlertDialog {
  RenameDialog({Key? key, required Widget contentWidget})
      : super(
          key: key,
          content: contentWidget,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        );
}

double btnHeight = 60;
double borderWidth = 2;

class RenameDialogContent extends StatefulWidget {
  final String title;
  final String cancelBtnTitle;
  final String okBtnTitle;
  final Function cancelBtnTap;
  final Function okBtnTap;

  //controller for describe
  final TextEditingController describeController;

  //controller for name
  final TextEditingController nameController;

  const RenameDialogContent({
    Key? key,
    required this.title,
    this.cancelBtnTitle = "取消",
    this.okBtnTitle = "创建",
    required this.cancelBtnTap,
    required this.okBtnTap,
    required this.describeController,
    required this.nameController,
  }) : super(key: key);

  @override
  _RenameDialogContentState createState() => _RenameDialogContentState();
}

class _RenameDialogContentState extends State<RenameDialogContent> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
        alignment: Alignment.bottomCenter,
        height: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                child: Text(
                  widget.title,
                  style: const TextStyle(color: Colors.grey),
                )),
            Container(
              height: 10,
            ),
            AnimatedTextFormField(
              controller: widget.nameController,
              width: 30,
              labelText:
              '项目名称',
              // keyboardType: TextFieldUtils.getKeyboardType(widget.userType),
              textInputAction: TextInputAction.next,
              // onFieldSubmitted: (value) {
              //   FocusScope.of(context).requestFocus(_passwordFocusNode);
              // },
              // validator: widget.userValidator,
              // onSaved: (value) => auth.email = value!,
              // enabled: !_isSubmitting,
            ),
            AnimatedTextFormField(
              controller: widget.describeController,
              width: 30,
              labelText:
              '项目描述',
              // keyboardType: TextFieldUtils.getKeyboardType(widget.userType),
              textInputAction: TextInputAction.next,
              // onFieldSubmitted: (value) {
              //   FocusScope.of(context).requestFocus(_passwordFocusNode);
              // },
              // validator: widget.userValidator,
              // onSaved: (value) => auth.email = value!,
              // enabled: !_isSubmitting,
            ),
            Container(
              // color: Colors.red,
              height: btnHeight,
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Column(
                children: [
                  Container(
                    // 按钮上面的横线
                    width: double.infinity,
                    color: Colors.blue,
                    height: borderWidth,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.cancelBtnTap();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.cancelBtnTitle,
                          style:
                              const TextStyle(fontSize: 22, color: Colors.blue),
                        ),
                      ),
                      Container(
                        // 按钮中间的竖线
                        width: borderWidth,
                        color: Colors.blue,
                        height: btnHeight - borderWidth - borderWidth,
                      ),
                      GestureDetector(
                          onTap: () {
                            widget.okBtnTap();
                          },
                          child: Text(
                            widget.okBtnTitle,
                            style: const TextStyle(
                                fontSize: 22, color: Colors.blue),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
