//
//  ZZClang-format.m
//  ZZClang-format
//
//  Created by zmz on 2018/11/20.
//  Copyright © 2018年 zmz. All rights reserved.
//

#import "ZZClang-format.h"
#import "NSDocument+ZZClang.h"
#import "ZZClang-Fragment.h"
#import "ZZClang-Helper.h"
#import "ZZXcode.h"

ZZClang_format *zzclang_format_once = nil;

@interface ZZClang_format ()

@property (nonatomic, copy) NSString *launchPath;
@property (nonatomic, strong) NSMenuItem *formatOnSaveItem;

@end

@implementation ZZClang_format

#pragma mark - 生命周期
+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zzclang_format_once            = [[ZZClang_format alloc] init];
        zzclang_format_once.launchPath = [plugin pathForResource:@"clang-format" ofType:@""];
        //注册通知，当app加载完成时，再加载此插件
        [[NSNotificationCenter defaultCenter]
         addObserver:zzclang_format_once
         selector:@selector(applicationDidFinishLaunching:)
         name:NSApplicationDidFinishLaunchingNotification
         object:nil];
    });
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [self addOperations];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSApplicationDidFinishLaunchingNotification
                                                  object:nil];
}

#pragma mark - 添加按钮
- (void)addOperations {
    // Edite栏
    NSMenuItem *editMenu = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (editMenu) {
        [[editMenu submenu] addItem:[NSMenuItem separatorItem]];
        // ZZCF按钮
        NSMenuItem *formatMenu =
        [[NSMenuItem alloc] initWithTitle:@"ZZClang-format" action:NULL keyEquivalent:@""];
        [[editMenu submenu] addItem:formatMenu];
        
        NSMenu *childMenu = [[NSMenu alloc] init];
        [formatMenu setSubmenu:childMenu];
        
        //三大按钮
        NSArray *titles = @[ @"选择format类型☟", @"FocusFile", @"SelectFiles", @"SelectText" ];
        NSArray *actions = @[ @"", @"formatFocusFile", @"formatSelectFiles", @"formatSelectText" ];
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *_Nonnull stop) {
            NSMenuItem *actionItem =
            [[NSMenuItem alloc] initWithTitle:titles[idx]
                                       action:NSSelectorFromString(actions[idx])
                                keyEquivalent:@""];
            [actionItem setTarget:self];
            [childMenu addItem:actionItem];
            if (idx == 0) {
                actionItem.state = NSOffState;
                [childMenu addItem:[NSMenuItem separatorItem]];
            }
        }];
        
        //是否开启FormatOnSave
        [childMenu addItem:[NSMenuItem separatorItem]];
        self.formatOnSaveItem = [[NSMenuItem alloc] initWithTitle:[self titleForIsFormatOnSave]
                                                           action:@selector(fomatOnSaveClick)
                                                    keyEquivalent:@""];
        [_formatOnSaveItem setTarget:self];
        [childMenu addItem:_formatOnSaveItem];
    }
}

#pragma mark - 三大方法
- (void)formatFocusFile {
    @try {
        IDEEditorDocument *document =
        [ZZClang_Helper editorContext].greatestDocumentAncestor.document;
        NSRange range = NSMakeRange(0, document.editedContents.length);
        NSLog(@"选中区域文本为：%@", [document.editedContents substringWithRange:range]);
        
        if (range.length < 1) { return; }
        [ZZClang_Helper formatDocument:document characterRange:range launchPath:self.launchPath];
    } @catch (NSException *exception) {
        NSLog(@"formatFocusFile崩溃，reson:%@, 堆栈：%@", exception.reason,
              exception.callStackSymbols);
    } @finally {}
}

- (void)formatSelectFiles {
    @try {
        [[ZZClang_Helper selectedFiles]
         enumerateObjectsUsingBlock:^(IDEFileNavigableItem *fileNavigableItem, NSUInteger idx,
                                      BOOL *_Nonnull stop) {
             
             //_TtC15IDESourceEditor18SourceCodeDocument
             IDEEditorDocument *document =
             [IDEDocumentController retainedEditorDocumentForNavigableItem:fileNavigableItem
                                               forUseWithWorkspaceDocument:nil
                                                                     error:nil];
             
             NSRange range = NSMakeRange(0, document.editedContents.length);
             NSLog(@"选中区域文本为：%@", [document.editedContents substringWithRange:range]);
             
             if (range.length < 1) { return; }
             [ZZClang_Helper formatDocument:document
                             characterRange:range
                                 launchPath:self.launchPath];
             
             [IDEDocumentController releaseEditorDocument:document];
         }];
    } @catch (NSException *exception) {
        NSLog(@"formatSelectFiles崩溃，reson:%@, 堆栈：%@", exception.reason,
              exception.callStackSymbols);
    } @finally {}
}

- (void)formatSelectText {
    @try {
        IDEEditorDocument *document =
        [ZZClang_Helper editorContext].greatestDocumentAncestor.document;
        
        NSArray *ranges = [document sdefSupport_selectedCharacterRange];
        if (ranges.count < 2) { return; }
        NSRange range = NSMakeRange([ranges[0] integerValue] - 1,
                                    [ranges[1] integerValue] - [ranges[0] integerValue] + 1);
        
        if (range.length < 1) { return; }
        NSLog(@"选中区域文本为：%@", [document.editedContents substringWithRange:range]);
        
        [ZZClang_Helper formatDocument:document characterRange:range launchPath:self.launchPath];
    } @catch (NSException *exception) {
        NSLog(@"formatSelectText崩溃，reson:%@, 堆栈：%@", exception.reason,
              exception.callStackSymbols);
    } @finally {}
}

- (void)fomatOnSaveClick {
    @try {
        [NSDocument changeIsFormatWhenSave];
        self.formatOnSaveItem.title = [self titleForIsFormatOnSave];
    } @catch (NSException *exception) {
        NSLog(@"fomatOnSaveClick崩溃，reson:%@, 堆栈：%@", exception.reason,
              exception.callStackSymbols);
    } @finally {}
}

- (NSString *)titleForIsFormatOnSave {
    return [NSDocument isFormatWhenSave] ? @"ZZFormatOnSave-ON" : @"ZZFormatOnSave-OFF";
}

@end
