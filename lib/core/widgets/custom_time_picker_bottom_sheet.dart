import 'package:flutter/cupertino.dart';

import '../imports/imports.dart';

Future<TimeOfDay?> customTimePickerBottomSheet(BuildContext context) async {
  int selectedHour = 1;
  int selectedMinute = 0;
  bool isAm = true;
  return await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 24.rH(context),
          horizontal: 8.rW(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200.rH(context),
              child: Row(
                children: [
                  //! Hour Picker
                  Expanded(
                    child: CupertinoPicker(
                      looping: true,
                      itemExtent: 40,
                      scrollController:
                          FixedExtentScrollController(initialItem: 0),
                      onSelectedItemChanged: (int index) {
                        selectedHour = index + 1;
                      },
                      children: List.generate(12, (index) {
                        return Center(
                          child: Text(
                            '${index + 1}',
                            style: Styles.semibold24Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  //! Minutes Picker
                  Expanded(
                    child: CupertinoPicker(
                      looping: true,
                      itemExtent: 40,
                      scrollController:
                          FixedExtentScrollController(initialItem: 0),
                      onSelectedItemChanged: (int index) {
                        selectedMinute = index;
                      },
                      children: List.generate(60, (index) {
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, "0"),
                            style: Styles.semibold24Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  //! AM/PM Picker
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      scrollController:
                          FixedExtentScrollController(initialItem: 0),
                      onSelectedItemChanged: (int index) {
                        index == 0 ? isAm = true : isAm = false;
                      },
                      children: [
                        Center(
                          child: Text(
                            'AM',
                            style: Styles.semibold24Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'PM',
                            style: Styles.semibold24Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.rH(context)),
            //! Choose Button
            CustomButton(
              title: AppStrings.save.tr(context),
              onPressed: () {
                Navigator.pop(
                  context,
                  TimeOfDay(
                    hour: (selectedHour % 12) + (isAm ? 0 : 12),
                    minute: selectedMinute,
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
