# JivoChat Mobile SDK for Developers
With the Jivo mobile SDK you can integrate the chat widget for customer support into your native app for iOS or Android. Integration will only take a few minutes because the chat interface is already implemented – you only need to add a couple of lines in your code to get the chat working.

### Demo apps for iOS and Android
Check out our demo-apps for a live preview of how the chat will look like and function inside your own app. These two very simple demo-apps we've created allow you to chat directly with our support team... so now you can imagine how users of your own app will be able to easily connect with your own support team.

- [Demo-app for iOS][iossdkapp]
- [Demo-app for Android][androidsdkapp]

 [iossdkapp]: <https://itunes.apple.com/en/app/jivosite-sdk-dla-razrabotcikov/id1085180661?mt=8>
[androidsdkapp]: <https://play.google.com/store/apps/details?id=com.jivosite.supportapp&hl=en>

The source code for these applications can be found in the demo folder.

### Supported OS
- iOS 8.0+, XCode 7.2
- Android 4.4+, Android Studio 2.0

### Instructions for getting started
View our video and everything will become clear:
- [Video manual for iOS][iosmanual]
- [Video manual for Android][androidmanual]

[iosmanual]: <https://www.youtube.com/watch?v=2M5BqDubp7g>
[androidmanual]: <https://www.youtube.com/watch?v=X5AEWG83G0g>

### Get the widget_id and site_id
The widget_id and site_id can be found by going to the admin panel and then into the settings section of your Mobile app SDK. If you didn't create one yet, go "Add communication channels -> Mobile app SDK" and after asigning a new name, the widget_id and site_id will be displayed.

### SDK Configuration
The following configuration settings can be located in the index.html file:

        jivo_config = {
            //widget_id - REPLACE with YOUR own!
            "widget_id": "xxxx",

            //site_id - REPLACE with YOUR own!
            "site_id": xxxxx,

            //the color of the submit button
            "plane_color":"red",

            //color of agent messages
            "agentMessage_bg_color":'green',

            //text color of the message agent
            "agentMessage_txt_color":'blue',

            //color of the client message
            "clientMessage_bg_color":'yellow',

            //text color of the client message
            "clientMessage_txt_color":'black',

            //active the invitation, if not use, leave blank
            "active_message": "Hello! Can I help you?",

            //link that will glow in the operator program
            "app_link":'Widget_Mobile',

            //The text in the input field
            "placeholder": "Enter message',

            //use secure connection
            "secure": true,

            //use for replace onEvent function
            //"event_func": function(event) {console.log(event)}
        }

#### iOS
To use the SDK in the iOS app you need to move the folder and the html source code of JivoSdk into your project. In the controller for the integration we place the UIWebView component and use the JivoDelegate protocol. Declare a JivoSDK variable and initialize it. During the initialization pass a reference to a webview and languageKey string, which will load either the Russian or English localization file index_<lang>.html. Second parameter is optional in this case, the index.html file will be loaded. In the onEvent method will receive the events from the component. The list of such events can be found  below.

#### Android
To use the SDK in the Android app the resources html and source codes of JivoSdk should be put to the assets folder. In Activity to incorporate implement JivoDelegate and place the UIWebView component. Declare a JivoSDK variable and initialize it. During the initialization pass a reference to a webview and the languageKey string, which will load either the Russian or English localization file index_<lang>.html. The onEvent method will receive the events from the component. The list of such events can be found  below.

### Events
The widget sends the following events in the **onEvent** method with JSONSTRING parameters

- **'chat.force_offline'** : the chat server has terminated the connection, there is no one to answer
- **'chat.ready'** : chat ready
- **'chat.accept'** : the operator has accepted the chat
- **'chat.transferred'** : the operator has transferred the chat
- **'chat.mode'** : chat operators state ( с параметром chat_mode : JSONSTRING)
- **'connection.connecting'** : connecting to server
- **'connection.disconnect'** : connection closed
- **'connection.connect'** : connection established
- **'connection.error'** : connection error (with parameter error : JSONSTRING)
- **'agent.message'** : agent message (with parameter message : JSONSTRING)
- **'agent.chat_close'** : chat closed by operator
- **'agent.info'** : operator info has been recieved (with parameter agentInfo : JSONSTRING)
- **'contact_info'** client info has been recieved (with parameter contact_info : JSONSTRING)
- **'url.click'** : url click (with parameter href : JSONSTRING)
- **'agent.name'** : operator name has been recieved (with parameter agent_name : JSONSTRING)

### Api functions
Use jivoSdk callApiMethod(methodName: String, data: String) method

#### SDK API setContactInfo
**method setContactInfo (clientInfo : JSONSTRING)**
Sets the contact info of the visitor. The data is displayed to the agent is a same as if a visitor introduced in the chat window. It's a special function to set contact info because name, phone number and e-mail are very important in JivoChat - visitor can introduce himself at the beginning of chat.
**clientInfo: JSONSTRING of Object**

| Key      | Type           | Description  |
| ------------- |:-------------:| ---------:|
| client_name   | string        | Client's name |
| email         | string      | Client's email |
| phone         | string      | Client's phone number |
| description   | string      | Additional information about the client |

#### SDK API setCustomData
**method setCustomData (customData : JSONSTRING)**
Using this method you can send any additional info about the client to the agent's App. This info will be shown on the information panel, located on the right side of the agent's App. The method can be called as many times as you need. If chat is established, information in the agent's App will be updated in real time. Fields will be displayed in the same sequence as they are in the array 'fields'.
**customData: JSONSTRING of Array**

| Param      | Type           | Description  |
| ------------- |:-------------:| ---------:|
| customData   | Array        | List of additional data fields of the chat |

fields of object

| Key      | Type           | Description  |
| ------------- |:-------------:| ---------:|
|content	|string	|Content of data field. Tags will be insulated|
|title	|string	|Title shown above a data field|
|link	|string	|URL that opens when you click on a data field|
|key	|string	|Description of the data field, bold text before a colon|

#### SDK API setUserToken
**method setUserToken (userToken : JSONSTRING)**
Use this method to open chat window with custom text at the moment you need. This may be useful if you want to show proactive invitation after the client added goods to cart of your online store
**userToken : JSONSTRING of string**

| Param      | Type           | Description  |
| ------------- |:-------------:| ---------:|
|userToken	|string	|Visitor id|

#### SDK API sendMessage
**method sendMessage (message : JSONSTRING)**
**message : JSONSTRING of string**

| Param      | Type           | Description  |
| ------------- |:-------------:| ---------:|
|message	|string	|Message text|

#### SDK API getContactInfo
**method getContactInfo()**
get contact information. SDK sends 'contact.info' event

#### SDK API getAgentInfo()
**method getAgentInfo ()**
get operator information, SDK sends 'contact.info' event

#### SDK API getAgentName()
**method getAgentName()**
get operator name, SDK sends 'agent.name' event

#### SDK API getAgentName()
**method chatMode()**
get chat mode, SDK sends 'chat.mode' event

### Примеры вызова функций API
#### iOS
```objective-c
//************************************************
-(void)onEvent:(NSString *)name :(NSString*)data;{
    NSLog(@"event:%@, data:%@", name, data);
    if([[name lowercaseString] isEqualToString:@"url.click"]){
        if([data length] > 2){
            NSString *urlStr = [data substringWithRange:NSMakeRange(1,[data length] - 2)];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
    }else if([[name lowercaseString] isEqualToString:@"chat.ready"]){
        NSString *contactInfo = @"{\"client_name\": \"User\", \"email\": \"123@123.com\", \"phone\": \"1234\",\"description\": \"description\"}";

        [jivoSdk callApiMethod:@"setContactInfo" :contactInfo];

        [jivoSdk callApiMethod:@"setUserToken" :@"\"UserToken\""];
    }
}
```
#### Android
```java
//*********************************************
    @Override
    public void onEvent(String name, String data) {
        if (name.equals("chat.ready")) {
            jivoSdk.callApiMethod("setContactInfo","{\"client_name\": \"User\", \"email\": \"123@123.com\", \"phone\": \"1234\",\"description\": \"description\"}");
            jivoSdk.callApiMethod("setUserToken","\"UserToken\"");
        }
    }
```


