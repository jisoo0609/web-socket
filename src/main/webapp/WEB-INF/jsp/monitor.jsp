<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>WebSocket Chatting</title>
    <link rel="stylesheet" href="/css/monitor.css">
    <style>
        /* 팝업 창의 높이를 고정하고, 세로 스크롤을 추가 */
        #attendeePopup {
            display: none; /* 팝업 숨김 */
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 600px; /* 폭을 500px로 설정 */
            height: 50%; /* 팝업 높이를 고정 (화면의 80%로 설정) */
            max-height: 80%; /* 팝업의 최대 높이를 80%로 설정 */
            padding: 20px;
            background-color: white;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            z-index: 1000; /* 팝업을 가장 위로 띄움 */
            overflow-y: auto; /* 세로 방향으로 스크롤이 생기도록 */
        }

        /* 테이블 스타일 - 기본 테이블 레이아웃으로 되돌림 */
        #attendeePopup table {
            width: 100%;
            border-collapse: collapse; /* 테이블 셀 간 경계가 붙도록 설정 */
            margin-top: 10px;
        }

        #attendeePopup th, #attendeePopup td {
            padding: 15px;
            text-align: center;
            font-size: 16px;
            border: 1px solid #ddd;
        }

        /* 테이블 헤더 스타일 */
        #attendeePopup th {
            background-color: #f4f4f4;
        }
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
    <!-- 참석자 목록을 표시하는 테이블 -->
    <table>
        <thead>
        <tr>
            <th>참석자명</th>
            <th>입장 시간</th>
            <th>퇴장 시간</th>
            <th>기능</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>참석자 1</td>
            <td>2024-11-13 10:00</td>
            <td>2024-11-13 12:00</td>
            <td><button class="kick-btn">강퇴</button></td>
        </tr>
        <tr>
            <td>참석자 2</td>
            <td>2024-11-13 10:05</td>
            <td>2024-11-13 12:05</td>
            <td><button class="kick-btn">강퇴</button></td>
        </tr>
        <tr>
            <td>참석자 3</td>
            <td>2024-11-13 10:10</td>
            <td>2024-11-13 12:10</td>
            <td><button class="kick-btn">강퇴</button></td>
        </tr>
        <tr>
            <td>참석자 4</td>
            <td>2024-11-13 10:10</td>
            <td>2024-11-13 12:10</td>
            <td><button class="kick-btn">강퇴</button></td>
        </tr>
        </tbody>
    </table>
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
