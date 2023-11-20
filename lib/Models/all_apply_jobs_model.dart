class GetAllApplyJobsModel {
  final bool? error;
  final String? message;
  final List<AllApplyJobList>? data;

  GetAllApplyJobsModel({
    this.error,
    this.message,
    this.data,
  });

  GetAllApplyJobsModel.fromJson(Map<String, dynamic> json)
      : error = json['error'] as bool?,
        message = json['message'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) =>
                AllApplyJobList.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class AllApplyJobList {
  final int? id;
  final int? userId;
  final int? jobId;
  final int? shortList;
  final String? title;
  final String? description;
  final int? career;
  final int? noOfPostions;
  final int? experience;
  final String? address;
  final dynamic startTime;
  final dynamic endTime;
  final String? dateTime;
  final int? approve;
  final int? type;
  final String? category;
  final String? city;

  AllApplyJobList({
    this.id,
    this.userId,
    this.jobId,
    this.shortList,
    this.title,
    this.description,
    this.career,
    this.noOfPostions,
    this.experience,
    this.address,
    this.startTime,
    this.endTime,
    this.dateTime,
    this.approve,
    this.type,
    this.category,
    this.city,
  });

  AllApplyJobList.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'] as int?,
        jobId = json['job_id'] as int?,
        shortList = json['short_list'] as int?,
        title = json['title'] as String?,
        description = json['description'] as String?,
        career = json['career'] as int?,
        noOfPostions = json['no_of_postions'] as int?,
        experience = json['experience'] as int?,
        address = json['address'] as String?,
        startTime = json['start_time'],
        endTime = json['end_time'],
        dateTime = json['date_time'] as String?,
        approve = json['approve'] as int?,
        type = json['type'] as int?,
        category = json['category'] as String?,
        city = json['city'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'job_id': jobId,
        'short_list': shortList,
        'title': title,
        'description': description,
        'career': career,
        'no_of_postions': noOfPostions,
        'experience': experience,
        'address': address,
        'start_time': startTime,
        'end_time': endTime,
        'date_time': dateTime,
        'approve': approve,
        'type': type,
        'category': category,
        'city': city
      };
}
