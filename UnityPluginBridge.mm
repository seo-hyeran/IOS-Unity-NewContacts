//
//  UnityPluginBridge.m
//  MyUnityPlugin
//
//  Created by tsp on 2021/11/29.
//

#import <Foundation/Foundation.h>
//#include "UnityFramework/UnityFramework-Swift.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <UIKit/UIKit.h>
#import "UnityAppController.h"

extern UIViewController *UnityGetGLViewController();





@interface MyPlugin: UIViewController<CNContactViewControllerDelegate>
{
    NSDate * creationDate;
}
@end

@implementation MyPlugin

static MyPlugin *_sharedInstance;

+(MyPlugin*) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"Creating MyPlugin shared instance");
        _sharedInstance = [[MyPlugin alloc] init];
    });
    return _sharedInstance;
}

-(void)directlyAddContact:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email phone:(NSString *)phone {

    // Create New Contact
    CNMutableContact *contact = [[CNMutableContact alloc] init];

    // Add Name to Contact
    contact.givenName = firstName;
    contact.familyName = lastName;

    // Add Phone Number to Contact
    CNLabeledValue *workPhone = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:[CNPhoneNumber phoneNumberWithStringValue:phone]];
    contact.phoneNumbers = @[workPhone];

    // Add Email to Contact

    // Save the newly created contact
    CNContactStore *store = [[CNContactStore alloc] init];
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:contact toContainerWithIdentifier:nil];
    NSError *error;

    NSLog(@"Added %@ %@ at %@", contact.givenName, contact.familyName, contact.phoneNumbers[0].value.stringValue);
    [store executeSaveRequest:saveRequest error:&error];
}

-(void)addContact:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email phone:(NSString *)phone {

    // Create Store
    CNContactStore *store = [[CNContactStore alloc] init];

    // Create New Contact
    CNMutableContact *contact = [[CNMutableContact alloc] init];

 
    // Add Name to Contact
    contact.givenName = firstName;
    contact.familyName = lastName;

    // Add Phone Number to Contact
    CNLabeledValue *workPhone = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:[CNPhoneNumber phoneNumberWithStringValue:phone]];
    contact.phoneNumbers = @[workPhone];

    // Add Email to Contact

    // Create Controller and Delegate
    CNContactViewController *controller = [CNContactViewController viewControllerForUnknownContact:contact];
    controller.contactStore = store;
    controller.delegate = self;
    
    UINavigationController *navController =[[UINavigationController alloc]initWithRootViewController:controller];
   
    [UnityGetGLViewController() presentViewController:navController animated:false completion:nil];
  //  [[[UIApplication sharedApplication]keyWindow].rootViewController presentViewController:controller animated:true completion:nil];
}


-(id)init
{
    self = [super init];
    return self;
}


@end

extern "C"
{
    void IOSaddContact(const char* firstName, const char* lastName, const char* email, const char* phone)
    {
        NSString *firstNameString = [[NSString alloc] initWithUTF8String:firstName];
        NSString *lastNameString = [[NSString alloc] initWithUTF8String:lastName];
        NSString *phoneString = [[NSString alloc] initWithUTF8String:phone];
        NSString *emailString = [[NSString alloc] initWithUTF8String:email];

        return [[MyPlugin sharedInstance] addContact:firstNameString lastName:lastNameString email:emailString phone:phoneString];
    }

    void IOSdirectlyAddContact(const char* firstName, const char* lastName, const char* email, const char* phone)
    {
        NSString *firstNameString = [[NSString alloc] initWithUTF8String:firstName];
        NSString *lastNameString = [[NSString alloc] initWithUTF8String:lastName];
        NSString *phoneString = [[NSString alloc] initWithUTF8String:phone];
        NSString *emailString = [[NSString alloc] initWithUTF8String:email];

        return [[MyPlugin sharedInstance] directlyAddContact:firstNameString lastName:lastNameString email:emailString phone:phoneString];
    }


}

/*extern "C" {
    
#pragma mark - Functions
    
    

   void _open()
{
      // [[UnityPlugin shared]AddContact];
   }

}
*/
