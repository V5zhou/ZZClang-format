//
//  ZZClang-Fragment.h
//  ZZClang-format
//
//  Created by zmz on 2018/11/21.
//  Copyright © 2018年 zmz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZClang_Fragment : NSObject

//初始记录，必传
@property (nonatomic, copy) NSString *launchPath; ///< 可执行文件路径(clang-format)

@property (nonatomic, copy) NSURL *sourceFileURL; ///< 初始文件地址
@property (nonatomic, copy) NSString *sourceText; ///< 初始文本内容

@property (nonatomic, assign) NSRange sourceSelectRange; ///< 初始选中文本range
@property (nonatomic, assign) NSRange linedCR;           ///< 化为整行时，文本range
@property (nonatomic, assign) NSRange linedLR;           ///< 化为整行时，行range

/**
 * 开始执行格式化
 */
- (void)startFormatWithCallback:(void (^)(NSString *errorDesc, NSString *formatedString))callback;

//格式化后记录
@property (nonatomic, copy) NSString *outputText;            ///< 格式化后文本
@property (nonatomic, copy) NSString *outputSelectText;      ///< 被格式化那部分文本
@property (nonatomic, assign) NSRange outputSelectTextRange; ///< 被格式化那部分文本range

@end

NS_ASSUME_NONNULL_END
