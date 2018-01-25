package com.whonor.Tread;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.websocket.Session;

import com.whonor.data.AlarmMessage;
import com.whonor.data.DBUtil;

public class OneThread extends Thread {

    private Session session;
    //private List<AlarmMessage> currentMessage;
    private DBUtil dbUtil;
    private int currentIndex;

    public OneThread(Session session) {
        this.session = session;
        //currentMessage = new ArrayList<AlarmMessage>();
        dbUtil = new DBUtil();
        currentIndex = 0;//此时是0条消息
    }

    @Override
    public void run() {
        while (true) {
            List<AlarmMessage> list = null;
            try {
                try {
                    list = dbUtil.getFromDB();
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (InstantiationException e) {
                    e.printStackTrace();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (list != null && currentIndex < list.size()) {
                for (int i = currentIndex; i < list.size(); i++) {
                    try {
                    	 session.getBasicRemote().sendText(
                    			"{\"Type\":"+list.get(i).getType()
                    			+",\"ID\":"+list.get(i).getID()
                    			+",\"lng\":"+list.get(i).getLng()
                                +",\"lat\":"+list.get(i).getLat()
                                +"}"
                               );
                       //session.getBasicRemote().sendObject(list.get(i)); //No encoder specified for object of class [class AlarmMessage]
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                currentIndex = list.size();
            }
            try {
                //一秒刷新一次
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

        }
    }
}
