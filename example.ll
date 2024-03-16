; ModuleID = 'MicroC'
source_filename = "MicroC"

@s2_str = global [1 x i8] zeroinitializer
@s2 = global [1 x i8]* @s2_str
@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.1 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@tmp = private unnamed_addr constant [5 x i8] c"tttt\00", align 1
@tmp.3 = private unnamed_addr constant [4 x i8] c"sss\00", align 1
@fmt.4 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.5 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@fmt.6 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @printbig(i32)

define i32 @main() {
entry:
  %x = alloca i32
  %s = alloca i8*
  %t = alloca i8*
  store i32 1, i32* %x
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @tmp, i32 0, i32 0), i8** %t
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @tmp.3, i32 0, i32 0), i8** %s
  %x1 = load i32, i32* %x
  %x2 = load i32, i32* %x
  %tmp = add i32 %x1, %x2
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %tmp)
  %x3 = load i32, i32* %x
  %printf4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %x3)
  %s5 = load i8*, i8** %s
  %printf6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.2, i32 0, i32 0), i8* %s5)
  %s2 = load [1 x i8]*, [1 x i8]** @s2
  %printf7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.2, i32 0, i32 0), [1 x i8]* %s2)
  %t8 = load i8*, i8** %t
  %printf9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.2, i32 0, i32 0), i8* %t8)
  ret i32 0
}

define i32 @add(i32 %x, i32 %y) {
entry:
  %x1 = alloca i32
  store i32 %x, i32* %x1
  %y2 = alloca i32
  store i32 %y, i32* %y2
  %s2 = load [1 x i8]*, [1 x i8]** @s2
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.6, i32 0, i32 0), [1 x i8]* %s2)
  %x3 = load i32, i32* %x1
  %y4 = load i32, i32* %y2
  %tmp = add i32 %x3, %y4
  ret i32 %tmp
}
