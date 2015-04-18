
<%@ page contentType="text/html; " language="java" import="java.sql.*,java.util.ArrayList,java.io.BufferedWriter,java.io.*"%>
<html>
<body>
From MySQL<hr>
<table border=1>
<tr><td>Id</td><td>Name</td><td>Value</td></tr>

<%! String[] weekday = {"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"};%>
<%!
class Data
{
    public String name;
    public String data;
public Data(String name, String data)
   {
      this.name = name;   
      this.data = data; 
   }
}
%>
<%! ArrayList<Data> dbdata = new ArrayList<Data>();%>
<%! ArrayList<Data> dbdata1 = new ArrayList<Data>();%>
<%
	ArrayList<Data> dbdata = new ArrayList<Data>();

   Class.forName("com.mysql.jdbc.Driver").newInstance();
   Connection con=java.sql.DriverManager.getConnection("jdbc:mysql://localhost/cs5224","root","root");
   Statement stmt=con.createStatement();
    ResultSet rst=stmt.executeQuery("select * from area");
    while(rst.next())
    {
        out.println("<tr>");
        out.println("<td>"+rst.getString("id")+"</td>");
        out.println("<td>"+rst.getString("name")+"</td>");
        out.println("<td>"+rst.getString("weekdaydata")+"</td>");
        out.println("</tr>");
	//String[] split_data = rst.getString("weekdaydata").split(",");
	//int[] int_data = new int[7];
	//for (int i = 0; i < 7; i++) {
   	//     int_data[i] = Integer.parseInt(split_data[i]);
	//}
	dbdata.add(new Data(rst.getString("name"),rst.getString("weekdaydata")));
		
    }
    ResultSet rst1=stmt.executeQuery("select * from pie");
    while(rst1.next())
    {
        out.println("<tr>");
        out.println("<td>"+rst1.getString("id")+"</td>");
        out.println("<td>"+rst1.getString("name")+"</td>");
        out.println("<td>"+rst1.getString("value")+"</td>");
        out.println("</tr>");
	dbdata1.add(new Data(rst1.getString("name"),rst1.getString("value")));
		
    }
    rst1.close();
    stmt.close();
    con.close();
%>


<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<json:object> 
	<json:object name="title">
		<json:property name="text" value="Area"/>
		<json:property name="subtext" value="Simple area"/>
	</json:object>
	<json:object name="tooltip">
		<json:property name="trigger" value="axis"/>
	</json:object>
	<json:object name="legend">
		<json:array name="data" items="${name}"/>
	</json:object>
	<json:object name="toolbox">
		<json:property name="show" value="${true}" />
		<json:object name="feature">
			<json:object name="saveAsImage">
				<json:property name="show" value="${true}" />
			</json:object>
		</json:object>
	</json:object>
	<json:property name="calculable" value="${false}" />
	<json:array name="xAxis">
	<json:object>
		<json:property name="type" value="category"/>
		<json:property name="boundaryGap" value="${false}" />
		<json:array name="data" items="<%=weekday%>"/>
	</json:object>
	</json:array>
	<json:array name="yAxis">
	<json:object>
		<json:property name="type" value="value"/>
		<json:object name="axisLabel">
			<json:property name="formatter" value="{value}"/>
		</json:object>
	</json:object>
	</json:array>
	<json:array name="series" var="item" items="$1">
	<json:object>
		<json:property name="name" value="$1"/>
		<json:property name="type" value="line"/>
		<json:property name="smooth" value="${true}"/>
		<json:object name="itemStyle">
			<json:object name="normal">
				<json:object name="areaStyle">
					<json:property name="type" value="default"/>
				</json:object>
			</json:object>
		</json:object>
		<json:array name="data" items="1"/>
	</json:object>
	</json:array>
</json:object>

<%
String str ="{\"title\":{\"text\":\"Area\",\"subtext\":\"Simple area\"},\"tooltip\":{\"trigger\":\"axis\"},\"legend\":{\"data\":[";
for (int i = 0; i < dbdata.size()-1; i++) {
	String name = "\""+dbdata.get(i).name+"\",";
	str+=name;
}
str+="\""+dbdata.get(dbdata.size()-1).name+"\"";
str+= "]},\"toolbox\":{\"show\":true,\"feature\":{\"saveAsImage\":{\"show\":true}}},\"calculable\":false,\"xAxis\":[{\"type\":\"category\",\"boundaryGap\":false,\"data\":[\"Monday\",\"Tuesday\",\"Wednesday\",\"Thursday\",\"Friday\",\"Saturday\",\"Sunday\"]}],\"yAxis\":[{\"type\":\"value\",\"axisLabel\":{\"formatter\":\"{value}\"}}],\"series\":[";
for (int i = 0; i < dbdata.size(); i++) {
	str+="{\"name\":";
	String name = "\""+dbdata.get(i).name+"\"";
	String data = dbdata.get(i).data;
	str+=name;
	str+=",\"type\":\"line\",\"smooth\":true,\"itemStyle\":{\"normal\":{\"areaStyle\":{\"type\":\"default\"}}},\"data\":["+data+"]}";
	if(i<dbdata.size()-1){
		str+=",";
	}
	else{
		str+="]}";
	}
}

//out.println(str);
String str2="{\"title\":{\"text\":\"Bar\",\"subtext\":\"BarChart\",\"x\":\"center\"},\"tooltip\":{\"show\":\"true\"},\"legend\":{\"data\":[\"Occurrence\"],\"x\":\"center\",\"y\":\"bottom\"},\"toolbox\":{\"show\":\"true\",\"feature\":{\"saveAsImage\":{\"show\":\"true\"}}},\"xAxis\":[{\"type\":\"category\",\"data\":[";
for (int i = 0; i < dbdata1.size(); i++) {
	str2+= "\""+dbdata1.get(i).name+"\"";
	if(i<dbdata1.size()-1){
		str2+=",";
	}
}
//\Endodontics"\,"\Periodontics"\,"\Orthodontics"\,"\Pediatrics"\]
str2+="]}],\"yAxis\":[{\"type\":\"value\"}],\"series\":[{\"name\":\"Occurrence\",\"type\":\"bar\",\"itemStyle\":{\"normal\":{\"color\":\"#000000\"},\"emphasis\":{\"color\":\"#ffffff\"}},\"data\":[";
for (int i = 0; i < dbdata1.size(); i++) {
	str2+=dbdata1.get(i).data;
	if(i<dbdata1.size()-1){
		str2+=",";
	}
	else{
		str2+="]}]}";
	}
}
String str3="{\"title\":{\"text\":\"polyline\",\"subtext\":\"example\"},\"tooltip\":{\"trigger\":\"axis\"},\"legend\":{\"data\":[\"DentalCases\",\"DengueFever\"]},\"toolbox\":{\"show\":true,\"feature\":{\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"category\",\"boundaryGap\":false,\"data\":[\"Monday\",\"Tuesday\",\"Wednesday\",\"Thursday\",\"Friday\",\"Saturday\",\"Sunday\"]}],\"yAxis\":[{\"type\":\"value\",\"axisLabel\":{\"formatter\":\"{value}\"}}],\"series\":[";
for (int i = 0; i < dbdata.size(); i++) {
	str3+="{\"name\":";
	String name = "\""+dbdata.get(i).name+"\"";
	String data = dbdata.get(i).data;
	str3+=name;
	str3+=",\"type\":\"line\",\"smooth\":true,\"data\":["+data+"]}";
	if(i<dbdata.size()-1){
		str3+=",";
	}
	else{
		str3+="]}";
	}
}
String str4="{\"title\":{\"text\":\"Pie\",\"subtext\":\"PieChart\",\"x\":\"center\"},\"tooltip\":{\"trigger\":\"item\",\"formatter\":\"{a}<br/>{b}:{c}({d}%)\"},\"legend\":{\"orient\":\"vertical\",\"x\":\"left\",\"data\":[";
for (int i = 0; i < dbdata1.size(); i++) {
	str4+= "\""+dbdata1.get(i).name+"\"";
	if(i<dbdata1.size()-1){
		str4+=",";
	}
}
//out.println(str4);
str4+="]},\"toolbox\":{\"show\":true,\"feature\":{\"saveAsImage\":{\"show\":true}}},\"series\":[{\"name\":\"Source\",\"type\":\"pie\",\"radius\":\"55%\",\"center\":[\"50%\",\"60%\"],\"data\":[";
for (int i = 0; i < dbdata1.size(); i++) {
	str4+="{\"value\":"+dbdata1.get(i).data+",\"name\":\""+dbdata1.get(i).name+"\"}";
	if(i<dbdata1.size()-1){
		str4+=",";
	}
	else{
		str4+="]}]}";
	}
}
try {   
    PrintWriter pw = new PrintWriter(new FileOutputStream("/var/lib/tomcat7/webapps/CS5224project/data/bar.json"));
    pw.println(str2);
    //clean up
    pw.close();
} catch(IOException e) {
   out.println(e.getMessage());
}
try {   
    PrintWriter pw = new PrintWriter(new FileOutputStream("/var/lib/tomcat7/webapps/CS5224project/data/area.json"));
    pw.println(str);
    //clean up
    pw.close();
} catch(IOException e) {
   out.println(e.getMessage());
}
try {   
    PrintWriter pw = new PrintWriter(new FileOutputStream("/var/lib/tomcat7/webapps/CS5224project/data/line.json"));
    pw.println(str3);
    //clean up
    pw.close();
} catch(IOException e) {
   out.println(e.getMessage());
}
try {   
    PrintWriter pw = new PrintWriter(new FileOutputStream("/var/lib/tomcat7/webapps/CS5224project/data/pie.json"));
    pw.println(str4);
    //clean up
    pw.close();
} catch(IOException e) {
   out.println(e.getMessage());
}

%>


</table>
</body>
</html>