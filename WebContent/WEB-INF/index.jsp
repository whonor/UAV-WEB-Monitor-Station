<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script type="text/javascript">
        //先检验能不能运行起来，能不能连上，自动推送数据，先不做数据显示
        //客户端就会与服务器进行连接
        var webSocket = new WebSocket("ws://127.0.0.1:8080/WebSocketDemo/SendData");
        
        //这里只是调试用
        //连接失败时回调
        webSocket.onerror = function (event) {
            makeDataOnWeb("error");
        };

        //这里只是调试用
        //连接成功时回调，真的会执行括号中的代码！
        webSocket.onopen = function (event) {
            makeDataOnWeb("connection success");
        };

        webSocket.onmessage = function (event) {
        	
            makeDataOnWeb(event.data);
        };

        //这里只是调试用
        webSocket.onclose = function (event) {
            makeDataOnWeb("connection close");
        };

        function makeDataOnWeb(data) {
            var a = data;
            var divNode = document.getElementById("view");
            var liNode = document.createElement("li");
            liNode.innerHTML = a;
            divNode.appendChild(liNode);
//            divNode.insertBefore(liNode, divNode.children[0]);
            //不能用insertAfter，好像不是这么用的

            //            var divNode = document.getElementById("view");
//            var trNode = document.createElement("tr");
//            var td1 = document.createElement("td");
//            var td2 = document.createElement("td");
//            var td3 = document.createElement("td");
//            td1.innerHTML = a;
//            td2.innerHTML = a;
//            td3.innerHTML = a;
//            trNode.appendChild(td1)
//            trNode.appendChild(td2)
//            trNode.appendChild(td3)
            //var head = document.getElementById("head");

//            document.write(a+"<br>");//直接写
//            document.getElementsById("a").innerHTML="fadfadfa";//不输出任何内容

        };

    </script>
</head>
<body>
<div id="view"></div>
</body>
</html>