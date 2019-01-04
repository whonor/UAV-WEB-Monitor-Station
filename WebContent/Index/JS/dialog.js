/**
 * 点击一键启动按钮弹出对话框
 */
function Dialog(){
	ID = prompt("请输入无人机id编号：", "");
	if(ID != null && ID != ""){
		webSocket.send(ID);
		alert("success!");
	}else{
		return null;
	}
}