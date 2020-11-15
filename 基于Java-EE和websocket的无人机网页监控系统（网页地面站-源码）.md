前段时间接了一个项目是关于无人机飞行监控系统的，众所周知，目前无人机地面站已经存在两个强大好用的开源软件——Mission planner和QGroundControl，前者是基于C#编写，只能运行在WIN系统，后者基于QT开发，可以跨平台运行。市场存在的地面站都是PC端软件，在跨平台安装使用方面存在短板，为了迎合项目的需求和软件系统的可拓展性，我和小组成员开发了网页版的无人机监控系统，也可以把它称作网页地面站，但功能略微简陋。

平台基于无人机飞行控制系统的GPS设备、数传设备等基础上，通过公共移动网络接收被监控设备传输的数据，在网页平台上显示被监控飞行器的位置和相关参数并绘制出相应的轨迹，目前可同时监控上百架设备。通过平台的各项飞行参数，决策者能够随时掌握飞行器的飞行动态，并对当下状态做出及时响应。本系统是嵌入式平台和计算机软件系统共同结合的系统，采用先进的网络通信协议和web设计方法，通过两者的协调运行可以达到理想的监控效果，主要功能包括数据采集、数据处理、轨迹展示、地图坐标抓取、系统管理等。

前端可实时显示被监控设备的各项指定参数，程序调用了高德地图API的多项功能，用户完全可以像用普通高德地图一样使用该平台。

该平台目前只是处于对无人机实时飞行状态的监控阶段。如图所示，

![Index.png](https://upload-images.jianshu.io/upload_images/2101095-2e61d684272a99fd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


首先介绍一下运行平台：

1、eclipse Java EE、JDK1.8

2、MySQL数据库

3、编辑语言：JAVA、JavaScript、HTML5、CSS、SQL

4、运行协议：websocket、TCP/IP

5、项目工程文件：

![总项目.png](https://upload-images.jianshu.io/upload_images/2101095-908683f303884372.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- Java Resources：Java资源类文件中包含了两个包，一个是数据库相关的    
   data类包，一个是websocket服务器Thread类包。

- WebContent：存放关于网页设计的全部代码内容和配置文件。

下面分模块介绍一下：

##前端系统

前端主要应用了高德地图JS API组件。

###基于高德开发平台

在高德发开着平台申请账号并申请对应的功能秘钥，其中平台内包括了大量的应用实例和详细地说明文档，前端设计思路都是基于其内部的功能接口实现的。

###基于JAVA Websocket

ws的出现打破了HTTP协议的壁垒，并且丰富了网络服务器的交互功能。虽然HTTP基于TCP/IP协议实现，但是并没有像TCP协议一样可以全双工实时通信，只能是被动或单双工交互。应用ws协议可以完全像TCP一样进行实时双向通信，即服务器在接收客户端的数据同时，也可以向客户端主动发送信息。因为该系统需要与嵌入式系统联动，在保证双向实时通信的条件下，ws协议是最好的选择。

##后端系统

后端系统主要是为数据的收发和存储服务，即数据库的操作和字节流的通信。其中也包括ws协议的节点功能。

###基于JAVA Socket

从这一部分开始，主要用于嵌入式系统的通信。服务器程序应用了JAVA Socket字节流通信的基本的API，通过TCP协议与嵌入式系统交互。

###MySQL数据库

根据实际情况，我将TCP服务器和网页服务器部署在了两台不同的主机上，并分别设计了两个相同的数据库，应用MySQL自有的主从复制功能，实现两个数据库的同步。


系统的主要构件如图所示：

![系统构件.png](https://upload-images.jianshu.io/upload_images/2101095-19dc200389941208.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

服务器如果细分的话按照上文可以分为网页服务器和TCP服务器两部分。总体来说，系统主要由四部分组成，硬件数传模块，网页端，服务器和数据库组成。

将项目部署到服务器上，在浏览器输入正确网址“http://localhost:8080/WebSocketDemo/”，即可进入系统。


关注公众号HonorWang，回复"无人机网页地面站"，即可获得源码。

![qrcode_for_gh_e20642ac17a9_258.jpg](https://upload-images.jianshu.io/upload_images/2101095-d9e9eb23a634cec6.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
