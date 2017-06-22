# JivoChat Mobile SDK

With Jivo mobile SDK you can integrate the chat  widget for customer support into your native app for iOS or Android. Integration will only take a few minutes because the chat interface is already implemented – you only need to add a couple of lines in your code to get the chat working.

[Continue reading in English][sdkengver]

[sdkengver]: <https://github.com/JivoSite/MobileSdk/blob/master/README.EN.md>

----

# JivoSite Mobile SDK для разработчиков
JivoSite Mobile SDK позволяет встроить чат для поддержки клиентов в нативные мобильные приложения iOS и Android и принимать обращения клиентов. Интеграция занимает несколько минут, так как интерфейс чата с лентой сообщений уже реализован – вам понадобится только добавить пару строчек в ваш код.


### Демо-приложения для iOS и Android
Посмотрите, как работает чат внутри приложения на примере наших демо-приложений. Эти две очень простые аппки позволяют написать в чат  техподдержке JivoSite.

 - [Демо-прога для iOS][iossdkapp]
 - [Демо-прога для Android][androidsdkapp]

 [iossdkapp]: <https://itunes.apple.com/ru/app/jivosite-sdk-dla-razrabotcikov/id1085180661?mt=8>
 [androidsdkapp]: <https://play.google.com/store/apps/details?id=com.jivosite.supportapp&hl=ru>

Исходники этих приложений можно найти в папке demo.


### Поддерживаемые ОС
- iOS 8.0+, XCode 7.2
- Android 4.4+, Android Studio 2.0

### Инструкция по началу работы
Посмотрите наши видео и все сразу станет понятно:
 - [Видео-мануал для iOS][iosmanual]
 - [Видео-мануал для Android][androidmanual]

 [iosmanual]: <https://www.youtube.com/watch?v=2M5BqDubp7g>
 [androidmanual]: <https://www.youtube.com/watch?v=X5AEWG83G0g>


### Получение widget_id и site_id
Для получения widget_id и site_id в панели управления добавьте канал связи “Мобильное приложение” – вы увидите widget_id и site_id на странице настроек.


### Конфигурация SDK
Настройка производится в файле index.html:

        jivo_config = {
            //widget_id - ЗАМЕНИТЕ НА СВОЙ!
            "widget_id": "xxxx",

            //site_id - ЗАМЕНИТЕ НА СВОЙ!
            "site_id": xxxxx,

            //цвет кнопки отправить
            "plane_color":"red",

            //цвет агентского сообщения
            "agentMessage_bg_color":'green',

            //цвет текста агентского сообщения
            "agentMessage_txt_color":'blue',

            //цвет клиентского сообщения
            "clientMessage_bg_color":'yellow',

            //цвет текста клиентского сообщения
            "clientMessage_txt_color":'black',

            //активное приглашение, если не используем, то оставить пустым
            "active_message": "Здравствуйте! Я могу вам чем-то помочь?",

            //ссылка, которая будет светиться в программе у оператора
            "app_link":'Widget_Mobile',

            //Текст в поле ввода
            "placeholder": 'Введите сообщение',

            //использовать защищенное соединение
            "secure": true,

            //используется для перегрузки функции onEvent
            //"event_func": function(event) {console.log(event)}
        }

#### iOS
Для подключения в проект iOS нужно перенести в свой проект папку html и исходные коды JivoSdk. В контроллере для встаивания используем протокол JivoDelegate и размещаем компонент UIWebView. Инициализируем переменную JivoSdk, при инициализации передаем ссылку на webview и строку с локализацией lang. Будет загружаться файл index_<lang>.html. Параметр lang необязательный, в этом случае будет загружен index.html. В метод onEvent будут приходить события из компонента. Перечень событий описан в разделе “События”.

#### Android
Для подключения в проект Android нужно перенести в папку assets ресурсы html и исходные коды JivoSdk. В Activity для встаивания имплементируем JivoDelegate и размещаем компонент UIWebView. Инициализируем переменную JivoSdk, при инициализации передаем ссылку на webview и строку с локализацией lang. Будет загружаться файл index_<lang>.html. Параметр lang необязательный, в этом случае будет загружен index.html. В метод onEvent будут приходить события из компонента.
Перечень событий описан в разделе “События”.

### События
Виджет отправляет следующие события в метод **onEvent**. Параметры событий приходят строками в формате JSON

- **'chat.force_offline'** : чат сервер разорвал соединение, некому ответить
- **'chat.ready'** : чат инициализирован
- **'chat.accept'** : оператор принял чат
- **'chat.transferred'** : оператор передал чат
- **'chat.mode'** : состояние чата ( с параметром chat_mode : JSONSTRING)
- **'connection.connecting'** : соединение с сервером
- **'connection.disconnect'** : соединение разорвано
- **'connection.connect'** : соединение установлено
- **'connection.error'** : ошибка подключения (с параметром error : JSONSTRING)
- **'agent.message'** : сообщение от оператора (с параметром message : JSONSTRING)
- **'agent.chat_close'** : оператор закрыл чат ()
- **'agent.info'** : получена информация об операторе (с параметром agentInfo : JSONSTRING)
- **'contact_info'** получена информация о клиенте (с параметром contact_info : JSONSTRING)
- **'url.click'** : клик по ссылке (с параметром href : JSONSTRING)
- **'agent.name'** : получено имя оператора (с параметром agent_name : JSONSTRING)

### Функции Api
Для вызова функций Api используется метод jivoSdk callApiMethod(methodName: String, data: String)

#### SDK API setContactInfo
**method setContactInfo (clientInfo : JSONSTRING)**
Устанавливает контактные данные посетителя. Данные отображаются оператору, как будто их ввел посетитель в форме представления. Для записи контактных данные представляется отдельная функция, т.к. имя, телефон и e-mail клиента играют особенную роль в JivoSite - эти данные может указать клиент сам при начале диалога.

**clientInfo: JSONSTRING of Object**
| Ключ      | Тип           | Описание  |
| ------------- |:-------------:| ---------:|
| client_name   | string        | Имя посетителя сайта |
| email         | string      | Email посетителя сайта |
| phone         | string      | Номер телефона посетителя сайта |
| description   | string      | Дополнительная информтация по клиенту |

#### SDK API setCustomData
**method setCustomData (customData : JSONSTRING)**
С помощью этой функции можно передать произвольную дополнительную информацию о клиенте оператору. Информация отображается в информационной панели справа в приложении оператора. Метод может быть вызван любое число раз - если диалог с оператором уже установлен, то данные в приложении оператора будут обновлены в реальном времени. Поля выводятся в порядке их следования в массиве fields.

**customData: JSONSTRING of Array**
| Параметр      | Тип           | Описание  |
| ------------- |:-------------:| ---------:|
| customData   | Array        | Массив полей диалога |

Объекты в массиве содержат поля
| Ключ      | Тип           | Описание  |
| ------------- |:-------------:| ---------:|
|content	|string	|Содержимое поля данных. Теги экранируются.|
|title	|string	|Заголовок, добавляемый сверху поля данных|
|link	|string	|URL, открываемый при клике на поле данных|
|key	|string	|Описание поля данных, добавляемое жирным шрифтом перед содержимым поля через двоеточие|

#### SDK API setUserToken
**method setUserToken (userToken : JSONSTRING)**
Устанавливает идентификатор посетителя. JivoSite никак не обрабатывает этот идентификатор, но передаёт его в каждом событии Webhooks. Таким образом можно идентифицировать посетителя сайта при обработке Webhooks. Рекомендуем использовать сложно-угадываемый идентификатор для исключения возможности спуфинга.

**userToken : JSONSTRING of string**
| параметр      | Тип           | Описание  |
| ------------- |:-------------:| ---------:|
|userToken	|string	|Идентификатор посетителя|

#### SDK API sendMessage
**method sendMessage (message : JSONSTRING)**
отправить сообщение
**message : JSONSTRING of string**
| параметр      | Тип           | Описание  |
| ------------- |:-------------:| ---------:|
|message	|string	|Текст сообщения|

#### SDK API getContactInfo
**method getContactInfo()**
получает данные о контакте, будут отправлены с событием 'contact.info'

#### SDK API getAgentInfo()
**method getAgentInfo ()**
получает данные оператора, будут отправлены с событием 'contact.info'

#### SDK API getAgentName()
**method getAgentName()**
получает имя оператора, данные будут отправлены с событием 'agent.name'

#### SDK API getAgentName()
**method chatMode()**
получает состояние чата, данные будут отправлены с событием 'chat.mode'

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
