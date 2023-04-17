class SensorRecord {
  int? secondSinceEpoch;
  double? value;

  SensorRecord({
    this.secondSinceEpoch,
    this.value,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['second_since_epoch'] = secondSinceEpoch;
    data['value'] = value;
    return data;
  }
}
