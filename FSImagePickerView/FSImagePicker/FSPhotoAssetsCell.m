//
//  FSPhotoAssetsCell.m
//  FSImagePickerView
//
//  Created by qufenqi on 1/5/16.
//  Copyright © 2016 王正一. All rights reserved.
//

#import "FSPhotoAssetsCell.h"

@interface FSPhotoAssetsCell()
@property (nonatomic, weak) UIImageView *imageView;
@end
@implementation FSPhotoAssetsCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        UIImageView *indicator = [[UIImageView alloc] init];
        [self.contentView addSubview:indicator];
        self.indicator = indicator;
    }
    return self;
}

- (void)setModel:(FSPhotoAssetsModel *)model
{
    _model = model;
    self.imageView.image = [UIImage imageWithCGImage:model.asset.thumbnail];
    if (model.selected) {
        self.indicator.image = [UIImage imageNamed:@"photo_selected"];
        
    } else {
        
        self.indicator.image = [UIImage imageNamed:@"photo_unSelected"];
        
    }
}

- (void)setDict:(NSMutableDictionary *)dict
{
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    
    CGFloat w = 20;
    CGFloat h = 20;
    CGFloat x = self.frame.size.width - w;
    CGFloat y = 2;
    self.indicator.frame = CGRectMake(x, y, w, h);
    
}

@end
