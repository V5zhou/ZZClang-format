//
//  ZZXcode.h
//  ZZClang-format
//
//  Created by zmz on 2018/11/20.
//  Copyright © 2018年 zmz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IDEEditorDocument : NSDocument

@property (nonatomic, copy) NSString *editedContents; //编辑区域内容

- (id)documentLocationFromCharacterRange:(struct _NSRange)arg1;
- (id)sdefSupport_selectedCharacterRange;

- (struct _NSRange)characterRangeFromDocumentLocation:(id)arg1;
- (struct _NSRange)lineRangeForCharacterRange:(struct _NSRange)arg1;
- (struct _NSRange)characterRangeForLineRange:(struct _NSRange)arg1;

- (BOOL)replaceTextWithContentsOfURL:(id)arg1 error:(id *)arg2;
- (id)replaceCharactersAtLocation:(id)arg1 withString:(id)arg2;

@end

@class IDESourceCodeEditor;
@interface IDEFileReferenceNavigableItem : NSObject
@property (nonatomic, strong) IDEEditorDocument *document;
@end

@interface IDEEditorContext : NSObject
@property (nonatomic, strong) IDEFileReferenceNavigableItem *greatestDocumentAncestor;
- (IDESourceCodeEditor *)editor;
@end

@interface IDEEditorArea : NSObject
- (IDEEditorContext *)lastActiveEditorContext;
@end

@interface IDEDocumentController : NSDocumentController
+ (id)retainedEditorDocumentForNavigableItem:(id)arg1
                 forUseWithWorkspaceDocument:(id)arg2
                                       error:(id *)arg3;
+ (void)releaseEditorDocument:(id)arg1;
@end

//################### 文件区 #####################

@interface DVTFileDataType : NSObject
@property (readonly) NSString *identifier;
@end

@interface IDENavigableItem : NSObject
@property (readonly) IDENavigableItem *parentItem;
@property (readonly) id representedObject;
@end

@interface IDEFileNavigableItem : IDENavigableItem
@property (readonly) DVTFileDataType *documentType;
@property (readonly) NSURL *fileURL;
@property (readonly) NSDocument *document;
@end

@interface IDEStructureNavigator : NSObject
@property (retain) NSArray *selectedObjects;
@end

@interface IDENavigatorArea : NSObject
- (IDEStructureNavigator *)currentNavigator;
@end

@interface IDEWorkspaceTabController : NSObject
@property (readonly) IDENavigatorArea *navigatorArea;
@end

@interface IDEWorkspaceWindowController : NSObject
@property (readonly) IDEWorkspaceTabController *activeWorkspaceTabController;
- (IDEEditorArea *)editorArea;
@end
