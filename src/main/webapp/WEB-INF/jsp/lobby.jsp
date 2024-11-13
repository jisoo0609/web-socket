<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
    <title>WebSocket Chat</title>
    <link rel="stylesheet" href="/css/main.css">
</head>
<body>
<div id="username-page">
    <div class="username-page-container">
        <h1 class="title">이름을 입력하세요</h1>
        <form id="enter-form" name="usernameForm" action="/chat/monitor">
            <div class="form-group">
                <label for="username">
                    <input type="text" id="username" name="username" placeholder="Input Username" autocomplete="off" class="form-control">
                </label>
            </div>
            <div class="form-group">
                <button id="enter-button" class="accent username-submit" type="submit">채팅 시작하기</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>