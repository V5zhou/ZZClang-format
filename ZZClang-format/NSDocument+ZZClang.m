//
//  NSDocument+ZZClang.m
//  ZZClang-format
//
//  Created by zmz on 2018/11/23.
//  Copyright © 2018年 zmz. All rights reserved.
//

#import "NSDocument+ZZClang.h"
#import "ZZClang-format.h"
#import <objc/runtime.h>

static BOOL static_is_save;
extern ZZClang_format *zzclang_format_once;

@implementation NSDocument (ZZClang)

+ (void)load {
    Method m1 = class_getInstanceMethod(self, @selector
                                        (saveDocumentWithDelegate:didSaveSelector:contextInfo:));
    Method m11 = class_getInstanceMethod(
                                         self, @selector(zz_saveDocumentWithDelegate:didSaveSelector:contextInfo:));
    method_exchangeImplementations(m1, m11);
    
    //取出磁盘值
    NSNumber *is_save =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"clang_format_when_save"];
    static_is_save = is_save.boolValue;
}

- (void)zz_saveDocumentWithDelegate:(id)delegate
                    didSaveSelector:(SEL)didSaveSelector
                        contextInfo:(void *)contextInfo {
    if (static_is_save && [self ZZClang_shouldFormat]) { [zzclang_format_once formatFocusFile]; }
    //    [self zz_saveDocumentWithDelegate:delegate didSaveSelector:didSaveSelector
    //    contextInfo:contextInfo];
}

+ (void)changeIsFormatWhenSave {
    static_is_save = !static_is_save;
    //同时保存磁盘
    [[NSUserDefaults standardUserDefaults] setObject:@(static_is_save)
                                              forKey:@"clang_format_when_save"];
}

+ (BOOL)isFormatWhenSave {
    return static_is_save;
}

/**
 是否支持当前文档类型？
 遍历所有支持的后缀实现
 */
- (BOOL)ZZClang_shouldFormat {
    return [[NSSet setWithObjects:@"c", @"h", @"cpp", @"cc", @"cxx", @"hh", @"hpp", @"hxx", @"ipp",
             @"m", @"mm", @"metal", nil]
            containsObject:[[[self fileURL] pathExtension] lowercaseString]];
}

@end
