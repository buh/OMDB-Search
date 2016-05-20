//
//  OMThumbnailImageCache.h
//  OMDB Search
//
//  Created by Alexey Bukhtin on 17.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OMThumbnailImageCacheCompletionBlock)(NSURL *imageURL, UIImage *thumbnailImage);

@interface OMThumbnailImageCache : NSObject

- (instancetype)initWithThumbnailSize:(CGSize)size;

- (UIImage *)thumbnailImageWithURL:(NSURL *)imageURL;

- (void)processImage:(UIImage *)image URL:(NSURL *)URL completionBlock:(OMThumbnailImageCacheCompletionBlock)completionBlock;

- (void)cancel;

@end
