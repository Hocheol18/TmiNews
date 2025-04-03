package tmi.app.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tmi.app.dto.CommentRequestDTO;
import tmi.app.dto.CommentResponseDTO;
import tmi.app.dto.CommentUpdateRequestDTO;
import tmi.app.service.CommentService;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/news")
public class CommentController {

    private final CommentService commentService;

    @PostMapping("/{newsId}/reply")
    public ResponseEntity<CommentResponseDTO> createComment(@PathVariable Long newsId,
                                                            @RequestBody CommentRequestDTO request,
                                                            @RequestHeader("Authorization") String token) {
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        CommentResponseDTO response = commentService.createComment(newsId, request, token);
        return ResponseEntity.ok(response);
    }

    @PatchMapping("/{newsId}/reply/{replyId}")
    public ResponseEntity<CommentResponseDTO> updateComment(@PathVariable Long newsId,
                                                            @PathVariable Long replyId,
                                                            @RequestBody CommentUpdateRequestDTO request,
                                                            @RequestHeader("Authorization") String token) {
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        CommentResponseDTO response = commentService.updateComment(newsId, replyId, request, token);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{newsId}/reply/{replyId}")
    public ResponseEntity<Void> deleteComment(@PathVariable Long newsId,
                                              @PathVariable Long replyId,
                                              @RequestHeader("Authorization") String token) {
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        commentService.deleteComment(newsId, replyId, token);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{newsId}/reply")
    public ResponseEntity<List<CommentResponseDTO>> getCommentTree(@PathVariable Long newsId) {
        List<CommentResponseDTO> tree = commentService.getCommentTree(newsId);
        return ResponseEntity.ok(tree);
    }


}
