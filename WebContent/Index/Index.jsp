<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE HTML>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
    <title>云都海鹰无人机监控平台</title>
    <style type="text/css">
        body{
            margin:0;
            height:100%;
            width:100%;
            position:absolute;
            font-size:12px;
        }
        #mapContainer{
            width:; 100%;
            height: 100%;
            position: absolute;
            top:0;
            left: 0;
            right:0;
            bottom:0;
        }

		#data{
			color:#fff;
            ackground-color:#fff;
            border:1px solid #ccc;
            padding-left:10px;
            padding-right:2px;
            position:absolute;
            height:100px;
            top:10px;
            font-size:12px;
            left:10px;
            border:0;
            overflow:auto;
            line-height:20px;
            width:350px;
        }
        
        #tip{
            background-color:#fff;
            border:1px solid #ccc;
            padding-left:10px;
            padding-right:2px;
            position:absolute;
            min-height:65px;
            top:10px;
            font-size:12px;
            right:10px;
            border-radius:3px;
            overflow:hidden;
            line-height:20px;
            min-width:400px;
        }
      
        #tip input[type="button"]{
            background-color: #0D9BF2;
            height:25px;
            text-align:center;
            line-height:25px;
            color:#fff;
            font-size:12px;
            border-radius:3px;
            outline: none;
            border:0;
            cursor:pointer;
        }

        #tip input[type="text"]{
            height:25px;
            border:1px solid #ccc;
            padding-left:5px;
            border-radius:3px;
            outline:none;
        }
        #pos{
            height: 70px;
            background-color: #fff;
            padding-left: 10px;
            padding-right: 10px;
            position:absolute;
            font-size: 12px;
            right: 10px;
            bottom: 30px;
            border-radius: 3px;
            line-height: 30px;
            border:1px solid #ccc;
        }
        #pos input{
            border:1px solid #ddd;
            height:23px;
            border-radius:3px;
            outline:none;
        }

        #result1{
            max-height:300px;
        }
        .button-group{
            width: 36%;
            padding-left: 10px;
            padding-right: 10px;
            position:absolute;;
            left: 20px;
            background-color: #0d9bf2
        }
        p.my-desc {
            margin: 5px 0;
            line-height: 150%;
        }
        #loadingTip {
            position: absolute;
            z-index: 9999;
            top: 0;
            left: 0;
            padding: 3px 10px;
            background: red;
            color: #fff;
            font-size: 14px;
        }
    </style>
    <script src="http://webapi.amap.com/maps?v=1.4.2&key=7ad6838d690504e95fba48571cf18060&&plugin=AMap.Scale,AMap.OverView,AMap.ToolBar"></script>
    <link rel="stylesheet" href="http://cache.amap.com/lbs/static/main1119.css"/>
    <script src="//webapi.amap.com/ui/1.0/main.js?v=1.0.11"></script>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
	<script src="JS/json.js"></script>
	<script type="text/javascript">
		var pointList;
		pointList = [{

  			"lng":121.451851,
  			"lat":37.478776

					}];
		
		var pointList02;
		pointList02 = [{

  			"lng":121.451851,
  			"lat":37.478776

					}];
		var pointList03;
		pointList03 = [{

  			"lng":121.470133,
  			"lat":37.469784

					}];
		var pointList04;
		pointList04 = [{

  			"lng":121.436574,
  			"lat":37.45718

					}];
		
		var pointList05;
		pointList05 = [{

  			"lng":121.436574,
  			"lat":37.45718

					}];
		
		pointList06 = [{

  			"lng":121.436574,
  			"lat":37.45718

					}];
		
		pointList07 = [{

  			"lng":121.436574,
  			"lat":37.45718

					}];
		
		pointList08 = [{

  			"lng":121.436574,
  			"lat":37.45718

					}];
		
		pointList09 = [{

  			"lng":121.436574,
  			"lat":37.45718

					}];
		
		pointList10 = [{

  			"lng":121.436574,
  			"lat":37.45718

					}];
		
		var mapObj = null;
		//GPS坐标系转换
		var GPS = {
			    PI : 3.14159265358979324,
			    x_pi : 3.14159265358979324 * 3000.0 / 180.0,
			    delta : function (lat, lon) {
			        // Krasovsky 1940
			        //
			        // a = 6378245.0, 1/f = 298.3
			        // b = a * (1 - f)
			        // ee = (a^2 - b^2) / a^2;
			        var a = 6378245.0; //  a: 卫星椭球坐标投影到平面地图坐标系的投影因子。
			        var ee = 0.00669342162296594323; //  ee: 椭球的偏心率。
			        var dLat = this.transformLat(lon - 105.0, lat - 35.0);
			        var dLon = this.transformLon(lon - 105.0, lat - 35.0);
			        var radLat = lat / 180.0 * this.PI;
			        var magic = Math.sin(radLat);
			        magic = 1 - ee * magic * magic;
			        var sqrtMagic = Math.sqrt(magic);
			        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * this.PI);
			        dLon = (dLon * 180.0) / (a / sqrtMagic * Math.cos(radLat) * this.PI);
			        return {'lat': dLat, 'lng': dLon};
			    },

			    //GPS---高德
			    gcj_encrypt : function ( wgsLat , wgsLon ) {
			        if (this.outOfChina(wgsLat, wgsLon))
			            return {'lat': wgsLat, 'lng': wgsLon};

			        var d = this.delta(wgsLat, wgsLon);
			        return {'lat' : wgsLat + d.lat,'lng' : wgsLon + d.lng};
			    },
			    outOfChina : function (lat, lon) {
			        if (lon < 72.004 || lon > 137.8347)
			            return true;
			        if (lat < 0.8293 || lat > 55.8271)
			            return true;
			        return false;
			    },
			    transformLat : function (x, y) {
			        var ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * Math.sqrt(Math.abs(x));
			        ret += (20.0 * Math.sin(6.0 * x * this.PI) + 20.0 * Math.sin(2.0 * x * this.PI)) * 2.0 / 3.0;
			        ret += (20.0 * Math.sin(y * this.PI) + 40.0 * Math.sin(y / 3.0 * this.PI)) * 2.0 / 3.0;
			        ret += (160.0 * Math.sin(y / 12.0 * this.PI) + 320 * Math.sin(y * this.PI / 30.0)) * 2.0 / 3.0;
			        return ret;
			    },
			    transformLon : function (x, y) {
			        var ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * Math.sqrt(Math.abs(x));
			        ret += (20.0 * Math.sin(6.0 * x * this.PI) + 20.0 * Math.sin(2.0 * x * this.PI)) * 2.0 / 3.0;
			        ret += (20.0 * Math.sin(x * this.PI) + 40.0 * Math.sin(x / 3.0 * this.PI)) * 2.0 / 3.0;
			        ret += (150.0 * Math.sin(x / 12.0 * this.PI) + 300.0 * Math.sin(x / 30.0 * this.PI)) * 2.0 / 3.0;
			        return ret;
			    }
			};
		//======================定义飞机marker==================================
		var lineArr;
		  lineArr = [];
		var marker1 = null;
		var polyline = null;
		
		var lineArr02 = [];
		var marker2 = null;
		var polyline02 = null;
		
		var lineArr03 = [];
		var marker3 = null;
		var polyline03 = null;
		
		var lineArr04 = [];
		var marker4 = null;
		var polyline04 = null;
		
		var lineArr05 = [];
		var marker5 = null;
		var polyline05 = null;
		
		var lineArr06 = [];
		var marker6 = null;
		var polyline06 = null;
		
		var lineArr07 = [];
		var marker7 = null;
		var polyline07 = null;
		
		var lineArr08 = [];
		var marker8 = null;
		var polyline08 = null;
		
		var lineArr09 = [];
		var marker9 = null;
		var polyline09 = null;
		
		var lineArr10 = [];
		var marker10 = null;
		var polyline10 = null;
				
		marker1 = new AMap.Marker({//飞机1点标记
		      //map: mapObj,
		      //draggable:true,
		      position: [pointList[pointList.length - 1].lng, pointList[pointList.length - 1].lat],//终点
		      icon: "./image/p3.png",
		      offset: new AMap.Pixel(-16, -18),
		      autoRotation: true,
		      title: "1号机起飞"
		  });
		
		marker2 = new AMap.Marker({//飞机2的点标记
		    position: [pointList02[0].lng, pointList02[0].lat],//终点
		    icon: "./image/p3.png",
		    offset: new AMap.Pixel(-16, -18),
		    autoRotation: true,
		    title: "2号机起飞"
		});
		
		marker3 = new AMap.Marker({//飞机3的点标记
		    position: [pointList03[0].lng, pointList03[0].lat],//终点
		    icon: "./image/p3.png", 
		    offset: new AMap.Pixel(-16, -18),
		    autoRotation: true,
		    title: "3号机起飞"
		});
		
		marker4 = new AMap.Marker({//飞机4的点标记
		    position: [pointList04[0].lng, pointList04[0].lat],//终点
		    icon: "./image/p3.png", 
		    offset: new AMap.Pixel(-16, -18),
		    autoRotation: true,
		    title: "4号机起飞"
		});
		
		marker5 = new AMap.Marker({//飞机5的点标记
		    position: [pointList05[0].lng, pointList05[0].lat],//终点
		    icon: "./image/p3.png", 
		    offset: new AMap.Pixel(-16, -18),
		    autoRotation: true,
		    title: "5号机起飞"
		});
		
		marker6 = new AMap.Marker({//飞机6的点标记
		    position: [pointList06[0].lng, pointList06[0].lat],//终点
		    icon: "./image/p3.png", 
		    offset: new AMap.Pixel(-16, -18),
		    autoRotation: true,
		    title: "6号机起飞"
		});
		
		marker7 = new AMap.Marker({//飞机7的点标记
		    position: [pointList07[0].lng, pointList07[0].lat],//终点
		    icon: "./image/p3.png", 
		    offset: new AMap.Pixel(-16, -18),
		    autoRotation: true,
		    title: "7号机起飞"
		});
		
		marker8 = new AMap.Marker({//飞机8的点标记
		    position: [pointList08[0].lng, pointList08[0].lat],//终点
		    icon: "./image/p3.png", 
		    offset: new AMap.Pixel(-16, -18),
		    autoRotation: true,
		    title: "8号机起飞"
		});
		
		marker9 = new AMap.Marker({//飞机9的点标记
		    position: [pointList09[0].lng, pointList09[0].lat],//终点
		    icon: "./image/p3.png",
		    offset: new AMap.Pixel(-16, -18),
		    autoRotation: true,
		    title: "9号机起飞"
		});
		//地图图块加载完毕后执行函数
		function completeEventHandler() {			
		polyline = new AMap.Polyline({//飞机1的航线
			  map: mapObj,
			  path: lineArr,
			  strokeColor: "#FFFF00",//橘红色
			  strokeOpacity: 1,//
			  strokeWeight: 3,//
			  strokeStyle: "solid"//
			});
		
		polyline02 = new AMap.Polyline({//飞机2的航线
			map: mapObj,
			path: lineArr02,
			strokeColor: "#FFFF00",//黄色
			strokeOpacity: 1,//
			strokeWeight: 3,//
			strokeStyle: "solid"//
			});
		
		polyline03 = new AMap.Polyline({//飞机3的航线
			map: mapObj,
			path: lineArr03,
			strokeColor: "#FFFF00",//深橙色
			strokeOpacity: 1,//
			strokeWeight: 3,//
			strokeStyle: "solid"//
			});
		
		polyline04 = new AMap.Polyline({//飞机4的航线
			map: mapObj,
			path: lineArr04,
			strokeColor: "#FFFF00",//薰衣草淡紫色
			strokeOpacity: 1,//
			strokeWeight: 3,//
			strokeStyle: "solid"//
			});
		
		polyline05 = new AMap.Polyline({//飞机5的航线
			map: mapObj,
			path: lineArr05,
			strokeColor: "#FFFF00",//
			strokeOpacity: 1,//
			strokeWeight: 3,//
			strokeStyle: "solid"//
			});
		
		polyline06 = new AMap.Polyline({//飞机6的航线
			map: mapObj,
			path: lineArr06,
			strokeColor: "#FFFF00",//
			strokeOpacity: 1,//
			strokeWeight: 3,//
			strokeStyle: "solid"//
			});
		
		polyline07 = new AMap.Polyline({//飞机7的航线
			map: mapObj,
			path: lineArr07,
			strokeColor: "#FFFF00",//
			strokeOpacity: 1,//
			strokeWeight: 3,//
			strokeStyle: "solid"//
			});
		
		polyline08 = new AMap.Polyline({//飞机8的航线
			map: mapObj,
			path: lineArr08,
			strokeColor: "#FFFF00",//
			strokeOpacity: 1,//
			strokeWeight: 3,//
			strokeStyle: "solid"//
			});
		
		polyline09 = new AMap.Polyline({//飞机9的航线
			map: mapObj,
			path: lineArr09,
			strokeColor: "#FFFF00",//
			strokeOpacity: 1,//
			strokeWeight: 3,//
			strokeStyle: "solid"//
			});	
		//polyline.setMap(mapObj);
		var lngX;
		var latY;
		var GDXY;
		var gdlng;
		var gdlat;
		for (var i = 1; i < pointList.length; i++) {
		  lngX = pointList[i].lng;
		  latY = pointList[i].lat;
		  GDXY = GPS.gcj_encrypt(latY, lngX);
		  gdlng = GDXY.lng;
		  gdlat = GDXY.lat;
			if(pointList[i].ID == "1"){
				marker1.setMap(mapObj);//在地图添加点标记对象
				lineArr.push(new AMap.LngLat(gdlng, gdlat));//把坐标分别放入各自轨迹数组
			}
				
		  	if(pointList[i].ID == "2"){
		  		marker2.setMap(mapObj);
		  		lineArr02.push(new AMap.LngLat(gdlng, gdlat));
		  	}
				
		  	if(pointList[i].ID == "3"){
		  		marker3.setMap(mapObj);
		  		lineArr03.push(new AMap.LngLat(gdlng, gdlat));
		  	}
						  	
		  	if(pointList[i].ID == "4"){
		  		marker4.setMap(mapObj);
		  		lineArr04.push(new AMap.LngLat(gdlng, gdlat));
		  	}
						  	
		  	if(pointList[i].ID == "5"){
		  		marker5.setMap(mapObj);
		  		lineArr05.push(new AMap.LngLat(gdlng, gdlat));
		  	}
						  	
		  	if(pointList[i].ID == "6"){
		  		marker6.setMap(mapObj);
		  		lineArr06.push(new AMap.LngLat(gdlng, gdlat));
		  	}
		  	
		  	if(pointList[i].ID == "7"){
		  		marker7.setMap(mapObj);
		  		lineArr07.push(new AMap.LngLat(gdlng, gdlat));
		  	}
				
		  	
		  	if(pointList[i].ID == "8"){
		  		marker8.setMap(mapObj);
		  		lineArr08.push(new AMap.LngLat(gdlng, gdlat));
		  	}
				
		  	
		  	if(pointList[i].ID == "9"){
		  		marker9.setMap(mapObj);
		  		lineArr09.push(new AMap.LngLat(gdlng, gdlat));
		  	}
				
		}
		//点标记执行画轨迹
		marker1.on('moving', function (e) {
		  polyline.setPath(e.passedPath);
		});
		
		marker2.on('moving', function (e) {
			  polyline02.setPath(e.passedPath);
			});
		
		marker3.on('moving', function (e) {
			  polyline03.setPath(e.passedPath);
			});
		
		marker4.on('moving', function (e) {
			  polyline04.setPath(e.passedPath);
			});
		
		marker5.on('moving', function (e) {
			  polyline05.setPath(e.passedPath);
			});
		
		marker6.on('moving', function (e) {
			  polyline06.setPath(e.passedPath);
			});
		
		marker7.on('moving', function (e) {
			  polyline07.setPath(e.passedPath);
			});
		
		marker8.on('moving', function (e) {
			  polyline08.setPath(e.passedPath);
			});
		
		marker9.on('moving', function (e) {
			  polyline09.setPath(e.passedPath);
			});
		}
		
	</script>
</head>
<body>
<div id="mapContainer"></div> <!--地图容器-->
<div id="data"></div>
<!--<div id="tip">
    <b>请输入关键字：</b>
    <input type="text" id="keyword" name="keyword" value="" onkeydown='keydown(event)' style="width: 95%;"/>
    <div id="result1" name="result1"></div>
</div>-->
<div id="pos">
    <b>鼠标左键在地图上单击获取坐标</b>
    <br><div>>X：<input type="text" id="lngX" name="lngX" value=""/>&nbsp;Y：<input type="text" id="latY" name="latY" value=""/></div>
</div>
<!--设置工具条包括：比例尺、工具条、工具条方向盘、工具条标尺、显示鹰眼、展开鹰眼 -->
<div class='button-group' >
    <input type="checkbox" onclick="toggleScale(this)"/>比例尺
    <input type="checkbox" id="toolbar" onclick="toggleToolBar(this)"/>工具条
    <input type="checkbox" id="toolbarDirection" disabled onclick="toggleToolBarDirection(this)"/>工具条方向盘
    <input type="checkbox" id="toolbarRuler" disabled onclick="toggleToolBarRuler(this)"/>工具条标尺
    <input type="checkbox" id="overview" onclick="toggleOverViewShow(this)"/>显示鹰眼
    <input type="checkbox" id="overviewOpen" disabled onclick="toggleOverViewOpen(this)"/>展开鹰眼
</div>
<script type="text/javascript">
<!--加载地图-->
var scale = new AMap.Scale({
    visible: false
}),
toolBar = new AMap.ToolBar({
    visible: false
}),
overView = new AMap.OverView({
    visible: false
});
var windowsArr = [];
mapObj = new AMap.Map("mapContainer", {
	
	layers: [new AMap.TileLayer.Satellite()],//显示卫星图层
	resizeEnable: true,
    zoom:13,
    //center: [116.39,39.9]//
});
mapObj.setCity("烟台市");
mapObj.addControl(scale);
mapObj.addControl(toolBar);
mapObj.addControl(overView);
  //先检验能不能运行起来，能不能连上，自动推送数据，先不做数据显示
  //客户端就会与服务器进行连接
  var webSocket = new WebSocket("ws://127.0.0.1:8080/WebSocketDemo/SendData");
  
	var arr = [];
  var cs = false;

  //连接失败时回调
  webSocket.onerror = function (event) {
	  console.log("error");
  };

  //连接成功时回调，真的会执行括号中的代码！
  webSocket.onopen = function (event) {
	  console.log("connection successful");//
      
  };

  webSocket.onmessage = function (event) {//接收服务器数据并做出处理
      cs = true;
      var serverdata = event.data;
      makeDataOnWeb(serverdata);//收到后台数据库中的字符串数据
		//alert(serverdata);
      
	};
  webSocket.onclose = function (event) {
      //makeDataOnWeb("connection close");
      console.log("connection close");
  };

  var historyVal;
  function makeDataOnWeb(data) {

      var a = data;
      var divNode = document.getElementById("data");
      var liNode = document.createElement("li");///动态创建<li>标签
      liNode.innerHTML = a;//把数据写入一行标签
      //alert(liNode.innerHTML);
      divNode.appendChild(liNode);
      
	  if(cs == true){
		  var x = 0;
		arr = document.getElementsByTagName("li");//获取所有li放到数组
		if(x<arr.length){
			pointList.push(JSON.parse(liNode.innerHTML));//获取HTML元素数据，转换成JSON，存入数组
			x++;
		}
		
	  //===============================================================	  
	/*	  //测试调试JSON数据用
	  var temp = "";
	  for(var i in pointList){//用javascript的for/in循环遍历对象的属性
	  temp += i+":"+pointList[i];
	  }
	  */
	  //================================================================
	  cs = false;
	  x = 0;
	  }

  }
  
//此处需要延时执行函数，否则后面程序无法执行
//加入提示信息，可顺利执行
  alert('欢迎使用烟台云都海鹰无人机监控平台');

<!--巡航画轨迹--> //必须初始化点坐标，否则全都不显示！！！
function startRun(){  //开始画轨迹，并沿轨迹移动
completeEventHandler();
marker1.moveAlong(lineArr,9000,false);//点标记沿轨迹移动，设置速度
marker2.moveAlong(lineArr02,9000,false);
marker3.moveAlong(lineArr03,9000,false);
marker4.moveAlong(lineArr04,9000,false);
marker5.moveAlong(lineArr05,9000,false);
marker6.moveAlong(lineArr06,9000,false);
marker7.moveAlong(lineArr07,9000,false);
marker8.moveAlong(lineArr08,9000,false);
marker9.moveAlong(lineArr09,9000,false);
}

<!--根据数据库的坐标点绘制航线轨迹-->
function init(){
startRun();
}

function move(){
	marker1.moveAlong(lineArr,90000,false);
}

function move02(){
		marker2.moveAlong(lineArr02,90000,false);
}

function move03(){
		marker3.moveAlong(lineArr03,90000,false);
}

function move04(){
		marker4.moveAlong(lineArr04,90000,false);
}

function move05(){
		marker5.moveAlong(lineArr05,90000,false);
}

function move06(){
		marker6.moveAlong(lineArr06,90000,false);
}

function move07(){
		marker7.moveAlong(lineArr07,90000,false);
}

function move08(){
		marker8.moveAlong(lineArr08,90000,false);
}

function move09(){
		marker9.moveAlong(lineArr09,90000,false);
}

//每隔一秒获取li的标签数量
setInterval(function getLi(){
	curVal = $('#data li').length;
},1000);

//加载完成全部页面后，动态检查li标签是否有变化，有变化则移动marker，并增加路径
$(document).ready(function(){
	historyVal = $('#data li').length;
		init();
		setInterval(function() {
		if (curVal != historyVal) {//检测到不相同
			historyVal = curVal;
			var Lng;
			var Lat;
		  	var XY = pointList.pop();
		  	//alert(XY);
		  	Lng = XY.lng;
		  	Lat = XY.lat;
		  	var GXY = GPS.gcj_encrypt(Lat, Lng);
		  	var Glng = GXY.lng;
		  	var Glat = GXY.lat;
		  	//alert(GXY);	  	
		  	if(XY.ID == "1"){
		  		marker1.hide();
		  		marker1 = new AMap.Marker({//飞机1点标记
				      position: [Glng, Glat],//终点
				      icon: "./image/p1.png",
				      offset: new AMap.Pixel(-16, -18),
				      autoRotation: true,
				      title: "1号机飞行中"
				  });
		  		marker1.setMap(mapObj);
		  		//polyline.setMap(mapObj);
		  		lineArr.push(new AMap.LngLat(Glng, Glat));
		  		polyline.getPath(lineArr);//获取变换后的坐标数组
			  	move();//点标记移动			
				marker1.on('moving', function (e) {//设置点轨迹
			  	polyline.setPath(e.passedPath);//设置路径
				});
		  	}
		  	if(XY.ID == "2"){
		  		marker2.hide();
		  		marker2 = new AMap.Marker({//飞机2点标记
				      position: [Glng, Glat],//终点
				      icon: "./image/p1.png",
				      offset: new AMap.Pixel(-16, -18),
				      autoRotation: true,
				      title: "2号机飞行中"
				  });
		  		marker2.setMap(mapObj);
		  		lineArr02.push(new AMap.LngLat(Glng, Glat));
			  	polyline02.getPath(lineArr02);///获取变换后的坐标数组
			  	move02();	  	//点标记移动
				marker2.on('moving', function (e) {//设置点轨迹
			  	polyline02.setPath(e.passedPath);
				});
		  	}
		  	if(XY.ID == "3"){
		  		marker3.hide();
		  		marker3 = new AMap.Marker({//飞机3点标记
				      position: [Glng, Glat],//终点
				      icon: "./image/p1.png",
				      offset: new AMap.Pixel(-16, -18),
				      autoRotation: true,
				      title: "3号机飞行中"
				  });
		  		marker3.setMap(mapObj);
		  		lineArr03.push(new AMap.LngLat(Glng, Glat));
			  	polyline03.getPath(lineArr03);///获取变换后的坐标数组
			  	move03();	  	//点标记移动
				marker3.on('moving', function (e) {//设置点轨迹
			  	polyline03.setPath(e.passedPath);
				});
		  	}
		  	if(XY.ID == "4"){
		  		marker4.hide();
		  		marker4 = new AMap.Marker({//飞机1点标记
				      position: [Glng, Glat],//终点
				      icon: "./image/p1.png",
				      offset: new AMap.Pixel(-16, -18),
				      autoRotation: true,
				      title: "4号机飞行中"
				  });
		  		marker4.setMap(mapObj);
		  		lineArr04.push(new AMap.LngLat(Glng, Glat));
			  	polyline04.getPath(lineArr04);///获取变换后的坐标数组
			  	move04();	  	//点标记移动
				marker4.on('moving', function (e) {//设置点轨迹
			  	polyline04.setPath(e.passedPath);
				});
		  	}
		  	if(XY.ID == "5"){
		  		marker5.hide();
		  		marker5 = new AMap.Marker({//飞机1点标记
				      position: [Glng, Glat],//终点
				      icon: "./image/p1.png",
				      offset: new AMap.Pixel(-16, -18),
				      autoRotation: true,
				      title: "5号机飞行中"
				  });
		  		marker5.setMap(mapObj);
		  		lineArr05.push(new AMap.LngLat(Glng, Glat));
			  	polyline05.getPath(lineArr05);///获取变换后的坐标数组
			  	move05();	  	//点标记移动
				marker5.on('moving', function (e) {//设置点轨迹
			  	polyline05.setPath(e.passedPath);
				});
		  	}
		  	if(XY.ID == "6"){
		  		marker6.hide();
		  		marker6 = new AMap.Marker({//飞机1点标记
				      position: [Glng, Glat],//终点
				      icon: "./image/p1.png",
				      offset: new AMap.Pixel(-16, -18),
				      autoRotation: true,
				      title: "6号机飞行中"
				  });
		  		marker6.setMap(mapObj);
		  		lineArr06.push(new AMap.LngLat(Glng, Glat));
			  	polyline06.getPath(lineArr06);///获取变换后的坐标数组
			  	move06();	  	//点标记移动
				marker6.on('moving', function (e) {//设置点轨迹
			  	polyline06.setPath(e.passedPath);
				});
		  	}
		  	if(XY.ID == "7"){
		  		marker7.hide();
		  		marker7 = new AMap.Marker({//飞机1点标记
				      position: [Glng, Glat],//终点
				      icon: "./image/p1.png",
				      offset: new AMap.Pixel(-16, -18),
				      autoRotation: true,
				      title: "7号机飞行中"
				  });
		  		marker7.setMap(mapObj);
		  		lineArr07.push(new AMap.LngLat(Glng, Glat));
			  	polyline07.getPath(lineArr07);///获取变换后的坐标数组
			  	move07();	  	//点标记移动
				marker7.on('moving', function (e) {//设置点轨迹
			  	polyline07.setPath(e.passedPath);
				});
		  	}
		  	if(XY.ID == "8"){
		  		marker8.hide();
		  		marker8 = new AMap.Marker({//飞机1点标记
				      position: [Glng, Glat],//终点
				      icon: "./image/p1.png",
				      offset: new AMap.Pixel(-16, -18),
				      autoRotation: true,
				      title: "8号机飞行中"
				  });
		  		marker8.setMap(mapObj);
		  		lineArr08.push(new AMap.LngLat(Glng, Glat));
			  	polyline08.getPath(lineArr08);///获取变换后的坐标数组
			  	move08();	  	//点标记移动
				marker8.on('moving', function (e) {//设置点轨迹
			  	polyline08.setPath(e.passedPath);
				});
		  	}
		  	if(XY.ID == "9"){
		  		marker9.hide();
		  		marker9 = new AMap.Marker({//飞机1点标记
				      position: [Glng, Glat],//终点
				      icon: "./image/p1.png",
				      offset: new AMap.Pixel(-16, -18),
				      autoRotation: true,
				      title: "9号机飞行中"
				  });
		  		marker9.setMap(mapObj);
		  		lineArr09.push(new AMap.LngLat(Glng, Glat));
			  	polyline09.getPath(lineArr09);///获取变换后的坐标数组
			  	move09();	  	//点标记移动
				marker9.on('moving', function (e) {//设置点轨迹
			  	polyline09.setPath(e.passedPath);
				});
		  	}
		}
	}, 1500); // 1000表示1500毫秒， 即每隔1.5秒执行一次

});

  //===================================================================================================================
  <!--输入关键字查询地点-->
  function autocomplete_CallBack(data) {
      var resultStr = "";
      var tipArr = data.tips;
      if (tipArr&&tipArr.length>0) {
          for (var i = 0; i < tipArr.length; i++) {
              resultStr += "<div id='divid" + (i + 1) + "' onmouseover='openMarkerTipById(" + (i + 1)
                  + ",this)' onclick='selectResult(" + i + ")' onmouseout='onmouseout_MarkerStyle(" + (i + 1)
                  + ",this)' style=\"font-size: 13px;cursor:pointer;padding:5px 5px 5px 5px;\"" + "data=" + tipArr[i].adcode + ">" + tipArr[i].name + "<span style='color:#C1C1C1;'>"+ tipArr[i].district + "</span></div>";
          }
      }
      else  {
      	resultStr = " π__π 亲,人家找不到结果!<br />要不试试：<br />1.请确保所有字词拼写正确<br />2.尝试不同的关键字<br />3.尝试更宽泛的关键字";
      }
      document.getElementById("result1").curSelect = -1;
      document.getElementById("result1").tipArr = tipArr;
      document.getElementById("result1").innerHTML = resultStr;
      document.getElementById("result1").style.display = "block";
  }

  //
  function openMarkerTipById(pointid, thiss) {  //
      thiss.style.background = '#CAE1FF';
  }

  //
  function onmouseout_MarkerStyle(pointid, thiss) {  //é
      thiss.style.background = "";
  }

  //
  function selectResult(index) {
      if(index<0){
          return;
      }
      if (navigator.userAgent.indexOf("MSIE") > 0) {
          document.getElementById("keyword").onpropertychange = null;
          document.getElementById("keyword").onfocus = focus_callback;
      }
      //
      var text = document.getElementById("divid" + (index + 1)).innerHTML.replace(/<[^>].*?>.*<\/[^>].*?>/g,"");
      var cityCode = document.getElementById("divid" + (index + 1)).getAttribute('data');
      document.getElementById("keyword").value = text;
      document.getElementById("result1").style.display = "none";
      //
      mapObj.plugin(["AMap.PlaceSearch"], function() {
          var msearch = new AMap.PlaceSearch();  //
          AMap.event.addListener(msearch, "complete", placeSearch_CallBack); //
          msearch.setCity(cityCode);
          msearch.search(text);  //
      });
  }

  //
  function focus_callback() {
      if (navigator.userAgent.indexOf("MSIE") > 0) {
          document.getElementById("keyword").onpropertychange = autoSearch;
      }
  }

  //
  function placeSearch_CallBack(data) {
      //
      windowsArr = [];
      marker     = [];
      mapObj.clearMap();
      var resultStr1 = "";
      var poiArr = data.poiList.pois;
      var resultCount = poiArr.length;
      for (var i = 0; i < resultCount; i++) {
          resultStr1 += "<div id='divid" + (i + 1) + "' onmouseover='openMarkerTipById1(" + i + ",this)' onmouseout='onmouseout_MarkerStyle(" + (i + 1) + ",this)' style=\"font-size: 12px;cursor:pointer;padding:0px 0 4px 2px; border-bottom:1px solid #C1FFC1;\"><table><tr><td><img src=\"http://webapi.amap.com/images/" + (i + 1) + ".png\"></td>" + "<td><h3><font color=\"#00a6ac\">åç§°: " + poiArr[i].name + "</font></h3>";
          resultStr1 += TipContents(poiArr[i].type, poiArr[i].address, poiArr[i].tel) + "</td></tr></table></div>";
          addmarker(i, poiArr[i]);
      }
      mapObj.setFitView();
  }

  //
  function openMarkerTipById1(pointid, thiss) {
      thiss.style.background = '#CAE1FF';
      windowsArr[pointid].open(mapObj, marker[pointid]);
  }

  //
  function addmarker(i, d) {
      var lngX = d.location.getLng();
      var latY = d.location.getLat();
      var markerOption = {
          map:mapObj,
          //offset:Pixel(-10,-34),
          position:new AMap.LngLat(lngX, latY)
      };
      var mar = new AMap.Marker(markerOption);
      marker.push(new AMap.LngLat(lngX, latY));

      var infoWindow = new AMap.InfoWindow({
          content:"<h3><font color=\"#00a6ac\">  " + (i + 1) + ". " + d.name + "</font></h3>" + TipContents(d.type, d.address, d.tel),
          size:new AMap.Size(300, 0),
          autoMove:true,
          offset:new AMap.Pixel(0,-30)
      });
      windowsArr.push(infoWindow);
      var aa = function (e) {
          var nowPosition = mar.getPosition(),
              lng_str = nowPosition.lng,
              lat_str = nowPosition.lat;
          infoWindow.open(mapObj, nowPosition);
          document.getElementById("lngX").value = lng_str;
          document.getElementById("latY").value = lat_str;
      };
      AMap.event.addListener(mar, "mouseover", aa);
  }

//infowindow显示内容
  function TipContents(type, address, tel) {  //窗体内容
      if (type == "" || type == "undefined" || type == null || type == " undefined" || typeof type == "undefined") {
          type = "暂无";
      }
      if (address == "" || address == "undefined" || address == null || address == " undefined" || typeof address == "undefined") {
          address = "暂无";
      }
      if (tel == "" || tel == "undefined" || tel == null || tel == " undefined" || typeof address == "tel") {
          tel = "暂无";
      }
      var str = "  地址：" + address + "<br />  电话：" + tel + " <br />  类型：" + type;
      return str;
  }
  function keydown(event){
      var key = (event||window.event).keyCode;
      var result = document.getElementById("result1")
      var cur = result.curSelect;
      if(key===40){//down
          if(cur + 1 < result.childNodes.length){
              if(result.childNodes[cur]){
                  result.childNodes[cur].style.background='';
              }
              result.curSelect=cur+1;
              result.childNodes[cur+1].style.background='#CAE1FF';
              document.getElementById("keyword").value = result.tipArr[cur+1].name;
          }
      }else if(key===38){//up
          if(cur-1>=0){
              if(result.childNodes[cur]){
                  result.childNodes[cur].style.background='';
              }
              result.curSelect=cur-1;
              result.childNodes[cur-1].style.background='#CAE1FF';
              document.getElementById("keyword").value = result.tipArr[cur-1].name;
          }
      }else if(key === 13){
          var res = document.getElementById("result1");
          if(res && res['curSelect'] !== -1){
              selectResult(document.getElementById("result1").curSelect);
          }
      }else{
          autoSearch();
      }
  }
  //============================================================================================================
  <!--鼠标坐标获取-->
  var clickEventListener=AMap.event.addListener(mapObj,'click',function(e){
      document.getElementById("lngX").value=e.lnglat.getLng();
      document.getElementById("latY").value=e.lnglat.getLat();
  });

 // document.getElementById("keyword").onkeyup = keydown;

  function autoSearch() {
     // var keywords = document.getElementById("keyword").value;
      var auto;
      //
      AMap.service(["AMap.Autocomplete"], function() {
          var autoOptions = {
              city: "" //
          };
          auto = new AMap.Autocomplete(autoOptions);
          //
          if ( keywords.length > 0) {
              auto.search(keywords, function(status, result){
                  autocomplete_CallBack(result);
              });
          }
          else {
              document.getElementById("result1").style.display = "none";
          }
      });
  }
//===================================================================================================================
	 
//=========================================================================

    function toggleScale(checkbox) {
        if (checkbox.checked) {
            scale.show();
        } else {
            scale.hide();
        }
    }
    function toggleToolBar(checkbox) {
        if (checkbox.checked) {
            showToolBar();
            showToolBarDirection();
            showToolBarRuler();
        } else {
            hideToolBar();
            hideToolBarDirection();
            hideToolBarRuler();
        }
    }
    function toggleToolBarDirection(checkbox) {
        if (checkbox.checked) {
            toolBar.showDirection()
        } else {
            toolBar.hideDirection()
        }
    }
    function toggleToolBarRuler(checkbox) {
        if (checkbox.checked) {
            toolBar.showRuler();
        } else {
            toolBar.hideRuler();
        }
    }
    function toggleOverViewShow(checkbox) {
        if (checkbox.checked) {
            overView.show();
            document.getElementById('overviewOpen').disabled = false;
        } else {
            overView.hide();
            document.getElementById('overviewOpen').disabled = true;
        }
    }
    function toggleOverViewOpen(checkbox) {
        if (checkbox.checked) {
            overView.open();
        }
        else {
            overView.close();
        }
    }
    function showToolBar() {
        document.getElementById('toolbar').checked = true;
        document.getElementById('toolbarDirection').disabled = false;
        document.getElementById('toolbarRuler').disabled = false;
        toolBar.show();
    }
    function hideToolBar() {
        document.getElementById('toolbar').checked = false;
        document.getElementById('toolbarDirection').disabled = true;
        document.getElementById('toolbarRuler').disabled = true;
        toolBar.hide();
    }
    function showToolBarDirection() {
        document.getElementById('toolbarDirection').checked = true;
        toolBar.showDirection();
    }
    function hideToolBarDirection() {
        document.getElementById('toolbarDirection').checked = false;
        toolBar.hideDirection();
    }
    function showToolBarRuler() {
        document.getElementById('toolbarRuler').checked = true;
        toolBar.showRuler();
    }
    function hideToolBarRuler() {
        document.getElementById('toolbarRuler').checked = false;
        toolBar.hideRuler();
    }

</script>
</body>
</html>