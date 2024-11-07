package com.example.chat.controller;

import com.example.chat.model.Message;
import com.example.chat.service.SocketModule;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Set;

@Slf4j
@Controller
@RequestMapping("/chat")
@AllArgsConstructor
public class ChatController {
    private final SocketModule socketModule;

    @RequestMapping("/lobby")
    public String lobby() {
        log.info("=====enter lobby=====");
        return "lobby";
    }

    @RequestMapping("/enter")
    public String enter(Model model) {
        log.info("=====enter=====");
        Set<Message> connectedList = socketModule.getConnectedList();
        model.addAttribute("memberList", connectedList);
        return "chat";
    }

}
