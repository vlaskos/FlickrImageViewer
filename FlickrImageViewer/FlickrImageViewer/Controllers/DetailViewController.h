//
//  DetailViewController.h
//  FlickrImageViewer
//
//  Created by vlaskos on 28.09.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) UIImage *detailImage;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (assign, nonatomic) NSInteger currentIndex;

@end
