//
//  DetailViewController.m
//  FlickrImageViewer
//
//  Created by vlaskos on 28.09.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailImageView.image = self.detailImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Accessors

-(NSMutableArray *)photoArray {
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    
    return _photoArray;
}


#pragma mark - Self Methods

- (void) appearImage {
 
    [UIView transitionWithView:self.detailImageView
                      duration:0.4f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.detailImageView.image = [self.photoArray objectAtIndex:self.currentIndex];
                    } completion:nil];
}

#pragma mark - UIGestureRecognizer

- (IBAction)rotationAndScale:(UIGestureRecognizer*)sender {
    
    if ([sender isKindOfClass:[UIRotationGestureRecognizer class]]) {

        CGFloat newRotaion = 0.0;
        CGFloat rotation = [(UIRotationGestureRecognizer*) sender rotation];
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotation + newRotaion);
        sender.view.transform = transform;
        
        if (sender.state == UIGestureRecognizerStateEnded) {
            newRotaion += rotation;
        }
    }
    
    if ([sender isKindOfClass:[UIPinchGestureRecognizer class]]) {
        
        CGFloat lastScaleFacetor = 1;
        CGFloat factor = [(UIPinchGestureRecognizer*) sender scale];
        
        if (factor > 1) {
            self.detailImageView.transform = CGAffineTransformMakeScale(lastScaleFacetor + (factor -1), lastScaleFacetor + (factor -1));
        } else {
            self.detailImageView.transform = CGAffineTransformMakeScale(lastScaleFacetor *factor, lastScaleFacetor * factor);
        }
        
        if (sender.state == UIGestureRecognizerStateEnded) {
            if (factor >1)
                lastScaleFacetor += (factor - 1);
            else
                lastScaleFacetor *= factor;
        }
    }
    
}


- (IBAction)swipe:(UISwipeGestureRecognizer*)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        
        if (self.currentIndex>=0 && self.currentIndex !=0) {
            self.currentIndex--;
            
           [self appearImage];
        }
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        if (self.currentIndex>=0 && self.currentIndex < self.photoArray.count - 1) {
            self.currentIndex++;
                        
            [self appearImage];
        }
    }
}


@end
