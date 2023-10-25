//
//  ViewController.m
//  socketTesting
//
//  Created by Sangeet Bhati on 10/10/23.
//

#import "ViewController.h"
#import <SocketIO/SocketIO-Swift.h>

@interface ViewController ()

@property(nonatomic,strong) SocketManager*socketManger;
@property(nonatomic,strong) SocketIOClient*socketClient;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *socketPath = @"http://148.113.16.25:7000";

    NSURL* url = [[NSURL alloc] initWithString:socketPath];

    if (! self.socketManger) {
         NSLog(@"Creating new socket");
        self.socketManger = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress":@YES}];

    } else {
        NSLog(@"Using existing socket");
    }
    self.socketClient = self.socketManger.defaultSocket;
     [ self.socketClient connect];
    // Socket events
    [self.socketClient on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];

    [self.socketClient on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        self.socketManger = nil;
        NSLog(@"socket killed");
    }];

    [self.socketClient on:@"error" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"ERROR with socket %@", data);
    }];

    [self.socketClient on:@"some message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"Some message arrived with data: %@", data);
    }];
    //[self onCcreate];
}

- (IBAction)sendRequest:(id)sender {
    NSDictionary *parameters = @{@"token":[NSNumber numberWithInteger:123456],
                                 @"client_id": [NSNumber numberWithInteger:12964],
                                 @"vehicle_id" : [NSNumber numberWithInteger:867440061216669]
    };
    [self.socketClient emit:@"vehicle_info" with:[parameters allValues]];
}

- (IBAction)desconnected:(id)sender {
    [self.socketClient disconnect];
}

/*    NSDictionary *parameters = @{@"token":[NSNumber numberWithInteger:123456],
 @"client_id": [NSNumber numberWithInteger:12964],
 @"vehicle_id" : [NSNumber numberWithInteger:867440061216669]
 };
 [self.socket emit:@"vehicle_info" with:[parameters allValues]];*/

-(void)onCcreate {
    self.socketManger = [[SocketManager alloc] initWithSocketURL:[NSURL URLWithString:@"http://148.113.16.25:7000"] config:@{@"log": @YES, @"compress":@YES}];
    
   self.socketClient = self.socketManger.defaultSocket;
    [ self.socketClient connect];
    
    [self.socketClient connectWithTimeoutAfter:10 withHandler:^{
        if (self.socketClient.status == SocketIOStatusConnected) {
            NSLog(@"Socket.IO is connected");
        } else {
            NSLog(@"Socket.IO is not connected");
        }
    }];
    
    [self.socketClient on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"Socket.IO connected");

        // Now it's safe to emit events or send messages
        [self.socketClient emit:@"your_event_name" with:@[@"your_data"]];
    }];
    
}

-(void)recevicedMsg{
    [self.socketClient on:@"message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        // Handle the received data here
        NSLog(@"Received a message: %@", data);
    }];
}

-(void)Socketdisconnected{
    [self.socketClient on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"Socket disconnected");
    }];
}

-(void)SocketError{
    [self.socketClient on:@"error" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"Socket error: %@", data);
    }];
}

-(void)SendDatatotheServer{
    [self.socketClient emit:@"chat" with:@[@"Hello, server!"]];
}
-(void)DisconnectfromtheServer{
    [self.socketClient disconnect];
}




@end
