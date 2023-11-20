class GetAllCategoryModel {
  bool? error;
  String? message;
  List<AllCategoryData>? data;

  GetAllCategoryModel({
    this.error,
    this.message,
    this.data,
  });

  GetAllCategoryModel.fromJson(Map<String, dynamic> json)
      : error = json['error'] as bool?,
        message = json['message'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) =>
                AllCategoryData.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class AllCategoryData {
  final int? id;
  final String? name;

  AllCategoryData({
    this.id,
    this.name,
  });

  AllCategoryData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
