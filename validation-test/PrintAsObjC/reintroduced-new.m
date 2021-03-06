// REQUIRES: objc_interop

// RUN: %empty-directory(%t)

// FIXME: BEGIN -enable-source-import hackaround
// RUN:  %target-swift-frontend(mock-sdk: -sdk %S/../../test/Inputs/clang-importer-sdk -I %t) -emit-module -o %t %S/../../test/Inputs/clang-importer-sdk/swift-modules/ObjectiveC.swift
// FIXME: END -enable-source-import hackaround

// RUN: %target-swift-frontend(mock-sdk: -sdk %S/../../test/Inputs/clang-importer-sdk -I %t) -emit-module -o %t %S/Inputs/reintroduced-new.swift -disable-objc-attr-requires-foundation-module -module-name main
// RUN: %target-swift-frontend(mock-sdk: -sdk %S/../../test/Inputs/clang-importer-sdk -I %t) -parse-as-library %t/main.swiftmodule -typecheck -emit-objc-header-path %t/generated.h -disable-objc-attr-requires-foundation-module
// RUN: not %clang -fsyntax-only -x objective-c %s -include %t/generated.h -fobjc-arc -fmodules -Werror -isysroot %S/../../test/Inputs/clang-importer-sdk 2>&1 | %FileCheck %s

// CHECK-NOT: error:

void test() {
  // CHECK: :[[@LINE+1]]:{{[0-9]+}}: error: 'init' is unavailable
  (void)[[Base alloc] init];
   // CHECK-NOT: error:
  (void)[[Sub alloc] init];
  // CHECK: :[[@LINE+1]]:{{[0-9]+}}: error: 'new' is unavailable
  (void)[Base new];
   // CHECK-NOT: error:
  (void)[Sub new];
}

// CHECK-NOT: error: