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
//服务器注解端点TCP
@ServerEndpoint("/SendData")//该类的功能是将服务器后台数据发送到网页上
public class SendData {
	
	String ip = "192.168.1.110";//TCP服务器地址
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
