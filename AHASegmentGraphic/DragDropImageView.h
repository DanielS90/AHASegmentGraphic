//
//  DragDropImageView.h
//  DST1Curve
//
//  Created by Daniel Schroth on 22.06.22.
//

#import <Cocoa/Cocoa.h>

@protocol DragDropImageViewDelegate;

@interface DragDropImageView : NSImageView <NSDraggingSource, NSDraggingDestination, NSPasteboardItemDataProvider>
{
    //highlight the drop zone
    BOOL highlight;
}

@property (assign) BOOL allowDrag;
@property (assign) BOOL allowDrop;
@property (assign) IBOutlet id<DragDropImageViewDelegate> delegate;
@property (retain) NSString *path;

- (id)initWithCoder:(NSCoder *)coder;

@end

@protocol DragDropImageViewDelegate <NSObject>

- (void)dropComplete:(NSString *)filePath;

@end
