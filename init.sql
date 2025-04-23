-- DB 없으면 생성
CREATE DATABASE IF NOT EXISTS tmi_news;
USE tmi_news;

-- notification 테이블 생성
CREATE TABLE IF NOT EXISTS notification (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('FRIEND_REQUEST', 'FRIEND_ACCEPTED', 'LIKE', 'COMMENT') NOT NULL,
    message VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 초기 데이터 삽입 (옵션)
INSERT INTO notification (type, message) VALUES
('FRIEND_REQUEST', '지윤님에게 친구 요청이 왔어요!'),
('LIKE', '지윤님 뉴스에 좋아요가 눌렸습니다.');
