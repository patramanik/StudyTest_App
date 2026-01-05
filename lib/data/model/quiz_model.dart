class QuizModel {
  String? subject;
  String? classNumber;
  List<Questions>? questions;

  QuizModel({this.subject, this.classNumber, this.questions});

  QuizModel.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    classNumber = json['class'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject'] = subject;
    data['class'] = classNumber;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? id;
  String? question;
  Options? options;
  String? correctAnswer;

  Questions({this.id, this.question, this.options, this.correctAnswer});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    options =
        json['options'] != null ? Options.fromJson(json['options']) : null;
    correctAnswer = json['correctAnswer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    if (options != null) {
      data['options'] = options!.toJson();
    }
    data['correctAnswer'] = correctAnswer;
    return data;
  }
}

class Options {
  String? a;
  String? b;
  String? c;
  String? d;

  Options({this.a, this.b, this.c, this.d});

  Options.fromJson(Map<String, dynamic> json) {
    a = json['A'];
    b = json['B'];
    c = json['C'];
    d = json['D'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['A'] = a;
    data['B'] = b;
    data['C'] = c;
    data['D'] = d;
    return data;
  }
}
