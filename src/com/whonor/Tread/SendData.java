package com.whonor.Tread;

import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.Socket;
import java.net.UnknownHostException;

import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

//该注解用来指定一个URI，客户端可以通过这个URI来连接到WebSocket。
//类似Servlet的注解mapping。无需在web.xml中配置
//服务器注解端点
@ServerEndpoint("/SendData")
public class SendData {
	
	String ip = "192.168.1.103";//连接TCP服务器IP地址
	int port = 8888;
	
	@OnOpen
	public void onOpen(Session session){
        OneThread thread =null;
        thread=new OneThread(session);
        thread.start();
	}
	@OnMessage
	public void onMessage(String ms) throws UnsupportedEncodingException{
		
		try {
			Socket sck = new Socket(ip, port);
			String message = "ws:"+ms;
			System.out.println(message);
			byte[] bstream = message.getBytes();
			OutputStream os = sck.getOutputStream();
			System.out.println(bstream);
			os.write(bstream);
			sck.close();
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
