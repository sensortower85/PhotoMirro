//
//  PECropViewController.m
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "PECropViewController.h"
#import "PECropView.h"

enum
{
    kRatioOrg = 0,
    kRatioFree,
    kRatioGold,
    kRatio11,
    kRatio34,
    kRatio43,
    kRatio169,
    kRatio916,
    kRatioCount
};
@interface PECropViewController () <UIActionSheetDelegate>

@property (nonatomic) PECropView *cropView;
@property (nonatomic) UIActionSheet *actionSheet;

- (void)commonInit;

@end

@implementation PECropViewController
@synthesize rotationEnabled = _rotationEnabled;

+ (NSBundle *)bundle
{
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"PEPhotoCropEditor" withExtension:@"bundle"];
        bundle = [[NSBundle alloc] initWithURL:bundleURL];
    });
    
    return bundle;
}

static inline NSString *PELocalizedString(NSString *key, NSString *comment)
{
    return [[PECropViewController bundle] localizedStringForKey:key value:nil table:@"Localizable"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
}

- (void) fillRatioControls
{
    [self.ratioControlScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray* arrayTools = @[@"crop_ori_1.png",
                            @"crop_free_1.png",
                            @"crop_gold_1.png",
                            @"crop_11_1.png",
                            @"crop_34_1.png",
                            @"crop_43_1.png",
                            @"crop_169_1.png",
                            @"crop_916_1.png"];

    NSArray* arraySelectedTools = @[@"crop_ori_2.png",
                            @"crop_free_2.png",
                            @"crop_gold_2.png",
                            @"crop_11_2.png",
                            @"crop_34_2.png",
                            @"crop_43_2.png",
                            @"crop_169_2.png",
                            @"crop_916_2.png"];
    
    for (NSInteger i = 0; i < [arrayTools count]; i ++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed: [arrayTools objectAtIndex: i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed: [arraySelectedTools objectAtIndex: i]] forState:UIControlStateSelected];
        [button setFrame:CGRectMake(i*80, 5, 40, 40)];
        [button setTag: i];
        [button addTarget:self action:@selector(selectRatio:) forControlEvents:UIControlEventTouchUpInside];
        [self.ratioControlScrollView addSubview: button];
    }
    
    [self.ratioControlScrollView setContentSize: CGSizeMake([arrayTools count]*80, 50)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds) - 50*3;
    
    self.cropView = [[PECropView alloc] initWithFrame:CGRectMake(0, 50, width, height)];
    [self.view addSubview:self.cropView];

    self.cropView.image = self.image;
    
    self.rotationEnabled = YES;
    self.cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
    
    [self.view bringSubviewToFront: self.bottomBannerView];
    [self.view bringSubviewToFront: self.topBannerView];
    [self.view bringSubviewToFront: self.ratioControlView];
    
    [self fillRatioControls];
}

- (void) selectRatio:(id) sender
{
    NSInteger nTag = ((UIButton*)sender).tag;
    
    NSArray* arrayButtons = self.ratioControlScrollView.subviews;
    for (NSInteger i = 0; i < [arrayButtons count]; i ++) {
        id buttonObject = [arrayButtons objectAtIndex: i];
        if ([buttonObject isKindOfClass:[UIButton class]] == NO)
            continue;
        UIButton* button = (UIButton*)buttonObject;
        [button setSelected: NO];
        
        if (button.tag == nTag)
            [button setSelected: YES];
    }
    
    switch (nTag) {
        case kRatioOrg:
            [self.cropView resetCropRectAnimated: YES];
            break;
        case kRatioFree:
            [self.cropView resetCropRectAnimated: YES];
            break;
        case kRatioGold:
            [self.cropView resetCropRectAnimated: YES];
            self.cropView.cropAspectRatio = 1.0f/1.618f;
            break;
        case kRatio11:
            [self.cropView resetCropRect];
            self.cropView.cropAspectRatio = 1.0f;
            break;
        case kRatio34:
            [self.cropView resetCropRect];
            self.cropView.cropAspectRatio = 3.0f/4.0f;
            break;
        case kRatio43:
            [self.cropView resetCropRect];
            self.cropView.cropAspectRatio = 4.0f/3.0f;
            break;
        case kRatio169:
            [self.cropView resetCropRect];
            self.cropView.cropAspectRatio = 16.0f/9.0f;
            break;
        case kRatio916:
            [self.cropView resetCropRect];
            self.cropView.cropAspectRatio = 9.0f/16.0f;
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.cropAspectRatio != 0) {
        self.cropAspectRatio = self.cropAspectRatio;
    }
    if (!CGRectEqualToRect(self.cropRect, CGRectZero)) {
        self.cropRect = self.cropRect;
    }
    if (!CGRectEqualToRect(self.imageCropRect, CGRectZero)) {
        self.imageCropRect = self.imageCropRect;
    }
    
    self.keepingCropAspectRatio = self.keepingCropAspectRatio;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.cropView.image = image;
}

- (void)setKeepingCropAspectRatio:(BOOL)keepingCropAspectRatio
{
    _keepingCropAspectRatio = keepingCropAspectRatio;
    self.cropView.keepingCropAspectRatio = self.keepingCropAspectRatio;
}

- (void)setCropAspectRatio:(CGFloat)cropAspectRatio
{
    _cropAspectRatio = cropAspectRatio;
    self.cropView.cropAspectRatio = self.cropAspectRatio;
}

- (void)setCropRect:(CGRect)cropRect
{
    _cropRect = cropRect;
    _imageCropRect = CGRectZero;
    
    CGRect cropViewCropRect = self.cropView.cropRect;
    cropViewCropRect.origin.x += cropRect.origin.x;
    cropViewCropRect.origin.y += cropRect.origin.y;
    
    CGSize size = CGSizeMake(fminf(CGRectGetMaxX(cropViewCropRect) - CGRectGetMinX(cropViewCropRect), CGRectGetWidth(cropRect)),
                             fminf(CGRectGetMaxY(cropViewCropRect) - CGRectGetMinY(cropViewCropRect), CGRectGetHeight(cropRect)));
    cropViewCropRect.size = size;
    self.cropView.cropRect = cropViewCropRect;
}

- (void)setImageCropRect:(CGRect)imageCropRect
{
    _imageCropRect = imageCropRect;
    _cropRect = CGRectZero;
    
    self.cropView.imageCropRect = imageCropRect;
}

- (BOOL)isRotationEnabled
{
    return _rotationEnabled;
}

- (void)setRotationEnabled:(BOOL)rotationEnabled
{
    _rotationEnabled = rotationEnabled;
    self.cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
}

- (CGAffineTransform)rotationTransform
{
    return self.cropView.rotation;
}

- (CGRect)zoomedCropRect
{
    return self.cropView.zoomedCropRect;
}

- (void)resetCropRect
{
    [self.cropView resetCropRect];
}

- (void)resetCropRectAnimated:(BOOL)animated
{
    [self.cropView resetCropRectAnimated:animated];
}

#pragma mark -

- (IBAction)backAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewControllerDidCancel:)]) {
        [self.delegate cropViewControllerDidCancel:self];
    }
}

- (IBAction)completeAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:transform:cropRect:)]) {
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage transform: self.cropView.rotation cropRect: self.cropView.zoomedCropRect];
    } else if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:)]) {
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage];
    }
}

- (void)constrain:(id)sender
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:PELocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:
                        PELocalizedString(@"Original", nil),
                        PELocalizedString(@"Square", nil),
                        PELocalizedString(@"3 x 2", nil),
                        PELocalizedString(@"3 x 5", nil),
                        PELocalizedString(@"4 x 3", nil),
                        PELocalizedString(@"4 x 6", nil),
                        PELocalizedString(@"5 x 7", nil),
                        PELocalizedString(@"8 x 10", nil),
                        PELocalizedString(@"16 x 9", nil), nil];
    [self.actionSheet showFromToolbar:self.navigationController.toolbar];
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CGRect cropRect = self.cropView.cropRect;
        CGSize size = self.cropView.image.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        CGFloat ratio;
        if (width < height) {
            ratio = width / height;
            cropRect.size = CGSizeMake(CGRectGetHeight(cropRect) * ratio, CGRectGetHeight(cropRect));
        } else {
            ratio = height / width;
            cropRect.size = CGSizeMake(CGRectGetWidth(cropRect), CGRectGetWidth(cropRect) * ratio);
        }
        self.cropView.cropRect = cropRect;
    } else if (buttonIndex == 1) {
        self.cropView.cropAspectRatio = 1.0f;
    } else if (buttonIndex == 2) {
        self.cropView.cropAspectRatio = 2.0f / 3.0f;
    } else if (buttonIndex == 3) {
        self.cropView.cropAspectRatio = 3.0f / 5.0f;
    } else if (buttonIndex == 4) {
        CGFloat ratio = 3.0f / 4.0f;
        CGRect cropRect = self.cropView.cropRect;
        CGFloat width = CGRectGetWidth(cropRect);
        cropRect.size = CGSizeMake(width, width * ratio);
        self.cropView.cropRect = cropRect;
    } else if (buttonIndex == 5) {
        self.cropView.cropAspectRatio = 4.0f / 6.0f;
    } else if (buttonIndex == 6) {
        self.cropView.cropAspectRatio = 5.0f / 7.0f;
    } else if (buttonIndex == 7) {
        self.cropView.cropAspectRatio = 8.0f / 10.0f;
    } else if (buttonIndex == 8) {
        CGFloat ratio = 9.0f / 16.0f;
        CGRect cropRect = self.cropView.cropRect;
        CGFloat width = CGRectGetWidth(cropRect);
        cropRect.size = CGSizeMake(width, width * ratio);
        self.cropView.cropRect = cropRect;
    }
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end
