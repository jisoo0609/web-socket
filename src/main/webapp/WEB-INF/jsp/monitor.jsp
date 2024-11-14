<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>WebSocket Chatting</title>
    <link rel="stylesheet" href="/css/monitor.css">
    <style>
        #attendeePopup .close-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
        }

        /* 종료 버튼 스타일 */
        #attendeePopup .end-btn {
            display: block;
            width: 100%;
            padding: 10px;
            margin-top: 20px;
            background-color: deepskyblue;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        #attendeePopup .end-btn:hover {
            background-color: dodgerblue;
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
        <tbody id="attendees-list">


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
    var username = (new URLSearchParams(location.search)).get('username');
    var room = 'test';
    var socketUrl = 'http://localhost:8081';

    const socket = io.connect(socketUrl,{
        query : {
            room : room,
            username : username
        },
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

    function addMessageToChat(data) {
        const responseDiv = document.getElementById('attendees-list');

        // 이미 같은 username의 메시지가 있는지 확인
        const existingMessage = Array.from(responseDiv.getElementsByTagName('tr')).find(chatMessage => {
            const message = chatMessage.querySelector('td');
            return message && message.innerText.includes('이름: ' + data.username);
        });

        // 이미 동일한 username이 있다면, 메시지를 추가하지 않음
        if (existingMessage) {
            return;
        }

        const row = document.createElement('tr');  // 새로운 테이블 행(tr) 생성

        // 참석자명 (이름)
        const nameCell = document.createElement('td');
        nameCell.innerText = data.username;
        row.appendChild(nameCell);

        // 입장 시간
        const entryTimeCell = document.createElement('td');
        entryTimeCell.innerText = data.enterDate;
        row.appendChild(entryTimeCell);

        // 퇴장 시간
        const exitTimeCell = document.createElement('td');
        exitTimeCell.innerText = data.exitDate || ''; //
        row.appendChild(exitTimeCell);

        // 강퇴 버튼
        const actionCell = document.createElement('td');
        const kickButton = document.createElement('button');
        kickButton.innerText = '강퇴';
        kickButton.classList.add('kick-btn');
        kickButton.addEventListener('click', function() {
            kickUser(data.username);
        });
        actionCell.appendChild(kickButton);
        row.appendChild(actionCell);

        // 테이블에 행 추가
        responseDiv.appendChild(row);

        // 스크롤을 가장 아래로 이동
        responseDiv.scrollTop = responseDiv.scrollHeight;
    }

    // 페이지 로드 시 테이블을 렌더링
    window.onload = renderTable;

</script>
</body>
</html>
