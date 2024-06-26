//
//  PasteViewController.m
//  iTerm
//
//  Created by George Nachman on 3/12/13.
//
//

#import "PasteViewController.h"

#import "iTermAdvancedSettingsModel.h"
#import "NSColor+iTerm.h"
#import "PasteContext.h"
#import "PasteView.h"
#import "PseudoTerminal.h"
#import "PreferencePanel.h"

static float kAnimationDuration = 0.25;

static NSString *iTermPasteViewControllerNibName(BOOL mini) {
    if (mini) {
        return @"MiniPasteView";
    }
    if ([iTermAdvancedSettingsModel useOldStyleDropDownViews]) {
        return @"PasteView";
    }
    return @"MinimalPasteView";
}

@implementation PasteViewController {
    IBOutlet NSTextField *_label;
    IBOutlet NSProgressIndicator *progressIndicator_;
    int totalLength_;
    PasteContext *pasteContext_;
}

@synthesize delegate = delegate_;
@synthesize remainingLength = remainingLength_;

- (instancetype)initWithContext:(PasteContext *)pasteContext
                         length:(int)length
                           mini:(BOOL)mini {
    self = [super initWithNibName:iTermPasteViewControllerNibName(mini)
                           bundle:[NSBundle bundleForClass:self.class]];
    if (self) {
        [self view];
        _mini = mini;

        if (self.view.flipped) {
            // Fix up frames because the view is flipped.
            for (NSView *view in [self.view subviews]) {
                NSRect frame = [view frame];
                frame.origin.y = NSMaxY([self.view bounds]) - NSMaxY([view frame]);
                [view setFrame:frame];
            }
        }
        pasteContext_ = [pasteContext retain];
        totalLength_ = remainingLength_ = length;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(themeDidChange:)
                                                     name:kRefreshTerminalNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [pasteContext_ release];
    [super dealloc];
}

- (void)awakeFromNib {
    if (pasteContext_.isUpload) {
        _label.stringValue = @"Sending…";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_mini) {
        return;
    }
    if ([iTermAdvancedSettingsModel useOldStyleDropDownViews]) {
        return;
    }

    NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
    shadow.shadowOffset = NSMakeSize(2, -2);
    shadow.shadowColor = [NSColor colorWithWhite:0 alpha:0.3];
    shadow.shadowBlurRadius = 2;

    self.view.wantsLayer = YES;
    [self.view makeBackingLayer];
    self.view.shadow = shadow;
}

- (void)viewDidAppear {
    [self updateLabelColor];
}

- (void)updateLabelColor {
    PseudoTerminal* term = [[self.view window] windowController];
    if ([term isKindOfClass:[PseudoTerminal class]]) {
        _label.textColor = [term accessoryTextColorForMini:self.mini];
    }
    if (!self.mini) {
        return;
    }
    if (_label.textColor.perceivedBrightness > 0.5) {
        progressIndicator_.appearance = [NSAppearance appearanceNamed:NSAppearanceNameDarkAqua];
    } else {
        progressIndicator_.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }
}

- (IBAction)cancel:(id)sender {
    [delegate_ pasteViewControllerDidCancel];
}

- (void)setRemainingLength:(int)remainingLength {
    remainingLength_ = remainingLength;
    double ratio = remainingLength;
    ratio /= (double)totalLength_;
    [progressIndicator_ setDoubleValue:1.0 - ratio];
    [progressIndicator_ displayIfNeeded];
}

- (void)updateFrame {
    NSRect newFrame = self.view.frame;
    newFrame.origin.y = self.view.superview.frame.size.height;
    self.view.frame = newFrame;

    newFrame.origin.y += self.view.frame.size.height;
    newFrame = NSMakeRect(self.view.frame.origin.x,
                          self.view.superview.frame.size.height - self.view.frame.size.height,
                          self.view.frame.size.width,
                          self.view.frame.size.height);
    [[NSAnimationContext currentContext] setDuration:kAnimationDuration];
    self.view.frame = newFrame;
    self.view.animator.alphaValue = 1;
}

- (void)closeWithCompletion:(void (^)(void))completion {
    NSRect newFrame = self.view.frame;
    newFrame.origin.y = self.view.superview.frame.size.height;
    [[NSAnimationContext currentContext] setDuration:kAnimationDuration];
    self.view.animator.alphaValue = 0;
    [self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kAnimationDuration];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        completion();
    }];
}

- (void)themeDidChange:(id)sender {
    [self updateLabelColor];
}

@end
