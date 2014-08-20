function wydgetLoader() {
	localStorage.setItem("zipCode", "77429");
	var _day = new Date();
	var _dateDay = document.getElementsByTagName("dateDay");
	var _dateDayArray = "Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday".split("|");
	for(var i = 0; i<_dateDay.length; i++){
		_dateDay[i].innerHTML = _dateDayArray[_day.getDay()];
	}
	
	var _dateDate = document.getElementsByTagName("dateDate");
	for(var i = 0; i<_dateDate.length; i++){
		_dateDate[i].innerHTML = _day.getDate();
	}
	
	var _dateMonth = document.getElementsByTagName("dateMonth");
	var _dateMonthArray = "January|February|March|April|May|June|July|August|September|October|November|December".split("|");
	for(var i = 0; i<_dateMonth.length; i++){
		_dateMonth[i].innerHTML = _dateMonthArray[_day.getMonth()];
	}
	
	var _dateMonthNum = document.getElementsByTagName("dateMonthNum");
	for(var i = 0; i<_dateMonthNum.length; i++){
		_dateMonthNum[i].innerHTML = _day.getMonth()+1;
	}
	
	var _dateYear = document.getElementsByTagName("dateYear");
	for(var i = 0; i<_dateYear.length; i++){
		_dateYear[i].innerHTML = _day.getFullYear();
	}
	_updateTime();
	_loadWeather();
}
function _updateTime(){
	var _day = new Date();
	var _timeHour = document.getElementsByTagName("timeHour");
	var _time24Hour = document.getElementsByTagName("time24Hour");
	var _timePaddedHour = document.getElementsByTagName("timePaddedHour");
	var _timePadded24Hour = document.getElementsByTagName("timePadded24Hour");
	var _timeMin = document.getElementsByTagName("timeMin");
	var _timeSec = document.getElementsByTagName("timeSec");
	var _ampm = document.getElementsByTagName("ampm");
	
	for(var i = 0; i<_timeHour.length; i++){
		_timeHour[i].innerHTML = _day.getHours()==0?12:(_day.getHours()>12?(_day.getHours()-12):_day.getHours());
	}
	for(var i = 0; i<_time24Hour.length; i++){
		_time24Hour[i].innerHTML = _day.getHours();
	}
	
	for(var i = 0; i<_timePaddedHour.length; i++){
		_timePaddedHour[i].innerHTML =	_day.getHours()==0?12:(_day.getHours()>=10?(_day.getHours()>12?((_day.getHours()-12)>=10?(_day.getHours()-12):("0"+(_day.getHours()-12))):_day.getHours()):"0"+_day.getHours());
	}
	
	for(var i = 0; i<_timePadded24Hour.length; i++){
		_timePadded24Hour[i].innerHTML =  _day.getHours()>=10?_day.getHours():("0"+_day.getHours());
	}
	
	for(var i = 0; i<_timeMin.length; i++){
		_timeMin[i].innerHTML = (_day.getMinutes()>=10?_day.getMinutes():"0"+_day.getMinutes());
	}
	
	for(var i = 0; i<_timeSec.length; i++){
		_timeSec[i].innerHTML = (_day.getSeconds()>=10?_day.getSeconds():"0"+_day.getSeconds());
	}
	
	for(var i = 0; i<_ampm.length; i++){
		_ampm[i].innerHTML = _day.getHours()<12?"AM":"PM";
	}
	
	if((_timeHour.length + _time24Hour.length + _timePaddedHour.length + _timePadded24Hour.length + _timeMin.length + _timeSec.length + _ampm.length)!=0){
		if(_timeSec.length==0){
			setTimeout(_updateTime,1000*(60-(_day.getSeconds())-1));
		}else{
			setTimeout(_updateTime,1000);
		}
	}
}
var MiniIcons = ["tstorm3","tstorm3","tstorm3","tstorm3","tstorm2","sleet","sleet","sleet","sleet","light_rain","sleet","shower2","shower2","snow1","snow2","snow4","snow4","hail","sleet","mist","fog","fog","fog","cloudy1","cloudy1","overcast","cloudy1","cloudy4_night","cloudy4","cloudy2_night","cloudy2","sunny_night","sunny","mist_night","mist","hail","sunny","tstorm1","tstorm2","tstorm2","tstorm2","snow5","snow3","snow5","cloudy1","storm1","snow2","tstorm1","dunno"];
var updateInterval = 10;
var postal;
var localStorageString = "zipCode";
var local;
var temp;
function _loadWeather(){
	if(localStorage.getItem(localStorageString)==null)
		setTimeout(_loadWeather, 1000);
	else{
		locale = localStorage.getItem(localStorageString);
		temp = locale.split("|")[1];
		validateWeatherLocation(escape(locale.split("|")[0]).replace(/^%u/g, "%"), setPostal);
		checkZip();
	}
}
function checkZip(){
	if(localStorage.getItem(localStorageString)!=locale){
		_loadWeather();
	}else{
		setTimeout(checkZip, 1000);
	}
}
function setPostal(obj){	
	if (obj.error == false){
		if(obj.cities.length > 0){
			postal = escape(obj.cities[0].zip).replace(/^%u/g, "%");
			weatherRefresherTemp();
		}else{
			var _weatherCityArray = document.getElementsByTagName("weatherCity");
			for(var i = 0; i<_weatherCityArray.length; i++){
				_weatherCityArray[i].innerText="Not Found";
			}
		}
	}else{
		var _weatherCityArray = document.getElementsByTagName("weatherCity");
		for(var i = 0; i<_weatherCityArray.length; i++){
			_weatherCityArray[i].innerText=obj.errorString;
		}
		setTimeout('validateWeatherLocation(escape(locale).replace(/^%u/g, "%"), setPostal)', 1000*60*5);
	}
}
function dealWithWeather(obj){
	var _weatherCityArray = document.getElementsByTagName("weatherCity");
	for(var i = 0; i<_weatherCityArray.length; i++){
		_weatherCityArray[i].innerText=obj.city;
	}
	
	var _weatherDescArray = document.getElementsByTagName("weatherDesc");
	for(var i = 0; i<_weatherDescArray.length; i++){
		_weatherDescArray[i].innerText=obj.description;
	}
	
	var _weatherTempArray = document.getElementsByTagName("weatherTemp");
	for(var i = 0; i<_weatherTempArray.length; i++){
		_weatherTempArray[i].innerText=obj.temp;
	}
	
	var _weatherHighArray = document.getElementsByTagName("weatherHigh");
	for(var i = 0; i<_weatherHighArray.length; i++){
		_weatherHighArray[i].innerText=obj.high;
	}
	
	var _weatherLowArray = document.getElementsByTagName("weatherLow");
	for(var i = 0; i<_weatherLowArray.length; i++){
		_weatherLowArray[i].innerText=obj.low;
	}
	
	var _weatherIconArray = document.getElementsByTagName("weatherIcon");
	for(var i = 0; i<_weatherIconArray.length; i++){
		_weatherIconArray[i].innerHTML = "<img class='wIcon' src=" + "Images/Icons"+"/"+MiniIcons[obj.icon]+".png" + "/>";
	}
}
function weatherRefresherTemp(){
	fetchWeatherData(dealWithWeather,postal);
	setTimeout(_loadWeather, 60*1000*updateInterval);
}
function constructError (string)
{
	return {error:true, errorString:string};
}
function findChild (element, nodeName)
{
	var child;
	for (child = element.firstChild; child != null; child = child.nextSibling)
	{
		if (child.nodeName == nodeName)
			return child;
	}
	return null;
}
function fetchWeatherData (callback, zip)
{
	if(temp == "C"){
		url="http://weather.yahooapis.com/forecastrss?u=c&p=";
	}else{
		url="http://weather.yahooapis.com/forecastrss?u=f&p=";
	}
	var xml_request = new XMLHttpRequest();
	xml_request.onload = function(e) {xml_loaded(e, xml_request, callback);}
	xml_request.overrideMimeType("text/xml");
	xml_request.open("GET", url+zip);
	xml_request.setRequestHeader("Cache-Control", "no-cache");
	xml_request.send(null); 
	return xml_request;
}
function xml_loaded (event, request, callback)
{
	if (request.responseXML)
	{
		var obj = {error:false, errorString:null};
		var effectiveRoot = findChild(findChild(request.responseXML, "rss"), "channel");
		obj.city = findChild(effectiveRoot, "yweather:location").getAttribute("city");
		obj.realFeel = findChild(effectiveRoot, "yweather:wind").getAttribute("chill"); 	
		conditionTag = findChild(findChild(effectiveRoot, "item"), "yweather:condition");
		obj.temp = conditionTag.getAttribute("temp");
		obj.icon = conditionTag.getAttribute("code");
		obj.description = conditionTag.getAttribute("text"); 
		var div = document.createElement("div");
		div.innerHTML = request.responseText;
		var list = div.getElementsByTagName("yweather:forecast");
		// high and low, from yahoo weather
		obj.high = list[0].getAttribute("high");
		obj.low = list[0].getAttribute("low");
		callback (obj); 
	}else{
		callback ({error:true, errorString:"XML request failed. no responseXML"});
	}
}
function validateWeatherLocation (location, callback)
{
	var obj = {error:false, errorString:null, cities: new Array};
	obj.cities[0] = {zip: location};
	callback (obj);
}
function loadStyle(style) {
	var headID = document.getElementsByTagName("head")[0];	       
	var styleNode = document.createElement('link');
	styleNode.type = 'text/css';
	styleNode.rel = 'stylesheet';
	styleNode.href = style+'.css';
	headID.appendChild(styleNode);
}