//
//  ViewController.m
//  FlickrImageViewer
//
//  Created by vlaskos on 26.09.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import "GeneralViewController.h"
#import "NetworkManager.h"
#import "CustomCollectionViewCell.h"
#import <SVProgressHUD.h>
#import "DetailViewController.h"


@interface GeneralViewController () <UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UISearchBarDelegate,
                                    UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *flickrPhoto;
@property (nonatomic, strong) NSMutableArray *flickrTitles;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (assign, nonatomic) NSInteger sliderCount;


@end

@implementation GeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchBar setValue:@"Search" forKey:@"_cancelButtonText"];
    self.sliderCount = 2;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Self Methods 

- (void) prepareView {
    self.descriptionLabel.hidden = YES;
    self.slider.enabled = YES;
}

#pragma mark - Actions 

- (IBAction)sliderAction:(UISlider*)sender {
    
    self.sliderCount = sender.value;
    [self.collectionView reloadData];
}


#pragma mark - API

- (void) fetchImagesWithWord:(NSString*)word {
    
    
    [self.flickrTitles removeAllObjects];
    [self.flickrPhoto removeAllObjects];
    [self.view endEditing:YES];
    
    [SVProgressHUD show];
    self.collectionView.userInteractionEnabled = NO;
    
    [[NetworkManager sharedManager] getImagesListWithTag:word
                                               OnSuccess:^(id result) {
        
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:&error];
//        NSLog(@"%@", jsonDict);
        
        NSDictionary *dict = [jsonDict objectForKey:@"photos"];
        NSArray *photoArray = [dict objectForKey:@"photo"];
        
        self.flickrPhoto = [NSMutableArray array];
        self.flickrTitles = [NSMutableArray array];
        
        for (NSDictionary *photoInfo in photoArray) {
            
            NSDictionary *imageInfo = @{@"farm_id": [photoInfo objectForKey:@"farm"],
                                        @"server_id" : [photoInfo objectForKey:@"server"],
                                        @"photo_id" : [photoInfo objectForKey:@"id"],
                                        @"secret" : [photoInfo objectForKey:@"secret"]};
            
            [self.flickrTitles addObject:[photoInfo objectForKey:@"title"]];
            
            [[NetworkManager sharedManager] getImageWithInfo:imageInfo OnSuccess:^(id result) {
                
                UIImage *image = [UIImage imageWithData:result];;

                [self.flickrPhoto addObject:image];
                
                if (photoArray.lastObject) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [self.collectionView reloadData];
                        self.collectionView.userInteractionEnabled = YES;
                    });
                }

            } onFailure:^(NSError *error, id responseObject) {
                NSLog(@"Error \n%@ \n%@", error, responseObject);
            }];

        }
                                                   
    } onFailure:^(NSError *error, id responseObject) {
        NSLog(@"Error \n%@ \n%@", error, responseObject);
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return self.flickrPhoto.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCollectionViewCell *customCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];

    customCell.image.image = self.flickrPhoto[indexPath.row];
    customCell.label.text = self.flickrTitles[indexPath.row];
    
    return customCell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellSize = 0.0;
    
    if (self.sliderCount == 1) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        cellSize = screenWidth - 20;
    }
    
    if (self.sliderCount == 2) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        cellSize = screenWidth/2 - 20 ;
    }
    
    if (self.sliderCount == 3) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        cellSize = screenWidth/3 - 20;
    }
    
    
    return CGSizeMake(cellSize, cellSize);
}


#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    DetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    vc.detailImage = self.flickrPhoto[indexPath.row];
    [vc.photoArray addObjectsFromArray:self.flickrPhoto];
    vc.currentIndex = (NSInteger)indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES];
    
    if (searchBar.text.length > 0) {
        [searchBar setShowsCancelButton:NO animated:YES];
        
        [self prepareView];
        [self fetchImagesWithWord:searchBar.text];
    }

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0) {
        [searchBar setShowsCancelButton:YES animated:YES];
        [[NetworkManager sharedManager].requestOperationManager.operationQueue cancelAllOperations];
        [SVProgressHUD dismiss];
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (searchBar.text.length > 0) {
        [searchBar setShowsCancelButton:NO animated:YES];
        [self prepareView];
        [self fetchImagesWithWord:searchBar.text];
    }
    
}


@end
