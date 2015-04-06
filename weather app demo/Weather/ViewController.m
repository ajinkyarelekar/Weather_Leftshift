//
//  ViewController.m
//  Weather
//
//  Created by Ajinkya's on 01/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

#import "ViewController.h"
#import "ForcastVC.h"

@interface ViewController ()
{
    IBOutlet UITextField *txtCityName;
    IBOutlet UITableView *cityTable;
    NSMutableArray *arrCities;
    
    CLLocationManager *locoman;
    CLLocationCoordinate2D currentLoc;
    
    CLLocation *cLoc;
    BOOL isForCurrentLoc;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrCities=[NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
    
    locoman = [[CLLocationManager alloc]init];
    //    if ([locoman respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    //        // [locationManager requestAlwaysAuthorization];
    //        [locoman requestWhenInUseAuthorization];
    //    }
    locoman.desiredAccuracy = kCLLocationAccuracyBest;
    locoman.distanceFilter = kCLDistanceFilterNone;
    locoman.delegate=self;
    [locoman startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBActions
- (IBAction)CurrentForcastClicked:(id)sender
{
    isForCurrentLoc=YES;
    [arrCities removeAllObjects];
    
    if(cLoc==nil)
    {
        cLoc=[[CLLocation alloc] initWithLatitude:18.5203 longitude:73.8567];
    }
    
    CLGeocoder *geocoder1 = [[CLGeocoder alloc] init];
    
    [geocoder1 reverseGeocodeLocation:cLoc completionHandler:^(NSArray *placemarks, NSError *error) {
                        
                        if (error)
                        {
                            NSLog(@"Geocode failed with error: %@", error);
                            return;
                        }
                        
                        if (placemarks && placemarks.count > 0)
                        {
                            CLPlacemark *placemark = placemarks[0];
                            NSDictionary *addressDictionary = placemark.addressDictionary;
                            NSLog(@"%@",addressDictionary);
                            
                            [arrCities addObject:[addressDictionary valueForKey:@"City"]];
                            [self performSegueWithIdentifier:@"ShowNextView" sender:self];
                        }
                    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    cLoc=[locations firstObject];
    
    [manager stopUpdatingLocation];
}

- (IBAction)AddCityClicked:(id)sender
{
    if ([txtCityName.text length]==0)
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Empty field!" message:@"Please enter the city name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alt show];
        return;
    }
    else
    {
        NSString *str=txtCityName.text;
        [arrCities addObject:str];
        [cityTable reloadData];
        txtCityName.text=@"";
    }
}

- (IBAction)ShowForcastClicked:(id)sender
{
    if ([arrCities count]==0)
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Enter Cities!" message:@"Please enter the city names." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alt show];
    }
    else
    {
        isForCurrentLoc=NO;
        [self performSegueWithIdentifier:@"ShowNextView" sender:self];
    }
}

-(void)removefromArray:(UIButton*)sender
{
    NSLog(@"%d",sender.tag);
    [arrCities removeObjectAtIndex:sender.tag-1];
    [cityTable reloadData];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ForcastVC *FVC=[segue destinationViewController];
    FVC.arrCities=arrCities;
    FVC.isForCurrentLoc=isForCurrentLoc;
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


#pragma mark - uitableview methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrCities count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    UIButton *remove=[UIButton buttonWithType:UIButtonTypeCustom];
    [remove setTitle:@"X" forState:UIControlStateNormal];
    [remove setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    remove.tag=indexPath.row+1;
    [remove setFrame:CGRectMake(250, 5, 30, 30)];
    [remove addTarget:self action:@selector(removefromArray:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:remove];
    
    cell.textLabel.text=[arrCities objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
@end
