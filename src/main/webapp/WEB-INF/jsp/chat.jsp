<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>WebSocket Chatting</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        #room-name {
            text-align: center;
            color: #444;
        }
        #conversation {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        #response {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background: #f9f9f9;
        }
        form {
            display: flex;
            justify-content: space-between;
        }
        input[type="text"] {
            flex: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-right: 10px;
        }
        button {
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            background-color: #4cae4c;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #1E90FF;
        }
        p {
            margin: 5px 0;
        }

        .chat-message {
            background: #e9ecef;
            border-radius: 5px;
            padding: 10px;
            margin: 5px 0;
            max-width: 80%;
            display: inline-block;
            clear: both;
        }

        .notice-message {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            border-radius: 5px;
            padding: 10px;
            margin: 5px 0;
            max-width: 80%;
            display: block;
            font-weight: bold;
            clear: both;
        }
        #response {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background: #f9f9f9;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }
        #member-list {
            position: relative;
            top: 20px;
            left: 20px;
            width: 250px;
            background-color: #f4f4f9;
            padding: 20px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            z-index: 1000;
        }
    </style>
</head>
<body>
<div class="member-list" id="member-list">
    <h3>Connected Member List</h3>
    <table>
        <c:forEach items="${memberList}" var="member">
            <tr>
                <td>${member}</td>
            </tr>
        </c:forEach>
    </table>
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

    // 서버 연결 후, 입장 알림 메시지 보내기
    socket.on('connect', () => {
        socket.emit('send_message', {
            username: 'notice',
            message: username+`님이 입장했습니다.`,
            type: 'SERVER',
            room: room
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
        message.innerText = `${data.username}: ${data.message}`;

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
            room: room
        });
    });
</script>
</body>
</html>