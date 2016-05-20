//
//  OMThumbnailImageCache.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 17.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "OMThumbnailImageCache.h"
#import "OMMacros.h"

@interface OMThumbnailImageCache ()

@property (nonatomic) NSCache *cache;
@property (nonatomic) CGSize size;
@property (nonatomic) NSOperationQueue *operationQueue;

@end

@implementation OMThumbnailImageCache

- (instancetype)initWithThumbnailSize:(CGSize)size
{
    self = [super init];
    
    if (self) {
        _cache = [NSCache new];
        _size = size;
        _operationQueue = [NSOperationQueue new];
        _operationQueue.maxConcurrentOperationCount = 10;
    }
    
    return self;
}

- (UIImage *)thumbnailImageWithURL:(NSURL *)imageURL
{
    return imageURL ? [_cache objectForKey:[imageURL absoluteString]] : nil;
}

- (void)processImage:(UIImage *)image URL:(NSURL *)URL completionBlock:(OMThumbnailImageCacheCompletionBlock)completionBlock
{
    if (completionBlock) {
        if (image && URL) {
            OMWeakSelf;
            [_operationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                OMStrongSelf;
                UIImage *thumbnailImage = [strongSelf resizeImage:image];
                
                if (thumbnailImage) {
                    [strongSelf.cache setObject:thumbnailImage forKey:[URL absoluteString]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(URL, thumbnailImage);
                });
            }]];
        } else {
            completionBlock(nil, nil);
        }
    }
}

- (void)cancel
{
    [_operationQueue cancelAllOperations];
}

- (UIImage *)resizeImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(_size, YES, 0.);
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
    
    CGFloat width = image.size.width;
    CGFloat scaleFactor = _size.width / width;
    [image drawInRect:CGRectMake(0., 0., width * scaleFactor, image.size.height * scaleFactor)];
    
    UIImage *thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnailImage;
}

@end
