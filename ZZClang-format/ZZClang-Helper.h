//
//  ZZClang-Helper.h
//  ZZClang-format
//
//  Created by zmz on 2018/11/20.
//  Copyright © 2018年 zmz. All rights reserved.
//

#import "ZZXcode.h"
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZClang_Helper : NSObject

+ (IDEEditorContext *)editorContext;

/**
 获取选中文件
 */
+ (NSArray *)selectedFiles;

/*
 获取选中行range, 选中整行字符range
 */
+ (BOOL)getsLineRange:(NSRange *)lineRange
       characterRange:(NSRange *)characterRange
           inDocument:(IDEEditorDocument *)document
          selectRange:(NSRange)selectRange;

/**
 * 执行clang-format格式化
 */
+ (void)formatDocument:(IDEEditorDocument *)document
        characterRange:(NSRange)characterRange
            launchPath:(NSString *)launchPath;

@end

NS_ASSUME_NONNULL_END
