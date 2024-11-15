package com.example.chat.service;

import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.ConnectListener;
import com.corundumstudio.socketio.listener.DataListener;
import com.corundumstudio.socketio.listener.DisconnectListener;
import com.example.chat.model.Message;
import com.example.chat.model.MessageType;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Component
@Slf4j
public class SocketIOHandler {
    @Getter
    private final SocketIOServer server;
    private final SocketService socketService;
    @Getter
    private final List<String> memberList = new ArrayList<>();
    @Getter
    private final Map<String, Message> attend = new HashMap<>();

    public SocketIOHandler(SocketIOServer socketServer, SocketService socketService) {
        this.server = socketServer;
        this.socketService = socketService;
        // 누군가 소켓에 연결하면 실행
        server.addConnectListener(onConnected());
        // 누군가 소켓에서 연결 끊을 때 실행
        server.addDisconnectListener(onDisconnected());

        socketServer.addEventListener("send_message", Message.class, onChatReceived());
        socketServer.addEventListener("get_member_list", Void.class, (client, data, ackSender) -> {
                ackSender.sendAckData(memberList);
        });
        socketServer.addEventListener("attend_list", Void.class, (client, data, ackSender) -> {
            ackSender.sendAckData(attend);
        });
        socketServer.addEventListener("disconnect_all", Void.class, (client, data, ackSender) -> {
            disconnectAllClient();
        });
    }

    public DataListener<Message> onChatReceived() {
        return (senderClient, data, ackSender) -> {
            log.info("=========onChatReceived===============");
            log.info("data: {}", data.toString());
            // 모든 클라이언트에게 데이터 broadcasting
            socketService.sendMessage(data.getRoom(), "get_message", senderClient, data.getUsername(), data.getEnterDate());
        };
    }

    public ConnectListener onConnected() {
        return (client) -> {
            Map<String, List<String>> params = client.getHandshakeData().getUrlParams();
            String room = params.get("room").stream().collect(Collectors.joining());
            String username = params.get("username").stream().collect(Collectors.joining());

            client.joinRoom(room);

            log.info("client joined room!");

            String enterDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            Message message = Message.builder()
                    .type(MessageType.SERVER)
                    .username(username)
                    .room(room)
                    .enterDate(enterDate)
                    .build();

            attend.put(username, message);

            log.info("=====Connected=====> Client: {}, room: {}, username: {}" , client.getSessionId().toString(), room, username);
            log.info(attend.toString());
        };
    }

    public DisconnectListener onDisconnected() {
        return (client) -> {
            Map<String, List<String>> params = client.getHandshakeData().getUrlParams();
            String room = params.get("room").stream().collect(Collectors.joining());
            String username = params.get("username").stream().collect(Collectors.joining());

            memberList.remove(username);

            String exitDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            Message message = attend.get(username);
            message.setExitDate(exitDate);

            attend.put(username, message);

            log.info("=====Disconnected=====> Client: {}, room: {}, username: {}", client.getSessionId().toString(), room, username);
            log.info(attend.toString());
        };
    }

    // 전체 연결 해제
    public void disconnectAllClient() {
        List<SocketIOClient> clients = server.getAllClients()
                .stream().map(SocketIOClient.class::cast).collect(Collectors.toList());
        for (SocketIOClient client : clients) {
            Map<String, List<String>> params = client.getHandshakeData().getUrlParams();
            String room = params.get("room").stream().collect(Collectors.joining());
            String username = params.get("username").stream().collect(Collectors.joining());

            String exitDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            Message message = attend.get(username);
            message.setExitDate(exitDate);

            attend.put(username, message);

            client.disconnect();
            log.info("=====Disconnected=====> Client: {}, room: {}, username: {}", client.getSessionId().toString(), room, username);
        }
    };
}
