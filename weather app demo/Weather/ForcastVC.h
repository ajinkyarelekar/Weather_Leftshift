//
//  ForcastVC.h
//  Weather
//
//  Created by Ajinkya's on 01/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForcastVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)NSMutableArray *arrCities;
@property(nonatomic)BOOL isForCurrentLoc;
@end
