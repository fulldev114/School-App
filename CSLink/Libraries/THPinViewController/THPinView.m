//
//  THPinView.m
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 21.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinView.h"
#import "THPinInputCirclesView.h"
#import "THPinNumPadView.h"
#import "THPinNumButton.h"
#import "ParentConstant.h"
#import "ParentForgotPinCodeViewController.h"
#import "BaseViewController.h"

@interface THPinView () <THPinNumPadViewDelegate>

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) THPinInputCirclesView *inputCirclesView;
@property (nonatomic, strong) THPinNumPadView *numPadView;
@property (nonatomic, strong) UIButton *bottomButtonDone;
@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, strong) UIButton *ForgotPinButton;

@property (nonatomic, assign) CGFloat paddingBetweenPromptLabelAndInputCircles;
@property (nonatomic, assign) CGFloat paddingBetweenInputCirclesAndNumPad;
@property (nonatomic, assign) CGFloat paddingBetweenForgotPinButtonAndNumPad;
@property (nonatomic, assign) CGFloat paddingBetweenNumPadAndBottomButton;

@property (nonatomic, strong) NSMutableString *input;

@end

@implementation THPinView

- (instancetype)initWithDelegate:(id<THPinViewDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        _delegate = delegate;
        _input = [NSMutableString string];
        
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? FONT_35_SEMIBOLD : FONT_18_REGULER;
        [_promptLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel
                                                      forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:_promptLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[promptLabel]|" options:0 metrics:nil
                                                                       views:@{ @"promptLabel" : _promptLabel }]];
        
        
        _inputCirclesView = [[THPinInputCirclesView alloc] initWithPinLength:[_delegate pinLengthForPinView:self]];
        _inputCirclesView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_inputCirclesView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_inputCirclesView attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f constant:0.0f]];
        
        _ForgotPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ForgotPinButton.translatesAutoresizingMaskIntoConstraints = NO;
        _ForgotPinButton.titleLabel.font = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? FONT_40_SEMIBOLD : FONT_20_REGULER;
        _ForgotPinButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_ForgotPinButton setTitleColor:TEXT_COLOR_LIGHT_CYNA forState:UIControlStateNormal];
        [_ForgotPinButton setTitle:[GeneralUtil getLocalizedText:@"BTN_FORGOT_PIN_CODE_TITLE"] forState:UIControlStateNormal];
        [_ForgotPinButton addTarget:self action:@selector(btnForgotPin:) forControlEvents:UIControlEventTouchUpInside];
        
        [_ForgotPinButton setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_ForgotPinButton attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        
        [self addSubview:_ForgotPinButton];
        
        _numPadView = [[THPinNumPadView alloc] initWithDelegate:self];
        _numPadView.translatesAutoresizingMaskIntoConstraints = NO;
        _numPadView.backgroundColor = self.backgroundColor;
        [self addSubview:_numPadView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_numPadView attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        
        
        _bottomButtonDone = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButtonDone.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomButtonDone.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _bottomButtonDone.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_bottomButtonDone setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"THPinViewController" ofType:@"bundle"]];
        
        [_bottomButtonDone setTitle:NSLocalizedStringFromTableInBundle(@"done_button_title", @"THPinViewController", bundle, nil) forState:UIControlStateNormal];
        [_bottomButtonDone addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        
        _bottomButtonDone.hidden = YES;
        
        [self addSubview:_bottomButtonDone];
        
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _bottomButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_bottomButton setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        
        
        
        [self updateBottomButton];
        [self addSubview:_bottomButton];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // place button right of zero number button
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f constant:-[THPinNumButton diameter] / 1.6f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0f constant:-[THPinNumButton diameter] / 2.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0
                                                            multiplier:0.0f constant:[THPinNumButton diameter]]];
            
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButtonDone attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0f constant:[THPinNumButton diameter] / 2.0f]];
            
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButtonDone attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0f constant:-[THPinNumButton diameter] / 2.0f]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButtonDone attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0
                                                            multiplier:0.0f constant:[THPinNumButton diameter]]];
            
        } else {
            // place button beneath the num pad on the right
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeRight
                                                            multiplier:0.9f constant:0.0f]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationLessThanOrEqual
                                                                toItem:self attribute:NSLayoutAttributeWidth
                                                            multiplier:0.4f constant:0.0f]];
            
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButtonDone attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0f constant:0.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButtonDone attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationLessThanOrEqual
                                                                toItem:self attribute:NSLayoutAttributeWidth
                                                            multiplier:0.4f constant:0.0f]];
        }
        
       // V:|[promptLabel]-(paddingBetweenPromptLabelAndInputCircles)-[inputCirclesView]-(paddingBetweenInputCirclesAndNumPad)-[numPadView]-(paddingBetweenNumPadAndBottomButton)-[bottomButton] 
        
        CGFloat paddingBetweenNumPadAndBottomButton2 = 0;
        
//        NSMutableString *vFormat = [NSMutableString stringWithString:@"V:|[promptLabel]-(paddingBetweenPromptLabelAndInputCircles)-(paddingBetweenInputCirclesAndNumPad)-[numPadView]"];
        
        NSMutableString *vFormat = [NSMutableString stringWithString:@"V:|[promptLabel]-(paddingBetweenPromptLabelAndInputCircles)-[inputCirclesView]-(paddingBetweenInputCirclesAndNumPad)-[ForgotPinButton]-(paddingBetweenForgotPinButtonAndNumPad)-[numPadView]"];
        
        [vFormat appendString:@"-(paddingBetweenNumPadAndBottomButton)-[bottomButton]-(paddingBetweenNumPadAndBottomButton2)-[bottomButtonDone]"];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _paddingBetweenPromptLabelAndInputCircles = 60.0f;
            _paddingBetweenInputCirclesAndNumPad = 60.0f;
            _paddingBetweenForgotPinButtonAndNumPad = 100.5f;
            _paddingBetweenNumPadAndBottomButton = -70.0f;
            paddingBetweenNumPadAndBottomButton2 = -65.0f;
        } else {
            
            BOOL isFourInchScreen = (fabs(CGRectGetHeight([[UIScreen mainScreen] bounds]) - 568.0f) < DBL_EPSILON);
            if (isFourInchScreen) {
                _paddingBetweenPromptLabelAndInputCircles = 30.5f;
                _paddingBetweenInputCirclesAndNumPad = 30.5f;
                _paddingBetweenForgotPinButtonAndNumPad = 20.5f;
                _paddingBetweenNumPadAndBottomButton = -55.0f;
                paddingBetweenNumPadAndBottomButton2 = -30.0f;
            } else {
                _paddingBetweenPromptLabelAndInputCircles = 20.5f;
                _paddingBetweenInputCirclesAndNumPad = 50.0f;
                 _paddingBetweenForgotPinButtonAndNumPad = 50.0f;
                _paddingBetweenNumPadAndBottomButton = -55.5f;
                paddingBetweenNumPadAndBottomButton2 = -30.0f;
            }
        }
        [vFormat appendString:@"|"];
        
        NSDictionary *metrics = @{ @"paddingBetweenPromptLabelAndInputCircles" : @(_paddingBetweenPromptLabelAndInputCircles),
                                   @"paddingBetweenInputCirclesAndNumPad" : @(_paddingBetweenInputCirclesAndNumPad),
                                   @"paddingBetweenNumPadAndBottomButton" : @(_paddingBetweenNumPadAndBottomButton)
                                   , @"paddingBetweenNumPadAndBottomButton2" : @(paddingBetweenNumPadAndBottomButton2),
                                   @"paddingBetweenForgotPinButtonAndNumPad" : @(_paddingBetweenForgotPinButtonAndNumPad)
                                   };
        NSDictionary *views = @{ @"promptLabel" : _promptLabel,
                                 @"inputCirclesView" : _inputCirclesView,
                                 @"numPadView" : _numPadView,
                                 @"bottomButton" : _bottomButton
                                 ,@"bottomButtonDone" : _bottomButtonDone,
                                 @"ForgotPinButton" : _ForgotPinButton
                                 };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:metrics views:views]];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    CGFloat height = (self.promptLabel.intrinsicContentSize.height + self.paddingBetweenPromptLabelAndInputCircles +
                      self.inputCirclesView.intrinsicContentSize.height + self.paddingBetweenInputCirclesAndNumPad +
                      self.numPadView.intrinsicContentSize.height);
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        height += self.paddingBetweenNumPadAndBottomButton + self.bottomButton.intrinsicContentSize.height;
    }
    return CGSizeMake(self.numPadView.intrinsicContentSize.width, height);
}

#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.numPadView.backgroundColor = self.backgroundColor;
}

- (NSString *)promptTitle
{
    return self.promptLabel.text;
}

- (void)setPromptTitle:(NSString *)promptTitle
{
    self.promptLabel.text = promptTitle;
}

- (UIColor *)promptColor
{
    return self.promptLabel.textColor;
}

- (void)setPromptColor:(UIColor *)promptColor
{
    self.promptLabel.textColor = promptColor;
}

- (BOOL)hideLetters
{
    return self.numPadView.hideLetters;
}

- (void)setHideLetters:(BOOL)hideLetters
{
    self.numPadView.hideLetters = hideLetters;
}

- (void)setDisableCancel:(BOOL)disableCancel
{
    if (self.disableCancel == disableCancel) {
        return;
    }
    _disableCancel = disableCancel;
    [self updateBottomButton];
}

#pragma mark - Public

- (void)updateBottomButton
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"THPinViewController" ofType:@"bundle"]];
    
     _bottomButtonDone.hidden = YES;
    
    if ([self.input length] == 0) {
        self.bottomButtonDone.hidden = YES;
        self.bottomButton.hidden = self.disableCancel;
        //[self.bottomButton setTitle:NSLocalizedStringFromTableInBundle(@"cancel_button_title", @"THPinViewController", bundle, nil) forState:UIControlStateNormal];
        [self.bottomButton  setImage:[UIImage imageNamed:@"Pinback"] forState:UIControlStateNormal];
        [self.bottomButton removeTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        self.bottomButtonDone.hidden = YES;
        self.bottomButton.hidden = NO;
        //[self.bottomButton setTitle:NSLocalizedStringFromTableInBundle(@"delete_button_title", @"THPinViewController", bundle, nil) forState:UIControlStateNormal];
        [self.bottomButton  setImage:[UIImage imageNamed:@"Pinback"] forState:UIControlStateNormal];
        [self.bottomButton removeTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - User Interaction

- (void)done:(id)sender
{
    if ([self.delegate pinView:self isPinValid:self.input])
    {
        double delayInSeconds = 0.3f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.delegate correctPinWasEnteredInPinView:self];
        });

    } else {

        [self.inputCirclesView shakeWithCompletion:^{
            [self resetInput];
            [self.delegate incorrectPinWasEnteredInPinView:self];
        }];
    }
}

- (void)cancel:(id)sender
{
    //[self.delegate cancelButtonTappedInPinView:self];
}

- (void)delete:(id)sender
{
    if ([self.input length] < 2) {
        [self resetInput];
    } else {
        [self.input deleteCharactersInRange:NSMakeRange([self.input length] - 1, 1)];
        [self.inputCirclesView unfillCircleAtPosition:[self.input length]];
    }
}

#pragma mark - THPinNumPadViewDelegate

- (void)pinNumPadView:(THPinNumPadView *)pinNumPadView numberTapped:(NSUInteger)number
{
    NSUInteger pinLength = [self.delegate pinLengthForPinView:self];
    
    if ([self.input length] >= pinLength) {
        return;
    }
    
    [self.input appendString:[NSString stringWithFormat:@"%lu", (unsigned long)number]];
    [self.inputCirclesView fillCircleAtPosition:[self.input length] - 1];
    
    [self updateBottomButton];
    
    if ([self.input length] < pinLength) {
        return;
    }
    
    if ([self.delegate pinView:self isPinValid:self.input])
    {
        double delayInSeconds = 0.3f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //[self.delegate correctPinWasEnteredInPinView:self];
        });
        
    } else {
        
        [self.inputCirclesView shakeWithCompletion:^{
            [self resetInput];
            [self.delegate incorrectPinWasEnteredInPinView:self];
        }];
    }
}

-(void)btnForgotPin:(UIButton *)sender {

    ParentUser *userObj = [[ParentUser alloc] init];
    
    [userObj forgotPin:[GeneralUtil getUserPreference:key_myParentPhone] andParentNo:[GeneralUtil getUserPreference:key_myParentNo] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SEND_PIN_SUCCESS"]];
            }
            else {
                [GeneralUtil alertInfo:[dicRes valueForKey:@"msg"]];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

#pragma mark - Util

- (void)reset
{
    [self.inputCirclesView shakeWithCompletion:^{
        [self resetInput];
        //[self.delegate incorrectPinWasEnteredInPinView:self];
    }];
}

- (void)resetInput
{
    self.input = [NSMutableString string];
    [self.inputCirclesView unfillAllCircles];
    [self updateBottomButton];
}

@end
