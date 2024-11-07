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
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Component
@Slf4j
public class SocketModule {
    @Getter
    private final SocketIOServer server;
    private final SocketService socketService;
    @Getter
    private final Set<String> connectedClients = new HashSet<>();

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
//            String room = client.getHandshakeData().getSingleUrlParam("room");
//            String username = client.getHandshakeData().getSingleUrlParam("username");
            Map<String, List<String>> params = client.getHandshakeData().getUrlParams();
            String room = params.get("room").stream().collect(Collectors.joining());
            String username = params.get("username").stream().collect(Collectors.joining());

            client.joinRoom(room);
            log.info("client joined room!");
            connectedClients.add(username);

            log.info("=====Connected=====> Client: {}, room: {}, username: {}" , client.getSessionId().toString(), room, username);
//            log.info("member List: {}", connectedClients.stream()
//                                        .map(c -> c.getSessionId().toString())
//                                        .collect(Collectors.joining(",")));
            log.info("member List: {}", getConnectedClients());
        };
    }

    public DisconnectListener onDisconnected() {
        return (client) -> {
           Map<String, List<String>> params = client.getHandshakeData().getUrlParams();
            String room = params.get("room").stream().collect(Collectors.joining());
            String username = params.get("username").stream().collect(Collectors.joining());

            connectedClients.remove(username);

            log.info("=====Disconnected=====> Client: {}, room: {}, username: {}", client.getSessionId().toString(), room, username);
            log.info("member List: {}", getConnectedClients());
        };
    }
}
