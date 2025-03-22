package tmi.app.exception;

public class InvalidKakaoAuthCodeException extends RuntimeException {
    public InvalidKakaoAuthCodeException(String message) {
        super(message);
    }
}
