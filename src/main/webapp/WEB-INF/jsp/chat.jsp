<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>WebSocket Chatting</title>
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
        <label for="message"></label>
        <input type="text" id="message" placeholder="Write a message..." />

        <button type="submit">Send</button>
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
        socket.emit('send_message', {
            username: username,
            message: username+'님이 입장했습니다.',
            type: 'SERVER',
            room: room,
            date: getFormattedDateTime()
        });
    });

    // 메시지 수신 처리
    socket.on('get_message', (data) => {
        console.log(data);
        const chatMessage = document.createElement('div');

        if (data.type === 'SERVER') {
            chatMessage.classList.add('notice-message');
        } else {
            chatMessage.classList.add('chat-message');
        }

        const message = document.createElement('p');
        message.innerText = `${data.username}: ${data.date}`;

        chatMessage.appendChild(message);
        document.getElementById('response').appendChild(chatMessage);

        // 스크롤을 항상 하단으로 설정
        const responseDiv = document.getElementById('response');
        responseDiv.scrollTop = responseDiv.scrollHeight;
    });

    // 채팅폼 제출 시 메시지 보내기
    document.getElementById('chat-form').addEventListener('submit', (e) => {
        e.preventDefault();  // 기본 제출 동작을 막기

        const messageInput = document.getElementById('message');
        const messageContent = messageInput.value;  // 사용자가 입력한 메시지 가져오기

        if (messageContent.trim() !== "") {  // 빈 메시지 보내지 않기
            // 메시지 객체 생성
            const message = {
                type: 'CLIENT',   // 메시지 유형 (텍스트)
                room: room,     // 방 이름
                message: messageContent,  // 사용자가 입력한 메시지 내용
                username: username   // 보낸 사람 이름
            };

            // 메시지 전송
            socket.emit('send_message', message);
            messageInput.value = '';  // 입력 필드 초기화
        }
    });


    // 브라우저를 닫을 때, 퇴장 메시지 보내기
    window.addEventListener('beforeunload', () => {
        socket.emit('send_message', {
            username: username,
            message: username+`님이 퇴장했습니다.`,
            type: 'SERVER',
            room: room,
            date: getFormattedDateTime()
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