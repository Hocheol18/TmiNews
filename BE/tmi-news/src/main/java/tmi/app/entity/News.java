package tmi.app.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "news")
public class News {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long newsId; // 뉴스 ID (PK)

    // User와 연관 관계 설정 (ManyToOne) (지연 로딩 추가)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, length = 50)
    private String category; // 뉴스 카테고리

    @Column(nullable = false, length = 50)
    private String title; // 뉴스 제목

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content; // 뉴스 본문

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt; // 생성 일시

    private LocalDateTime newsTime; // 기사 날짜

    // 댓글 리스트 추가
    @OneToMany(mappedBy = "news", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> comments = new ArrayList<>();

    @OneToMany(mappedBy = "news", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<NewsLike> newsLikes = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }
}
