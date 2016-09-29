//
//  CustomCollectionViewCell.h
//  FlickrImageViewer
//
//  Created by vlaskos on 27.09.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
