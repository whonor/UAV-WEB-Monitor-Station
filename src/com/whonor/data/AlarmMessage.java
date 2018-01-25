package com.whonor.data;

public class AlarmMessage {
	
    private String Type;
    private String ID;
    private String Lng;
    private String Lat;
    private String High;
    private String KeyNum;

    public AlarmMessage(String Type, String ID, String Lng, String Lat, String High, String KeyNum) {
        this.Type = Type;
        this.ID = ID;
        this.Lng = Lng;
        this.Lat = Lat;
        this.High = High;
        this.KeyNum = KeyNum;
    }

    public String getType() {
        return Type;
    }

    public String getID() {
        return ID;
    }

    public String getLng() {
        return Lng;
    }
    public String getLat(){
    	return Lat;
    }
    public String getHigh(){
    	return High;
    }
    public String getKeyNum(){
    	return KeyNum;
    }
}