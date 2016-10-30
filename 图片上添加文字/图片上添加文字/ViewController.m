//
//  ViewController.m
//  图片上添加文字
//
//  Created by 梦想 on 16/10/6.
//  Copyright © 2016年 lin_tong. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, weak) UITextView *text;

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UITextView *text = [[UITextView alloc] init];
    [self.view addSubview:text];
    self.text = text;
    text.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).heightIs(50).rightEqualToView(self.view);
    text.delegate = self;

    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    imageView.sd_layout.topSpaceToView(self.text,0).leftEqualToView(self.view).bottomEqualToView(self.view).rightEqualToView(self.view);
    imageView.image = [UIImage imageNamed:@"1"];
    imageView.backgroundColor = [UIColor orangeColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView addSubview:btn];
    btn.backgroundColor = [UIColor orangeColor];
    
//    NSString *text1 = @"国庆节放假从10.1-10.7";
    
//    imageView.image = 
    //[self text:@"国庆节放假从10.1-10.7" addToImage:[UIImage imageNamed:@"1"]];
    //[self text:@"Made By Jack" addToView:[UIImage imageNamed:@"1"]];
    //[self image:[UIImage imageNamed:@"2"] addToImage:[UIImage imageNamed:@"1"]];
    
}

#pragma mark----将View转换成图片
- (UIImage *)convertImageFromeView:(UIView *)view{
    
    NSLog(@"%f", [UIScreen mainScreen].scale);
    
    //不加scale图片截屏会模糊
    UIGraphicsBeginImageContextWithOptions(view.size, NO, [UIScreen mainScreen].scale);
    //绘制图形上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ref];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //获取固定位置的图片
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(200, 300, 100, 100));
    
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
    return img;
}
#pragma mark----将文字添加到图片上
- (UIImage *)text:(NSString *)text addToImage:(UIImage *)image{
    
    UIFont *font = [UIFont systemFontOfSize:30];
    NSDictionary *dict = @{NSFontAttributeName : font,
                           NSForegroundColorAttributeName : [UIColor purpleColor]};
    //绘制图片上下文
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //字体绘制到图片的位置和字体属性
    [text drawInRect:CGRectMake(100, 100, 400, 50) withAttributes:dict];
    
    //获得新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark----图片添加到图片上
- (UIImage *)image:(UIImage *)image addToImage:(UIImage *)bigImage{
    
    CGFloat w = bigImage.size.width;
    CGFloat h = bigImage.size.height;
    
    //bitmap上下文使用的颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //绘制图形上下文
    CGContextRef ref = CGBitmapContextCreate(NULL, w, h, 8, 444 * bigImage.size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
    //给bigImage画图
    CGContextDrawImage(ref, CGRectMake(0, 0, w, h), bigImage.CGImage);
    CGContextDrawImage(ref, CGRectMake(w - 100, 100, image.size.width, image.size.height), image.CGImage);
    
    //合成图片
    CGImageRef imageMasked = CGBitmapContextCreateImage(ref);
    UIImage *resultImage = [UIImage imageWithCGImage:imageMasked];
    
    //关闭图形上下文
    CGContextClosePath(ref);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return resultImage;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self convertImageFromeView:self.imageView];
    //将文字添加到图片上
    NSLog(@"%s", __func__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
