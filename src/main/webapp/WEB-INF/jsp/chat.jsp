<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>socket.io Demo</title>
    <link rel="stylesheet" href="/css/chat.css">
</head>
<body>
<button type="button" onclick="getMemberList()">Connected Member List</button>
<div id="member-list">
    <div id="members"></div>
    <button type="button" onclick="buttonClose()">Close</button>
</div>
<h3 class="room-name" id="room-name">Room</h3>

<div id="conversation">
    <div id="response"></div>
    <form id="chat-form">
        <h4><span id="username-holder"></span></h4>
    </form>
</div>
<script src="https://cdn.socket.io/4.7.1/socket.io.min.js"></script>
<script>
    const username = (new URLSearchParams(location.search)).get('username');
    const room = 'test';
    let members = document.getElementById('member-list');
    console.log("username: ", username);
    document.getElementById('username-holder').innerText = username;

    const socket = io('http://localhost:8081', {
        query: {
            room: room,
            username: username
        }
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

    // 서버 연결 후, 입장 알림 메시지 보내기
    socket.on('connect', () => {
        console.log("connected socket")
        const data = {
            username: username,
            type: 'SERVER',  // 서버 메시지로 구분
            room: room,
            enterDate: getFormattedDateTime()
        };
        socket.emit("send_message", data);
        addMessageToChat(data);
    });

    function addMessageToChat(data) {
        const responseDiv = document.getElementById('response');

        // 이미 같은 username의 메시지가 있는지 확인
        const existingMessage = Array.from(responseDiv.getElementsByTagName('div')).find(chatMessage => {
            const message = chatMessage.querySelector('p');
            return message && message.innerText.includes('이름: ' + data.username);
        });

        // 이미 동일한 username이 있다면, 메시지를 추가하지 않음
        if (existingMessage) {
            return;
        }

        const chatMessage = document.createElement('div');
        const message = document.createElement('p');

        message.innerText = "이름: " + data.username + "\t입장 시간: " + data.enterDate + "\t퇴장시간: "+data.exitDate;

        // 강퇴 버튼 생성
        const kickButton = document.createElement('button');
        kickButton.innerText = '강퇴';
        kickButton.addEventListener('click', function() {
            kickUser(data.username);
        });

        chatMessage.appendChild(message);
        responseDiv.appendChild(chatMessage);

        responseDiv.scrollTop = responseDiv.scrollHeight;
    }

    socket.on('get_message', (data) => {
        console.log('Received message:', data);
        addMessageToChat(data);
    });

    // 브라우저를 닫을 때, 퇴장 메시지 보내기
    window.addEventListener('beforeunload', () => {
        socket.emit('send_message', {
            username: username,
            type: 'SERVER',
            room: room,
            exitDate: getFormattedDateTime()
        });
    });

    function getMemberList() {
        socket.emit('get_member_list', null, (members) => {
            let memberListContainer = document.getElementById('members');
            memberListContainer.innerHTML = '';  // 기존 목록 초기화
            members.forEach((member) => {
                let memberItem = document.createElement('p');
                memberItem.innerText = member;
                memberListContainer.appendChild(memberItem);
            });

            // 'member-list' 영역을 보이게 하기
            document.getElementById('member-list').style.display = 'block';
        });
    }

    // 'Close' 버튼 클릭 시 'member-list' 영역 숨기기
    function buttonClose() {
        document.getElementById('member-list').style.display = 'none';  // 목록 숨기기
    }
</script>
</body>
</html>