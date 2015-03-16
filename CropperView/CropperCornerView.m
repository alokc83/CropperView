//
//  CropperCornerView.m
//  Cropper
//
//  Created by 최 중관 on 2014. 7. 18..
//  Copyright (c) 2014년 JoongKwan Choi. All rights reserved.
//

#import "CropperCornerView.h"

@interface CropperCornerView() {

    CGPoint _beganCenter;
}
@end

@implementation CropperCornerView

@synthesize cropperCornerMode;
@synthesize index = tag;

- (void)cc_initialization {
    cropperCornerMode = CropperCornerModeNone;
    
    UIImageView * cornerImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [cornerImage setImage:[UIImage imageNamed:@"CropperCornerView.png"]];
    [self addSubview:cornerImage];
    
    // add GestureRecognizer
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

#pragma mark -
#pragma mark life-cycle
- (instancetype)init {
    if (self = [super init]) {
        // Initialization code
        [self cc_initialization];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        [self cc_initialization];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    [self cc_initialization];
}

- (void)dealloc {
    _delegate = nil;
}

/**
 코너의 위치를 등록하는 메소드
 */
- (void)setBeganCenter {
    _beganCenter = [self center];
}

/**
 코너를 이동하는 메소드
 @param CGPoint
 @param CropperCornerMode
 */
- (void)setTranslate:(CGPoint)translate cropperCornerMode:(CropperCornerMode)newCropperCornerMode {
    // ex,. 우측 & 아래 움직일땐 ...
    // 우축 & 위   ... Y 고정
    // 좌측 & 아래  ... X 고정
    // 좌측 & 위   ... X, Y고정
    CGPoint newPoint = _beganCenter;
    
    if ((cropperCornerMode & newCropperCornerMode & CropperCornerModeLeft) ||
        (cropperCornerMode & newCropperCornerMode & CropperCornerModeRight)) {
        newPoint.x += translate.x;
    }
    
    if ((cropperCornerMode & newCropperCornerMode & CropperCornerModeTop)  ||
        (cropperCornerMode & newCropperCornerMode & CropperCornerModeBottom)) {
        newPoint.y += translate.y;
    }
    
    [self setCenter:newPoint];
}

#pragma mark -
#pragma mark UIPanGestureRecognizer
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)sender {
    switch ([sender state]) {
        case UIGestureRecognizerStateBegan: {
            if ([_delegate respondsToSelector:@selector(cropperCorner:)]) {
                // began center
                [_delegate cropperCorner:self];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translate = [sender translationInView:[sender view]];
            if ([_delegate respondsToSelector:@selector(cropperCorner:translate:cropperCornerMode:)]) {
                // translate
                [_delegate cropperCorner:self translate:translate cropperCornerMode:[self cropperCornerMode]];
            }
            break;
        }
        default:
            [self setBeganCenter];
            break;
    }
}

@end
