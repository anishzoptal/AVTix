//
//  DBManager.m
//  dataBase
//
//  Created by Manpreet Kaur on 17/10/14.
//  Copyright (c) 2014 Manpreet Kaur. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
static DBManager *sharedInstance = nil;
static sqlite3 *database;

NSFileManager *fileMgr ;
NSString *homeDir;

+(DBManager*)getSharedInstance {
    
    if (!sharedInstance) {
        sharedInstance = [[DBManager alloc]init];
        [sharedInstance copyAvBackgroundDatabase];
    }
    return sharedInstance;
}

-(NSString *)getDBPath {
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc=[paths objectAtIndex:0];
    return [doc stringByAppendingPathComponent:@"dbavtix.sql"];
}

-(void)copyAvBackgroundDatabase {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    dbPath=[self getDBPath];
    NSLog(@"%@",dbPath);
    BOOL success=[fileManager fileExistsAtPath:dbPath];
    if(!success)
    {
        if(sqlite3_open([[self getDBPath]UTF8String], &database)==SQLITE_OK) {
            
            NSString *str=[NSString stringWithFormat:@"create table av_backgrounds(BackgroundId text,BackgroundName text,BackgroundCategory text, BackgroundType text , BackgroundUrl text, BackgroundDefault text, BackgroundData text, Date text)"];
            const char *sqlStmt=[str UTF8String];
            char *error1;
            if(sqlite3_exec(database, sqlStmt, NULL, NULL, &error1)==SQLITE_OK)
            {
            }
        }
        if(sqlite3_open([[self getDBPath]UTF8String], &database)==SQLITE_OK) {
            
            NSString *str=[NSString stringWithFormat:@"create table av_categories(CategoryId text,CategoryName text,CategoryOrderId text , Date text)"];
            const char *sqlStmt=[str UTF8String];
            char *error1;
            if(sqlite3_exec(database, sqlStmt, NULL, NULL, &error1)==SQLITE_OK)
            {
            }
        }
        if(sqlite3_open([[self getDBPath]UTF8String], &database)==SQLITE_OK) {
            
            NSString *str=[NSString stringWithFormat:@"create table av_events(EventId text,EventName text,EventDescription text, EventCategory text , EventLocation text, EventStartDate text,EventEndDate text, EventUrl text , EventImageUrl text, EventImageData text , Date text)"];
            const char *sqlStmt=[str UTF8String];
            char *error1;
            if(sqlite3_exec(database, sqlStmt, NULL, NULL, &error1)==SQLITE_OK)
            {
            }
        }
        if(sqlite3_open([[self getDBPath]UTF8String], &database)==SQLITE_OK) {
            
            NSString *str=[NSString stringWithFormat:@"create table av_invites(InviteId text, InviteTitle text, InviteLocation text, InviteDescription text , InviteCategory text, InviteDate text, InviteValidDate text, InviteBackground text, InviteAccepted text, Date text)"];//
            const char *sqlStmt=[str UTF8String];
            char *error1;
            if(sqlite3_exec(database, sqlStmt, NULL, NULL, &error1)==SQLITE_OK)
            {
            }
        }
        if(sqlite3_open([[self getDBPath]UTF8String], &database)==SQLITE_OK) {
            
            NSString *str=[NSString stringWithFormat:@"create table av_promotions(PromoId text,PromoName text,PromoDescription text, PromoFromDate text , PromoToDate text, PromoUrl text, PromoImageUrl text , PromoImageData text , Date text)"];
            const char *sqlStmt=[str UTF8String];
            char *error1;
            if(sqlite3_exec(database, sqlStmt, NULL, NULL, &error1)==SQLITE_OK)
            {
            }
        }
        if(sqlite3_open([[self getDBPath]UTF8String], &database)==SQLITE_OK) {
            
            NSString *str=[NSString stringWithFormat:@"create table av_tickets(TicketId text,TicketManualId text,TicketType text, TicketAmount text , EventName text, EventLocation text, EventStartDate text , EventEndDate text , EventCategory text, UpGradeEnable text, ChatEnabled text, RateEnabled text, BackgroundCode text, ReceivedDate text, UserDate text, UsedBy text, PinEntry text, UsedSendDate text, UsedSendLog text , Date text)"];
            const char *sqlStmt=[str UTF8String];
            char *error1;
            if(sqlite3_exec(database, sqlStmt, NULL, NULL, &error1)==SQLITE_OK)
            {
            }
        }
    }
}


#pragma mark //////////////////////
#pragma mark:- ///////////////// Av_Backgrounds //////////////////////

- (void)saveAvBackgroundData:(NSString *)backgroundId BackgroundName:(NSString *)backgroundName BackgroundCategory:(NSString *)backgroundCategory BackgroundType:(NSString *)backgroundType BackgroundUrl:(NSString *)backgroundUrl BackgroundDefault:(NSString *)backgroundDefault BackgroundData:(NSString *)backgroundData Date:(NSString *)date {
    
    const char *dbpath = [[self getDBPath] UTF8String];
    NSLog(@"%s",dbpath);
    if(sqlite3_open(dbpath, &database)==SQLITE_OK){
        NSString *str=[NSString stringWithFormat:@"insert into av_backgrounds values('%@','%@','%@','%@','%@','%@','%@','%@');",backgroundId,backgroundName,backgroundCategory,backgroundType,backgroundUrl,backgroundDefault,backgroundData, date];
        
        
        const char *sqlStmt=[str UTF8String];
        sqlite3_stmt *stmt;
        NSLog(@"%d  %d",SQLITE_DONE,sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL));
        if(sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL)==SQLITE_OK)
        {
            NSLog(@"%d",sqlite3_step(stmt));
            if(sqlite3_step(stmt)==SQLITE_DONE)
            {
                NSLog(@"Save");
            }}
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    else
        NSLog(@"Error");
}

- (NSMutableArray*) findByAvBackgrounds:(NSString*)background BackgroundCategory:(NSString *)backgroundCategory {
    
    NSMutableArray *resultArray =[[NSMutableArray alloc]init];
    if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK)
    {
        sqlite3_stmt *stmt;
        NSString *fetchquery;
        if ([backgroundCategory isEqualToString:@""]) {
            fetchquery =[NSString stringWithFormat:@"SELECT * FROM av_backgrounds WHERE BackgroundId == \"%@\" ;",background];
        }
        else {//BackgroundCategory
            fetchquery =[NSString stringWithFormat:@"SELECT * FROM av_backgrounds WHERE BackgroundCategory == \"%@\" ;",background];
        }
        const char *sqlfetch=[fetchquery UTF8String];
        if (sqlite3_prepare(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW)
            {
                NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
                NSString *str=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                NSString *str1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                NSString *str2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                NSString *str3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                NSString *str4=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                NSString *str5=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                NSString *str6=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                NSString *str7=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                [Dic setValue:str  forKey:@"id"];
                [Dic setValue:str1 forKey:@"name"];
                [Dic setValue:str2 forKey:@"category"];
                [Dic setValue:str3 forKey:@"type"];
                [Dic setValue:str4 forKey:@"url"];
                [Dic setValue:str5 forKey:@"default"];
                [Dic setValue:str6 forKey:@"data"];
                [Dic setValue:str7 forKey:@"date"];
                
                [resultArray addObject:Dic];
            }
        }

        sqlite3_finalize(stmt);
       
        sqlite3_close(database);
    }
    return resultArray;
}

#pragma mark /////////////////////////
#pragma mark:- /////////////// Av_Categories ///////////////////


- (void)saveAvCategoriesData:(NSString *)categoryId CategoryName:(NSString *)categoryName CategoryOrderId:(NSString *)categoryOrderId Date:(NSString *)date{
    
    const char *dbpath = [[self getDBPath] UTF8String];
    NSLog(@"%s",dbpath);
    if(sqlite3_open(dbpath, &database)==SQLITE_OK){
        NSString *str=[NSString stringWithFormat:@"insert into av_categories values('%@','%@','%@','%@');",categoryId,categoryName,categoryOrderId,date];
        
        const char *sqlStmt=[str UTF8String];
        sqlite3_stmt *stmt;
        NSLog(@"%d  %d",SQLITE_DONE,sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL));
        if(sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL)==SQLITE_OK)
        {
            NSLog(@"%d",sqlite3_step(stmt));
            if(sqlite3_step(stmt)==SQLITE_DONE)
            {
                NSLog(@"Save");
            }}
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    else
        NSLog(@"Error");
}

- (NSMutableArray*) findByAvCategories:(NSString*)categroy {
    
    NSMutableArray *resultArray =[[NSMutableArray alloc]init];
    if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK)
    {
        sqlite3_stmt *stmt;
        NSString *fetchquery=[NSString stringWithFormat:@"SELECT * FROM av_categories ;"];
        const char *sqlfetch=[fetchquery UTF8String];
        if (sqlite3_prepare(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW)
            {
                NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
                NSString *str=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                NSString *str1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                NSString *str2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                NSString *str3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                
                [Dic setValue:str  forKey:@"id"];
                [Dic setValue:str1 forKey:@"name"];
                [Dic setValue:str2 forKey:@"orderid"];
                [Dic setValue:str3 forKey:@"date"];
                
                [resultArray addObject:Dic];
            }
        }
        
        sqlite3_finalize(stmt);
        
        sqlite3_close(database);
    }
    return resultArray;
}

#pragma mark /////////////////////////
#pragma mark:- ////////////////// Av_Events ///////////////////

- (void)saveAvEventsData:(NSString *)eventId EventName:(NSString *)eventName EventDescription:(NSString *)eventDescription EventCategory:(NSString *)eventCategory EventLocation:(NSString *)eventLocation EventStartDate:(NSString *)eventStartDate EventEndDate:(NSString *)eventEndDate EventUrl:(NSString *)eventUrl EventImageUrl:(NSString *)eventImageUrl EventImageData:(NSString *)eventImageData Date:(NSString *)date {
    
    const char *dbpath = [[self getDBPath] UTF8String];
    NSLog(@"%s",dbpath);
    if(sqlite3_open(dbpath, &database)==SQLITE_OK){
        NSString *str=[NSString stringWithFormat:@"insert into av_events values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",eventId,eventName,eventDescription,eventCategory,eventLocation,eventStartDate,eventEndDate,eventUrl, eventImageUrl,eventImageData, date];
        
        
        const char *sqlStmt=[str UTF8String];
        sqlite3_stmt *stmt;
        NSLog(@"%d  %d",SQLITE_DONE,sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL));
        if(sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL)==SQLITE_OK)
        {
            NSLog(@"%d",sqlite3_step(stmt));
            if(sqlite3_step(stmt)==SQLITE_DONE)
            {
                NSLog(@"Save");
            }}
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    else
        NSLog(@"Error");
}

- (NSMutableArray*) findByAvEvents:(NSString*)events {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    NSString *str_Date  = [dateFormatter stringFromDate:[NSDate date]] ;
    NSMutableArray *resultArray =[[NSMutableArray alloc]init];
    if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK)
    {
        sqlite3_stmt *stmt;
        NSString *fetchquery=[NSString stringWithFormat:@"SELECT * FROM av_events WHERE EventStartDate >=\"%@\" ORDER BY EventStartDate ASC  ;" , str_Date ];
        const char *sqlfetch=[fetchquery UTF8String];
        if (sqlite3_prepare(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW)
            {
                NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
                NSString *str  =[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                NSString *str1 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                NSString *str2 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                NSString *str3 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                NSString *str4 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                NSString *str5 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                NSString *str6 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                NSString *str7 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                NSString *str8 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,8)];
                NSString *str9 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,9)];
                NSString *str10=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,10)];
               
                [Dic setValue:str   forKey:@"id"];
                [Dic setValue:str1  forKey:@"name"];
                [Dic setValue:str2  forKey:@"description"];
                [Dic setValue:str3  forKey:@"categroy"];
                [Dic setValue:str4  forKey:@"location"];
                [Dic setValue:str5  forKey:@"startdate"];
                [Dic setValue:str6  forKey:@"enddate"];
                [Dic setValue:str7  forKey:@"url"];
                [Dic setValue:str8  forKey:@"imageurl"];
                [Dic setValue:str9  forKey:@"imagedata"];
                [Dic setValue:str10 forKey:@"date"];
              
                [resultArray addObject:Dic];
            }
        }
        
        sqlite3_finalize(stmt);
        
        sqlite3_close(database);
    }
    return resultArray;
}

#pragma mark ////////////////////////
#pragma mark:- ///////////////// Av_Invites ////////////////////

-(void)saveAvInvitesData:(NSString *)inviteId InviteTitle:(NSString *)inviteTitle InviteLocation:(NSString *)inviteLocation InviteDescription:(NSString *)inviteDescription InviteCategory:(NSString *)inviteCategory InviteDate:(NSString *)inviteDate InviteValidDate:(NSString *)inviteValidDate InviteBackground:(NSString *)inviteBackground InviteAccepted:(NSString *)inviteAccepted Date:(NSString *)date {
    
    const char *dbpath = [[self getDBPath] UTF8String];
    NSLog(@"%s",dbpath);
    if(sqlite3_open(dbpath, &database)==SQLITE_OK){
        NSString *str=[NSString stringWithFormat:@"insert into av_invites values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",inviteId,inviteTitle,inviteLocation,inviteDescription,inviteCategory,inviteDate,inviteValidDate, inviteBackground,inviteAccepted, date];
        
        
        const char *sqlStmt=[str UTF8String];
        sqlite3_stmt *stmt;
        NSLog(@"%d  %d",SQLITE_DONE,sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL));
        if(sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL)==SQLITE_OK)
        {
            NSLog(@"%d",sqlite3_step(stmt));
            if(sqlite3_step(stmt)==SQLITE_DONE)
            {
                NSLog(@"Save");
            }}
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    else
        NSLog(@"Error");
}

- (NSMutableArray*) findByAvInvites:(NSString *)invites {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    NSString *str_Date  = [dateFormatter stringFromDate:[NSDate date]] ;//yyyy-MM-dd'T'HH:mm:ss'Z'
    
    NSMutableArray *resultArray =[[NSMutableArray alloc]init];
    if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK)
    {
        sqlite3_stmt *stmt;
        NSString *fetchquery=[NSString stringWithFormat:@"SELECT * FROM av_invites WHERE InviteValidDate >=\"%@\" ORDER BY InviteDate ASC ;", str_Date];
        const char *sqlfetch=[fetchquery UTF8String];
        if (sqlite3_prepare(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW)
            {
                NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
                NSString *str=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                NSString *str1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                NSString *str2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                NSString *str3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                NSString *str4=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                NSString *str5=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                NSString *str6=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                NSString *str7=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                NSString *str8=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,8)];
                NSString *str9=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,9)];
               
                [Dic setValue:str   forKey:@"id"];
                [Dic setValue:str1  forKey:@"title"];
                [Dic setValue:str2  forKey:@"location"];
                [Dic setValue:str3  forKey:@"description"];
                [Dic setValue:str4  forKey:@"category"];
                [Dic setValue:str5  forKey:@"invitedate"];
                [Dic setValue:str6  forKey:@"valid"];
                [Dic setValue:str7  forKey:@"background"];
                [Dic setValue:str8  forKey:@"accepted"];
                [Dic setValue:str9  forKey:@"date"];
                
                
                [resultArray addObject:Dic];
            }
        }
        
        sqlite3_finalize(stmt);
        
        sqlite3_close(database);
    }
    return resultArray;
}

#pragma mark /////////////////////////
#pragma mark:- /////////////// Av_Promotions //////////////////

- (void)saveAvPromotionsData:(NSString *)PromoId PromoName:(NSString *)promoName PromoDescription:(NSString *)promoDescription PromoFromDate:(NSString *)promoFromDate PromoToDate:(NSString *)promoToDate PromoUrl:(NSString *)promoUrl PromoImageUrl:(NSString *)promoImageUrl PromoImageData:(NSString *)PromoImageData Date:(NSString *)date {
    
    const char *dbpath = [[self getDBPath] UTF8String];
    NSLog(@"%s",dbpath);
    if(sqlite3_open(dbpath, &database)==SQLITE_OK){
        NSString *str=[NSString stringWithFormat:@"insert into av_promotions values('%@','%@','%@','%@','%@','%@','%@','%@','%@');",PromoId,promoName,promoDescription,promoFromDate, promoToDate ,promoUrl,promoImageUrl,PromoImageData, date];
        
        
        const char *sqlStmt=[str UTF8String];
        sqlite3_stmt *stmt;
        NSLog(@"%d  %d",SQLITE_DONE,sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL));
        if(sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL)==SQLITE_OK)
        {
            NSLog(@"%d",sqlite3_step(stmt));
            if(sqlite3_step(stmt)==SQLITE_DONE)
            {
                NSLog(@"Save");
            }}
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    else
        NSLog(@"Error");
}

- (NSMutableArray*) findByAvPromotions:(NSString *)promotions {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *str_Date  = [dateFormatter stringFromDate:[NSDate date]] ;
    
    NSMutableArray *resultArray =[[NSMutableArray alloc]init];
    if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK)
    {
        sqlite3_stmt *stmt;
        NSString *fetchquery=[NSString stringWithFormat:@"SELECT * FROM av_promotions WHERE PromoFromDate <= \"%@\" AND PromoToDate >\"%@\"  ORDER BY PromoFromDate ASC ;",str_Date,str_Date ];
        const char *sqlfetch=[fetchquery UTF8String];
        if (sqlite3_prepare(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW)
            {
                NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
                NSString *str=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                NSString *str1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                NSString *str2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                NSString *str3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                NSString *str4=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                NSString *str5=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                NSString *str6=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                NSString *str7=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                NSString *str8=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,8)];

                [Dic setValue:str   forKey:@"id"];
                [Dic setValue:str1  forKey:@"name"];
                [Dic setValue:str2  forKey:@"description"];
                [Dic setValue:str3  forKey:@"fromDate"];
                [Dic setValue:str4  forKey:@"toDate"];
                [Dic setValue:str5  forKey:@"url"];
                [Dic setValue:str6  forKey:@"imageurl"];
                [Dic setValue:str7  forKey:@"data"];
                [Dic setValue:str8  forKey:@"date"];
                
                
                [resultArray addObject:Dic];
            }
        }
        
        sqlite3_finalize(stmt);
        
        sqlite3_close(database);
    }
    return resultArray;
}

#pragma mark /////////////////////////////////////////
#pragma mark:- ///////////// Av_Tickets /////////////

-(void)saveAvTicketsData:(NSString *)ticketId TicketManualId:(NSString *)ticketManualId TicketType:(NSString *)ticketType TicketAmount:(NSString *)ticketAmount EventName:(NSString *)eventName EventLocation:(NSString *)eventLocation EventStartDate:(NSString *)eventStartDate EventEndDate:(NSString *)eventEndDate EventCategory:(NSString *)eventCategory UpGradeEnable:(NSString *)upGradeEnable ChatEnabled:(NSString *)chatEnable RateEnabled:(NSString *)rateEnable BackgroundCode:(NSString *)backgroundCode ReceivedDate:(NSString *)receivedDate UserDate:(NSString *)userDate UsedBy:(NSString *)usedBy PinEntry:(NSString *)pinEntry UsedSendDate:(NSString *)usedSendDate UsedSendLog:(NSString *)usedSendLog Date:(NSString *)date {
    
    const char *dbpath = [[self getDBPath] UTF8String];
    NSLog(@"%s",dbpath);
    if(sqlite3_open(dbpath, &database)==SQLITE_OK){
        NSString *str=[NSString stringWithFormat:@"insert into av_tickets values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@', '%@','%@');",ticketId,ticketManualId,ticketType,ticketAmount, eventName ,eventLocation,eventStartDate,eventEndDate, eventCategory, upGradeEnable,chatEnable,rateEnable,backgroundCode, receivedDate,userDate,usedBy,pinEntry,usedSendDate,usedSendLog,date];
        
        
        const char *sqlStmt=[str UTF8String];
        sqlite3_stmt *stmt;
        NSLog(@"%d  %d",SQLITE_DONE,sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL));
        if(sqlite3_prepare(database, sqlStmt, -1, &stmt, NULL)==SQLITE_OK)
        {
            NSLog(@"%d",sqlite3_step(stmt));
            if(sqlite3_step(stmt)==SQLITE_DONE)
            {
                NSLog(@"Save");
            }}
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    else
        NSLog(@"Error");
}

- (NSMutableArray*) findByAvTickets:(NSString *)tickets {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *str_Date  = [dateFormatter stringFromDate:[NSDate date]] ;
    
    NSMutableArray *resultArray =[[NSMutableArray alloc]init];
    if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK)
    {
        sqlite3_stmt *stmt;
        NSString *fetchquery=[NSString stringWithFormat:@"SELECT * FROM av_tickets WHERE EventEndDate >\"%@\" ;", str_Date];
        const char *sqlfetch=[fetchquery UTF8String];
        if (sqlite3_prepare(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW)
            {
                NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
                NSString *str=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                NSString *str1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                NSString *str2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                NSString *str3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                NSString *str4=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                NSString *str5=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                NSString *str6=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                NSString *str7=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                NSString *str8=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,8)];
                NSString *str9=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,9)];
                NSString *str10=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,10)];
                NSString *str11=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,11)];
                NSString *str12=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,12)];
                NSString *str13=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,13)];
                NSString *str14=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,14)];
                NSString *str15=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,15)];
                NSString *str16=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,16)];
                NSString *str17=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,17)];
                NSString *str18=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,18)];
                NSString *str19=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,19)];

                
                [Dic setValue:str   forKey:@"id"];
                [Dic setValue:str1  forKey:@"manualId"];
                [Dic setValue:str2  forKey:@"type"];
                [Dic setValue:str3  forKey:@"amount"];
                [Dic setValue:str4  forKey:@"name"];
                [Dic setValue:str5  forKey:@"location"];
                [Dic setValue:str6  forKey:@"startDate"];
                [Dic setValue:str7  forKey:@"endDate"];
                [Dic setValue:str8  forKey:@"category"];
                [Dic setValue:str9  forKey:@"upgrade"];
                [Dic setValue:str10 forKey:@"chat"];
                [Dic setValue:str11 forKey:@"rate"];
                [Dic setValue:str12 forKey:@"code"];
                [Dic setValue:str13 forKey:@"received"];
                [Dic setValue:str14 forKey:@"userDate"];
                [Dic setValue:str15 forKey:@"usedBy"];
                [Dic setValue:str16 forKey:@"pin"];
                [Dic setValue:str17 forKey:@"usedDate"];
                [Dic setValue:str18 forKey:@"usedLog"];
                [Dic setValue:str19 forKey:@"date"];
                
                
                [resultArray addObject:Dic];
            }
        }
        
        sqlite3_finalize(stmt);
        
        sqlite3_close(database);
    }
    return resultArray;
}

#pragma mark ///////////////////////////////
#pragma mark:- ****************Delete All DataBase*******************

-(void)deleteinformationbydate:(NSString *)date1 Value:(NSString *)value {
    
#pragma mark:- DELETE FROM av_backgrounds
    NSLog(@"%@",dbPath);
    NSString *query;
    
    query=[NSString stringWithFormat:@"DELETE FROM av_backgrounds ;"];

    NSLog(@"Query is:%s",[query UTF8String]);
    sqlite3_stmt *statement;
    NSLog(@"%d",sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"%d",SQLITE_ROW);
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            NSLog(@"Success");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
#pragma mark:- DELETE FROM av_categories
    NSLog(@"%@",dbPath);
    
    query=[NSString stringWithFormat:@"DELETE FROM av_categories ;"];
    
    NSLog(@"Query is:%s",[query UTF8String]);

    NSLog(@"%d",sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"%d",SQLITE_ROW);
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            NSLog(@"Success");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
#pragma mark:- DELETE FROM av_events
    NSLog(@"%@",dbPath);
    
    query=[NSString stringWithFormat:@"DELETE FROM av_events ;"];
    
    NSLog(@"Query is:%s",[query UTF8String]);
    
    NSLog(@"%d",sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"%d",SQLITE_ROW);
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            NSLog(@"Success");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
#pragma mark:- DELETE FROM av_invites
    NSLog(@"%@",dbPath);

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *str_Date  = [dateFormatter stringFromDate:[NSDate date]] ;
    
    query=[NSString stringWithFormat:@"DELETE FROM av_invites WHERE InviteValidDate <=\"%@\" ;", str_Date];

    NSLog(@"Query is:%s",[query UTF8String]);

    NSLog(@"%d",sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"%d",SQLITE_ROW);
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            NSLog(@"Success");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
#pragma mark:- DELETE FROM av_promotions
    NSLog(@"%@",dbPath);
    
    query=[NSString stringWithFormat:@"DELETE FROM av_promotions ;"];
    
    NSLog(@"Query is:%s",[query UTF8String]);
    
    NSLog(@"%d",sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"%d",SQLITE_ROW);
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            NSLog(@"Success");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
#pragma mark:- DELETE FROM av_tickets
    NSLog(@"%@",dbPath);

    query=[NSString stringWithFormat:@"DELETE FROM av_tickets WHERE EventStartDate <\"%@\" ;", str_Date];

    NSLog(@"Query is:%s",[query UTF8String]);

    NSLog(@"%d",sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"%d",SQLITE_ROW);
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            NSLog(@"Success");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
}

#pragma mark ///////////////////////////
#pragma mark:- ///////////////// UpDate DataBase //////////////////// Not Used

-(void)update:(NSString *)ticketId PinEntry:(NSString *)pinEntry UserDate:(NSString *)userDate UsedBy:(NSString *)usedBy {//UserDate text, UsedBy text, PinEntry text,
    const char *dbpath = [[self getDBPath] UTF8String];
    NSLog(@"%s",dbpath);
    if(sqlite3_open(dbpath, &database)==SQLITE_OK) {
    NSString *query=[NSString stringWithFormat:@"UPDATE av_tickets SET UsedBy = 1 WHERE TicketId =\"%@\" ;", ticketId];
    NSLog(@"Query is:%s",[query UTF8String]);
    sqlite3_stmt *statement;
    NSLog(@"%d",sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            NSLog(@"Success");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    }
}

-(void)updateInvitation:(NSString *)invitationId InvitationAccepted:(NSString *)invitationAccepted {//UserDate text, UsedBy text, PinEntry text,
    const char *dbpath = [[self getDBPath] UTF8String];
    NSLog(@"%s",dbpath);
    if(sqlite3_open(dbpath, &database)==SQLITE_OK) {//av_invites,InviteAccepted,InviteId
        NSString *query=[NSString stringWithFormat:@"UPDATE av_invites SET InviteAccepted = \"%@\" WHERE InviteId =\"%@\" ;", invitationAccepted,invitationId];
        NSLog(@"Query is:%s",[query UTF8String]);
        sqlite3_stmt *statement;
        NSLog(@"%d",sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
            
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSLog(@"Success");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
}
@end

