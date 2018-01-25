package com.whonor.data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DBUtil {

    public List<AlarmMessage> getFromDB() throws SQLException, ClassNotFoundException, IllegalAccessException, InstantiationException {
        List<AlarmMessage> list=new ArrayList<AlarmMessage>();

        String dirver="com.mysql.jdbc.Driver";
        String user="GPS";
        String psd="142468";
        String database="GPS";
        String tablename="gps0";
        String url="jdbc:mysql://localhost:3306/"+database+"?useSSL=false&user="+user+"&password="+psd;//加入useSSL=false关闭SSl功能，避免服务器警告
        Class.forName(dirver).newInstance();
        Connection conn= DriverManager.getConnection(url);
        Statement stat=conn.createStatement();
        String sql="select * from "+tablename;
        ResultSet rs=stat.executeQuery(sql);
        while (rs.next()){
            AlarmMessage alarmMessage=new AlarmMessage(rs.getString(1),rs.getString(2),rs.getString(3),rs.getString(4),rs.getString(5),rs.getString(6));
            list.add(alarmMessage);
        }
        rs.close();
        stat.close();
        conn.close();
        return list;
    }

}
