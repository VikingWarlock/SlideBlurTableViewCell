//
//  BlurTableViewCell_mark1.m
//  Peanut_Mark1
//
//  Created by viking warlock on 5/14/14.
//  Copyright (c) 2014 viking warlock. All rights reserved.
//

#import "BlurTableViewCell_mark1.h"

@interface BlurTableViewCell_mark1()<UIGestureRecognizerDelegate>

@end


@implementation BlurTableViewCell_mark1
{
    UIPanGestureRecognizer *gesture;
    UIView *Slider;
    UIImageView *imageInSlider;
    Cell_Init_Direction init_dir;
    
    UIImage *bluredImage;
    
    CGPoint startingPoint;
    CGPoint originPoint;
    CGPoint donePoint;
    BOOL gestureEnable;
}


-(void)SetupWithBackImage:(UIImage *)bkImage AtIndexpath:(NSIndexPath *)indexpath AndInitPosition:(Cell_Init_Direction)position AndDelegate:(id<Delegate_BlurCellSlide>)delegate
{
    
    self.indexpath=indexpath;
    self.BKImage=[bkImage copy];
    [self setupLayout];
    

    
    self.Delegate_Blur=delegate;
    
    Slider=[[UIView alloc]init];
    
    imageInSlider=[[UIImageView alloc]initWithImage:bluredImage];
    Slider.clipsToBounds=YES;
    [self addSubview:Slider];
    [Slider addSubview:imageInSlider];

    [Slider setBackgroundColor:[UIColor lightGrayColor]];
    
    gestureEnable=YES;
    
    
    switch (position) {
        case Cell_Init_Direction_At_Left:
        {
            Slider.frame=CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
           // [Slider setImage:[self getSubImage:CGRectMake(Slider.frame.origin.x, 0, self.frame.size.height, self.frame.size.height)]];
            
            originPoint=CGPointMake(0, 0);
            donePoint=CGPointMake(self.frame.size.width-self.frame.size.height, 0);
        }
            break;
            
        default:
        {
            Slider.frame=CGRectMake(self.frame.size.width-self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
       //     [Slider setImage:[self getSubImage:CGRectMake(Slider.frame.origin.x, 0, self.frame.size.height, self.frame.size.height)]];
            
            originPoint=CGPointMake(self.frame.size.width-self.frame.size.height, 0);
            donePoint=CGPointMake(0, 0);
        }
            break;
    }
    
 //   CGRect frame=Slider.frame;
    [imageInSlider sizeToFit];
    imageInSlider.clipsToBounds=YES;
    [imageInSlider setFrame:CGRectMake(-Slider.frame.origin.x, 0, self.frame.size.width, self.frame.size.height)];
    
    
    gesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(GestureHandle:)];
    gesture.delegate=self;
    [Slider addGestureRecognizer:gesture];
    [Slider setUserInteractionEnabled:YES];
    
    [self sliderConfig];
    
    
    
}




-(id)initWithBackImage:(UIImage *)bkImage AtIndexpath:(NSIndexPath *)indexpath AndInitPosition:(Cell_Init_Direction)position AndDelegate:(id<Delegate_BlurCellSlide>)delegate
{
    self=[super init];
    
    [self SetupWithBackImage:bkImage AtIndexpath:indexpath AndInitPosition:position AndDelegate:delegate];
    
    return self;
}


 
-(void)setupLayout
{
    UIImageView *imgView=[[UIImageView alloc]initWithImage:self.BKImage];
    [self addSubview:imgView];
    imgView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    bluredImage=[self darkened:0.5f andBlurredImage:18.f blendModeFilterName:@"CIMultiplyBlendMode" :self.BKImage];
    
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)GestureHandle:(UIPanGestureRecognizer*)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            startingPoint=[sender locationInView:self];
            
            if ([self.Delegate_Blur respondsToSelector:@selector(ThisCellHaveBeenSlide:)]) {
                [self.Delegate_Blur ThisCellHaveBeenSlide:self.indexpath];
            }
            
        }
            break;
        case  UIGestureRecognizerStateChanged:
        {
            CGPoint trans=[sender translationInView:self];
            
            if ((abs(trans.x)>abs(trans.y)*3)) {
                
                CGFloat X_offset=[sender locationInView:self].x - startingPoint.x;
                                
                if ((Slider.frame.origin.x>=0)&&(Slider.frame.origin.x+self.frame.size.height<=self.frame.size.width)) {
                    
                    CGRect frame=Slider.frame;
                    frame.origin.x=originPoint.x;
                    frame.origin.y=originPoint.y;
                    frame.origin.x+=X_offset;
                    Slider.frame=frame;
                    imageInSlider.frame=CGRectMake(-Slider.frame.origin.x, 0, imageInSlider.frame.size.width, imageInSlider.frame.size.height);
                    }
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if ([self.Delegate_Blur respondsToSelector:@selector(ThisCellHaveBeenReleased:)]) {
                [self.Delegate_Blur ThisCellHaveBeenReleased:self.indexpath];
            }
            
            startingPoint=CGPointZero;
            BOOL trigger=abs(Slider.frame.origin.x-originPoint.x)/(self.frame.size.width*1.f)>0.4f;
            if (trigger) {
                [UIView animateWithDuration:0.3f animations:^{
                    Slider.frame=CGRectMake(donePoint.x, donePoint.y, self.frame.size.height, Slider.frame.size.height);
                    
                    imageInSlider.frame=CGRectMake(-donePoint.x, 0, self.frame.size.width, self.frame.size.height);

        //            [Slider setImage:[self getSubImage:CGRectMake(Slider.frame.origin.x, 0, self.frame.size.height, self.frame.size.height)]];
                } completion:^(BOOL finished) {
                    if ([self.Delegate_Blur respondsToSelector:@selector(slideHaveBeenDoneAtIndexPath:)]) {
                        
                        [self.Delegate_Blur slideHaveBeenDoneAtIndexPath:self.indexpath];
                    }
                    
                }];
                
                
            }else
            {
                //没有达到触发距离
                [UIView animateWithDuration:0.3f animations:^{
                    Slider.frame=CGRectMake(originPoint.x, originPoint.y, self.frame.size.height, Slider.frame.size.height);
                    imageInSlider.frame=CGRectMake(-originPoint.x, 0, self.frame.size.width, self.frame.size.height);
               
                } completion:^(BOOL finished) {
                    
                    
                }];
                
                
                
            }
            
        }
            break;
            // blow equal state ended;
        default:
            break;
    }
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint trans=[gestureRecognizer translationInView:self];
    if (abs(trans.x)<abs(trans.y)) {
        return NO;
    }
    return gestureEnable&&([self.Delegate_Blur respondsToSelector:@selector(SlideCouldBegin:)]?[self.Delegate_Blur SlideCouldBegin:self.indexpath]:1);
    
    
}


-(void)sliderConfig
{
    [Slider clipsToBounds];
    Slider.contentMode=UIViewContentModeScaleAspectFill;
}



-(void)backToOriginWithAnimate:(BOOL)animate
{
    
    if (animate) {
        [UIView animateWithDuration:0.3f animations:^{
            Slider.frame=CGRectMake(originPoint.x, originPoint.y, self.frame.size.height, self.frame.size.height);
            imageInSlider.frame=CGRectMake(-originPoint.x, 0, self.frame.size.width, self.frame.size.height);
        }];
        
        
    }else
    {
        Slider.frame=CGRectMake(originPoint.x, originPoint.y, self.frame.size.height, self.frame.size.height);
        imageInSlider.frame=CGRectMake(-originPoint.x, 0, self.frame.size.width, self.frame.size.height);
    
    
    }
}



-(UIImage*)darkened:(CGFloat)alpha andBlurredImage:(CGFloat)radius blendModeFilterName:(NSString *)blendModeFilterName :(UIImage*)oriImage{
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:oriImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //First, create some darkness
    CIFilter* blackGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    CIColor* black = [CIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:alpha];
    [blackGenerator setValue:black forKey:@"inputColor"];
    CIImage* blackImage = [blackGenerator valueForKey:@"outputImage"];
    
    //Second, apply that black
    CIFilter *compositeFilter = [CIFilter filterWithName:blendModeFilterName];
    [compositeFilter setValue:blackImage forKey:@"inputImage"];
    [compositeFilter setValue:inputImage forKey:@"inputBackgroundImage"];
    CIImage *darkenedImage = [compositeFilter outputImage];
    
    //Third, blur the image
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:@(radius) forKey:@"inputRadius"];
    [blurFilter setValue:darkenedImage forKey:kCIInputImageKey];
    CIImage *blurredImage = [blurFilter outputImage];
    
    CGImageRef cgimg = [context createCGImage:blurredImage fromRect:inputImage.extent];
    UIImage *blurredAndDarkenedImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return blurredAndDarkenedImage;
}




@end
