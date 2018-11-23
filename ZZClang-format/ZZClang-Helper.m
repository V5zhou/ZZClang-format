//
//  ZZClang-Helper.m
//  ZZClang-format
//
//  Created by zmz on 2018/11/20.
//  Copyright © 2018年 zmz. All rights reserved.
//

#import "ZZClang-Helper.h"
#import "ZZClang-Fragment.h"

@implementation ZZClang_Helper

#pragma mark - 公共方法

+ (NSWindowController *)windowController {
    return [[NSApp keyWindow] windowController];
}

+ (IDEEditorContext *)editorContext {
    NSWindowController *window = [self windowController];
    if (![window isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) return nil;
    
    IDEEditorArea *editorArea       = [(IDEWorkspaceWindowController *)window editorArea];
    IDEEditorContext *editorContext = [editorArea lastActiveEditorContext];
    return editorContext;
}

/**
 获取选中文件
 */
+ (NSArray *)selectedFiles {
    NSWindowController *window = [self windowController];
    if (![window isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) return nil;
    
    //左上代码区域
    IDEWorkspaceTabController *workspaceTabController =
    [(IDEWorkspaceWindowController *)window activeWorkspaceTabController];
    IDENavigatorArea *navigatorArea         = [workspaceTabController navigatorArea];
    IDEStructureNavigator *currentNavigator = [navigatorArea currentNavigator];
    
    //取出放入数组
    NSMutableArray *selectFiles = [NSMutableArray array];
    [[currentNavigator selectedObjects] enumerateObjectsUsingBlock:^(
                                                                     IDEFileNavigableItem *fileNavigableItem, NSUInteger idx,
                                                                     BOOL *_Nonnull stop) {
        if (![fileNavigableItem isKindOfClass:NSClassFromString(@"IDEFileNavigableItem")]) return;
        
        NSString *uti = fileNavigableItem.documentType.identifier;
        if ([[NSWorkspace sharedWorkspace] type:uti conformsToType:(NSString *)kUTTypeSourceCode]) {
            [selectFiles addObject:fileNavigableItem];
        }
    }];
    return [selectFiles copy];
}

//获取选中行range,选中整行字符range
+ (BOOL)getsLineRange:(NSRange *)lineRange
       characterRange:(NSRange *)characterRange
           inDocument:(IDEEditorDocument *)document
          selectRange:(NSRange)selectRange {
    NSRange LR      = [document lineRangeForCharacterRange:selectRange];
    NSRange CR      = [document characterRangeForLineRange:LR];
    *lineRange      = LR;
    *characterRange = CR;
    return YES;
}

//执行clang-format格式化
+ (void)formatDocument:(IDEEditorDocument *)document
        characterRange:(NSRange)characterRange
            launchPath:(NSString *)launchPath {
    NSRange LR, CR;
    [self getsLineRange:&LR characterRange:&CR inDocument:document selectRange:characterRange];
    
    NSMutableArray *fragments = [NSMutableArray array];
    NSMutableArray *errors    = [NSMutableArray array];
    
    //组装碎片
    ZZClang_Fragment *fragment = [ZZClang_Fragment new];
    fragment.launchPath        = launchPath;
    fragment.sourceSelectRange = characterRange;
    fragment.linedLR           = LR;
    fragment.linedCR           = CR;
    fragment.sourceFileURL     = document.fileURL;
    fragment.sourceText        = document.editedContents;
    
    //开始格式化
    __weak typeof(fragment) weakFragment = fragment;
    [fragment
     startFormatWithCallback:^(NSString *_Nonnull errorDesc, NSString *_Nonnull formatedString) {
         __weak typeof(fragment) strongFragment = weakFragment;
         if (errorDesc.length > 0) {
             [errors addObject:errorDesc];
         } else {
             [fragments addObject:strongFragment];
         }
     }];
    
    //更新undo及选中区
    [self updateUndoAndSelectedRangeWithFragments:fragments inDocument:document];
}

//格式化完成后，更新undo及选中区域
+ (void)updateUndoAndSelectedRangeWithFragments:(NSArray *)fragments
                                     inDocument:(IDEEditorDocument *)document {
    [fragments enumerateObjectsUsingBlock:^(ZZClang_Fragment *fragment, NSUInteger idx,
                                            BOOL *_Nonnull stop) {
        NSRange range = fragment.linedCR;
        id loc        = [document documentLocationFromCharacterRange:range];
        [document replaceCharactersAtLocation:loc withString:fragment.outputSelectText];
    }];
}

@end
