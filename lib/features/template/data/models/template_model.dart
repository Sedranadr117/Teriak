import '../../domain/entities/template_entity.dart';

class TemplateModel extends TemplateEntity {
  TemplateModel();

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
