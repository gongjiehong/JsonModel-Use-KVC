//
//  DragView.h
//  HelloDragAndDrop
//
//  Created by 龚杰洪 on 2014/5/10.
//  Copyright (c) 2014年 龚杰洪. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DragView;

@protocol DragViewDelagate < NSObject >

@optional
- (BOOL)dragFileURL:(NSURL *)fileURL;

@end

@interface DragView : NSView

@property (nonatomic) id< DragViewDelagate > delegate;

@end
