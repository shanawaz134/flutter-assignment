class TaskModel {
  String? task;
  String? description;
  String? date;
  String? status;
  String? crestedAt;
  String? category;
  String? id;

  TaskModel(
      {this.task,
        this.description,
        this.date,
        this.status,
        this.crestedAt,
        this.category,
        this.id
      });

  TaskModel.fromJson(Map<String, dynamic> json) {
    task = json['task'];
    description = json['desc'];
    date = json['date'];
    status = json['status'];
    crestedAt = json['crested_at'];
    category = json['category'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task'] = task;
    data['desc'] = description;
    data['date'] = date;
    data['status'] = status;
    data['crested_at'] = crestedAt;
    data['category'] = category;
    data['id'] = id;
    return data;
  }
}
