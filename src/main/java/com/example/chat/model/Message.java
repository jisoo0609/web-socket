package com.example.chat.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import java.text.SimpleDateFormat;
import java.util.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Message {
    @Enumerated(EnumType.STRING)
    private MessageType type;
    private String room;
    private String username;
    private String enterDate;   // 입장시간
    private String exitDate;    // 퇴장시간

    public Message(MessageType type, String username, String enterDate) {
        this.type = type;
        this.username = username;
        this.enterDate = enterDate;
    }
}


