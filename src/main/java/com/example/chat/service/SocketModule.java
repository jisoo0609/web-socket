package com.example.chat.service;

import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.ConnectListener;
import com.corundumstudio.socketio.listener.DataListener;
import com.corundumstudio.socketio.listener.DisconnectListener;
import com.example.chat.model.Message;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Component
@Slf4j
public class SocketModule {
    @Getter
    private final SocketIOServer server;
    private final SocketService socketService;
    @Getter
    private final Set<SocketIOClient> connectedClients = new HashSet<>();

    public SocketModule(SocketIOServer socketServer, SocketService socketService) {
        this.server = socketServer;
        this.socketService = socketService;
        // 누군가 소켓에 연결하면 실행
        server.addConnectListener(onConnected());
        // 누군가 소켓에서 연결 끊을 때 실행
        server.addDisconnectListener(onDisconnected());
        socketServer.addEventListener("send_message", Message.class, onChatReceived());
    }

    public DataListener<Message> onChatReceived() {
        return (senderClient, data, ackSender) -> {
            log.info("data: {}", data.toString());
            // 모든 클라이언트에게 데이터 broadcasting
            socketService.sendMessage(data.getRoom(), "get_message", senderClient, data.getMessage());
            log.info("get_Message : {}", data.getMessage());
        };
    }

    public ConnectListener onConnected() {
        return (client) -> {
            String room = client.getHandshakeData().getSingleUrlParam("room");
            String username = client.getHandshakeData().getSingleUrlParam("username");
            client.joinRoom(room);
            connectedClients.add(client);
            log.info("=====Connected=====> Client: {}, room: {}, username: {}" , client.getSessionId().toString(), room, username);
            log.info("member List: {}", connectedClients.stream()
                                        .map(c -> c.getSessionId().toString())
                                        .collect(Collectors.joining(",")));
        };
    }

    public DisconnectListener onDisconnected() {
        return (client) -> {
            String room = client.getHandshakeData().getSingleUrlParam("room");
            String username = client.getHandshakeData().getSingleUrlParam("username");
            connectedClients.remove(client);
            log.info("=====Disconnected=====> Client: {}, room: {}, username: {}", client.getSessionId().toString(), room, username);
        };
    }
}
