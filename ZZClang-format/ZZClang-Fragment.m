//
//  ZZClang-Fragment.m
//  ZZClang-format
//
//  Created by zmz on 2018/11/21.
//  Copyright © 2018年 zmz. All rights reserved.
//

#import "ZZClang-Fragment.h"

@implementation ZZClang_Fragment

- (void)startFormatWithCallback:(void (^)(NSString *errorDesc, NSString *formatedString))callback {
    NSString *fileName = [self.sourceFileURL lastPathComponent];
    NSURL *tmpDirURL   = [[self.sourceFileURL URLByDeletingLastPathComponent]
                          URLByAppendingPathComponent:@"ClangFormatXcodeTmpDir"];
    
    //创建tmp文件夹，并把源文本写入文件
    [[NSFileManager defaultManager] createDirectoryAtURL:tmpDirURL
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:nil];
    NSURL *tmpFileURL = [tmpDirURL URLByAppendingPathComponent:fileName];
    [self.sourceText writeToURL:tmpFileURL atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    //执行clang-format
    [self clangFormatWithFileURL:tmpFileURL
                        callback:^(NSString *errorDesc, NSString *formatedString) {
                            if (callback) { callback(errorDesc, formatedString); }
                            //删除tmp
                            [[NSFileManager defaultManager] removeItemAtURL:tmpDirURL error:NULL];
                        }];
}

/**
 * 真实的clang-format执行主体
 */
- (void)clangFormatWithFileURL:(NSURL *)fileURL
                      callback:(void (^)(NSString *errorDesc, NSString *formatedString))callback {
    NSPipe *outputPipe = [NSPipe pipe];
    NSPipe *errorPipe  = [NSPipe pipe];
    
    NSTask *task        = [[NSTask alloc] init];
    task.standardOutput = outputPipe;
    task.standardError  = errorPipe;
    task.launchPath     = self.launchPath;
    
    //这里有个bug，为什么我格式-lines=64:64，就会把XHGMineMachinesGroupVC.m第65行的8个空格给去掉，导致我计算错误，日了狗。
    NSString *lineRange =
    [NSString stringWithFormat:@"-lines=%tu:%tu", self.linedLR.location + 1,
     self.linedLR.location + self.linedLR.length]; // 1-based
    task.arguments = @[ lineRange, @"--style=File", @"-i", [fileURL path] ];
    [outputPipe.fileHandleForReading readToEndOfFileInBackgroundAndNotify];
    
    [task launch];
    [task waitUntilExit];
    
    //读取格式化后文本内容
    self.outputText =
    [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:NULL];
    [self recordFormatedData]; //更新格式化后数据
    
    //读取错误信息
    NSString *errorDesc =
    [[NSString alloc] initWithData:[errorPipe.fileHandleForReading readDataToEndOfFile]
                          encoding:NSUTF8StringEncoding];
    
    if (callback) { callback(errorDesc, [self.outputSelectText copy]); }
}

/**
 * 更新格式化后数据
 */
- (void)recordFormatedData {
    NSUInteger source_len = self.sourceText.length;
    NSUInteger out_len    = self.outputText.length;
    
    //左验证
    for (NSInteger i = 0; i < self.linedCR.location; i++) {
        printf("%c", [self.sourceText characterAtIndex:i]);
        if ([self.sourceText characterAtIndex:i] != [self.outputText characterAtIndex:i]) {
            NSLog(@"左部分异常改动");
            break;
        }
    }
    NSLog(@"===========================");
    //右验证
    NSInteger offset = out_len - source_len;
    for (NSInteger i = self.linedCR.location + self.linedCR.length + 1; i < source_len; i++) {
        printf("%c", [self.sourceText characterAtIndex:i]);
        if ([self.sourceText characterAtIndex:i] != [self.outputText characterAtIndex:i + offset]) {
            NSLog(@"右部分异常改动");
            break;
        }
    }
    //区域
    self.outputSelectTextRange = NSMakeRange(self.linedCR.location, self.linedCR.length + offset);
    self.outputSelectText      = [self.outputText substringWithRange:self.outputSelectTextRange];
}

@end
