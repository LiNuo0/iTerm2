//
//  iTermImageWell.m
//  iTerm2
//
//  Created by George Nachman on 12/17/14.
//
//

#import "iTermImageWell.h"

@implementation iTermImageWell

- (void)awakeFromNib {
    self.wantsLayer = YES;
    self.layer.borderColor = [[NSColor whiteColor] CGColor];
    self.layer.borderWidth = 2.0;
    self.layer.cornerRadius = 6.0;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)draggingInfo {
    if (![super performDragOperation:draggingInfo]) {
        return NO;
    }

    NSPasteboard *pasteboard = [draggingInfo draggingPasteboard];
    NSString *theString = [pasteboard stringForType:NSPasteboardTypeFileURL];

    if (theString) {
        NSData *data = [theString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *filenames =
            [NSPropertyListSerialization propertyListWithData:data
                                                      options:NSPropertyListImmutable
                                                       format:nil
                                                        error:nil];

        if (filenames.count) {
            [_delegate imageWellDidPerformDropOperation:self filename:filenames[0]];
        }
    }

    return YES;
}

// If we don't override mouseDown: then mouseUp: never gets called.
- (void)mouseDown:(NSEvent *)theEvent {
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (theEvent.clickCount == 1) {
        [_delegate imageWellDidClick:self];
    }
}

- (BOOL)clipsToBounds {
    return YES;
}

@end
