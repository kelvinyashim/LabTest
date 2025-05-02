import 'package:test_ease/api/admin/tests_admin.dart';
import 'package:test_ease/models/admin/test_catalogue.dart';
import 'package:test_ease/providers/base_view_model.dart';

class AdminTestProvider extends BaseViewModel {
  final TestAdminApi _testAdminApi = TestAdminApi();


  List<TestCatalogue> _testCatalogue = [];
  List<TestCatalogue> get testCatalogue => _testCatalogue;

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
}
