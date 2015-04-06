//
//  ForcastVC.m
//  Weather
//
//  Created by Ajinkya's on 01/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

#import "ForcastVC.h"

@interface ForcastVC ()
{
    IBOutlet UITableView *forcastTable;
}
@end

@implementation ForcastVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrCities count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    UIActivityIndicatorView *actInd= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actInd.tag=100;
    actInd.center=cell.center;
    [actInd startAnimating];
    [cell addSubview:actInd];
    cell.tag=indexPath.row;
    
    NSString *urlReqStr;
    if (_isForCurrentLoc)
    {
        urlReqStr=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=14&APPID=0e21f78cf00153df4322520e495fe3ed",[_arrCities objectAtIndex:indexPath.row]];
    }
    else
    {
        urlReqStr=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=14&APPID=0e21f78cf00153df4322520e495fe3ed",[_arrCities objectAtIndex:indexPath.row]];
    }
    urlReqStr=[urlReqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlReqStr]];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error)
     {
         if(data)
         {
             [actInd stopAnimating];
             [actInd removeFromSuperview];
             //uisng nsjason serilaization:
             NSError *error;
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             NSMutableArray *array =[[NSMutableArray alloc]initWithArray:[responseDict objectForKey:@"list"]];
             
             UIScrollView *scrolvw=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
             [scrolvw setContentSize:CGSizeMake(3600, 150)];
             [cell.contentView addSubview:scrolvw];
             
             UILabel *lblCityName=[[UILabel alloc] initWithFrame:CGRectMake(18, 64, 80, 20)];
             lblCityName.text=[_arrCities objectAtIndex:indexPath.row];
             [scrolvw addSubview:lblCityName];
             
             int X=120;
             for (NSDictionary *dict in array)
             {
                 UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(X, 0, 230, 150)];
                 vw.backgroundColor=[UIColor brownColor];
                 
                 UILabel *lbldate=[[UILabel alloc] initWithFrame:CGRectMake(13 , 5, 72, 15)];
                 
                 NSTimeInterval _interval=[[dict valueForKey:@"dt"] doubleValue];
                 NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                 NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                 [_formatter setDateFormat:@"dd/MM/yy"];
                 NSString *str1=[_formatter stringFromDate:date];
                 
                 lbldate.text=str1;
                 [vw addSubview:lbldate];
                 
                 UILabel *lblMinTemp=[[UILabel alloc] initWithFrame:CGRectMake(13, 28, 72, 20)];
                 lblMinTemp.font=[UIFont systemFontOfSize:11];
                 lblMinTemp.text=@"Min Temp:";
                 [vw addSubview:lblMinTemp];
                 
                 UILabel *lblMinTempVAlue=[[UILabel alloc] initWithFrame:CGRectMake(107, 28, 80, 20)];
                 lblMinTempVAlue.text=[[[dict valueForKey:@"temp"] valueForKey:@"min"] stringValue];
                 lblMinTempVAlue.font=[UIFont systemFontOfSize:11];
                 [vw addSubview:lblMinTempVAlue];
                 
                 UILabel *lblMaxTemp=[[UILabel alloc] initWithFrame:CGRectMake(13, 57, 72, 20)];
                 lblMaxTemp.text=@"Max Temp:";
                 lblMaxTemp.font=[UIFont systemFontOfSize:11];
                 [vw addSubview:lblMaxTemp];
                 
                 UILabel *lblMaxTempVAlue=[[UILabel alloc] initWithFrame:CGRectMake(107, 57, 80, 20)];
                 lblMaxTempVAlue.text=[[[dict valueForKey:@"temp"] valueForKey:@"max"] stringValue];
                 lblMaxTempVAlue.font=[UIFont systemFontOfSize:11];
                 [vw addSubview:lblMaxTempVAlue];
                 
                 UILabel *lblHumidity=[[UILabel alloc] initWithFrame:CGRectMake(13, 86, 72, 20)];
                 lblHumidity.text=@"Humidity:";
                 lblHumidity.font=[UIFont systemFontOfSize:11];
                 [vw addSubview:lblHumidity];
                 
                 UILabel *lblHumidityValue=[[UILabel alloc] initWithFrame:CGRectMake(107, 86, 80, 20)];
                 lblHumidityValue.text=[[dict valueForKey:@"humidity"] stringValue];
                 lblHumidityValue.font=[UIFont systemFontOfSize:11];
                 [vw addSubview:lblHumidityValue];
                 
                 UILabel *lblComment=[[UILabel alloc] initWithFrame:CGRectMake(13, 105, 72, 20)];
                 lblComment.text=@"Forcast:";
                 lblComment.font=[UIFont systemFontOfSize:11];
                 [vw addSubview:lblComment];
                 
                 UILabel *lblCommentvalue=[[UILabel alloc] initWithFrame:CGRectMake(107, 105, 115, 46)];
                 lblCommentvalue.text=[[[dict valueForKey:@"weather"] firstObject] valueForKey:@"description"];
                 lblCommentvalue.lineBreakMode=NSLineBreakByWordWrapping;
                 lblCommentvalue.font=[UIFont systemFontOfSize:11];
                 [vw addSubview:lblCommentvalue];
                 
                 [scrolvw addSubview:vw];
                 X+=238;
             }
             
         }
         
         else
         {
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection not available" message:@"Connection failed to load data. Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [alert show];
             
         }
     }];

    
//    [self performSelectorInBackground:@selector(loadDataOnCell:) withObject:cell];
    
    return cell;
}

-(void)loadDataOnCell:(UITableViewCell*)cell //withCity:(NSString*)city
{
    NSString *urlReqStr=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=14&APPID=0e21f78cf00153df4322520e495fe3ed",[_arrCities objectAtIndex:cell.tag]];
    
    urlReqStr=[urlReqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"l url %@",urlReqStr);
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlReqStr]];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error)
     {
         if(data)
         {
             
             //uisng nsjason serilaization:
             NSError *error;
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             NSArray *array = [responseDict objectForKey:@"list"];
             
             UIScrollView *scrolvw=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
             [scrolvw setContentSize:CGSizeMake(3700, 150)];
             [cell.contentView addSubview:scrolvw];
             
             UILabel *lblCityName=[[UILabel alloc] initWithFrame:CGRectMake(18, 64, 80, 20)];
             lblCityName.text=[_arrCities objectAtIndex:cell.tag];
             [scrolvw addSubview:lblCityName];
             
             int X=120;
             for (NSDictionary *dict in array)
             {
                 UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(X, 0, 230, 149)];
                 
                 UILabel *lblMinTemp=[[UILabel alloc] initWithFrame:CGRectMake(18, 64, 80, 20)];
                 lblMinTemp.text=@"Min Temp:";
                 [vw addSubview:lblMinTemp];
                 
                 UILabel *lblMinTempVAlue=[[UILabel alloc] initWithFrame:CGRectMake(18, 64, 80, 20)];
                 lblMinTempVAlue.text=[[dict valueForKey:@"temp"] valueForKey:@"min"];
                 [vw addSubview:lblMinTempVAlue];
                 
                 UILabel *lblMaxTemp=[[UILabel alloc] initWithFrame:CGRectMake(18, 64, 80, 20)];
                 lblMaxTemp.text=@"Max Temp:";
                 [vw addSubview:lblMaxTemp];
                 
                 UILabel *lblMaxTempVAlue=[[UILabel alloc] initWithFrame:CGRectMake(18, 64, 80, 20)];
                 lblMaxTempVAlue.text=[[dict valueForKey:@"temp"] valueForKey:@"max"];
                 [vw addSubview:lblMaxTempVAlue];
                 
                 UILabel *lblHumidity=[[UILabel alloc] initWithFrame:CGRectMake(18, 64, 80, 20)];
                 lblHumidity.text=@"Humidity:";
                 [vw addSubview:lblHumidity];
                 
                 UILabel *lblHumidityValue=[[UILabel alloc] initWithFrame:CGRectMake(18, 64, 80, 20)];
                 lblHumidityValue.text=[dict valueForKey:@"humidity"];
                 [vw addSubview:lblHumidityValue];
                 
                 UILabel *lblComment=[[UILabel alloc] initWithFrame:CGRectMake(18, 64, 80, 20)];
                 lblComment.text=@"Forcast:";
                 [vw addSubview:lblComment];
                 
                 UILabel *lblCommentvalue=[[UILabel alloc] initWithFrame:CGRectMake(18, 64, 80, 20)];
                 lblCommentvalue.text=[[[dict valueForKey:@"weather"] firstObject] valueForKey:@"description"];
                 [vw addSubview:lblCommentvalue];
                 
                 [scrolvw addSubview:vw];
                 
                 X+=238;
                 
             }
             
         }
         
         else
         {
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection not available" message:@"Connection failed to load data. Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [alert show];
             
         }
     }];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
