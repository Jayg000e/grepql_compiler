; ModuleID = 'MicroC'
source_filename = "MicroC"

@s2 = global i8* null
@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.1 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@tmp = private unnamed_addr constant [4 x i8] c"abc\00", align 1
@tmp.3 = private unnamed_addr constant [4 x i8] c"cba\00", align 1
@fmt.4 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.5 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@fmt.6 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @printbig(i32)

declare i8* @concat(i8*, i8*)

define i32 @main() {
entry:
  %s = alloca i8*
  %t = alloca i8*
  %st = alloca i8*
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @tmp, i32 0, i32 0), i8** %s
  %s1 = load i8*, i8** %s
  store i8* %s1, i8** @s2
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @tmp.3, i32 0, i32 0), i8** %t
  %t2 = load i8*, i8** %t
  %s3 = load i8*, i8** %s
  %concat = call i8* @concat(i8* %s3, i8* %t2)
  store i8* %concat, i8** %st
  %st4 = load i8*, i8** %st
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.2, i32 0, i32 0), i8* %st4)
  %s5 = load i8*, i8** %s
  %t6 = load i8*, i8** %t
  %concat7 = call i8* @concat(i8* %t6, i8* %s5)
  store i8* %concat7, i8** %st
  %st8 = load i8*, i8** %st
  %t9 = load i8*, i8** %t
  %concat10 = call i8* @concat(i8* %t9, i8* %st8)
  store i8* %concat10, i8** %st
  %st11 = load i8*, i8** %st
  %printf12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.2, i32 0, i32 0), i8* %st11)
  %s13 = load i8*, i8** %s
  %cat3_result = call i8* @cat3(i8* %s13)
  %printf14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.2, i32 0, i32 0), i8* %cat3_result)
  %printbig = call i32 @printbig(i32 100)
  %s2 = load i8*, i8** @s2
  %printf15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.2, i32 0, i32 0), i8* %s2)
  ret i32 0
}

define i8* @cat3(i8* %a) {
entry:
  %a1 = alloca i8*
  store i8* %a, i8** %a1
  %b = alloca i8*
  %a2 = load i8*, i8** %a1
  %a3 = load i8*, i8** %a1
  %concat = call i8* @concat(i8* %a3, i8* %a2)
  store i8* %concat, i8** %b
  %a4 = load i8*, i8** %a1
  %b5 = load i8*, i8** %b
  %concat6 = call i8* @concat(i8* %b5, i8* %a4)
  store i8* %concat6, i8** %b
  %b7 = load i8*, i8** %b
  ret i8* %b7
}
