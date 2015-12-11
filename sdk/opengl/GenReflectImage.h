//
//  GenReflectImage.h
//  PhotoMirror
//
//  Created by heliumsoft on 12/10/14.
//  Copyright (c) 2014 quantum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum
{
    k2DType_1 = 0,
    k2DType_2,
    k2DType_3,
    k2DType_4,
    k2DType_5,
    k2DType_6,
    k2DType_7,
    k2DType_8,
    k2DTypeCount,

    k3DType_1,
    k3DType_2,
    k3DType_3,
    k3DType_4,
    k3DType_5,
    k3DType_6,
    k3DType_7,
    k3DType_8,
    k3DType_9,
    k3DType_10,
    k3DType_11,
    k3DType_12,
};

enum
{
    kRatio_1_1 = 0,
    kRatio_2_3,
    kRatio_3_2,
    kRatio_3_4,
    kRatio_4_3,
    kRatio_3_5,
    kRatio_5_3,
    kRatio_5_7,
    kRatio_7_5,
    kRatio_9_16,
    kRatio_16_9,
    kRatioCount
};

@interface GenReflectImage : NSObject
{
    UIImage* image;
    UIImage* backupImage;
    float reflectOffsetX;
    float reflectOffsetY;
    NSInteger _reflectType;
    CGFloat _ratio;
    
    float lastOffsetX;
    float lastOffsetY;
}

@property(nonatomic, retain) UIImage* image;
@property(nonatomic, retain) UIImage* backupImage;
@property(nonatomic) NSInteger reflectType;
@property(nonatomic) CGFloat ratio;

- (id) initWithImage:(UIImage*) imageWith;

- (UIImage*) reflectImage:(float) offsetX offsetY:(float) offsetY;
- (UIImage*) reflectLastImage;
- (void) setProcessImage:(UIImage*) orgImage;
@end
