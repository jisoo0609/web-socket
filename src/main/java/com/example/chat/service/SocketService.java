package com.example.chat.service;

import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.example.chat.model.Message;
import com.example.chat.model.MessageType;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class SocketService {
    public void sendMessage(String room, String eventName, SocketIOClient senderClient, String username, String enterDate) {
        log.info("=====sendMessage=====");
        for (SocketIOClient client : senderClient.getNamespace().getRoomOperations(room).getClients()) {
            log.info("Checking client: " + client.getSessionId());

            if (!client.getSessionId().equals(senderClient.getSessionId())) {
                log.info("===broadcasting to client: " + client.getSessionId());
                try {
                    client.sendEvent(eventName, new Message(MessageType.SERVER, username, enterDate));
                    log.info("Message sent to client: " + client.getSessionId());
                } catch (Exception e) {
                    e.printStackTrace();
                    log.error("Error sending message to client: " + client.getSessionId(), e);
                }
            } else {
                log.info("Skipping sender client: " + senderClient.getSessionId());
            }
        }
    }
}
