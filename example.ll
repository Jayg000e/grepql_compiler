; ModuleID = 'MicroC'
source_filename = "MicroC"

@s2 = global i8* null
@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.1 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@tmp = private unnamed_addr constant [4 x i8] c"abc\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @printbig(i32)

define i32 @main() {
entry:
  %s = alloca i8*
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @tmp, i32 0, i32 0), i8** %s
  %s1 = load i8*, i8** %s
  store i8* %s1, i8** @s2
  %s2 = load i8*, i8** @s2
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.2, i32 0, i32 0), i8* %s2)
  ret i32 0
}
