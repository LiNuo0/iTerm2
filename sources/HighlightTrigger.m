//
//  HighlightTrigger.m
//  iTerm2
//
//  Created by George Nachman on 9/23/11.
//

#import "HighlightTrigger.h"
#import "NSColor+iTerm.h"
#import "NSDictionary+iTerm.h"
#import "NSImage+iTerm.h"
#import "ScreenChar.h"

NSString * const kHighlightForegroundColor = @"kHighlightForegroundColor";
NSString * const kHighlightBackgroundColor = @"kHighlightBackgroundColor";


// Preserve these values - they are the tags and are saved in preferences.
enum {
    kYellowOnBlackHighlight,
    kBlackOnYellowHighlight,
    kWhiteOnRedHighlight,
    kRedOnWhiteHighlight,
    kBlackOnOrangeHighlight,
    kOrangeOnBlackHighlight,
    kBlackOnPurpleHighlight,
    kPurpleOnBlackHighlight,

    kBlackHighlight = 1000,
    kDarkGrayHighlight,
    kLightGrayHighlight,
    kWhiteHighlight,
    kGrayHighlight,
    kRedHighlight,
    kGreenHighlight,
    kBlueHighlight,
    kCyanHighlight,
    kYellowHighlight,
    kMagentaHighlight,
    kOrangeHighlight,
    kPurpleHighlight,
    kBrownHighlight,

    kBlackBackgroundHighlight = 2000,
    kDarkGrayBackgroundHighlight,
    kLightGrayBackgroundHighlight,
    kWhiteBackgroundHighlight,
    kGrayBackgroundHighlight,
    kRedBackgroundHighlight,
    kGreenBackgroundHighlight,
    kBlueBackgroundHighlight,
    kCyanBackgroundHighlight,
    kYellowBackgroundHighlight,
    kMagentaBackgroundHighlight,
    kOrangeBackgroundHighlight,
    kPurpleBackgroundHighlight,
    kBrownBackgroundHighlight,


};

@implementation HighlightTrigger {
    NSDictionary *_cachedColors;
}

+ (NSString *)title {
    return @"Highlight Text…";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Highlight text %@ over %@", self.textColor.humanReadableDescription ?: @"(no color)", self.backgroundColor.humanReadableDescription ?: @"(no color))"];
}

- (NSString *)triggerOptionalParameterPlaceholderWithInterpolation:(BOOL)interpolation {
    return @"";
}

- (BOOL)takesParameter
{
    return YES;
}

- (BOOL)paramIsPopupButton {
    return NO;
}

- (BOOL)paramIsTwoColorWells {
    return YES;
}

- (BOOL)isIdempotent {
    return YES;
}

- (void)sanitize {
    NSDictionary *colors = [self colorsPreservingColorSpace:YES];
    self.textColor = colors[kHighlightForegroundColor];
    self.backgroundColor = colors[kHighlightBackgroundColor];
}

- (NSDictionary *)menuItemsForPoupupButton {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Yellow on Black", [NSNumber numberWithInt:(int)kYellowOnBlackHighlight],
            @"Black on Yellow", [NSNumber numberWithInt:(int)kBlackOnYellowHighlight],
            @"White on Red",    [NSNumber numberWithInt:(int)kWhiteOnRedHighlight],
            @"Red on White",    [NSNumber numberWithInt:(int)kRedOnWhiteHighlight],
            @"Black on Orange", [NSNumber numberWithInt:(int)kBlackOnOrangeHighlight],
            @"Orange on Black", [NSNumber numberWithInt:(int)kOrangeOnBlackHighlight],
            @"Purple on Black", [NSNumber numberWithInt:(int)kPurpleOnBlackHighlight],
            @"Black on Purple", [NSNumber numberWithInt:(int)kBlackOnPurpleHighlight],

            @"Black Foreground",  [NSNumber numberWithInt:(int)kBlackHighlight],
            @"Blue Foreground",  [NSNumber numberWithInt:(int)kBlueHighlight],
            @"Brown Foreground",  [NSNumber numberWithInt:(int)kBrownHighlight],
            @"Cyan Foreground",  [NSNumber numberWithInt:(int)kCyanHighlight],
            @"Dark Gray Foreground",  [NSNumber numberWithInt:(int)kDarkGrayHighlight],
            @"Gray Foreground",  [NSNumber numberWithInt:(int)kGrayHighlight],
            @"Green Foreground",  [NSNumber numberWithInt:(int)kGreenHighlight],
            @"Light Gray Foreground",  [NSNumber numberWithInt:(int)kLightGrayHighlight],
            @"Magenta Foreground",  [NSNumber numberWithInt:(int)kMagentaHighlight],
            @"Orange Foreground",  [NSNumber numberWithInt:(int)kOrangeHighlight],
            @"Purple Foreground",  [NSNumber numberWithInt:(int)kPurpleHighlight],
            @"Red Foreground",  [NSNumber numberWithInt:(int)kRedHighlight],
            @"White Foreground",  [NSNumber numberWithInt:(int)kWhiteHighlight],
            @"Yellow Foreground",  [NSNumber numberWithInt:(int)kYellowHighlight],

            @"Black Background",  [NSNumber numberWithInt:(int)kBlackBackgroundHighlight],
            @"Blue Background",  [NSNumber numberWithInt:(int)kBlueBackgroundHighlight],
            @"Brown Background",  [NSNumber numberWithInt:(int)kBrownBackgroundHighlight],
            @"Cyan Background",  [NSNumber numberWithInt:(int)kCyanBackgroundHighlight],
            @"Dark Gray Background",  [NSNumber numberWithInt:(int)kDarkGrayBackgroundHighlight],
            @"Gray Background",  [NSNumber numberWithInt:(int)kGrayBackgroundHighlight],
            @"Green Background",  [NSNumber numberWithInt:(int)kGreenBackgroundHighlight],
            @"Light Gray Background",  [NSNumber numberWithInt:(int)kLightGrayBackgroundHighlight],
            @"Magenta Background",  [NSNumber numberWithInt:(int)kMagentaBackgroundHighlight],
            @"Orange Background",  [NSNumber numberWithInt:(int)kOrangeBackgroundHighlight],
            @"Purple Background",  [NSNumber numberWithInt:(int)kPurpleBackgroundHighlight],
            @"Red Background",  [NSNumber numberWithInt:(int)kRedBackgroundHighlight],
            @"White Background",  [NSNumber numberWithInt:(int)kWhiteBackgroundHighlight],
            @"Yellow Background",  [NSNumber numberWithInt:(int)kYellowBackgroundHighlight],

            nil];
}

- (NSArray *)groupedMenuItemsForPopupButton {
    NSDictionary *fgbg = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Yellow on Black", [NSNumber numberWithInt:(int)kYellowOnBlackHighlight],
                          @"Black on Yellow", [NSNumber numberWithInt:(int)kBlackOnYellowHighlight],
                          @"White on Red",    [NSNumber numberWithInt:(int)kWhiteOnRedHighlight],
                          @"Red on White",    [NSNumber numberWithInt:(int)kRedOnWhiteHighlight],
                          @"Black on Orange", [NSNumber numberWithInt:(int)kBlackOnOrangeHighlight],
                          @"Orange on Black", [NSNumber numberWithInt:(int)kOrangeOnBlackHighlight],
                          @"Purple on Black", [NSNumber numberWithInt:(int)kPurpleOnBlackHighlight],
                          @"Black on Purple", [NSNumber numberWithInt:(int)kBlackOnPurpleHighlight],
                          nil];
    NSDictionary *fg = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"Black Foreground",  [NSNumber numberWithInt:(int)kBlackHighlight],
                        @"Blue Foreground",  [NSNumber numberWithInt:(int)kBlueHighlight],
                        @"Brown Foreground",  [NSNumber numberWithInt:(int)kBrownHighlight],
                        @"Cyan Foreground",  [NSNumber numberWithInt:(int)kCyanHighlight],
                        @"Dark Gray Foreground",  [NSNumber numberWithInt:(int)kDarkGrayHighlight],
                        @"Gray Foreground",  [NSNumber numberWithInt:(int)kGrayHighlight],
                        @"Green Foreground",  [NSNumber numberWithInt:(int)kGreenHighlight],
                        @"Light Gray Foreground",  [NSNumber numberWithInt:(int)kLightGrayHighlight],
                        @"Magenta Foreground",  [NSNumber numberWithInt:(int)kMagentaHighlight],
                        @"Orange Foreground",  [NSNumber numberWithInt:(int)kOrangeHighlight],
                        @"Purple Foreground",  [NSNumber numberWithInt:(int)kPurpleHighlight],
                        @"Red Foreground",  [NSNumber numberWithInt:(int)kRedHighlight],
                        @"White Foreground",  [NSNumber numberWithInt:(int)kWhiteHighlight],
                        @"Yellow Foreground",  [NSNumber numberWithInt:(int)kYellowHighlight],
                        nil];

    NSDictionary *bg = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"Black Background",  [NSNumber numberWithInt:(int)kBlackBackgroundHighlight],
                        @"Blue Background",  [NSNumber numberWithInt:(int)kBlueBackgroundHighlight],
                        @"Brown Background",  [NSNumber numberWithInt:(int)kBrownBackgroundHighlight],
                        @"Cyan Background",  [NSNumber numberWithInt:(int)kCyanBackgroundHighlight],
                        @"Gray Background",  [NSNumber numberWithInt:(int)kDarkGrayBackgroundHighlight],
                        @"Gray Background",  [NSNumber numberWithInt:(int)kGrayBackgroundHighlight],
                        @"Green Background",  [NSNumber numberWithInt:(int)kGreenBackgroundHighlight],
                        @"Light Gray Background",  [NSNumber numberWithInt:(int)kLightGrayBackgroundHighlight],
                        @"Magenta Background",  [NSNumber numberWithInt:(int)kMagentaBackgroundHighlight],
                        @"Orange Background",  [NSNumber numberWithInt:(int)kOrangeBackgroundHighlight],
                        @"Purple Background",  [NSNumber numberWithInt:(int)kPurpleBackgroundHighlight],
                        @"Red Background",  [NSNumber numberWithInt:(int)kRedBackgroundHighlight],
                        @"White Background",  [NSNumber numberWithInt:(int)kWhiteBackgroundHighlight],
                        @"Yellow Background",  [NSNumber numberWithInt:(int)kYellowBackgroundHighlight],
                        nil];
    return [NSArray arrayWithObjects:fgbg, fg, bg, nil];
}

- (BOOL)instantTriggerCanFireMultipleTimesPerLine {
    return YES;
}

- (NSInteger)indexForObject:(id)object {
    int i = 0;
    BOOL isFirst = YES;
    for (NSDictionary *dict in [self groupedMenuItemsForPopupButton]) {
        if (!isFirst) {
            ++i;
        }
        isFirst = NO;
        for (NSNumber *n in [self objectsSortedByValueInDict:dict]) {
            if ([n isEqual:object]) {
                return i;
            }
            i++;
        }
    }
    return -1;
}

- (id)objectAtIndex:(NSInteger)theIndex {
    int i = 0;
    BOOL isFirst = YES;
    for (NSDictionary *dict in [self groupedMenuItemsForPopupButton]) {
        if (!isFirst) {
            ++i;
        }
        isFirst = NO;
        for (NSNumber *n in [self objectsSortedByValueInDict:dict]) {
            if (i == theIndex) {
                return n;
            }
            i++;
        }
    }
    return nil;
}

- (NSDictionary *)dictionaryWithForegroundColor:(NSColor *)foreground
                                backgroundColor:(NSColor *)background {
    return [NSDictionary dictionaryWithObjectsAndKeys:foreground, kHighlightForegroundColor, background, kHighlightBackgroundColor, nil];
}

- (NSDictionary *)dictionaryWithForegroundColor:(NSColor *)foreground {
    return [NSDictionary dictionaryWithObjectsAndKeys:foreground, kHighlightForegroundColor, nil];
}

- (NSDictionary *)dictionaryWithBackgroundColor:(NSColor *)background {
    return [NSDictionary dictionaryWithObjectsAndKeys:background, kHighlightBackgroundColor, nil];
}

- (NSString *)stringValue {
    return [self stringForTextColor:self.textColor backgroundColor:self.backgroundColor];
}

- (NSString *)stringForTextColor:(NSColor *)textColor backgroundColor:(NSColor *)backgroundColor {
    return [NSString stringWithFormat:@"{%@,%@}",
            textColor.hexStringPreservingColorSpace ?: @"",
            backgroundColor.hexStringPreservingColorSpace ?: @""];
}

- (NSColor *)textColor {
    NSDictionary *colors = [self colorsPreservingColorSpace:NO];
    return colors[kHighlightForegroundColor];
}

- (NSColor *)backgroundColor {
    NSDictionary *colors = [self colorsPreservingColorSpace:NO];
    return colors[kHighlightBackgroundColor];
}

- (void)setTextColor:(NSColor *)textColor {
    [super setTextColor:textColor];
    NSMutableArray *temp = [[self stringsForColors] mutableCopy];
    temp[0] = textColor ? textColor.hexStringPreservingColorSpace: @"";
    self.param = [NSString stringWithFormat:@"{%@,%@}", temp[0], temp[1]];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    NSMutableArray *temp = [[self stringsForColors] mutableCopy];
    temp[1] = backgroundColor ? backgroundColor.hexStringPreservingColorSpace: @"";
    self.param = [NSString stringWithFormat:@"{%@,%@}", temp[0], temp[1]];
}

- (void)setParam:(id)param {
    _cachedColors = nil;
    [super setParam:param];
}

// Returns a string of the form {text components,background components} from self.param.
- (NSArray<NSString *> *)stringsForColors {
    if (self.param == nil) {
        return @[ [[NSColor whiteColor] hexString], [[NSColor redColor] hexString] ];
    }
    if ([self.param isKindOfClass:[NSString class]] &&
        [self.param hasPrefix:@"{"] && [self.param hasSuffix:@"}"]) {
        NSString *stringParam = self.param;
        NSString *inner = [self.param substringWithRange:NSMakeRange(1, stringParam.length - 2)];
        NSArray *parts = [inner componentsSeparatedByString:@","];
        if (parts.count == 2) {
            return parts;
        }
        return @[ @"", @"" ];
    }

    if ([self.param isKindOfClass:[NSNumber class]]) {
        NSNumber *numberParam = self.param;
        NSDictionary *dict = [self colorDictionaryForInteger:numberParam.intValue];
        NSColor *text = dict[kHighlightForegroundColor];
        NSColor *background = dict[kHighlightBackgroundColor];
        return @[ text ? text.hexString : @"",
                  background ? background.hexString : @"" ];
    }

    return @[ @"", @"" ];
}

// Returns a dictionary with text and background color from the self.param string.
- (NSDictionary<NSString *, NSColor *> *)colorsPreservingColorSpace:(BOOL)preserveColorSpace {
    if (_cachedColors) {
        return _cachedColors;
    }
    NSArray *parts = [self stringsForColors];
    NSMutableDictionary<NSString *, NSColor *> *dict = [NSMutableDictionary dictionary];
    NSColor *textColor = nil;
    NSColor *backgroundColor = nil;
    if (parts.count == 2) {
        if (preserveColorSpace) {
            textColor = [NSColor colorPreservingColorspaceFromString:parts[0]];
            backgroundColor = [NSColor colorPreservingColorspaceFromString:parts[1]];
        } else {
            textColor = [NSColor colorWithString:parts[0]];
            backgroundColor = [NSColor colorWithString:parts[1]];
        }
    }
    if (textColor) {
        dict[kHighlightForegroundColor] = textColor;
    }
    if (backgroundColor) {
        dict[kHighlightBackgroundColor] = backgroundColor;
    }
    _cachedColors = [dict copy];
    return dict;
}

- (NSDictionary *)colorDictionaryForInteger:(int)param {
    switch (param) {
        case kYellowOnBlackHighlight:
            return [self dictionaryWithForegroundColor:[NSColor yellowColor] backgroundColor:[NSColor blackColor]];

        case kBlackOnYellowHighlight:
            return [self dictionaryWithForegroundColor:[NSColor blackColor] backgroundColor:[NSColor yellowColor]];

        case kWhiteOnRedHighlight:
            return [self dictionaryWithForegroundColor:[NSColor whiteColor] backgroundColor:[NSColor redColor]];

        case kRedOnWhiteHighlight:
            return [self dictionaryWithForegroundColor:[NSColor redColor] backgroundColor:[NSColor whiteColor]];

        case kBlackOnOrangeHighlight:
            return [self dictionaryWithForegroundColor:[NSColor blackColor] backgroundColor:[NSColor orangeColor]];

        case kOrangeOnBlackHighlight:
            return [self dictionaryWithForegroundColor:[NSColor orangeColor] backgroundColor:[NSColor blackColor]];

        case kBlackOnPurpleHighlight:
            return [self dictionaryWithForegroundColor:[NSColor blackColor] backgroundColor:[NSColor purpleColor]];

        case kPurpleOnBlackHighlight:
            return [self dictionaryWithForegroundColor:[NSColor purpleColor] backgroundColor:[NSColor blackColor]];

        case kBlackHighlight:
            return [self dictionaryWithForegroundColor:[NSColor blackColor]];

        case kDarkGrayHighlight:
            return [self dictionaryWithForegroundColor:[NSColor darkGrayColor]];

        case kLightGrayHighlight:
            return [self dictionaryWithForegroundColor:[NSColor lightGrayColor]];

        case kWhiteHighlight:
            return [self dictionaryWithForegroundColor:[NSColor whiteColor]];

        case kGrayHighlight:
            return [self dictionaryWithForegroundColor:[NSColor grayColor]];

        case kRedHighlight:
            return [self dictionaryWithForegroundColor:[NSColor redColor]];

        case kGreenHighlight:
            return [self dictionaryWithForegroundColor:[NSColor greenColor]];

        case kBlueHighlight:
            return [self dictionaryWithForegroundColor:[NSColor blueColor]];

        case kCyanHighlight:
            return [self dictionaryWithForegroundColor:[NSColor cyanColor]];

        case kYellowHighlight:
            return [self dictionaryWithForegroundColor:[NSColor yellowColor]];

        case kMagentaHighlight:
            return [self dictionaryWithForegroundColor:[NSColor magentaColor]];

        case kOrangeHighlight:
            return [self dictionaryWithForegroundColor:[NSColor orangeColor]];

        case kPurpleHighlight:
            return [self dictionaryWithForegroundColor:[NSColor purpleColor]];

        case kBrownHighlight:
            return [self dictionaryWithForegroundColor:[NSColor brownColor]];

        case kBlackBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor blackColor]];

        case kDarkGrayBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor darkGrayColor]];

        case kLightGrayBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor lightGrayColor]];

        case kWhiteBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor whiteColor]];

        case kGrayBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor grayColor]];

        case kRedBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor redColor]];

        case kGreenBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor greenColor]];

        case kBlueBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor blueColor]];

        case kCyanBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor cyanColor]];

        case kYellowBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor yellowColor]];

        case kMagentaBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor magentaColor]];

        case kOrangeBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor orangeColor]];

        case kPurpleBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor purpleColor]];

        case kBrownBackgroundHighlight:
            return [self dictionaryWithBackgroundColor:[NSColor brownColor]];
    }
    return nil;
}

- (BOOL)performActionWithCapturedStrings:(NSArray<NSString *> *)stringArray
                          capturedRanges:(const NSRange *)capturedRanges
                               inSession:(id<iTermTriggerSession>)aSession
                                onString:(iTermStringLine *)stringLine
                    atAbsoluteLineNumber:(long long)lineNumber
                        useInterpolation:(BOOL)useInterpolation
                                    stop:(BOOL *)stop {
    NSRange rangeInString = capturedRanges[0];
    NSRange rangeInScreenChars = [stringLine rangeOfScreenCharsForRangeInString:rangeInString];

    [aSession triggerSession:self
        highlightTextInRange:rangeInScreenChars
                absoluteLine:lineNumber
                      colors:[self colorsPreservingColorSpace:NO]];
    return YES;
}

- (NSAttributedString *)paramAttributedString {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];

    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Text: "]];

    NSTextAttachment *textColorAttachment = [[NSTextAttachment alloc] init];
    textColorAttachment.image = [self imageForColor:self.textColor];
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textColorAttachment];
    NSMutableAttributedString *mutableTextAttachmentString = [textAttachmentString mutableCopy];
    // Lower the image by adjusting the baseline offset.
    [mutableTextAttachmentString addAttribute:NSBaselineOffsetAttributeName value:@(-2) range:NSMakeRange(0, mutableTextAttachmentString.length)];
    [result appendAttributedString:mutableTextAttachmentString];

    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@" Background: "]];

    NSTextAttachment *backgroundColorAttachment = [[NSTextAttachment alloc] init];
    backgroundColorAttachment.image = [self imageForColor:self.backgroundColor];
    NSAttributedString *backgroundAttachmentString = [NSAttributedString attributedStringWithAttachment:backgroundColorAttachment];
    NSMutableAttributedString *mutableBackgroundAttachmentString = [backgroundAttachmentString mutableCopy];
    // Lower the image by adjusting the baseline offset.
    [mutableBackgroundAttachmentString addAttribute:NSBaselineOffsetAttributeName value:@(-2) range:NSMakeRange(0, mutableBackgroundAttachmentString.length)];
    [result appendAttributedString:mutableBackgroundAttachmentString];

    return result;
}

- (NSImage *)imageForColor:(NSColor *)color {
    return [NSImage it_imageForColorSwatch:color size:NSMakeSize(22, 14)];
}

@end
