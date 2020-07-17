## WebSocket

WebSocket API 是 HTML5 标准的一部分，它实现了浏览器与服务器全双工通信(full-duplex)，可以传输基于消息的文本和二进制数据。WebSocket 是浏览器中最靠近套接字的API，除最初建立连接时需要借助于现有的HTTP协议，其他时候直接基于TCP完成通信。

在传统的 Web 中，要实现实时通信，通用的方式是采用 HTTP 协议不断发送请求，如 Ajax & long poll。但这并不代表 WebSocket 一定要用在 HTML 中，或者只能在基于浏览器的应用程序中使用。

实际上，许多语言、框架和服务器都提供了 WebSocket 支持，例如：

* 基于 C 的 [libwebsocket.org](https://libwebsockets.org/trac/libwebsockets)
* 基于 Node.js 的 [Socket.io](http://socket.io/)
* 基于 Python 的 [ws4py](https://github.com/Lawouach/WebSocket-for-Python)
* 基于 C++ 的 [WebSocket++](http://www.zaphoyd.com/websocketpp)
* Apache 对 WebSocket 的支持： [Apache Module mod_proxy_wstunnel](http://httpd.apache.org/docs/2.4/mod/mod_proxy_wstunnel.html)
* Nginx 对 WebSockets 的支持： [NGINX as a WebSockets Proxy](http://nginx.com/blog/websocket-nginx/) 、 [NGINX Announces Support for WebSocket Protocol](http://nginx.com/news/nginx-websockets/) 、[WebSocket proxying](http://nginx.org/en/docs/http/websocket.html)
* lighttpd 对 WebSocket 的支持：[mod_websocket](https://github.com/nori0428/mod_websocket)

## 创建 WebSocket

### WebSocket 连接

```js
var ws = new WebSocket('wss://example.com/socket'); // 创建安全WebSocket 连接（wss）

 ws.onerror = function (error) { ... } // 错误处理
 ws.onclose = function () { ... } // 关闭时调用

 ws.onopen = function () { // 连接建立时调用
   ws.send("Connection established. Hello server!"); // 向服务端发送消息
 }

 ws.onmessage = function(msg) { // 接收服务端发送的消息
   if(msg.data instanceof Blob) { // 处理二进制信息
     processBlob(msg.data);
   } else {
     processText(msg.data); // 处理文本信息
   }
 }
```

### 接收和发送数据

浏览器会为我们完成缓冲、解析、重建接收到的数据等工作。  
应用只需监听`onmessage`事件，用回调处理返回数据即可。

WebSocket支持文本和二进制数据传输，浏览器如果接收到文本数据，会将其转换为 `DOMString` 对象，如果是二进制数据或 `Blob` 对象，可直接将其转交给应用或将其转化为 `ArrayBuffer`，由应用对其进行进一步处理。
从内部看，协议只关注消息的两个信息：净荷长度和类型（前者是一个可变长度字段），据以区别 UTF-8 数据和二进制数据。

```js
var wss = new WebSocket('wss://example.com/socket');
 ws.binaryType = "arraybuffer"; 

 // 接收数据
 wss.onmessage = function(msg) {
   if(msg.data instanceof ArrayBuffer) {
     processArrayBuffer(msg.data);
   } else {
     processText(msg.data);
   }
 }

 // 发送数据
 ws.onopen = function () {
   socket.send("Hello server!"); 
   socket.send(JSON.stringify({'msg': 'payload'}));

   var buffer = new ArrayBuffer(128);
   socket.send(buffer);

   var intview = new Uint32Array(buffer);
   socket.send(intview);

   var blob = new Blob([buffer]);
   socket.send(blob); 
 }
```

> Blob 对象是包含有只读原始数据的类文件对象，可存储二进制数据，它会被写入磁盘；ArrayBuffer （缓冲数组）是一种用于呈现通用、固定长度的二进制数据的类型，作为内存区域可以存放多种类型的数据。
> 
> 对于将要传输的二进制数据，开发者可以决定以何种方式处理，可以更好的处理数据流，Blob 对象一般用来表示一个不可变文件对象或原始数据，如果你不需要修改它或者不需要把它切分成更小的块，那这种格式是理想的；如果你还需要再处理接收到的二进制数据，那么选择ArrayBuffer 应该更合适。

### bufferedAmount

WebSocket 提供的信道是全双工的，在同一个TCP 连接上，可以双向传输文本信息和二进制数据，通过数据帧中的一位（bit）来区分二进制或者文本。WebSocket 只提供了最基础的文本和二进制数据传输功能，如果需要传输其他类型的数据，就需要通过额外的机制进行协商。WebSocket 中的send( ) 方法是异步的：提供的数据会在客户端排队，而函数则立即返回。在传输大文件时，不要因为回调已经执行，就错误地以为数据已经发送出去了，数据很可能还在排队。要监控在浏览器中排队的数据量，可以查询套接字的bufferedAmount 属性：

```js
 var ws = new WebSocket('wss://example.com/socket');

 ws.onopen = function () {
   subscribeToApplicationUpdates(function(evt) { 
     if (ws.bufferedAmount == 0) 
     ws.send(evt.data); 
   });
 };
```

前面的例子是向服务器发送应用数据，所有WebSocket 消息都会按照它们在客户端排队的次序逐个发送。因此，大量排队的消息，甚至一个大消息，都可能导致排在它后面的消息延迟——队首阻塞！为解决这个问题，应用可以将大消息切分成小块，通过监控bufferedAmount 的值来避免队首阻塞。甚至还可以实现自己的优先队列，而不是盲目都把它们送到套接字上排队。要实现最优化传输，应用必须关心任意时刻在套接字上排队的是什么消息！

### 子协议
WebSocket构造器方法如下所示：

```js
 WebSocket WebSocket(
 in DOMString url, // 表示要连接的URL。这个URL应该为响应WebSocket的地址。
 in optional DOMString protocols // 可以是一个单个的协议名字字符串或者包含多个协议名字字符串的数组。默认设为一个空字符串。
 );
```

通过上述WebSocket构造器方法的第二个参数，客户端可以在初次连接握手时，可以告知服务器自己支持哪种协议。如下所示：

```js
 var ws = new WebSocket('wss://example.com/socket',['appProtocol', 'appProtocol-v2']);

 ws.onopen = function () {
   if (ws.protocol == 'appProtocol-v2') { 
     ...
   } else {
     ...
   }
 }
```

如上所示，WebSocket 构造函数接受了一个可选的子协议名字的数组，通过这个数组，客户端可以向服务器通告自己能够理解或希望服务器接受的协议。当服务器接收到该请求后，会根据自身的支持情况，返回相应信息。

* 有支持的协议，则子协议协商成功，触发客户端的onopen回调，应用可以查询WebSocket 对象上的protocol 属性，从而得知服务器选定的协议；
* 没有支持的协议，则协商失败，触发onerror 回调，连接断开。



### WS与WSS

WebSocket 的连接协议也可以用于浏览器之外的场景，可以通过非HTTP协商机制交换数据，采用了自定义的URI模式

* ws协议：普通请求，占用与http相同的80端口，表示纯文本通信；
* wss协议：基于SSL的安全传输，占用与tls相同的443端口，表示使用加密信道通信（TCP+TLS）。

各自的URI如下：

```js
 ws-URI = "ws:" "//" host [ ":" port ] path [ "?" query ]
 wss-URI = "wss:" "//" host [ ":" port ] path [ "?" query ]
```

很多现有的HTTP 中间设备可能不理解新的WebSocket 协议，而这可能导致各种问题：盲目的连接升级、意外缓冲WebSocket 帧、不明就里地修改内容、把WebSocket 流量误当作不完整的HTTP 通信，等等。这时WSS就提供了一种不错的解决方案，它建立一条端到端的安全通道，这个端到端的加密隧道对中间设备模糊了数据，因此中间设备就不能再感知到数据内容，也就无法再对请求做特殊处理。

## WebSocket协议

HyBi Working Group 制定的WebSocket 通信协议（RFC 6455）包含两个高层组件：开放性HTTP 握手用于协商连接参数，二进制消息分帧机制用于支持低开销的基于消息的文本和二进制数据传输。

### 握手（handshake）

**Request**

```js
GET /socket HTTP/1.1 // 请求的方法必须是GET，HTTP版本必须至少是1.1
 Host: thirdparty.com
 Origin: Example Domain
 Connection: Upgrade 
 Upgrade: websocket // 请求升级到WebSocket 协议
 Sec-WebSocket-Version: 13 // 客户端使用的WebSocket 协议版本
 Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ== // 自动生成的键，以验证服务器对协议的支持，其值必须是nonce组成的随机选择的16字节的被base64编码后的值
 Sec-WebSocket-Protocol: appProtocol, appProtocol-v2 // 可选的应用指定的子协议列表
 Sec-WebSocket-Extensions: x-webkit-deflate-message, x-custom-extension // 可选的客户端支持的协议扩展列表，指示了客户端希望使用的协议级别的扩展
```

可以看到，前两行跟HTTP的Request的起始行一模一样，而真正在WS的握手过程中起到作用的是下面几个`header`域。

* `Upgrade：upgrade`是HTTP1.1中用于定义转换协议的`header`域。它表示，如果服务器支持的话，客户端希望使用现有的「网络层」已经建立好的这个「连接（此处是TCP连接）」，切换到另外一个「应用层」（此处是WebSocket）协议。
* `Connection：HTTP1.1`中规定Upgrade只能应用在「直接连接」中，所以带有Upgrade头的HTTP1.1消息必须含有Connection头，因为Connection头的意义就是，任何接收到此消息的人（往往是代理服务器）都要在转发此消息之前处理掉Connection中指定的域（不转发Upgrade域）。
* 如果客户端和服务器之间是通过代理连接的，那么在发送这个握手消息之前首先要发送CONNECT消息来建立直接连接。
* `Sec-WebSocket-＊`：第7行标识了客户端支持的子协议的列表（关于子协议会在下面介绍），第8行标识了客户端支持的WS协议的版本列表，`Sec-WebSocket-Key`用来发送给服务器使用（服务器会使用此字段组装成另一个key值放在握手返回信息里发送客户端）。
* `Origin`：作安全使用，防止跨站攻击，浏览器一般会使用这个来标识原始域。

**Response**

如果服务器接受了这个请求，可能会发送如下这样的返回信息，这是一个标准的HTTP的Response消息。101表示服务器收到了客户端切换协议的请求，并且同意切换到此协议。RFC2616规定只有切换到的协议「比HTTP1.1更好」的时候才能同意切换。

```js
HTTP/1.1 101 Switching Protocols // 101 响应码确认升级到WebSocket 协议
 Upgrade: websocket
 Connection: Upgrade
 Access-Control-Allow-Origin: Example Domain // CORS 首部表示选择同意跨源连接
 Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo= // 签名的键值验证协议支持
 Sec-WebSocket-Protocol: appProtocol-v2 // 服务器选择的应用子协议
 Sec-WebSocket-Extensions: x-custom-extension // 服务器选择的WebSocket 扩展
```

`Sec-WebSocket-Accept`头域，其内容的生成步骤：

```
Sec-WebSocket-Accept = base64-value-non-empty
 　　base64-value-non-empty = (1*base64-data [ base64-padding ]) |
 　　base64-padding
 　　base64-data = 4base64-character
 　　base64-padding = (2base64-character "==") | 
 　　(3base64-character "=")
 　　base64-character = ALPHA | DIGIT | "+" | "/"
```
如果客户端发送的key值为：`dGhlIHNhbXBsZSBub25jZQ==`，服务端将把`258EAFA5-E914-47DA-95CA-C5AB0DC85B11` 这个唯一的GUID与它拼接起来，就是`dGhlIHNhbXBsZSBub25jZQ==258EAFA5-E914-47DA-95CAC5AB0DC85B11`，然后对其进行SHA-1哈希，结果为`0xb3 0x7a 0x4f 0x2c 0xc0 0x62 0x4f 0x16 0x90 0xf6 0x46 0x06 0xcf 0x38 0x59 0x45 0xb2 0xbe 0xc4 0xea`，再进行`base64-encoded`即可得`s3pPLMBiTxaQ9kYGzzhZRbK+xOo=`。

## 帧

```js
  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-------+-+-------------+-------------------------------+
 |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
 |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
 |N|V|V|V|       |S|             |   (if payload len==126/127)   |
 | |1|2|3|       |K|             |                               |
 +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
 |     Extended payload length continued, if payload len == 127  |
 + - - - - - - - - - - - - - - - +-------------------------------+
 |                               |Masking-key, if MASK set to 1  |
 +-------------------------------+-------------------------------+
 | Masking-key (continued)       |          Payload Data         |
 +-------------------------------- - - - - - - - - - - - - - - - +
 :                     Payload Data continued ...                :
 + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
 |                     Payload Data continued ...                |
 +---------------------------------------------------------------+
```

* FIN： 1 bit 。表示此帧是否是消息的最后帧，第一帧也可能是最后帧。
* RSV1，RSV2，RSV3： 各1 bit 。必须是0，除非协商了扩展定义了非0的意义。
* opcode：4 bit。表示被传输帧的类型：x0 表示一个后续帧；x1 表示一个文本帧；x2 表示一个二进制帧；x3-7 为以后的非控制帧保留；x8 表示一个连接关闭；x9 表示一个ping；xA 表示一个pong；xB-F 为以后的控制帧保留。
* Mask： 1 bit。表示净荷是否有掩码（只适用于客户端发送给服务器的消息）。
* Payload length： 7 bit, 7 + 16 bit, 7 + 64 bit。 净荷长度由可变长度字段表示： 如果是 0~125，就是净荷长度；如果是 126，则接下来 2 字节表示的 16 位无符号整数才是这一帧的长度； 如果是 127，则接下来 8 字节表示的 64 位无符号整数才是这一帧的长度。
* Masking-key：0或4 Byte。 用于给净荷加掩护，客户端到服务器标记。
* Extension data： x Byte。默认为0 Byte，除非协商了扩展。
* Application data： y Byte。 在”Extension data”之后，占据了帧的剩余部分。
* Payload data： (x + y) Byte。”extension data” 后接 “application data”。

>帧：最小的通信单位，包含可变长度的帧首部和净荷部分，净荷可能包含完整或部分应用消息。
>
>消息：一系列帧，与应用消息对等。

### 未分帧

FIN设置为1，opcode非0

### 分帧

```
[单个帧:FIN设为0，opcode非0]
[0个或多个帧:FIN设为0，opcode设为0]
[单个帧:FIN设为1，opcode为0]
```
开始于：单个帧，FIN设为0，opcode非0；后接 ：0个或多个帧，FIN设为0，opcode设为0；终结于：单个帧，FIN设为1，opcode设为0。一个分帧了消息在概念上等价于一个未分帧的大消息，它的有效载荷长度等于所有帧的有效载荷长度的累加；然而，有扩展时，这可能不成立，因为扩展定义了出现的Extension data的解释。例如，Extension data可能只出现在第一帧，并用于后续的所有帧，或者Extension data出现于所有帧，且只应用于特定的那个帧。在缺少Extension data时，下面的示例示范了分帧如何工作。举例：如一个文本消息作为三个帧发送，第一帧的opcode是0x1，FIN是0，第二帧的opcode是0x0，FIN是0，第三帧的opcode是0x0，FIN是1。

###控制帧

控制帧可能被插入到分帧了消息中，控制帧必须不能被分帧。如果控制帧不能插入，例如，如果是在一个大消息后面，ping的延迟将会很长。因此要求处理消息帧中间的控制帧。

### 其他
* 消息的帧必须以发送者发送的顺序传递给接受者。
* 一个消息的帧必须不能交叉在其他帧的消息中，除非有扩展能够解释交叉。
* 一个终端必须能够处理消息帧中间的控制帧。
* 一个发送者可能对任意大小的非控制消息分帧。
* 客户端和服务器必须支持接收分帧和未分帧的消息。
* 由于控制帧不能分帧，中间设施必须不尝试改变控制帧。
* 中间设施必须不修改消息的帧，如果保留位的值已经被使用，且中间设施不明白这些值的含义。
## 参考

* [使用 HTML5 WebSocket 构建实时 Web 应用](https://www.ibm.com/developerworks/cn/web/1112_huangxa_websocket/)
* [Socket 与 WebSocket](http://zengrong.net/post/2199.htm)
* [WebSocket 浅析](https://zhuanlan.zhihu.com/p/25592934)