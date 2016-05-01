library angular2.test.compiler.offline_compiler_spec;

import "package:angular2/testing_internal.dart"
    show
        ddescribe,
        describe,
        xdescribe,
        it,
        iit,
        xit,
        expect,
        beforeEach,
        afterEach,
        AsyncTestCompleter,
        inject,
        beforeEachProviders,
        el;
import "package:angular2/src/facade/lang.dart" show IS_DART;
import "package:angular2/core.dart" show Injector;
import "package:angular2/src/core/linker/component_factory.dart"
    show ComponentFactory;
import "offline_compiler_codegen_typed.dart" as typed;
import "offline_compiler_codegen_untyped.dart" as untyped;
import "package:angular2/src/platform/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/platform/dom/shared_styles_host.dart"
    show SharedStylesHost;
import "offline_compiler_util.dart" show CompA;

main() {
  var typedComponentFactory = typed.CompANgFactory;
  var untypedComponentFactory = untyped.CompANgFactory;
  List<TestFixture> fixtures = [];
  if (IS_DART || !DOM.supportsDOMEvents()) {
    // Our generator only works on node.js and Dart...
    fixtures.add(new TestFixture(typedComponentFactory, "typed"));
  }
  if (!IS_DART) {
    // Our generator only works on node.js and Dart...
    if (!DOM.supportsDOMEvents()) {
      fixtures.add(new TestFixture(untypedComponentFactory, "untyped"));
    }
  }
  describe("OfflineCompiler", () {
    Injector injector;
    SharedStylesHost sharedStylesHost;
    beforeEach(
        inject([Injector, SharedStylesHost], (_injector, _sharedStylesHost) {
      injector = _injector;
      sharedStylesHost = _sharedStylesHost;
    }));
    fixtures.forEach((fixture) {
      describe('''${ fixture . name}''', () {
        it("should compile components", () {
          var hostEl = fixture.compFactory.create(injector);
          expect(hostEl.instance).toBeAnInstanceOf(CompA);
          var styles = sharedStylesHost.getAllStyles();
          expect(styles[0]).toContain(".redStyle[_ngcontent");
          expect(styles[1]).toContain(".greenStyle[_ngcontent");
        });
      });
    });
  });
}

class TestFixture {
  ComponentFactory<CompA> compFactory;
  String name;
  TestFixture(this.compFactory, this.name) {}
}