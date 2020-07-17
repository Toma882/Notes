# HTTP

## Request

RFC2616中这样定义HTTP Request 消息：

```js
Request = Request-Line
          *(( general-header 
            | request-header（跟本次请求相关的一些header）
            | entity-header ) CRLF)（跟本次请求相关的一些header）
          CRLF
          [ message-body ]
```

一个HTTP的request消息以一个请求行开始，从第二行开始是header，接下来是一个空行，表示header结束，最后是消息体。

请求行的定义如下：

```js
//请求行的定义
Request-Line = Method SP Request-URL SP HTTP-Version CRLF

//方法的定义
Method = "OPTIONS" | "GET" | "HEAD"  |"POST" |"PUT" |"DELETE" |"TRACE" |"CONNECT"  | extension-method

//资源地址的定义
Request-URI   ="*" | absoluteURI | abs_path | authotity（CONNECT）
```

Request消息中使用的`header`可以是`general-header`或者`request-header`，`request-header`（后边会讲解）。其中有一个比较特殊的就是Host，Host会与`reuqest Uri`一起来作为Request消息的接收者判断请求资源的条件，方法如下：

* 如果Request-URI是绝对地址（absoluteURI），这时请求里的主机存在于Request-URI里。任何出现在请求里Host头域值应当被忽略。
* 假如Request-URI不是绝对地址（absoluteURI），并且请求包括一个Host头域，则主机由该Host头域值决定。
* 假如由规则１或规则２定义的主机是一个无效的主机，则应当以一个400（错误请求）错误消息返回。


## Response

响应消息跟请求消息几乎一模一样，定义如下：

```js
   Response      = Status-Line              
                   *(( general-header        
                    | response-header       
                    | entity-header ) CRLF)  
                   CRLF
                   [ message-body ]
```

可以看到，除了header不使用`request-header`之外，只有第一行不同，响应消息的第一行是状态行，其中就包含大名鼎鼎的返回码。

Status-Line的内容首先是协议的版本号，然后跟着返回码，最后是解释的内容，它们之间各有一个空格分隔，行的末尾以一个回车换行符作为结束。定义如下：

```js
   Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
```


### 返回码

返回码是一个3位数，第一位定义的返回码的类别，总共有5个类别，它们是：

```js
  - 1xx: Informational - Request received, continuing process

  - 2xx: Success - The action was successfully received,
    understood, and accepted

  - 3xx: Redirection - Further action must be taken in order to
    complete the request

  - 4xx: Client Error - The request contains bad syntax or cannot
    be fulfilled

  - 5xx: Server Error - The server failed to fulfill an apparently
    valid request
```

## Header

### General Header Fields
可用于request，也可用于response的头，但不可作为实体头，只能作为消息的头。

```js
general-header = Cache-Control            ; Section 14.9
              | Connection               ; Section 14.10
              | Date                     ; Section 14.18
              | Pragma                   ; Section 14.32
              | Trailer                  ; Section 14.40
              | Transfer-Encoding        ; Section 14.41
              | Upgrade                  ; Section 14.42
              | Via                      ; Section 14.45
              | Warning                  ; Section 14.46
```


### Request Header Fields
被请求发起端用来改变请求行为的头。

```js
request-header = Accept                   ; Section 14.1
               | Accept-Charset           ; Section 14.2
               | Accept-Encoding          ; Section 14.3
               | Accept-Language          ; Section 14.4
               | Authorization            ; Section 14.8
               | Expect                   ; Section 14.20
               | From                     ; Section 14.22
               | Host                     ; Section 14.23
               | If-Match                 ; Section 14.24
               | If-Modified-Since        ; Section 14.25
               | If-None-Match            ; Section 14.26
               | If-Range                 ; Section 14.27
               | If-Unmodified-Since      ; Section 14.28
               | Max-Forwards             ; Section 14.31
               | Proxy-Authorization      ; Section 14.34
               | Range                    ; Section 14.35
               | Referer                  ; Section 14.36
               | TE                       ; Section 14.39
               | User-Agent               ; Section 14.43
```

### Response Header Fields
被服务器用来对资源进行进一步的说明。

```js
response-header = Accept-Ranges           ; Section 14.5
                | Age                     ; Section 14.6
                | ETag                    ; Section 14.19
                | Location                ; Section 14.30
                | Proxy-Authenticate      ; Section 14.33
                | Retry-After             ; Section 14.37
                | Server                  ; Section 14.38
                | Vary                    ; Section 14.44
                | WWW-Authenticate        ; Section 14.47
```

### Entity Header Fields
如果消息带有消息体，实体头用来作为元信息；如果没有消息体，就是为了描述请求的资源的信息。

```
entity-header  = Allow                    ; Section 14.7
               | Content-Encoding         ; Section 14.11
               | Content-Language         ; Section 14.12
               | Content-Length           ; Section 14.13
               | Content-Location         ; Section 14.14
               | Content-MD5              ; Section 14.15
               | Content-Range            ; Section 14.16
               | Content-Type             ; Section 14.17
               | Expires                  ; Section 14.21
               | Last-Modified            ; Section 14.29
               | extension-header
```

## Message Body
### 是否含有消息体 Message Body


| type  | condition  |
|------------- |---------------|
| request | 在request消息中，消息头中含有`Content-Length | Transfer-Encoding`，标识会有一个消息体跟在后边。如果请求的方法不应该含有消息体（如OPTION），那么request消息一定不能含有消息体，即使客户端发送过去，服务器也不会读取消息体。 |
| response | 在response消息中，是否存在消息体由请求方法和返回码来共同决定。像1xx，204，304不会带有消息体。 |


### 消息体（Message Body）和实体主体（Entity Body）

* 如果有`Transfer-Encoding`头，消息体解码完了就是实体主体
* 如果没有`Transfer-Encoding`头，消息体就是实体主体。

`message-body = entity-body
                | <entity-body encoded as per Transfer-Encoding>`
                

### 消息体的长度

* 所有不应该返回内容的Response消息(像1xx，204，304不会带有消息体)都不应该带有任何的消息体，消息会在第一个空行就被认为是终止了。
* 如果消息头含有`Transfer-Encoding`，且它的值不是`identity`，那么消息体的长度会使用`chunked`方式解码来确定，直到连接终止。
* 如果消息头中有`Content-Length`，`entity-length`和`transfer-length`相等；如果同时含有`Transfer-Encoding`，则`entity-length`和`transfer-length`可能不会相等，会忽略`Content-Length`。
* 如果消息的媒体类型是`multipart/byteranges`，并且`transfer-length`也没有指定，那么传输长度由这个媒体自己定义。通常是收发双发定义好了格式， HTTP1.1客户端请求里如果出现`Range`头域并且带有多个字节范围（byte-range）指示符，这就意味着客户端能解析`multipart/byteranges`响应。
* 如果是Response消息，也可以由服务器来断开连接，作为消息体结束。

从消息体中得到实体主体，它的类型由两个`header`来定义，`Content-Type`和`Content-Encoding`（通常用来做压缩）。如果有实体主体，则必须有`Content-Type`,如果没有，接收方就需要猜测，猜不出来就是用`application/octet-stream`。

## 参考
[刨根问底HTTP和WebSocket协议](http://www.jianshu.com/p/0e5b946880b4)