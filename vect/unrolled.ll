; ModuleID = 'loop.ll'
source_filename = "loop.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@.str = private unnamed_addr constant [18 x i8] c"v[0]=%d v[63]=%d\0A\00", align 1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca [64 x i32], align 4
  br i1 false, label %scalar.ph, label %vector.ph

vector.ph:                                        ; preds = %0
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.ind = phi <4 x i32> [ <i32 1, i32 2, i32 3, i32 4>, %vector.ph ], [ %vec.ind.next, %vector.body ]
  %step.add = add <4 x i32> %vec.ind, splat (i32 4)
  %step.add.2 = add <4 x i32> %step.add, splat (i32 4)
  %step.add.3 = add <4 x i32> %step.add.2, splat (i32 4)
  %offset.idx = add i32 1, %index
  %2 = add i32 %offset.idx, 0
  %3 = sub nsw i32 %2, 1
  %4 = sext i32 %3 to i64
  %5 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 %4
  %6 = getelementptr inbounds i32, ptr %5, i32 0
  %7 = getelementptr inbounds i32, ptr %5, i32 4
  %8 = getelementptr inbounds i32, ptr %5, i32 8
  %9 = getelementptr inbounds i32, ptr %5, i32 12
  %wide.load = load <4 x i32>, ptr %6, align 4
  %wide.load1 = load <4 x i32>, ptr %7, align 4
  %wide.load2 = load <4 x i32>, ptr %8, align 4
  %wide.load3 = load <4 x i32>, ptr %9, align 4
  %10 = add nsw <4 x i32> %wide.load, %vec.ind
  %11 = add nsw <4 x i32> %wide.load1, %step.add
  %12 = add nsw <4 x i32> %wide.load2, %step.add.2
  %13 = add nsw <4 x i32> %wide.load3, %step.add.3
  store <4 x i32> %10, ptr %6, align 4
  store <4 x i32> %11, ptr %7, align 4
  store <4 x i32> %12, ptr %8, align 4
  store <4 x i32> %13, ptr %9, align 4
  %index.next = add nuw i32 %index, 16
  %vec.ind.next = add <4 x i32> %step.add.3, splat (i32 4)
  %14 = icmp eq i32 %index.next, 64
  br i1 %14, label %middle.block, label %vector.body, !llvm.loop !6

middle.block:                                     ; preds = %vector.body
  br label %scalar.ph

scalar.ph:                                        ; preds = %0, %middle.block
  %bc.resume.val = phi i32 [ 65, %middle.block ], [ 1, %0 ]
  br label %15

15:                                               ; preds = %scalar.ph, %23
  %.0 = phi i32 [ %bc.resume.val, %scalar.ph ], [ %24, %23 ]
  %16 = icmp sle i32 %.0, 64
  br i1 %16, label %17, label %25

17:                                               ; preds = %15
  %18 = sub nsw i32 %.0, 1
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 %19
  %21 = load i32, ptr %20, align 4
  %22 = add nsw i32 %21, %.0
  store i32 %22, ptr %20, align 4
  br label %23

23:                                               ; preds = %17
  %24 = add nsw i32 %.0, 1
  br label %15, !llvm.loop !10

25:                                               ; preds = %15
  %26 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 0
  %27 = load i32, ptr %26, align 4
  %28 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 63
  %29 = load i32, ptr %28, align 4
  %30 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %27, i32 noundef %29)
  ret i32 0
}

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 2]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Homebrew clang version 20.1.7"}
!6 = distinct !{!6, !7, !8, !9}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.isvectorized", i32 1}
!9 = !{!"llvm.loop.unroll.runtime.disable"}
!10 = distinct !{!10, !7, !9, !8}
