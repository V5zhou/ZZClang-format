//
//  ZZClang-format.h
//  ZZClang-format
//
//  Created by zmz on 2018/11/20.
//  Copyright © 2018年 zmz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZClang_format : NSObject

- (void)formatFocusFile;
- (void)formatSelectFiles;
- (void)formatSelectText;

@end

NS_ASSUME_NONNULL_END
