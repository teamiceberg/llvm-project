; RUN: opt < %s -argpromotion -argpromotion-max-elements-to-promote=0 -S | FileCheck %s --check-prefix=PROMOTED
; RUN: opt < %s -argpromotion -argpromotion-max-elements-to-promote=2147483647 -S | FileCheck %s --check-prefix=PROMOTED
; RUN: opt < %s -argpromotion -S | FileCheck %s --check-prefix=NOTPROMOTED

target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.fourmem = type { i32, i32, i32, i32 }

; Function Attrs: noinline norecurse ssp uwtable
define i32 @main() #0 {
entry:
  %four = alloca %struct.fourmem, align 4
  %a = getelementptr inbounds %struct.fourmem, %struct.fourmem* %four, i32 0, i32 0
  store i32 1, i32* %a, align 4
  %b = getelementptr inbounds %struct.fourmem, %struct.fourmem* %four, i32 0, i32 1
  store i32 2, i32* %b, align 4
  %c = getelementptr inbounds %struct.fourmem, %struct.fourmem* %four, i32 0, i32 2
  store i32 3, i32* %c, align 4
  %d = getelementptr inbounds %struct.fourmem, %struct.fourmem* %four, i32 0, i32 3
  store i32 4, i32* %d, align 4
  %call = call i32 @_ZL6calleeP7fourmem(%struct.fourmem* %four)
  ret i32 0
}

; 'PROMOTED' tag is to check that flag works correctly to promote elements within aggregates
; PROMOTED-LABEL: define {{[^@]+}}@main()
; PROMOTED-NEXT: entry:
; PROMOTED-NEXT: [[F:%.*]] = alloca {{.*}}
; PROMOTED-NEXT: {{%.*}} = getelementptr {{.*}}
; PROMOTED-NEXT: store {{.*}}
; PROMOTED-NEXT: {{%.*}} = getelementptr {{.*}}
; PROMOTED-NEXT: store {{.*}}
; PROMOTED-NEXT: {{%.*}} = getelementptr {{.*}}
; PROMOTED-NEXT: store {{.*}}
; PROMOTED-NEXT: {{%.*}} = getelementptr {{.*}}
; PROMOTED-NEXT: store {{.*}}
; PROMOTED-NEXT: [[F]].idx{{.*}} = getelementptr %struct.fourmem,  %struct.fourmem* [[F]], i64 0, i32 0
; PROMOTED-NEXT: [[F]].idx{{.*}}.val = load i32, i32* [[F]].idx{{.*}}, align 4
; PROMOTED-NEXT: [[F]].idx{{.*}} = getelementptr %struct.fourmem,  %struct.fourmem* [[F]], i64 0, i32 1
; PROMOTED-NEXT: [[F]].idx{{.*}}.val = load i32, i32* [[F]].idx{{.*}}, align 4
; PROMOTED-NEXT: [[F]].idx{{.*}} = getelementptr %struct.fourmem,  %struct.fourmem* [[F]], i64 0, i32 2
; PROMOTED-NEXT: [[F]].idx{{.*}}.val = load i32, i32* [[F]].idx{{.*}}, align 4
; PROMOTED-NEXT: [[F]].idx{{.*}} = getelementptr %struct.fourmem,  %struct.fourmem* [[F]], i64 0, i32 3
; PROMOTED-NEXT: [[F]].idx{{.*}}.val = load i32, i32* [[F]].idx{{.*}}, align 4
; PROMOTED-NEXT: %{{.*}} = call i32 @{{.*}}fourmem(i32 [[F]].idx{{.*}}.val, i32 [[F]].idx{{.*}}.val, i32 [[F]].idx{{.*}}.val, i32 [[F]].idx{{.*}}.val)
; PROMOTED-NEXT: ret i32 0
;

; 'NOTPROMOTED' tag is to check that flag works correctly to NOT promote elements within aggregates
; NOTPROMOTED-LABEL: define {{[^@]+}}@main()
; NOTPROMOTED-NEXT: entry:
; NOTPROMOTED-NEXT: [[F:%.*]] = alloca {{.*}}
; NOTPROMOTED-NEXT: {{%.*}} = getelementptr {{.*}}
; NOTPROMOTED-NEXT: store {{.*}}
; NOTPROMOTED-NEXT: {{%.*}} = getelementptr {{.*}}
; NOTPROMOTED-NEXT: store {{.*}}
; NOTPROMOTED-NEXT: {{%.*}} = getelementptr {{.*}}
; NOTPROMOTED-NEXT: store {{.*}}
; NOTPROMOTED-NEXT: {{%.*}} = getelementptr {{.*}}
; NOTPROMOTED-NEXT: store {{.*}}
; NOTPROMOTED-NEXT: %{{.*}} = call i32 @{{.*}}fourmem(%struct.fourmem* [[F]])
; NOTPROMOTED-NEXT: ret i32 0
;

; Function Attrs: noinline nounwind ssp uwtable
define internal i32 @_ZL6calleeP7fourmem(%struct.fourmem* %t) #1 {
entry:
  %a = getelementptr inbounds %struct.fourmem, %struct.fourmem* %t, i32 0, i32 0
  %0 = load i32, i32* %a, align 4
  %b = getelementptr inbounds %struct.fourmem, %struct.fourmem* %t, i32 0, i32 1
  %1 = load i32, i32* %b, align 4
  %add = add nsw i32 %0, %1
  %c = getelementptr inbounds %struct.fourmem, %struct.fourmem* %t, i32 0, i32 2
  %2 = load i32, i32* %c, align 4
  %add1 = add nsw i32 %add, %2
  %d = getelementptr inbounds %struct.fourmem, %struct.fourmem* %t, i32 0, i32 3
  %3 = load i32, i32* %d, align 4
  %add2 = add nsw i32 %add1, %3
  ret i32 %add2
}

; 'PROMOTED' tag is to check that flag works correctly to promote elements within aggregates
; PROMOTED-LABEL: define {{[^@]+}}@{{.*}}fourmem
; PROMOTED-SAME: (i32 %t.0.{{.*}}.val, i32 %t.0.{{.*}}.val, i32 %t.0.{{.*}}.val, i32 %t.0.{{.*}}.val)
; PROMOTED-NEXT: entry:
; PROMOTED-NEXT: %add{{.*}} = add nsw i32 {{.*}}, {{.*}}
; PROMOTED-NEXT: %add{{.*}} = add nsw i32 {{.*}}, {{.*}}
; PROMOTED-NEXT: %add{{.*}} = add nsw i32 {{.*}}, {{.*}}
; PROMOTED-NEXT: ret i32 %{{.*}}
;

; 'NOTPROMOTED' tag is to check that flag works correctly to NOT promote elements within aggregates
; NOTPROMOTED: define {{[^@]+}}@{{.*}}fourmem(%struct.fourmem* %t)
; NOTPROMOTED-NEXT: entry:
; NOTPROMOTED-NEXT: %{{.*}} = getelementptr inbounds {{.*}}, {{%.*}}, i32 0, i32 0
; NOTPROMOTED-NEXT: %{{.*}} = load i32, i32* {{%.*}}, align 4
; NOTPROMOTED-NEXT: %{{.*}} = getelementptr inbounds {{.*}}, {{%.*}}, i32 0, i32 1
; NOTPROMOTED-NEXT: %{{.*}} = load i32, i32* {{%.*}}, align 4
; NOTPROMOTED-NEXT: %add{{.*}} = add nsw i32 {{%.*}}, {{%.*}}
; NOTPROMOTED-NEXT: %{{.*}} = getelementptr inbounds {{.*}}, {{%.*}}, i32 0, i32 2
; NOTPROMOTED-NEXT: %{{.*}} = load i32, i32* {{%.*}}, align 4
; NOTPROMOTED-NEXT: %add{{.*}} = add nsw i32 {{%.*}}, {{%.*}}
; NOTPROMOTED-NEXT: %{{.*}} = getelementptr inbounds {{.*}}, {{%.*}}, i32 0, i32 3
; NOTPROMOTED-NEXT: %{{.*}} = load i32, i32* {{%.*}}, align 4
; NOTPROMOTED-NEXT: %add{{.*}} = add nsw i32 {{%.*}}, {{%.*}}
; NOTPROMOTED-NEXT: ret i32 %{{.*}}
;
