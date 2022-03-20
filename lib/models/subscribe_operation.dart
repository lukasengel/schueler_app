enum OperationMode { SUBSCRIBE, UNSUBSCRIBE }

class SubscribeOperation {
  String topic;
  OperationMode mode;

  SubscribeOperation(this.topic, this.mode);

  factory SubscribeOperation.fromJson(Map<String, dynamic> json) {
    return SubscribeOperation(
      json["topic"],
      OperationMode.values[json["mode"]],
    );
  }

  Map<String, dynamic> toJson() => {"topic": topic, "mode": mode.index};
}
