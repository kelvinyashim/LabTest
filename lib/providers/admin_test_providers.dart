import 'package:test_ease/api/admin/reg_lab.dart';
import 'package:test_ease/api/admin/tests_admin.dart';
import 'package:test_ease/models/admin/test_catalogue.dart';
import 'package:test_ease/models/lab/labs.dart';
import 'package:test_ease/providers/base_view_model.dart';

class AdminTestProvider extends BaseViewModel {
  final TestAdminApi _testAdminApi = TestAdminApi();
  final AdminLabApi adminLabApi = AdminLabApi();

  List<TestCatalogue> _testCatalogue = [];
  List<TestCatalogue> get testCatalogue => _testCatalogue;

  Lab? _lab;
  Lab? get lab => _lab;

  List<Lab> _labs = [];
  List<Lab> get labs => _labs;

  Future<void> addTest(TestCatalogue newTest) async {
    await runWithLoader(() async {
      final test = await _testAdminApi.addTest(newTest);
      _testCatalogue.add(test);
    });
  }

  Future<void> getTestCatalogue() async {
    await runWithLoader(() async {
      final tests = await _testAdminApi.getAllTests();
      _testCatalogue = tests;
    });
  }

  Future<void> createLab(Lab lab) async {
    await runWithLoader(() async {
      _lab = await adminLabApi.createLab(lab);
    });
  }

  Future<void> getLabs() async {
    await runWithLoader(() async {
      final lab = await adminLabApi.getAllLabs();
      _labs = lab;
    });
  }
}
