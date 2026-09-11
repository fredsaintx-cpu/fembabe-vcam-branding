#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static IMP originalButtonSetTitle;
static IMP originalLabelSetText;

static UIColor *FemBabePurple(void) {
    return [UIColor colorWithRed:0.25 green:0.09 blue:0.40 alpha:1.0];
}

static NSString *FemBabeTitle(NSString *title) {
    if ([title isEqualToString:@"UF"]) return @"FB";
    if ([title hasPrefix:@"UFATM APP"]) {
        return [@"FemBabeCam" stringByAppendingString:[title substringFromIndex:9]];
    }
    return title;
}

static void brandedSetTitle(UIButton *button, SEL command, NSString *title, UIControlState state) {
    NSString *brandedTitle = FemBabeTitle(title);
    ((void (*)(id, SEL, NSString *, UIControlState))originalButtonSetTitle)(button, command, brandedTitle, state);
    if ([title isEqualToString:@"UF"]) {
        button.backgroundColor = FemBabePurple();
    }
}

static void brandedSetText(UILabel *label, SEL command, NSString *text) {
    ((void (*)(id, SEL, NSString *))originalLabelSetText)(label, command, FemBabeTitle(text));
}

static void brandExistingViews(UIView *view) {
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        NSString *title = [button titleForState:UIControlStateNormal];
        if ([title isEqualToString:@"UF"]) {
            [button setTitle:@"FB" forState:UIControlStateNormal];
            button.backgroundColor = FemBabePurple();
        }
    } else if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        NSString *title = FemBabeTitle(label.text);
        if (title != label.text) label.text = title;
    }

    for (UIView *subview in view.subviews) {
        brandExistingViews(subview);
    }
}

static void brandExistingWindows(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *window in ((UIWindowScene *)scene).windows) {
            brandExistingViews(window);
        }
    }
}

__attribute__((constructor)) static void initializeBranding(void) {
    @autoreleasepool {
        Method buttonMethod = class_getInstanceMethod(UIButton.class, @selector(setTitle:forState:));
        originalButtonSetTitle = method_setImplementation(buttonMethod, (IMP)brandedSetTitle);

        Method labelMethod = class_getInstanceMethod(UILabel.class, @selector(setText:));
        originalLabelSetText = method_setImplementation(labelMethod, (IMP)brandedSetText);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            brandExistingWindows();
        });
    }
}
