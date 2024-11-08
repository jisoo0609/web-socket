package com.example.chat.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Message {
    @Enumerated(EnumType.STRING)
    private MessageType type;
    private String message;
    private String room;
    private String username;
    private String date;  // 입장시간

    public Message(MessageType type, String username, String date) {
        this.type = type;
        this.username = username;
        this.date = date;
    }
}


