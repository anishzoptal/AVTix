//
//  DBManager.h
//  dataBase
//
//  Created by Manpreet Kaur on 17/10/14.
//  Copyright (c) 2014 Manpreet Kaur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
    NSString *dbPath;
}
+(DBManager*)getSharedInstance;

- (void)saveAvBackgroundData:(NSString *)backgroundId BackgroundName:(NSString *)backgroundName BackgroundCategory:(NSString *)backgroundCategory BackgroundType:(NSString *)backgroundType BackgroundUrl:(NSString *)backgroundUrl BackgroundDefault:(NSString *)backgroundDefault BackgroundData:(NSString *)backgroundData Date:(NSString *)date;
- (void)saveAvCategoriesData:(NSString *)categoryId CategoryName:(NSString *)categoryName CategoryOrderId:(NSString *)categoryOrderId Date:(NSString *)date;
- (void)saveAvEventsData:(NSString *)eventId EventName:(NSString *)eventName EventDescription:(NSString *)eventDescription EventCategory:(NSString *)eventCategory EventLocation:(NSString *)eventLocation EventStartDate:(NSString *)eventStartDate EventEndDate:(NSString *)eventEndDate EventUrl:(NSString *)eventUrl EventImageUrl:(NSString *)eventImageUrl EventImageData:(NSString *)eventImageData Date:(NSString *)date;
- (void)saveAvInvitesData:(NSString *)inviteId InviteTitle:(NSString *)inviteTitle InviteLocation:(NSString *)inviteLocation InviteDescription:(NSString *)inviteDescription InviteCategory:(NSString *)inviteCategory InviteDate:(NSString *)inviteDate InviteValidDate:(NSString *)inviteValidDate InviteBackground:(NSString *)inviteBackground InviteAccepted:(NSString *)inviteAccepted Date:(NSString *)date;
- (void)saveAvPromotionsData:(NSString *)PromoId PromoName:(NSString *)promoName PromoDescription:(NSString *)promoDescription PromoFromDate:(NSString *)promoFromDate PromoToDate:(NSString *)promoToDate PromoUrl:(NSString *)promoUrl PromoImageUrl:(NSString *)promoImageUrl PromoImageData:(NSString *)PromoImageData Date:(NSString *)date;
- (void)saveAvTicketsData:(NSString *)ticketId TicketManualId:(NSString *)ticketManualId TicketType:(NSString *)ticketType TicketAmount:(NSString *)ticketAmount EventName:(NSString *)eventName EventLocation:(NSString *)eventLocation EventStartDate:(NSString *)eventStartDate EventEndDate:(NSString *)eventEndDate EventCategory:(NSString *)eventCategory  UpGradeEnable:(NSString *)upGradeEnable ChatEnabled:(NSString *)chatEnable RateEnabled:(NSString *)rateEnable BackgroundCode:(NSString *)backgroundCode ReceivedDate:(NSString *)receivedDate UserDate:(NSString *)userDate UsedBy:(NSString *)usedBy PinEntry:(NSString *)pinEntry UsedSendDate:(NSString *)usedSendDate UsedSendLog:(NSString *)usedSendLog Date:(NSString *)date ;

- (NSMutableArray*) findByAvBackgrounds:(NSString*)background BackgroundCategory:(NSString *)backgroundCategory;
-(NSMutableArray*) findByAvCategories:(NSString*)categroy;
-(NSMutableArray*) findByAvEvents:(NSString*)events;
-(NSMutableArray*) findByAvInvites:(NSString*)invites;
-(NSMutableArray*) findByAvPromotions:(NSString*)promotions;
-(NSMutableArray*) findByAvTickets:(NSString*)tickets;

-(void)deleteinformationbydate:(NSString *)date1 Value:(NSString *)value;
-(void)update:(NSString *)ticketId PinEntry:(NSString *)pinEntry UserDate:(NSString *)userDate UsedBy:(NSString *)usedBy;
-(void)updateInvitation:(NSString *)invitationId InvitationAccepted:(NSString *)invitationAccepted;

@end
