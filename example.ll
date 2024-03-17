; ModuleID = 'MicroC'
source_filename = "MicroC"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.1 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@tmp = private unnamed_addr constant [2 x i8] c".\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @printbig(i32)

declare i8* @concat(i8*, i8*)

declare { i8**, i32, i32 }* @newStrings()

declare i32 @append({ i8**, i32, i32 }*, i8*)

declare i32 @size({ i8**, i32, i32 }*)

declare i32 @show({ i8**, i32, i32 }*)

declare { i8**, i32, i32 }* @query(i8*)

define i32 @main() {
entry:
  %a = alloca { i8**, i32, i32 }*
  %query = call { i8**, i32, i32 }* @query(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @tmp, i32 0, i32 0))
  store { i8**, i32, i32 }* %query, { i8**, i32, i32 }** %a
  %a1 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %size = call i32 @size({ i8**, i32, i32 }* %a1)
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %size)
  %a2 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %show = call i32 @show({ i8**, i32, i32 }* %a2)
  ret i32 0
}
