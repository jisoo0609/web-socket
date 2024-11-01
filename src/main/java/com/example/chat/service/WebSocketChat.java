package com.example.chat.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@Slf4j
@Service
@ServerEndpoint("/ws/chat")
public class WebSocketChat {
    // 클라이언트의 session 정보 저장
    private static Set<Session> clients = Collections.synchronizedSet(new HashSet<Session>());

    // 클라이언트가 접속할 때마다 실행
    @OnOpen
    public void onOpen(Session session) throws IOException {
        log.info("open session : {}, clients={}", session.toString(), clients);
        
        if (!clients.contains(session)) {
            clients.add(session);
            log.info("session open : {}", session);
        } else {
            log.info("session already exists : {}", session);
        }
    }

    // 메세지 수신 시
    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        log.info("receive message : {}", message);
        
        for (Session client : clients) {
            log.info("send data : {}", message);
            client.getBasicRemote().sendText(message);
        }
    }
    
    // 클라이언트가 접속을 종료할 시
    @OnClose
    public void onClose(Session session) throws IOException {
        log.info("session close : {}", session);
        clients.remove(session);
    }
}
