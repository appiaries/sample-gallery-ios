//
//  ImageViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
    NSString *imageURL;
}
#pragma mark - Initialization
- (id)initWithImageURL:(NSString *)url;

@end
