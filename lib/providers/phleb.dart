import 'package:test_ease/api/labs/labs.dart';
import 'package:test_ease/models/phleb/phleb.dart';
import 'package:test_ease/providers/base_view_model.dart';

class PhlebProvider extends BaseViewModel {
  LabApi labApi = LabApi();

  Phleb? _phleb;
  Phleb? get phleb => _phleb;

  List<Phleb> _phlebs = [];
  List<Phleb> get phlebs => _phlebs;

  Future<void> addPhleb(Phleb phleb) async {
    await runWithLoader(() async {
      final newPhleb = await labApi.addPhleb(phleb);
      _phlebs.add(newPhleb);
    });
  }

  Future<void> getPhlebs() async {
    await runWithLoader(() async {
      final allPhlebs = await labApi.getAllPhlebs();
      _phlebs = allPhlebs;
    });
  }
}
