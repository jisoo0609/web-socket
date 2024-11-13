<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>WebSocket Chatting</title>
    <link rel="stylesheet" href="/css/monitor.css">
    <style>

    </style>
</head>
<body>
<div id="container">
    <div id="eventName">행사명</div>
    <div class="container">
        <div class="video-container">
            <div id="video">영상</div>
            <div id="attend">
                <button id="attendBtn">참석자</button>
            </div>
        </div>
        <div id="slide">슬라이드</div>
    </div>
    <div id="message">메시지 표시창</div>
</div>

<div id="attendeePopup">
    <button class="close-btn" id="closePopup">&times;</button>
    <h3>참석자</h3>
    <ul>
        <li>
            참석자 1
            <button class="kick-btn">강퇴</button>
        </li>
        <li>
            참석자 2
            <button class="kick-btn">강퇴</button>
        </li>
        <li>
            참석자 3
            <button class="kick-btn">강퇴</button>
        </li>
    </ul>
    <button class="end-btn">종료</button>
</div>
<script src="https://cdn.socket.io/4.7.1/socket.io.min.js"></script>
<script>
    // 참석자 버튼 클릭 시 팝업 표시
    document.getElementById('attendBtn').addEventListener('click', function() {
        document.getElementById('attendeePopup').style.display = 'block';
    });

    // 팝업 닫기 버튼 클릭 시 팝업 숨김
    document.getElementById('closePopup').addEventListener('click', function() {
        document.getElementById('attendeePopup').style.display = 'none';
    });

    // 팝업 외부 클릭 시 팝업 닫기
    window.addEventListener('click', function(event) {
        const popup = document.getElementById('attendeePopup');
        if (event.target === popup) {
            popup.style.display = 'none';
        }
    });

    var room = 'test';
    var socketUrl = 'http://localhost:8081';

    const socket = io.connect(socketUrl,{
        //'transport': ['xhr-polling'],
        'secure': false,
        'reconnect': true,
        'reconnection delay': 500,
        'max reconnection attempts': 3,
        'sync disconnect on unload': false
    });

    function getFormattedDateTime() {
        var today = new Date();

        var year = today.getFullYear();
        var month = ('0' + (today.getMonth() + 1)).slice(-2);
        var day = ('0' + today.getDate()).slice(-2);

        var hours = ('0' + today.getHours()).slice(-2);
        var minutes = ('0' + today.getMinutes()).slice(-2);
        var seconds = ('0' + today.getSeconds()).slice(-2);

        var dateString = year + '-' + month  + '-' + day;
        var timeString = hours + ':' + minutes  + ':' + seconds;

        return dateString + " " + timeString;
    }

    socket.on('connect', () => {
        console.log("connected socket");
        const data = {
            username : username,
            room : room,
            enterDate: getFormattedDateTime()
        };
        socket.emit("send_message", data);
        addMessageToChat(data);
    });


</script>
</body>
</html>
