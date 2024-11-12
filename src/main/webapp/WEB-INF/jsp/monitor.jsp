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
    <h3>참석자 목록</h3>
    <ul>
        <li>참석자 1</li>
        <li>참석자 2</li>
        <li>참석자 3</li>
    </ul>
</div>

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
</script>
</body>
</html>
