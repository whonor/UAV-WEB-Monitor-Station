package com.whonor.Tread;

import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

//该注解用来指定一个URI，客户端可以通过这个URI来连接到WebSocket。
//类似Servlet的注解mapping。无需在web.xml中配置
@ServerEndpoint("/SendData")
public class SendData {
	
	@OnOpen
	public void onOpen(Session session){
        OneThread thread =null;
        thread=new OneThread(session);
        thread.start();
        
	}
}
