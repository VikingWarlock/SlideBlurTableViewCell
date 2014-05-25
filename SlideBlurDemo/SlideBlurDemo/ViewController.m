//
//  ViewController.m
//  SlideBlurDemo
//
//  Created by viking warlock on 5/25/14.
//  Copyright (c) 2014 viking warlock. All rights reserved.
//

#import "ViewController.h"
#import "BlurTableViewCell_mark1.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,Delegate_BlurCellSlide>
{
    UITableView *tableview;
    UIImage *bkimage;
}


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    bkimage=[UIImage imageNamed:@"pic.jpg"];
    
    tableview=[[UITableView alloc]init];
    [self.view addSubview:tableview];
    [tableview setFrame:self.view.frame];
    tableview.delegate=self;
    tableview.dataSource=self;
    [tableview registerClass:[BlurTableViewCell_mark1 class] forCellReuseIdentifier:@"DemoCell"];
    
    [tableview reloadData];

}



#pragma TableView DataSource &&Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)alert:(NSString*)msg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Here" message:msg delegate:nil cancelButtonTitle:@"Good" otherButtonTitles: nil];
    [alert show];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlurTableViewCell_mark1 *cell=[tableview dequeueReusableCellWithIdentifier:@"DemoCell" forIndexPath:indexPath];
    
    //you can shoose the slide direction by your self
    //Cell_Init_Direction_At_*
    
    if (indexPath.row %2==0) {
        [cell SetupWithBackImage:bkimage AtIndexpath:indexPath AndInitPosition:Cell_Init_Direction_At_Right AndDelegate:self];
    }else
    [cell SetupWithBackImage:bkimage AtIndexpath:indexPath AndInitPosition:Cell_Init_Direction_At_Left AndDelegate:self];

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlurTableViewCell_mark1 *cell=(BlurTableViewCell_mark1*)[tableview cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:NO];
    [self alert:@"Select Cell"];
}

-(void)slideHaveBeenDoneAtIndexPath:(NSIndexPath *)indexpath
{
    [self alert:@"Slide Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
