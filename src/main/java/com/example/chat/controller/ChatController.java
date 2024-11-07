package com.example.chat.controller;

import com.example.chat.model.Message;
import com.example.chat.service.SocketModule;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Collections;
import java.util.List;
import java.util.Locale;

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
        return "chat";
    }

    @RequestMapping("/member-list")
    public String memberList(Model model) {
        log.info("=====Connecting member-list=====");
        List<String> memberList = socketModule.getMemberList();
        log.info("memberList: {}", memberList);
        model.addAttribute("memberList", memberList);
        return "member-list";
    }

}
