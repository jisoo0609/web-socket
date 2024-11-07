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
        h3 {
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
    </style>
</head>
<body>
<h3 id="room-name"></h3>
<div id="conversation">
    <div id="response"></div>
    <form id="chat-form">
        <h4>
            <span id="username-holder"></span>
        </h4>
        <label for="message"></label><input type="text" id="message" placeholder="Write a message..."/>
        <button type="submit">Send</button>
    </form>
</div>
<script src="https://cdn.socket.io/4.7.1/socket.io.min.js"></script>
<script>
    const username = (new URLSearchParams(location.search)).get('username');
    const room = 'test';
    console.log("username: ", username);
    document.getElementById('username-holder').innerText = username;

    // Socket.io 연결
    const socket = io('http://localhost:8081', {
        query: {
            room: room,
            username: username
        }
    });

    // 채팅방 입장 시 공지 전송
    socket.on('connect', () => {
        socket.emit('get_message', {
            username: 'notice',
            message: username + '님이 입장했습니다.'
        });
    });

    // 메시지 수신 시
    socket.on('chat-message', (data) => {
        console.log(data);
        const chatMessage = document.createElement('div');

        // 공지 메시지인지 확인
        if (data.username === 'notice') {
            chatMessage.classList.add('notice-message');
        } else {
            chatMessage.classList.add('get_message');
        }

        const message = document.createElement('p');
        message.innerText = `${data.username}: ${data.message}`;

        chatMessage.appendChild(message);
        document.getElementById('response').appendChild(chatMessage);

        // 스크롤을 항상 하단으로 설정
        const responseDiv = document.getElementById('response');
        responseDiv.scrollTop = responseDiv.scrollHeight;
    });

    // 채팅방 퇴장 시
    window.addEventListener('beforeunload', () => {
        socket.emit('get_message', {
            username: username,
            message: username + '님이 퇴장했습니다.'
        });
    });

    // 메시지 전송
    document.getElementById('chat-form').addEventListener('submit', (e) => {
        e.preventDefault();
        const messageInput = document.getElementById('message');
        const message = messageInput.value;

        socket.emit('get_message', {
            username: username,
            message: message
        });

        messageInput.value = '';
    });

</script>
</body>
</html>