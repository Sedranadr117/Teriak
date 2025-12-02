import 'dart:io';

void main() async {
  // =================== 1️⃣ Feature الجديد ===================
  const featureName = 'notification'; // <-- غيّري الاسم لأي Feature جديدة
  final featureLower = featureName.toLowerCase();
  final featureCapital = capitalize(featureName);

  // =================== 2️⃣ مجلد القالب ===================
  final templateFolder = Directory('lib/features/template');
  final targetFolder = Directory('lib/features/$featureLower');

  if (!templateFolder.existsSync()) {
    print('❌ Template folder does not exist: ${templateFolder.path}');
    return;
  }

  // =================== 3️⃣ نسخ الملفات من القالب ===================
  await for (var entity in templateFolder.list(recursive: true, followLinks: false)) {
    if (entity is File) {
      final relativePath = entity.path.substring(templateFolder.path.length + 1);
      var newFilePath = relativePath.replaceAll('template', featureLower);
      newFilePath = newFilePath.replaceAll('Template', featureCapital);
      final newFile = File('${targetFolder.path}/$newFilePath');

      newFile.parent.createSync(recursive: true);

      var content = await entity.readAsString();
      content = content.replaceAll('Template', featureCapital);
      content = content.replaceAll('template', featureLower);
      content = content.replaceAll('TEMPLATE', featureName.toUpperCase());

      await newFile.writeAsString(content);
      print('✅ Created: ${newFile.path}');
    }
  }

  // =================== 4️⃣ إضافة Params Class ===================
  final paramsFile = File('lib/core/params/params.dart');
  if (!paramsFile.existsSync()) {
    paramsFile.createSync(recursive: true);
    paramsFile.writeAsStringSync('// Core Params file\n');
  }

  var paramsContent = paramsFile.readAsStringSync();
  if (!paramsContent.contains('${featureCapital}Params')) {
    final newParams = '''

class ${featureCapital}Params {
  final String id;
  const ${featureCapital}Params({required this.id});
  Map<String, dynamic> toJson() => {'id': id};
}
''';
    paramsFile.writeAsStringSync(paramsContent + newParams);
    print('✅ Added ${featureCapital}Params to params.dart');
  } else {
    print('ℹ️ ${featureCapital}Params already exists in params.dart, skipping.');
  }

  // =================== 5️⃣ إضافة EndPoint ===================
  final endPointsFile = File('lib/core/databases/api/end_points.dart');
  if (!endPointsFile.existsSync()) {
    print('❌ EndPoints file does not exist!');
  } else {
    var endPointsContent = endPointsFile.readAsStringSync();

    if (!endPointsContent.contains('$featureLower =')) {
      final classEndIndex = endPointsContent.lastIndexOf('}');
      if (classEndIndex != -1) {
        final newEndPointLine = '  static const String $featureLower = "$featureLower/";\n';
        final updatedContent = endPointsContent.substring(0, classEndIndex) +
            newEndPointLine +
            endPointsContent.substring(classEndIndex);

        endPointsFile.writeAsStringSync(updatedContent);
        print('✅ Added EndPoints.$featureLower');
      } else {
        print('❌ Could not find closing brace for EndPoints class!');
      }
    } else {
      print('ℹ️ EndPoints.$featureLower already exists, skipping.');
    }
  }

  print('🎉 Feature "$featureName" created successfully from template with Params and EndPoint!');
}

// دالة مساعدة
String capitalize(String s) => '${s[0].toUpperCase()}${s.substring(1)}';
