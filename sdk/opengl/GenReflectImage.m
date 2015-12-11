//
//  GenReflectImage.m
//  PhotoMirror
//
//  Created by heliumsoft on 12/10/14.
//  Copyright (c) 2014 quantum. All rights reserved.
//

#import "GenReflectImage.h"
#import "UIImage+Resize.h"

@implementation GenReflectImage
@synthesize image;
@synthesize backupImage;
@synthesize reflectType=_reflectType;
@synthesize ratio=_ratio;

- (id) initWithImage:(UIImage*) imageWith
{
    if ((self=[super init]))
    {
        self.backupImage = imageWith;
        self.image = imageWith;
        reflectOffsetX = 0;
        reflectOffsetY = 0;
        self.reflectType = k2DType_1;
        self.ratio = 1;
    }
    
    return self;
}

- (void) setReflectType:(NSInteger)reflectType
{
    reflectOffsetX = 0;
    reflectOffsetY = 0;
    _reflectType = reflectType;
}

- (void) setRatio:(CGFloat)ratio
{
    reflectOffsetX = 0;
    reflectOffsetY = 0;
    _ratio = ratio;
}

- (CGSize) canvasSizeByRatio:(CGFloat) w
{
    float width = w;
    float height = w;
    
    if (self.ratio <= 1)
    {
        width = height*self.ratio;
    }
    else
    {
        height = width/self.ratio;
    }

    int ceilW = ceil(width);
    int ceilH = ceil(height);
    
    if ((ceilW%2) == 1)
    {
        ceilW = floor(width);
    }

    if ((ceilH%2) == 1)
    {
        ceilH = floor(height);
    }

    return CGSizeMake(ceilW, ceilH);
}

- (CGSize) canvasSizeByRatioH:(CGFloat) h ratioBy:(CGFloat)ratioBy
{
    return CGSizeMake(h*ratioBy, h);
}

- (CGSize) canvasSizeByRatioW:(CGFloat) w ratioBy:(CGFloat)ratioBy
{
    return CGSizeMake(w, w*ratioBy);
}

- (UIImage *)renderImageWithImage2D_Type1:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];

    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width/2.0f, cropSize.height)];
    
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*3/2.0f, 0);
    [withImage drawInRect:CGRectMake(cropSize.width/2.0f, 0, cropSize.width/2.0f, cropSize.height)];

    CGContextRestoreGState(context);

    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage2D_Type1:(float) offsetX offsetY:(float) offsetY
{
    float imageW = self.image.size.width;
    float imageH = self.image.size.height;
    
    float imgRatio = imageW / imageH;

    float backOffsetX = reflectOffsetX;
    backOffsetX += offsetX;

    float backOffsetY = reflectOffsetY;
    backOffsetY += offsetY;

    CGSize cropSize;
    
    if (imgRatio > self.ratio/2.0f)
    {
        cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio/2.0f];
    }
    else
    {
        cropSize = [self canvasSizeByRatioW: imageW ratioBy:2/self.ratio];
    }
    
    if (backOffsetX > (imageW-cropSize.width))
    {
        backOffsetX = reflectOffsetX;
    }
    
    if (backOffsetX < 0)
        backOffsetX = 0;
    
    reflectOffsetX = backOffsetX;

    if (backOffsetY > (imageH-cropSize.height))
    {
        backOffsetY = reflectOffsetY;
    }
    
    if (backOffsetY < 0)
        backOffsetY = 0;
    
    reflectOffsetY = backOffsetY;
    
    //Crop Image
    UIImage* cropImage = [self.image croppedImage:CGRectMake(reflectOffsetX, reflectOffsetY, cropSize.width, cropSize.height)];
    
    return [self renderImageWithImage2D_Type1:cropImage];
}

- (UIImage *)renderImageWithImage2D_Type2:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];

    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [withImage drawInRect:CGRectMake(cropSize.width/2.0f, 0, cropSize.width/2.0f, cropSize.height)];
    
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width/2.0f, 0);
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width/2.0f, cropSize.height)];
    
    CGContextRestoreGState(context);

    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage2D_Type2:(float) offsetX offsetY:(float) offsetY
{
    float imageW = self.image.size.width;
    float imageH = self.image.size.height;
    
    float imgRatio = imageW / imageH;
    
    float backOffsetX = reflectOffsetX;
    backOffsetX += offsetX;
    
    float backOffsetY = reflectOffsetY;
    backOffsetY += offsetY;
    
    CGSize cropSize;
    
    if (imgRatio > self.ratio/2.0f)
    {
        cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio/2];
    }
    else
    {
        cropSize = [self canvasSizeByRatioW: imageW ratioBy:2/self.ratio];
    }
    
    if (backOffsetX > (imageW-cropSize.width))
    {
        backOffsetX = reflectOffsetX;
    }
    
    if (backOffsetX < 0)
        backOffsetX = 0;
    
    reflectOffsetX = backOffsetX;
    
    if (backOffsetY > (imageH-cropSize.height))
    {
        backOffsetY = reflectOffsetY;
    }
    
    if (backOffsetY < 0)
        backOffsetY = 0;
    
    reflectOffsetY = backOffsetY;
    
    //Crop Image
    UIImage* cropImage = [self.image croppedImage:CGRectMake(reflectOffsetX, reflectOffsetY, cropSize.width, cropSize.height)];
    
    return [self renderImageWithImage2D_Type2:cropImage];
}

- (UIImage *)renderImageWithImage2D_Type3:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];

    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height/2.0f)];
    
    CGContextSaveGState(context);

    CGContextTranslateCTM(context, 0, 3*cropSize.height/2.0f);
    CGContextScaleCTM(context, 1, -1);
    [withImage drawInRect:CGRectMake(0, cropSize.height/2.0f, cropSize.width, cropSize.height/2.0f)];
    
    CGContextRestoreGState(context);

    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage2D_Type3:(float) offsetX offsetY:(float) offsetY
{
    float imageW = self.image.size.width;
    float imageH = self.image.size.height;
    
    float imgRatio = imageW / imageH;
    
    float backOffsetX = reflectOffsetX;
    backOffsetX += offsetX;
    
    float backOffsetY = reflectOffsetY;
    backOffsetY += offsetY;
    
    CGSize cropSize;
    
    if (imgRatio > self.ratio)
    {
        cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio*2];
        if (cropSize.width > imageW)
        {
            cropSize = [self canvasSizeByRatioW: imageW ratioBy:1/(self.ratio*2)];
        }
    }
    else
    {
        cropSize = [self canvasSizeByRatioW: imageW ratioBy:1/(self.ratio*2)];
    }
    
    if (backOffsetX > (imageW-cropSize.width))
    {
        backOffsetX = reflectOffsetX;
    }
    
    if (backOffsetX < 0)
        backOffsetX = 0;
    
    reflectOffsetX = backOffsetX;
    
    if (backOffsetY > (imageH-cropSize.height))
    {
        backOffsetY = reflectOffsetY;
    }
    
    if (backOffsetY < 0)
        backOffsetY = 0;
    
    reflectOffsetY = backOffsetY;
    
    //Crop Image
    UIImage* cropImage = [self.image croppedImage:CGRectMake(reflectOffsetX, reflectOffsetY, cropSize.width, cropSize.height)];
    
    return [self renderImageWithImage2D_Type3:cropImage];
}

- (UIImage *)renderImageWithImage2D_Type4:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [withImage drawInRect:CGRectMake(0, cropSize.height/2.0f, cropSize.width, cropSize.height/2.0f)];
    
    CGContextSaveGState(context);

    CGContextTranslateCTM(context, 0, cropSize.height/2.0f);
    CGContextScaleCTM(context, 1, -1);
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height/2.0f)];
    
    CGContextRestoreGState(context);

    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage2D_Type4:(float) offsetX offsetY:(float) offsetY
{
    float imageW = self.image.size.width;
    float imageH = self.image.size.height;
    
    float imgRatio = imageW / imageH;
    
    float backOffsetX = reflectOffsetX;
    backOffsetX += offsetX;
    
    float backOffsetY = reflectOffsetY;
    backOffsetY += offsetY;
    
    CGSize cropSize;
    
    if (imgRatio > self.ratio)
    {
        cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio*2];
        if (cropSize.width > imageW)
        {
            cropSize = [self canvasSizeByRatioW: imageW ratioBy:1/(self.ratio*2)];
        }
    }
    else
    {
        cropSize = [self canvasSizeByRatioW: imageW ratioBy:1/(self.ratio*2)];
    }
    
    if (backOffsetX > (imageW-cropSize.width))
    {
        backOffsetX = reflectOffsetX;
    }
    
    if (backOffsetX < 0)
        backOffsetX = 0;
    
    reflectOffsetX = backOffsetX;
    
    if (backOffsetY > (imageH-cropSize.height))
    {
        backOffsetY = reflectOffsetY;
    }
    
    if (backOffsetY < 0)
        backOffsetY = 0;
    
    reflectOffsetY = backOffsetY;
    
    //Crop Image
    UIImage* cropImage = [self.image croppedImage:CGRectMake(reflectOffsetX, reflectOffsetY, cropSize.width, cropSize.height)];
    
    return [self renderImageWithImage2D_Type4:cropImage];
}

- (UIImage *)renderImageWithImage2D_Type5:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //top
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width/2.0f, cropSize.height/2.0f)];

    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*3/2.0f, 0);
    [withImage drawInRect:CGRectMake(cropSize.width/2.0f, 0, cropSize.width/2.0f, cropSize.height/2.0f)];

    CGContextRestoreGState(context);
    CGContextSaveGState(context);

    //bottom
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -cropSize.height*3/2.0f);
    [withImage drawInRect:CGRectMake(0, cropSize.height/2.0f, cropSize.width/2.0f, cropSize.height/2.0f)];

    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, -1, -1);
    CGContextTranslateCTM(context, -cropSize.width*3/2.0f, -cropSize.height*3/2.0f);
    [withImage drawInRect:CGRectMake(cropSize.width/2.0f, cropSize.height/2.0f, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage2D_Type5:(float) offsetX offsetY:(float) offsetY
{
    float imageW = self.image.size.width;
    float imageH = self.image.size.height;
    
    float imgRatio = imageW / imageH;
    
    float backOffsetX = reflectOffsetX;
    backOffsetX += offsetX;
    
    float backOffsetY = reflectOffsetY;
    backOffsetY += offsetY;
    
    CGSize cropSize;
    
    if (imgRatio > self.ratio)
    {
        cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio];
        if (cropSize.width > imageW)
        {
            cropSize = [self canvasSizeByRatioW: imageW ratioBy:self.ratio];
        }
    }
    else
    {
        cropSize = [self canvasSizeByRatioW: imageW ratioBy:1/self.ratio];
        if (cropSize.height > imageH)
        {
//            cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio];
        }
    }
    
    if (backOffsetX > (imageW-cropSize.width))
    {
        backOffsetX = reflectOffsetX;
    }
    
    if (backOffsetX < 0)
        backOffsetX = 0;
    
    reflectOffsetX = backOffsetX;
    
    if (backOffsetY > (imageH-cropSize.height))
    {
        backOffsetY = reflectOffsetY;
    }
    
    if (backOffsetY < 0)
        backOffsetY = 0;
    
    reflectOffsetY = backOffsetY;
    
    //Crop Image
    UIImage* cropImage = [self.image croppedImage:CGRectMake(reflectOffsetX, reflectOffsetY, cropSize.width, cropSize.height)];
    
    return [self renderImageWithImage2D_Type5:cropImage];

}

- (UIImage *)renderImageWithImage2D_Type6:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //top
    [withImage drawInRect:CGRectMake(cropSize.width/2.0f, 0, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width/2.0f, 0);
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    //bottom
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -cropSize.height*3/2.0f);
    [withImage drawInRect:CGRectMake(cropSize.width/2.0f, cropSize.height/2.0f, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, -1, -1);
    CGContextTranslateCTM(context, -cropSize.width/2.0f, -cropSize.height*3/2.0f);
    [withImage drawInRect:CGRectMake(0, cropSize.height/2.0f, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage2D_Type6:(float) offsetX offsetY:(float) offsetY
{
    float imageW = self.image.size.width;
    float imageH = self.image.size.height;
    
    float imgRatio = imageW / imageH;
    
    float backOffsetX = reflectOffsetX;
    backOffsetX += offsetX;
    
    float backOffsetY = reflectOffsetY;
    backOffsetY += offsetY;
    
    CGSize cropSize;
    
    if (imgRatio > self.ratio)
    {
        cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio];
        if (cropSize.width > imageW)
        {
            cropSize = [self canvasSizeByRatioW: imageW ratioBy:self.ratio];
        }
    }
    else
    {
        cropSize = [self canvasSizeByRatioW: imageW ratioBy:1/self.ratio];
        if (cropSize.height > imageH)
        {
//            cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio];
        }
    }
    
    if (backOffsetX > (imageW-cropSize.width))
    {
        backOffsetX = reflectOffsetX;
    }
    
    if (backOffsetX < 0)
        backOffsetX = 0;
    
    reflectOffsetX = backOffsetX;
    
    if (backOffsetY > (imageH-cropSize.height))
    {
        backOffsetY = reflectOffsetY;
    }
    
    if (backOffsetY < 0)
        backOffsetY = 0;
    
    reflectOffsetY = backOffsetY;
    
    //Crop Image
    UIImage* cropImage = [self.image croppedImage:CGRectMake(reflectOffsetX, reflectOffsetY, cropSize.width, cropSize.height)];
    
    return [self renderImageWithImage2D_Type6:cropImage];
    
}

- (UIImage *)renderImageWithImage2D_Type7:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //top
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*3/2.0f, 0);
    [withImage drawInRect:CGRectMake(cropSize.width/2.0f, 0, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    //bottom
    [withImage drawInRect:CGRectMake(cropSize.width/2.0f, cropSize.height/2.0f, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width/2.0f, 0);
    [withImage drawInRect:CGRectMake(0, cropSize.height/2.0f, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage2D_Type7:(float) offsetX offsetY:(float) offsetY
{
    float imageW = self.image.size.width;
    float imageH = self.image.size.height;
    
    float imgRatio = imageW / imageH;
    
    float backOffsetX = reflectOffsetX;
    backOffsetX += offsetX;
    
    float backOffsetY = reflectOffsetY;
    backOffsetY += offsetY;
    
    CGSize cropSize;
    
    if (imgRatio > self.ratio)
    {
        cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio];
        if (cropSize.width > imageW)
        {
            cropSize = [self canvasSizeByRatioW: imageW ratioBy:self.ratio];
        }
    }
    else
    {
        cropSize = [self canvasSizeByRatioW: imageW ratioBy:1/self.ratio];
        if (cropSize.height > imageH)
        {
//            cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio];
        }
    }
    
    if (backOffsetX > (imageW-cropSize.width))
    {
        backOffsetX = reflectOffsetX;
    }
    
    if (backOffsetX < 0)
        backOffsetX = 0;
    
    reflectOffsetX = backOffsetX;
    
    if (backOffsetY > (imageH-cropSize.height))
    {
        backOffsetY = reflectOffsetY;
    }
    
    if (backOffsetY < 0)
        backOffsetY = 0;
    
    reflectOffsetY = backOffsetY;
    
    //Crop Image
    UIImage* cropImage = [self.image croppedImage:CGRectMake(reflectOffsetX, reflectOffsetY, cropSize.width, cropSize.height)];
    
    return [self renderImageWithImage2D_Type7:cropImage];
    
}

- (UIImage *)renderImageWithImage2D_Type8:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //bottom
    [withImage drawInRect:CGRectMake(0, cropSize.height/2.0f, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*3/2.0f, 0);
    [withImage drawInRect:CGRectMake(cropSize.width/2.0f, cropSize.height/2.0f, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    //top
    [withImage drawInRect:CGRectMake(cropSize.width/2.0f, 0, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width/2.0f, 0);
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width/2.0f, cropSize.height/2.0f)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage2D_Type8:(float) offsetX offsetY:(float) offsetY
{
    float imageW = self.image.size.width;
    float imageH = self.image.size.height;
    
    float imgRatio = imageW / imageH;
    
    float backOffsetX = reflectOffsetX;
    backOffsetX += offsetX;
    
    float backOffsetY = reflectOffsetY;
    backOffsetY += offsetY;
    
    CGSize cropSize;
    
    if (imgRatio > self.ratio)
    {
        cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio];
        if (cropSize.width > imageW)
        {
            cropSize = [self canvasSizeByRatioW: imageW ratioBy:self.ratio];
        }
    }
    else
    {
        cropSize = [self canvasSizeByRatioW: imageW ratioBy:1/self.ratio];
        if (cropSize.height > imageH)
        {
//            cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio];
        }
    }
    
    if (backOffsetX > (imageW-cropSize.width))
    {
        backOffsetX = reflectOffsetX;
    }
    
    if (backOffsetX < 0)
        backOffsetX = 0;
    
    reflectOffsetX = backOffsetX;
    
    if (backOffsetY > (imageH-cropSize.height))
    {
        backOffsetY = reflectOffsetY;
    }
    
    if (backOffsetY < 0)
        backOffsetY = 0;
    
    reflectOffsetY = backOffsetY;
    
    //Crop Image
    UIImage* cropImage = [self.image croppedImage:CGRectMake(reflectOffsetX, reflectOffsetY, cropSize.width, cropSize.height)];
    
    return [self renderImageWithImage2D_Type8:cropImage];
    
}


- (UIImage*) reflectImage3D_Type1:(float) offsetX offsetY:(float) offsetY
{
    UIImage* exportImage = [self reflectImage2D_Type1:offsetX offsetY:offsetY];
    CGSize cropSize = [self canvasSizeByRatio: 640];

    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    
    //top
    [exportImage drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    [[UIImage imageNamed: @"img_heart_t.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage3D_Type2:(float) offsetX offsetY:(float) offsetY
{
    UIImage* exportImage = [self reflectImage2D_Type2:offsetX offsetY:offsetY];
    
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    
    //top
    [exportImage drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    [[UIImage imageNamed: @"img_heart_t.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage3D_Type3:(float) offsetX offsetY:(float) offsetY
{
    UIImage* exportImage = [self reflectImage2D_Type1:offsetX offsetY:offsetY];
    
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    
    //top
    [exportImage drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    [[UIImage imageNamed: @"img_butterfly.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage3D_Type4:(float) offsetX offsetY:(float) offsetY
{
    UIImage* exportImage = [self reflectImage2D_Type2:offsetX offsetY:offsetY];
    
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    
    //top
    [exportImage drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    [[UIImage imageNamed: @"img_butterfly.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage3D_Type5:(float) offsetX offsetY:(float) offsetY
{
    UIImage* exportImage = [self reflectImage2D_Type1:offsetX offsetY:offsetY];
    
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    
    //top
    [exportImage drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    [[UIImage imageNamed: @"img_foot.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage3D_Type6:(float) offsetX offsetY:(float) offsetY
{
    UIImage* exportImage = [self reflectImage2D_Type2:offsetX offsetY:offsetY];
    
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    
    //top
    [exportImage drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    [[UIImage imageNamed: @"img_foot.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage3D_Type7:(float) offsetX offsetY:(float) offsetY
{
    UIImage* exportImage = [self reflectImage2D_Type1:offsetX offsetY:offsetY];
    
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    
    //top
    [exportImage drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    [[UIImage imageNamed: @"img_heart.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage3D_Type8:(float) offsetX offsetY:(float) offsetY
{
    UIImage* exportImage = [self reflectImage2D_Type2:offsetX offsetY:offsetY];
    
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    
    //top
    [exportImage drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    [[UIImage imageNamed: @"img_heart.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}


- (UIImage *)renderImageWithImage3D_Type9:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width/4.0f, cropSize.height)];

    [withImage drawInRect:CGRectMake(cropSize.width*2/4.0f, 0, cropSize.width/4.0f, cropSize.height)];

    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*3/4, 0);
    [withImage drawInRect:CGRectMake(cropSize.width/4.0f, 0, cropSize.width/4.0f, cropSize.height)];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*7/4.0f, 0);
    [withImage drawInRect:CGRectMake(cropSize.width*3/4.0f, 0, cropSize.width/4.0f, cropSize.height)];
    CGContextRestoreGState(context);
    
    [[UIImage imageNamed: @"img_screen1.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage3D:(float) offsetX offsetY:(float) offsetY
{
    float imageW = self.image.size.width;
    float imageH = self.image.size.height;
    
    float imgRatio = imageW / imageH;
    
    float backOffsetX = reflectOffsetX;
    backOffsetX += offsetX;
    
    float backOffsetY = reflectOffsetY;
    backOffsetY += offsetY;
    
    CGSize cropSize;
    
    if (imgRatio > self.ratio/2)
    {
        cropSize = [self canvasSizeByRatioH: imageH ratioBy:self.ratio/4];
    }
    else
    {
        cropSize = [self canvasSizeByRatioW: imageW ratioBy:4/self.ratio];
    }
    
    if (backOffsetX > (imageW-cropSize.width))
    {
        backOffsetX = reflectOffsetX;
    }
    
    if (backOffsetX < 0)
        backOffsetX = 0;
    
    reflectOffsetX = backOffsetX;
    
    if (backOffsetY > (imageH-cropSize.height))
    {
        backOffsetY = reflectOffsetY;
    }
    
    if (backOffsetY < 0)
        backOffsetY = 0;
    
    reflectOffsetY = backOffsetY;
    
    //Crop Image
    UIImage* cropImage = [self.image croppedImage:CGRectMake(reflectOffsetX, reflectOffsetY, cropSize.width, cropSize.height)];
    return cropImage;
}

- (UIImage *)renderImageWithImage3D_Type10:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [withImage drawInRect:CGRectMake(cropSize.width/4.0f, 0, cropSize.height/4.0f, cropSize.height)];
    
    [withImage drawInRect:CGRectMake(cropSize.width*3/4.0f, 0, cropSize.height/4.0f, cropSize.height)];
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width/4.0f, 0);
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width/4.0f, cropSize.height)];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*5/4.0f, 0);
    [withImage drawInRect:CGRectMake(cropSize.width*2/4.0f, 0, cropSize.width/4.0f, cropSize.height)];
    CGContextRestoreGState(context);
    
    [[UIImage imageNamed: @"img_screen1.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)renderImageWithImage3D_Type11:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [withImage drawInRect:CGRectMake(0, 0, cropSize.width/4.0f, cropSize.height)];
    
    [withImage drawInRect:CGRectMake(cropSize.width/4.0f, 0, cropSize.width/4.0f, cropSize.height)];
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*5/4.0f, 0);
    [withImage drawInRect:CGRectMake(cropSize.width*2/4.0f, 0, cropSize.width/4.0f, cropSize.height)];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*7/4.0f, 0);
    [withImage drawInRect:CGRectMake(cropSize.width*3/4.0f, 0, cropSize.width/4.0f, cropSize.height)];
    CGContextRestoreGState(context);
    
    [[UIImage imageNamed: @"img_screen1.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)renderImageWithImage3D_Type12:(UIImage*) withImage
{
    CGSize cropSize = [self canvasSizeByRatio: 640];
    CGRect rect = CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [withImage drawInRect:CGRectMake(cropSize.width*2/4.0f, 0, cropSize.width/4.0f, cropSize.height)];
    
    [withImage drawInRect:CGRectMake(cropSize.width*3/4.0f, 0, cropSize.width/4.0f, cropSize.height)];
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*3/4.0f, 0);
    [withImage drawInRect:CGRectMake(cropSize.width*2/4.0f, 0, cropSize.width/4.0f, cropSize.height)];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -cropSize.width*5/4.0f, 0);
    [withImage drawInRect:CGRectMake(cropSize.width*3/4.0f, 0, cropSize.width/4.0f, cropSize.height)];
    CGContextRestoreGState(context);
    
    [[UIImage imageNamed: @"img_screen1.png"] drawInRect:CGRectMake(0, 0, cropSize.width, cropSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage*) reflectImage:(float) offsetX offsetY:(float) offsetY
{
    lastOffsetX = offsetX;
    lastOffsetY = offsetY;
 
    UIImage* exportImage = nil;
    switch (self.reflectType) {
        case k2DType_1:
            exportImage = [self reflectImage2D_Type1:offsetX offsetY:offsetY];
            break;
        case k2DType_2:
            exportImage = [self reflectImage2D_Type2:offsetX offsetY:offsetY];
            break;
        case k2DType_3:
            exportImage = [self reflectImage2D_Type3:offsetX offsetY:offsetY];
            break;
        case k2DType_4:
            exportImage = [self reflectImage2D_Type4:offsetX offsetY:offsetY];
            break;
        case k2DType_5:
            exportImage = [self reflectImage2D_Type5:offsetX offsetY:offsetY];
            break;
        case k2DType_6:
            exportImage = [self reflectImage2D_Type6:offsetX offsetY:offsetY];
            break;
        case k2DType_7:
            exportImage = [self reflectImage2D_Type7:offsetX offsetY:offsetY];
            break;
        case k2DType_8:
            exportImage = [self reflectImage2D_Type8:offsetX offsetY:offsetY];
            break;

        case k3DType_1:
            exportImage = [self reflectImage3D_Type1:offsetX offsetY:offsetY];
            break;
        case k3DType_2:
            exportImage = [self reflectImage3D_Type2:offsetX offsetY:offsetY];
            break;
        case k3DType_3:
            exportImage = [self reflectImage3D_Type3:offsetX offsetY:offsetY];
            break;
        case k3DType_4:
            exportImage = [self reflectImage3D_Type4:offsetX offsetY:offsetY];
            break;
        case k3DType_5:
            exportImage = [self reflectImage3D_Type5:offsetX offsetY:offsetY];
            break;
        case k3DType_6:
            exportImage = [self reflectImage3D_Type6:offsetX offsetY:offsetY];
            break;
        case k3DType_7:
            exportImage = [self reflectImage3D_Type7:offsetX offsetY:offsetY];
            break;
        case k3DType_8:
            exportImage = [self reflectImage3D_Type8:offsetX offsetY:offsetY];
            break;
        case k3DType_9:
        {
            UIImage *cropImage = [self reflectImage3D:offsetX offsetY:offsetY];
            exportImage = [self renderImageWithImage3D_Type9:cropImage];
        }
            break;
        case k3DType_10:
        {
            UIImage *cropImage = [self reflectImage3D:offsetX offsetY:offsetY];
            exportImage = [self renderImageWithImage3D_Type10:cropImage];
        }
            break;
        case k3DType_11:
        {
            UIImage *cropImage = [self reflectImage3D:offsetX offsetY:offsetY];
            exportImage = [self renderImageWithImage3D_Type11:cropImage];
        }
            break;
        case k3DType_12:
        {
            UIImage *cropImage = [self reflectImage3D:offsetX offsetY:offsetY];
            exportImage = [self renderImageWithImage3D_Type12:cropImage];
        }
            break;
            
        default:
            break;
    }

    return exportImage;
}

- (UIImage*) reflectLastImage
{
    return [self reflectImage: lastOffsetX offsetY:lastOffsetY];
}

- (void) setProcessImage:(UIImage*) orgImage
{
    self.image = orgImage;
    self.backupImage = orgImage;
}
@end
