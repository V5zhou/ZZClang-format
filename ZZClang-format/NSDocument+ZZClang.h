//
//  NSDocument+ZZClang.h
//  ZZClang-format
//
//  Created by zmz on 2018/11/23.
//  Copyright © 2018年 zmz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDocument (ZZClang)

/*
 是否save时保存
 */
+ (void)changeIsFormatWhenSave;
+ (BOOL)isFormatWhenSave;

/**
 是否支持当前文档类型？
 遍历所有支持的后缀实现
 */
- (BOOL)ZZClang_shouldFormat;

@end

NS_ASSUME_NONNULL_END
