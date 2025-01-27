//
//  iTermKeyMapper.h
//  iTerm2
//
//  Created by George Nachman on 12/30/18.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, iTermKeyMappingMode) {
    iTermKeyMappingModeStandard,
    iTermKeyMappingModeCSIu,
    iTermKeyMappingModeRaw,
    iTermKeyMappingModeModifyOtherKeys1,
    iTermKeyMappingModeModifyOtherKeys2
};

NS_ASSUME_NONNULL_BEGIN

// A key mapper is responsible for converting an event into the data that gets sent to the pty.
@protocol iTermKeyMapper<NSObject>

@property (nonatomic, readonly) BOOL keyMapperWantsKeyUp;

// Before the event is routed through Cocoa's input handling (via the input method editor), this
// gets a chance to handle it. For better or worse this is how we handle control keys. I have a
// feeling doing so causes some amount of pain for people whose input method editors use control
// for something, but I don't really know and nobody is complaining.
//
// If this returns a non-nil value then it's sent to insertText: and the event will receive no more
// handling.
- (nullable NSString *)keyMapperStringForPreCocoaEvent:(NSEvent *)event;

// For events that are not handled by the pre-cocoa code (because it was bypassed, the pre-cocoa
// handler returned nil, or it was a repeating keypress not otherwise handled), they may come here
// as the last resort after the controller has a chance to handle it.
- (nullable NSData *)keyMapperDataForPostCocoaEvent:(NSEvent *)event;

- (nullable NSData *)keyMapperDataForKeyUp:(NSEvent *)event;

// If this returns YES then the event will be sent to the controller which, if it does not handle
// the event itself, will send the event to the post-cocoa handler here.
//
// If this returns NO, keyMapperStringForPreCocoaEvent is usually called (except for unusual cases
// like cmd is pressed, it's a dead key, or marked text existed) and if it returns a nonnil value
// it is sent.
//
// Most importantly: if you want the event to go through the IME, return NO.
- (BOOL)keyMapperShouldBypassPreCocoaForEvent:(NSEvent *)event;

// Prepare to handle this event. Update config from delegate.
- (void)keyMapperSetEvent:(NSEvent *)event;

// When a keystroke is routed to performKeyEquivalent instead of keyDown, this is called to check
// if the key mapper is interested in it.
- (BOOL)keyMapperWantsKeyEquivalent:(NSEvent *)event;

- (NSDictionary *)keyMapperDictionaryValue;

- (BOOL)wouldReportControlReturn;

- (BOOL)shouldHandleBuckyBits;
- (NSString * _Nullable)handleKeyDownWithBuckyBits:(NSEvent *)event;
- (NSString * _Nullable)handleKeyUpWithBuckyBits:(NSEvent *)event;
- (NSString * _Nullable)handleFlagsChangedWithBuckyBits:(NSEvent *)event;

// When the IME provides text and calls insertText: the keymapper has a chance to transform
// it (for example, to CSI-u encode it) in this method.
- (NSString *)transformedTextToInsert:(NSString *)text;

//@optional
//- (void)setDelegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
