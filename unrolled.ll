; ModuleID = 'loop.ll'
source_filename = "loop.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@.str = private unnamed_addr constant [27 x i8] c"v[0]=%d v[63]=%d found=%d\0A\00", align 1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca [64 x i32], align 4
  br i1 false, label %scalar.ph, label %vector.ph

vector.ph:                                        ; preds = %0
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %2 = add i32 %index, 0
  %3 = sext i32 %2 to i64
  %4 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 %3
  %5 = getelementptr inbounds i32, ptr %4, i32 0
  %6 = getelementptr inbounds i32, ptr %4, i32 4
  %7 = getelementptr inbounds i32, ptr %4, i32 8
  %8 = getelementptr inbounds i32, ptr %4, i32 12
  store <4 x i32> zeroinitializer, ptr %5, align 4
  store <4 x i32> zeroinitializer, ptr %6, align 4
  store <4 x i32> zeroinitializer, ptr %7, align 4
  store <4 x i32> zeroinitializer, ptr %8, align 4
  %index.next = add nuw i32 %index, 16
  %9 = icmp eq i32 %index.next, 64
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !6

middle.block:                                     ; preds = %vector.body
  br label %scalar.ph

scalar.ph:                                        ; preds = %0, %middle.block
  %bc.resume.val = phi i32 [ 64, %middle.block ], [ 0, %0 ]
  br label %10

10:                                               ; preds = %scalar.ph, %15
  %.01 = phi i32 [ %bc.resume.val, %scalar.ph ], [ %16, %15 ]
  %11 = icmp slt i32 %.01, 64
  br i1 %11, label %12, label %17

12:                                               ; preds = %10
  %13 = sext i32 %.01 to i64
  %14 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 %13
  store i32 0, ptr %14, align 4
  br label %15

15:                                               ; preds = %12
  %16 = add nsw i32 %.01, 1
  br label %10, !llvm.loop !10

17:                                               ; preds = %10
  br i1 false, label %scalar.ph5, label %vector.ph6

vector.ph6:                                       ; preds = %17
  br label %vector.body7

vector.body7:                                     ; preds = %vector.body7, %vector.ph6
  %index8 = phi i32 [ 0, %vector.ph6 ], [ %index.next12, %vector.body7 ]
  %vec.ind = phi <4 x i32> [ <i32 1, i32 2, i32 3, i32 4>, %vector.ph6 ], [ %vec.ind.next, %vector.body7 ]
  %step.add = add <4 x i32> %vec.ind, splat (i32 4)
  %step.add.2 = add <4 x i32> %step.add, splat (i32 4)
  %step.add.3 = add <4 x i32> %step.add.2, splat (i32 4)
  %offset.idx = add i32 1, %index8
  %18 = add i32 %offset.idx, 0
  %19 = sub nsw i32 %18, 1
  %20 = sext i32 %19 to i64
  %21 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 %20
  %22 = getelementptr inbounds i32, ptr %21, i32 0
  %23 = getelementptr inbounds i32, ptr %21, i32 4
  %24 = getelementptr inbounds i32, ptr %21, i32 8
  %25 = getelementptr inbounds i32, ptr %21, i32 12
  %wide.load = load <4 x i32>, ptr %22, align 4
  %wide.load9 = load <4 x i32>, ptr %23, align 4
  %wide.load10 = load <4 x i32>, ptr %24, align 4
  %wide.load11 = load <4 x i32>, ptr %25, align 4
  %26 = add nsw <4 x i32> %wide.load, %vec.ind
  %27 = add nsw <4 x i32> %wide.load9, %step.add
  %28 = add nsw <4 x i32> %wide.load10, %step.add.2
  %29 = add nsw <4 x i32> %wide.load11, %step.add.3
  store <4 x i32> %26, ptr %22, align 4
  store <4 x i32> %27, ptr %23, align 4
  store <4 x i32> %28, ptr %24, align 4
  store <4 x i32> %29, ptr %25, align 4
  %index.next12 = add nuw i32 %index8, 16
  %vec.ind.next = add <4 x i32> %step.add.3, splat (i32 4)
  %30 = icmp eq i32 %index.next12, 64
  br i1 %30, label %middle.block4, label %vector.body7, !llvm.loop !11

middle.block4:                                    ; preds = %vector.body7
  br label %scalar.ph5

scalar.ph5:                                       ; preds = %17, %middle.block4
  %bc.resume.val13 = phi i32 [ 65, %middle.block4 ], [ 1, %17 ]
  br label %31

31:                                               ; preds = %scalar.ph5, %39
  %.02 = phi i32 [ %bc.resume.val13, %scalar.ph5 ], [ %40, %39 ]
  %32 = icmp sle i32 %.02, 64
  br i1 %32, label %33, label %41

33:                                               ; preds = %31
  %34 = sub nsw i32 %.02, 1
  %35 = sext i32 %34 to i64
  %36 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 %35
  %37 = load i32, ptr %36, align 4
  %38 = add nsw i32 %37, %.02
  store i32 %38, ptr %36, align 4
  br label %39

39:                                               ; preds = %33
  %40 = add nsw i32 %.02, 1
  br label %31, !llvm.loop !12

41:                                               ; preds = %31
  br label %42

42:                                               ; preds = %51, %41
  %.0 = phi i32 [ 0, %41 ], [ %52, %51 ]
  %43 = icmp slt i32 %.0, 64
  br i1 %43, label %44, label %53

44:                                               ; preds = %42
  %45 = sext i32 %.0 to i64
  %46 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 %45
  %47 = load i32, ptr %46, align 4
  %48 = icmp sgt i32 %47, 0
  br i1 %48, label %49, label %50

49:                                               ; preds = %44
  %.0.lcssa14 = phi i32 [ %.0, %44 ]
  br label %54

50:                                               ; preds = %44
  br label %51

51:                                               ; preds = %50
  %52 = add nsw i32 %.0, 1
  br label %42, !llvm.loop !13

53:                                               ; preds = %42
  br label %54

54:                                               ; preds = %53, %49
  %.03 = phi i32 [ %.0.lcssa14, %49 ], [ -1, %53 ]
  %55 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 0
  %56 = load i32, ptr %55, align 4
  %57 = getelementptr inbounds [64 x i32], ptr %1, i64 0, i64 63
  %58 = load i32, ptr %57, align 4
  %59 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %56, i32 noundef %58, i32 noundef %.03)
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
!11 = distinct !{!11, !7, !8, !9}
!12 = distinct !{!12, !7, !9, !8}
!13 = distinct !{!13, !7}
