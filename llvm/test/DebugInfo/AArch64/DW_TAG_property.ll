; RUN: llc < %s -filetype=obj -o %t
; RUN: llvm-dwarfdump -v %t | FileCheck %s

; Test that a DISubprogram with DISPFlagProperty emits a DW_TAG_property
; child DIE, with DW_TAG_property_getter/DW_TAG_property_setter children
; whose DW_AT_property_forward points back at the accessor DW_TAG_subprogram.

; CHECK: 0x[[GETTER_OFF:[0-9a-f]+]]:{{.*}}DW_TAG_subprogram
; CHECK: DW_AT_name {{.*}}= "GetProp"

; CHECK: 0x[[SETTER_OFF:[0-9a-f]+]]:{{.*}}DW_TAG_subprogram
; CHECK: DW_AT_name {{.*}}= "SetProp"

; CHECK: DW_TAG_subprogram {{.*}}
; CHECK: DW_AT_name {{.*}}= "PropFromMethods"
; CHECK: DW_TAG_property {{.*}}
; CHECK-NEXT: DW_AT_name {{.*}}= "PropFromMethods"
; CHECK: DW_TAG_property_getter
; CHECK-NEXT: DW_AT_property_forward {{.*}}=> {0x[[GETTER_OFF]]}
; CHECK: DW_TAG_property_setter
; CHECK-NEXT: DW_AT_property_forward {{.*}}=> {0x[[SETTER_OFF]]}

source_filename = "property_test.ll"

define void @_ZN3Foo3GetProp() !dbg !10 {
entry:
  ret void, !dbg !13
}

define void @_ZN3Foo3SetProp() !dbg !11 {
entry:
  ret void, !dbg !14
}

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "test", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2)
!1 = !DIFile(filename: "property_test.cpp", directory: "/tmp")
!2 = !{!3}
!3 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "Foo", file: !1, size: 8, flags: DIFlagFwdDecl, elements: !4, identifier: "Foo")
!4 = !{!10, !11, !12}
!5 = !DISubroutineType(types: !6)
!6 = !{null}

!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = distinct !DISubprogram(name: "GetProp", linkageName: "_ZN3Foo3GetProp", scope: !3, file: !1, line: 5, type: !5, scopeLine: 5, spFlags: DISPFlagDefinition, unit: !0)
!11 = distinct !DISubprogram(name: "SetProp", linkageName: "_ZN3Foo3SetProp", scope: !3, file: !1, line: 6, type: !5, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !0)
!12 = distinct !DISubprogram(name: "PropFromMethods", scope: !3, file: !1, line: 7, type: !5, spFlags: DISPFlagProperty, propertyGetter: !10, propertySetter: !11)
!13 = !DILocation(line: 5, scope: !10)
!14 = !DILocation(line: 6, scope: !11)
