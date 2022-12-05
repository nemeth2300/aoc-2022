import 'dart:io';
import 'dart:convert';

bool intervalContains(List<int> a, List<int> b) {
  return a[0] <= b[0] && a[1] >= b[1];
}

bool intervalHasContainment(List<List<int>> intervals) {
  return intervalContains(intervals[0], intervals[1]) ||
      intervalContains(intervals[1], intervals[0]);
}

List<List<int>> parseIntervalString(String line) {
  const lineSeparator = ",";
  const intervalSeparator = "-";
  var interval = line
      .split(lineSeparator)
      .map((intervalString) => intervalString
          .split(intervalSeparator)
          .map((value) => int.parse(value))
          .toList())
      .toList();
  return interval;
}

main() async {
  const path = "input.txt";

  var result = await new File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(new LineSplitter())
      .map((line) => parseIntervalString(line))
      .where((interval) => intervalHasContainment(interval))
      .length;

  print(result);
}
