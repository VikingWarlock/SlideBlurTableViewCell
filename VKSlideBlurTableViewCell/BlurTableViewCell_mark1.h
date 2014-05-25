//
//  BlurTableViewCell_mark1.h
//  Peanut_Mark1
//
//  Created by viking warlock on 5/14/14.
//  Copyright (c) 2014 viking warlock. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, Cell_Init_Direction) {
    Cell_Init_Direction_At_Right=0,
    Cell_Init_Direction_At_Left
};

@protocol Delegate_BlurCellSlide <NSObject>



@optional

-(BOOL)SlideCouldBegin:(NSIndexPath*)indexpath;
-(void)slideHaveBeenDoneAtIndexPath:(NSIndexPath*)indexpath;
-(void)ThisCellHaveBeenSlide:(NSIndexPath*)indexpath;
-(void)ThisCellHaveBeenReleased:(NSIndexPath *)indexpath;
//滑动完成后做的事情
//After slide

@end

@interface BlurTableViewCell_mark1 : UITableViewCell

@property(nonatomic,weak)id<Delegate_BlurCellSlide> Delegate_Blur;
@property(nonatomic,strong)NSIndexPath* indexpath;
@property(nonatomic,strong)UIImage *BKImage;





-(id)initWithBackImage:(UIImage*)bkImage AtIndexpath:(NSIndexPath*)indexpath AndInitPosition:(Cell_Init_Direction)position AndDelegate:(id<Delegate_BlurCellSlide>)delegate;

/**
 * setup a cell
 *
 */
-(void)SetupWithBackImage:(UIImage*)bkImage AtIndexpath:(NSIndexPath*)indexpath AndInitPosition:(Cell_Init_Direction)position AndDelegate:(id<Delegate_BlurCellSlide>)delegate;

/**
 *
 *
 */
-(void)backToOriginWithAnimate:(BOOL)animate;




@end
