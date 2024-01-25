class PosCategory {
  int? id;
  String? name;
  int? parentId;
  int? writeUid;
  String? writeDate;

  PosCategory(
      {this.id, this.name, this.parentId, this.writeUid, this.writeDate});

  PosCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = int.tryParse(json['parent_id']?.toString() ?? '');
    writeUid = int.tryParse(json['write_uid']?.toString() ?? '');
    writeDate = json['write_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['write_uid'] = writeUid;
    data['write_date'] = writeDate;
    return data;
  }
}
