# Web Chatting
웹 소켓을 이용한 간단한 채팅 프로그램

## 개발 환경
- Spring Boot 2.5.2
- Maven
- Java 1.8

### dependency
- websocket
- lombok
- jstl
- tomcat-embed-jasper

### Document
- [Web Socket](https://docs.spring.io/spring-framework/docs/4.3.x/spring-framework-reference/html/websocket.html)

### End Point
- lobby : `/chat/lobby`
- enter: `/chat/enter`

## Test
로컬 환경에서 테스트가 가능합니다.
1. 애플리케이션 실행
2. 메인페이지(lobby) 입장
    - location: http://localhost:8080/chat/lobby
3. `Input Username`에 채팅에 사용할 닉네임을 입력
4. `채팅 시작하기` 버튼을 클릭하여 채팅을 시작
5. `message`를 입력 후 `send`버튼을 클릭하여 실시간으로 채팅이 진행되는 것을 확인
    - 시크릿 모드를 사용하여 다른 클라이언트를 이용한 접근이 가능

## Content
### Configuration
`WebsocketConfig`
```java
@Component
public class WebSocketConfig {
    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }
}
```
### Service
`WebSocketChat`

```java
@Slf4j
@Service
@ServerEndpoint("/ws/chat")
public class WebSocketChat { ... }

```

### Controller



---
## 2024.11. 06
   ### Socket.io를 이용한 구현
