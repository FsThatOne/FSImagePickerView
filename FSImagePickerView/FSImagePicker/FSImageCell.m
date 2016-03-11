//
//  FSImageCell.m
//  FSImagePickerView
//
//  Created by qufenqi on 12/30/15.
//  Copyright © 2015 王正一. All rights reserved.
//

#import "FSImageCell.h"
#import "FSImageModel.h"

@interface FSImageCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIImageView *addImageView;
@property (nonatomic, weak) UIButton *btn;
@end
@implementation FSImageCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        self.imageView = imageView;
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"information_delete_icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:btn];
        self.btn = btn;
        
        UIImageView *addImageView = [[UIImageView alloc] init];
        addImageView.image = [UIImage imageNamed:@"addImage"];
        [self.contentView addSubview:addImageView];
        self.addImageView = addImageView;
        addImageView.hidden = YES;
        
        
    }
    return self;
}

//- (void)setUrl:(NSString *)url
//{
//    _url = url;
////    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
//    if ([url isEqualToString:kAddImage]) {
//        self.imageView.hidden = YES;
//        self.addImageView.hidden = NO;
//    } else {
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
//        self.imageView.hidden = NO;
//        self.addImageView.hidden = YES;
//    }
//}
//- (void)setImage:(UIImage *)image
//{
//    _image = image;
//    self.imageView.image = image;
//    self.imageView.hidden = NO;
//    self.addImageView.hidden = YES;
//}

- (void)setModel:(FSImageModel *)model
{
    _model = model;
    if (model.data.length) {
        UIImage *image = [UIImage imageWithData:model.data];
        self.imageView.image = image;
        self.imageView.hidden = NO;
        self.addImageView.hidden = YES;
    } else {
        
        if ([model.url isEqualToString:kAddImage]) {
            self.imageView.hidden = YES;
            self.addImageView.hidden = NO;
        } else {
            self.imageView.hidden = NO;
            self.addImageView.hidden = YES;
        }
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.addImageView.frame = self.bounds;
    
    CGFloat btnW = 13;
    CGFloat btnH = 13;
    CGFloat btnX = self.imageView.frame.size.width - btnW -5;
    CGFloat btnY = 5;
    self.btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
}

- (void)deleteClick
{
    if ([self.delegate respondsToSelector:@selector(imageCellDelete:indexPath:)]) {
        [self.delegate imageCellDelete:self indexPath:self.indexPath];
    }
    
}
@end
