; ModuleID = 'MicroC'
source_filename = "MicroC"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.1 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@tmp = private unnamed_addr constant [2 x i8] c".\00", align 1
@tmp.3 = private unnamed_addr constant [10 x i8] c"string_of\00", align 1

declare i32 @printf(i8*, ...)

declare i8* @concat(i8*, i8*)

declare { i8**, i32, i32 }* @newStrings()

declare i32 @append({ i8**, i32, i32 }*, i8*)

declare i32 @size({ i8**, i32, i32 }*)

declare i32 @show({ i8**, i32, i32 }*)

declare { i8**, i32, i32 }* @query(i8*, i32, i32, i32, i8*, i8*)

declare { i8**, i32, i32 }* @searchPath(i8*, i8*)

declare { i8**, i32, i32 }* @unionStrings({ i8**, i32, i32 }*, { i8**, i32, i32 }*)

declare { i8**, i32, i32 }* @intersectStrings({ i8**, i32, i32 }*, { i8**, i32, i32 }*)

define i32 @main() {
entry:
  %grep = call { i8**, i32, i32 }* @searchPath(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @tmp.3, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @tmp, i32 0, i32 0))
  %check = call i32 @show({ i8**, i32, i32 }* %grep)
  ret i32 0
}
